include <TransformCopy.inc>
include <Constants.inc>

module mirror_copy(vec=undef) {
    children();
    mirror(vec) children();
}

mirror_copy(VEC_X) {
    text("mirror_copy(VEC_X)");
}
