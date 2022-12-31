include <TransformCopy.inc>
include <Constants.inc>

module mirror_copy(vec=undef) {
    children();
    mirror(vec) children();
}

module rotate_copy(a, vec=undef) {
    children();
    rotate(a, vec) children();
}

mirror_copy(VEC_X) {
    text("mirror_copy(VEC_X)");
}
