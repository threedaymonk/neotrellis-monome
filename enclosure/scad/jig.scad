$e = 0.01;
base_h = 10;
boss_h = 3;
boss_d = 10;
boss_x = 15;
screw_d = 2.4;
corner_r = 5;

module bosses(r, h) {
  for (x = [-30, 30])
    translate([x, 0, 0])
      for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
          translate([boss_x, 0, 0])
            cylinder(r = r, h = h);
}

difference() {
  union() {
    translate([-60, -30, 0]) cube([120, 60, base_h]);
    bosses(r = boss_d/2, h = base_h + boss_h);
    intersection() {
      translate([-60, -30, 0]) cube([120, 60, base_h + boss_h]);
      union() {
        for (y = [-30, 30])
          for (x = [-60, 0, 60])
            translate([x, y, 0])
              cylinder(r = corner_r, h = base_h + boss_h);
      }
    }
  }
  translate([0, 0, -$e]) bosses(r = screw_d / 2, h = base_h + boss_h + 2*$e);
}
