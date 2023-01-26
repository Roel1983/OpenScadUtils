include <Debug.inc>
include <Constants.inc>
use <GetBound.scad>

$vpr = [0,0,0];
$vpt = [0.170204, 0, 0.0499167];
$vpd = 73.1102;

DebugPoints(points_of_circle(r = 10, a1 = 30, a2 = 135));

DebugPoints(points_of_square(x_from = 0, y_to = -5, size=[10, 5]));

function point_mirror(vec, point) = (
    assert(is_list(vec))
    assert(len(vec) == 2 || (len(vec) == 3 && vec[2] == 0))
    assert(is_num(vec[X]) && is_num(vec[Y]))
    assert(is_list(point), str(point))
    assert(len(point) >= 2)
    assert(is_num(point[X]))
    assert(is_num(point[Y]))
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
function points_mirror(
    vec,
    points,
    reverse    = false,
    trim_first = 0,
    trim_last  = 0
) = (
    let(
        _start    = trim_first,
        _end      = len(points) - 1 - trim_first,
        start     = reverse ? _end : _start,
        increment = reverse ? -1 : 1,
        end       = reverse ? _start : _end
    ) [
        for (i = [start : increment : end]) let (p = points[i]) (
            point_mirror(vec, p)
        )
    ]
);
function points_trim(points, first = 0, last = 0) = [
    let(from = first, to = len(points) - 1 - last)
    for(i=[from:to]) points[i]
];
function points_reverse(points) = [
    let(from = len(points) - 1, to = 0)
    for(i=[from:-1:to]) points[i]
];

function points_mirror_copy(
    vec,
    points,
    trim_first = 0,
    trim_last  = 0
) = concat(
    points, 
    points_mirror(
        vec        = vec,
        points     = points,
        reverse    = true,
        trim_first = trim_first,
        trim_last  = trim_last
    )
);
    
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

function points_of_square(
    size,
    bound,
    x_size,
    x_from,
    x_to,
    x_bound,
    y_size,
    y_from,
    y_to,
    y_bound
) = (
    let(_x_bound = get_bound(
        index   = X,
        prefix  = "x_",
        size    = size,
        bound   = bound,
        a_size  = x_size,
        a_bound = x_bound,
        a_from  = x_from,
        a_to    = x_to
    ))
    let(_y_bound = get_bound(
        index   = Y,
        prefix  = "y_",
        size    = size,
        bound   = bound,
        a_size  = y_size,
        a_bound = y_bound,
        a_from  = y_from,
        a_to    = y_to
    ))
    [
        [_x_bound[0], _y_bound[1]],
        [_x_bound[1], _y_bound[1]],
        [_x_bound[1], _y_bound[0]],
        [_x_bound[0], _y_bound[0]],
    ]
);
    
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
    
function points_with_offset(
    points,
    offset
) = let(
    point_count = len(points)
) (
    assert(is_num(offset) || (is_list(offset) && len(offset) == len(points)))
    [for (i = [0 : point_count - 1]) let(,
        i_prev        = (i + point_count - 1) % point_count,
        i_next        = (i + 1) % point_count,
        offset_prev   = is_list(offset) ? offset[i_prev] : offset,
        offset_next   = is_list(offset) ? offset[i] : offset,
        point         = points[i],
        relative_prev = points[i_prev] - point,
        relative_next = points[i_next] - point,
        p1_prev       = [
                             relative_prev[1] / norm(relative_prev),
                            -relative_prev[0] / norm(relative_prev)],
        p1_next       = [
                            -relative_next[1] / norm(relative_next),
                             relative_next[0] / norm(relative_next)],
        a_prev        = offset_prev * (p1_prev[1] + pow(p1_prev[0], 2) / p1_prev[1]),
        a_next        = offset_next * (p1_next[1] + pow(p1_next[0], 2) / p1_next[1]),
        b_prev        = -p1_prev[0] / p1_prev[1],
        b_next        = -p1_next[0] / p1_next[1]
    ) (
        (relative_prev[0] == 0) ? (
            [
                point[0] + p1_prev[0],
                point[1] + a_next + p1_prev[0] * b_next
            ]
        ) : (relative_next[0] == 0) ? (
            [
                point[0] + p1_next[0],
                point[1] + a_prev + p1_next[0] * b_prev
            ]
        ) : (p1_prev == p1_next) ? (
            point + p1_prev
        ) : (
            let (
                relative_x = (a_next - a_prev) / (b_prev - b_next),
                relative_y = a_prev + b_prev * relative_x
            ) (
                echo(a_prev, a_next, b_prev, b_next, relative_x, relative_y)
                point + [relative_x, relative_y]
            )
        )
    )]  
);
