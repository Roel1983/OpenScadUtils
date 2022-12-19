include <TransformIf.inc>

module translate_if(condition, vec) {
    if(condition) {
        translate(vec) children();
    } else {
        children();
    }
}

module rotate_if(condition, a, vec) {
    if(condition) {
        rotate(a, vec) children();
    } else {
        children();
    }
}

module mirror_if(condition, vec) {
    if(condition) {
        mirror(vec) children();
    } else {
        children();
    }
}