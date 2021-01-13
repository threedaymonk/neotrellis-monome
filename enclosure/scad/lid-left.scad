use <case.scad>
difference() {
  intersection() {
    lid();
    lid_select_right();
  }
  lid_pegs();
}
