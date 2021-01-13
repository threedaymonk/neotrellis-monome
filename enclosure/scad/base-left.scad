use <case.scad>
difference() {
  intersection() {
    base();
    base_select_left();
  }
  base_pegs_left();
}
