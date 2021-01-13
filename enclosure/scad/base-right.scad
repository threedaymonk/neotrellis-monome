use <case.scad>
difference() {
  intersection() {
    base();
    base_select_right();
  }
  base_pegs_right();
}
