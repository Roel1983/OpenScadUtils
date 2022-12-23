include <Debug.inc>
include <Constants.inc>

$vpr = [0,0,0];
$vpt = [0.170204, 0, 0.0499167];
$vpd = 73.1102;

DebugPoints(points_of_circle(r = 10, a1 = 30, a2 = 135));


p   = [10 ,10];
vec = [1,.5];

translate(p) circle(1);
mirror(vec) translate(p) circle(1);

function point_mirror(vec, point) = (
    let(
        M  = norm(vec),
        AA = -vec[X] / M,
        BB = -vec[Y] / M,
        DD = AA * point[X] + BB * point[Y]
    ) [
        point[X] - 2 * AA * DD,
        point[Y] - 2 * BB * DD,
    ]
);
function points_mirror(vec, points) = [
    for(p=points) point_mirror(vec, p)
];
function points_trim(points, first = 0, last = 0) = [
    let(from = first, to = len(points) - 1 - last)
    for(i=[from:to]) points[i]
];
function points_reverse(points) = [
    let(from = len(points) - 1, to = 0)
    for(i=[from:-1:to]) points[i]
];
    
function points_fn(r) = ($fn > 0 ? $fn : $fs > 0 ? r * 2 * PI / $fs : _ad / $fa);

function points_of_circle(r, a1, a2) = [
    let(
        _a1   = (((a1 % 360) + 360) % 360),
        _ad   = ((((a2 - a1) % 360) + 360) % 360),
        _a2   = a1 + _ad,
        fn    = points_fn(r),
        max = ceil(abs(_a1 - _a2) / (360 / fn))
    )
    for(i=[0:max]) (
        let(a = _a1 + (_a2 - _a1) * i / max)
        [
            cos(a) * r,
            sin(a) * r
        ]
    )
];
    
function mirror_y_points_2d(points) = [
    for(p=points) [
         p[X],
        -p[Y]
    ]
];

function points_distances(points) = [
    let(from = 0, to = len(points) - 2)
    for(i=[from:to]) (
        let(p0 = points[i], p1 = points[i + 1])
        norm(p1 - p0)
    )   
];