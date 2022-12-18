include <Optional.inc>
include <Constants.inc>

Box(
    y_bounds = [10, 20],
    x_size = +8,
    x_to   = +1
);

module Box(
    size,
    x_from, x_to, x_size, x_bounds,
    y_from, y_to, y_size, y_bounds,
    z_from, z_to, z_size, z_bounds,
    bounds
) {
    if(is_num(size)) {
        if(is_undef(z_from) && is_undef(z_to) && is_undef(y_size)) {
            Box(
                size = [size, size], 
                x_from = x_from, x_to = x_to, x_size = x_size, x_bounds = x_bounds,
                y_from = y_from, y_to = y_to, y_size = y_size, y_bounds = y_bounds,
                z_from = z_from, z_to = z_to, z_size = z_size, z_bounds = z_bounds,
                bounds = bounds
            );
        } else {
            Box(
                size = [size, size, size], 
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size,
                bounds = bounds
            );
        }
    } else if(!is_undef(x_bounds)) {
        assert(is_undef(x_from));
        assert(is_undef(x_to));
        assert(is_undef(bounds));
        Box(
            size = size, 
            x_from = x_bounds[0], x_to = x_bounds[1], x_size = x_size,
            y_from = y_from, y_to = y_to, y_size = y_size,
            z_from = z_from, z_to = z_to, z_size = z_size
        );
    } else if(!is_undef(y_bounds)) {
        assert(is_undef(y_from));
        assert(is_undef(y_to));
        assert(is_undef(bounds));
        Box(
            size = size, 
            x_from = x_from, x_to = x_to, x_size = x_size,
            y_from = y_bounds[0], y_to = y_bounds[1], y_size = y_size,
            z_from = z_from, z_to = z_to, z_size = z_size
        );
    } else if(!is_undef(z_bounds)) {
        assert(is_undef(z_from));
        assert(is_undef(z_to));
        assert(is_undef(bounds));
        Box(
            size = size, 
            x_from = x_from, x_to = x_to, x_size = x_size,
            y_from = y_from, y_to = y_to, y_size = y_size,
            z_from = z_bounds[0], z_to = z_bounds[1], z_size = z_size
        );
    } else if(!is_undef(size)) {
        assert(is_undef(x_size));
        assert(is_undef(y_size));
        assert(is_undef(bounds));
        if(len(size) == 2) {
            Box(
                x_from = x_from, x_to = x_to, x_size = size[X],
                y_from = y_from, y_to = y_to, y_size = size[Y],
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        } else {
            assert(is_undef(z_size));
            Box(
                x_from = x_from, x_to = x_to, x_size = size[X],
                y_from = y_from, y_to = y_to, y_size = size[Y],
                z_from = z_from, z_to = z_to, z_size = size[Z]
            );
        }
    } else if (!is_undef(bounds)) {
        assert(is_undef(x_from));
        assert(is_undef(x_to));
        assert(is_undef(y_from));
        assert(is_undef(y_to));
        if(len(bounds) == 2) {
            Box(
                x_from = bounds[X][0], x_to = bounds[X][1], x_size = x_size,
                y_from = bounds[Y][0], y_to = bounds[Y][1], y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        } else {
            assert(is_undef(z_from));
            assert(is_undef(z_to));
            Box(
                x_from = bounds[X][0], x_to = bounds[X][1], x_size = x_size,
                y_from = bounds[Y][0], y_to = bounds[Y][1], y_size = y_size,
                z_from = bounds[Z][0], z_to = bounds[Z][1], z_size = z_size
            );
        }
    } else if (!is_undef(x_size)) {
        if(!is_undef(x_from)) {
            assert(is_undef(x_to))
            Box(
                x_from = x_from, x_to = x_from + x_size, x_size = undef,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        } else if(!is_undef(x_to)) {
            Box(
                x_from = x_to - x_size, x_to = x_to, x_size = undef,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        } else {
            Box(
                x_from = -x_size/2, x_to = x_size/2, x_size = undef,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        }
    } else if (!is_undef(y_size)) {
        if(!is_undef(y_from)) {
            assert(is_undef(y_to))
            Box(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_from + y_size, y_size = undef,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        } else if(!is_undef(y_to)) {
            Box(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_to - y_size, y_to = y_to, y_size = undef,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        } else {
            Box(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = -y_size/2, y_to = y_size/2, y_size = undef,
                z_from = z_from, z_to = z_to, z_size = z_size
            );
        }
    } else if (!is_undef(z_size)) {
        if(!is_undef(z_from)) {
            assert(is_undef(z_to))
            Box(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_from, z_to = z_from + z_size, z_size = undef
            );
        } else if(!is_undef(z_to)) {
            Box(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = z_to - z_size, z_to = z_to, z_size = undef
            );
        } else {
            Box(
                x_from = x_from, x_to = x_to, x_size = x_size,
                y_from = y_from, y_to = y_to, y_size = y_size,
                z_from = -z_size/2, z_to = z_size/2, z_size = undef
            );
        }
    } else if (
        (!is_undef(x_from) || !is_undef(x_to)) &&
        (!is_undef(x_to)   || !is_undef(y_to))
    ) {
        _x_from = optional(x_from, 0);
        _x_to   = optional(x_to, 0);
        _y_from = optional(y_from, 0);
        _y_to   = optional(y_to, 0);
            
        if (!is_undef(z_from) || !is_undef(z_to)) {
            _z_from = optional(z_from, 0);
            _z_to   = optional(z_to, 0);
            
            translate([
                _x_from, 
                _y_from,
                _z_from
            ]) cube([
                (_x_to - _x_from),
                (_y_to - _y_from),
                (_z_to - _z_from)
            ]);
        } else {
            translate([
                _x_from, 
                _y_from
            ]) square([
                (_x_to - _x_from),
                (_y_to - _y_from)
            ]);
        }
    }
}
