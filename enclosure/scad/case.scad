$fs = 0.1;
$fa = 0.1;
$e = 0.01;

inch = 25.4;
layer = 0.2;

board_size = 60;
board_cols = 4;
board_rows = 2;
inner_width = board_size * board_cols;
inner_height = board_size * board_rows;
outer_width = 10.2 * inch;
outer_height = 5.4 * inch;
radius = 0.1 * inch;
lid_depth = 7;
min_z = layer * 4;
min_wall = 0.8;

screw_inset = (outer_width - inner_width) / 4;
screw_thread_diameter = 2.9;
screw_shaft_diameter = 3.2;
screw_cap_diameter = 6;

button_size = 11;
button_r = 2;
button_pitch = 15;


button_cols = 4 * board_cols;
button_rows = 4 * board_rows;

board_thickness = 3;
connector_depth = 6.5;

base_depth = min_z + board_thickness +  connector_depth;
echo(base_depth);
normal_thickness = 2;

screw_cap_depth = base_depth - board_thickness;

module round_rect(x, y, h, r) {
  xpos = x / 2 - r;
  ypos = y / 2 - r;

  hull() {
    translate([-xpos, -ypos, 0]) cylinder(r = r, h = h);
    translate([ xpos, -ypos, 0]) cylinder(r = r, h = h);
    translate([-xpos,  ypos, 0]) cylinder(r = r, h = h);
    translate([ xpos,  ypos, 0]) cylinder(r = r, h = h);
  }
}

module boat(x, y, h, r) {
  xpos = x / 2 - r;
  ypos = y / 2 - r;

  hull() {
    translate([-xpos, -ypos, r]) sphere(r = r);
    translate([ xpos, -ypos, r]) sphere(r = r);
    translate([-xpos,  ypos, r]) sphere(r = r);
    translate([ xpos,  ypos, r]) sphere(r = r);
    translate([-xpos, -ypos, h - $e]) cylinder(r = r, h = $e);
    translate([ xpos, -ypos, h - $e]) cylinder(r = r, h = $e);
    translate([-xpos,  ypos, h - $e]) cylinder(r = r, h = $e);
    translate([ xpos,  ypos, h - $e]) cylinder(r = r, h = $e);
  }
}

module buttons(h) {
  first_col = -(button_cols - 1) * button_pitch / 2;
  first_row = -(button_rows - 1) * button_pitch / 2;
  for(row = [0:button_rows - 1]) {
    for(col = [0:button_cols - 1]) {
      translate([first_col + col * button_pitch, first_row + row * button_pitch, 0])
        round_rect(button_size, button_size, h, button_r); 
    }
  }
}

module screw_holes(r, h) {
  xs = [
    screw_inset,
    board_size - screw_inset,
    board_size + screw_inset,
    outer_width / 2 - screw_inset
  ];
  y = outer_height / 2 - screw_inset;

  for (m = [[0, 0, 0], [1, 0, 0]])
    for (n = [[0, 0, 0], [0, 1, 0]])
      mirror(m)
        mirror(n)
          for (x = xs)
            translate([x, y, 0]) cylinder(r = r, h = h);
}

module lid() {
  difference() {
    round_rect(outer_width, outer_height, lid_depth, radius);
    translate([0, 0, -$e]) {
      buttons(lid_depth + 2 * $e);
      screw_holes(r = screw_thread_diameter / 2, h = lid_depth - min_z + $e);
    }
  }
}

module usb_cutout() {
  height = 21;
  cutout_height = 8;
  cutout_depth = 5;
  width = 20;
  screw_dia = 2.4;
  screw_pitch = 15;
  screw_x = 2.5;
  additional_cutout_x = 7;
  additional_cutout_depth = 2;
  z_offset = base_depth - cutout_depth;

  translate([min_wall, 0, z_offset])
    cube([width, height, base_depth]);
  translate([min_wall + additional_cutout_x, 0, normal_thickness])
    cube([width, height, base_depth]);
  translate([-$e, (height - cutout_height) / 2, z_offset])
    cube([width, cutout_height, base_depth]);
  translate([screw_x + min_wall, (height - screw_pitch) / 2, min_z])
    cylinder(r = screw_dia / 2, h = base_depth);
  translate([screw_x + min_wall, height - (height - screw_pitch) / 2, min_z])
    cylinder(r = screw_dia / 2, h = base_depth);
}

module teensy() {
  width = 18;
  length = 37;
  cube([length, width, base_depth]);
}

module board() {
  margin = 3;
  lead_depth = 2;
  lead_width = 15;
  plug_x = 28;
  plug_y = 25;
  plug_w = 16;
  plug_h = 10;
  translate([-inner_width / 2, -inner_height / 2, 0]) {
    // pcb
    translate([0, 0, base_depth - board_thickness])
      cube([inner_width, inner_height, base_depth]);
    for (col = [0:board_cols - 1]) {
      // horizontal connection channels
      translate([
        board_size * col + (board_size - lead_width) / 2,
        board_size / 2,
        base_depth - board_thickness - lead_depth
      ]) {
        cube([lead_width, board_size * (board_rows - 1), base_depth]);
      }
    }
    for (row = [0:board_rows - 1]) {
      // vertical connection channels
      translate([
        board_size / 2,
        board_size * row + (board_size - lead_width) / 2,
        base_depth - board_thickness - lead_depth
      ]) {
        cube([board_size * (board_cols - 1), lead_width, base_depth]);
      }
      for (col = [0:board_cols - 1]) {
        // space for SMT components
        translate([
          margin + col * board_size,
          margin + row * board_size,
          normal_thickness,
        ]) {
          cube([
            board_size - 2 * margin,
            board_size - 2 * margin,
            base_depth
          ]);
        }
        // plug scoop
        translate([
          col * board_size + plug_x,
          row * board_size + plug_y,
          min_z,
        ]) {
          cube([plug_w, plug_h, base_depth]);
        }
      }
    }
  }
}

module base() {
  usb_depth = 4;
  difference() {
    boat(outer_width, outer_height, base_depth, radius);
    board();
    screw_holes(screw_shaft_diameter / 2, base_depth + $e);
    translate([0, 0, -$e])
      screw_holes(screw_cap_diameter / 2, screw_cap_depth + $e);
    translate([-outer_width / 2, 20, 0])
      usb_cutout();
    translate([-inner_width / 2 + 15, 39, min_z])
      teensy();
  }
}

//lid();
base();
