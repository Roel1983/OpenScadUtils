include <Units.inc>
include <Shapes.inc>
include <IntersectTransform.inc>
include <Constants.inc>

translate([-10,0]) Hex(10);
translate([ 10,0]) Droplet(10, degree(60));

module Hex(size = 1) {
    intersection_for(a=[0:120:359]) rotate(a) {
        square([size, 2 * size], true);
    }
}

module Droplet(d, a) {
    circle(d=d);
    intersection_mirror(VEC_X) {
        rotate(a) square([d/2, d]);
    }
}
