include <Functions.inc>
include <Points.inc>

module DebugPoints(points, size = undef) {
    _size = is_undef(size)?(
        minimum_value(points_distances(points)) / 2
    ) : (
        size
    );
    for(i=[0:len(points)-1]) let(p = points[i]) {
        translate(p) rotate($vpr) color("black") {
            linear_extrude(_size / 10) {
                text(str(i), size = _size, valign = "bottom", halign = "center");
                circle(d = _size / 4);
            }
        }
    }
}
