include <Constants.inc>
include <Optional.inc>

module LinearExtrude(
    x_from, x_to, x_size,
    y_from, y_to, y_size,
    z_from, z_to, z_size
) {
    if (!is_undef(x_size)) {
        if(!is_undef(x_from)) {
            assert(is_undef(x_to))
            LinearExtrude(
                x_from = x_from, x_to = x_from + x_size, x_size = undef,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            ) children();
        } else if(!is_undef(x_to)) {
            LinearExtrude(
                x_from = x_to - x_size, x_to = x_to, x_size = undef,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            ) children();
        } else {
            LinearExtrude(
                x_from = -x_size/2, x_to = x_size/2, x_size = undef,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            ) children();
        }
    } else if (!is_undef(y_size)) {
        if(!is_undef(y_from)) {
            assert(is_undef(y_to))
            LinearExtrude(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_from + y_size, y_size = undef,
                z_from = z_from, z_to = z_to, z_size = z_size
            ) children();
        } else if(!is_undef(y_to)) {
            LinearExtrude(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_to - y_size, y_to = y_to, y_size = undef,
                z_from = z_from, z_to = z_to, z_size = z_size
            ) children();
        } else {
            LinearExtrude(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = -y_size/2, y_to = y_size/2, y_size = undef,
                z_from = z_from, z_to = z_to, z_size = z_size
            ) children();
        }
    } else if (!is_undef(z_size)) {
        if(!is_undef(z_from)) {
            assert(is_undef(z_to))
            LinearExtrude(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_from + z_size, z_size = undef
            ) children();
        } else if(!is_undef(z_to)) {
            LinearExtrude(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_to - z_size, z_to = z_to, z_size = undef
            ) children();
        } else {
            LinearExtrude(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = -z_size/2, z_to = z_size/2, z_size = undef
            ) children();
        }
    } else if (!is_undef(x_from) || !is_undef(x_to)) {
        assert( is_undef(y_from) &&  is_undef(y_to));
        assert( is_undef(z_from) &&  is_undef(z_to));
        rotate(90, VEC_Y) rotate(90) {
            LinearExtrude(z_from = x_from, z_to = x_to) children();
        }
    } else if (!is_undef(y_from) || !is_undef(y_to)) {
        assert( is_undef(x_from) &&  is_undef(x_to));
        assert( is_undef(z_from) &&  is_undef(z_to));
        rotate(-90, VEC_X) {
            LinearExtrude(z_from = y_from, z_to = y_to) children();
        }
    }
    else {
        assert( is_undef(x_from) &&  is_undef(x_to));
        assert( is_undef(y_from) &&  is_undef(y_to));
        _z_from = optional(z_from, 0);
        _z_to   = optional(z_to,   0);
        if (_z_from > _z_to) {
            LinearExtrude(z_from = _z_to, z_to = _z_from) mirror(VEC_X) children();
        } else {
            translate([0, 0, _z_from]) {
                linear_extrude(_z_to - _z_from) {
                    children();
                }
            }
        }
    }
}