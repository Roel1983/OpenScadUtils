include <Constants.inc>
include <IntersectTransform.inc>

module intersection_mirror(vec=undef) {
    intersection() {
        children();
        mirror(vec) children();
    }
}

intersection_mirror(VEC_Y) {
    translate([0, 5]) circle(10);
}
