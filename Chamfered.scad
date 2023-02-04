include <Constants.inc>
include <Points.inc>

*ChamferedSquare(
    size          = 20,
    y_from        = 0,
    thickness     = 1,
    chamfer_angle = [45, -45, 0, 45]
);

!ChamferedPolygon(
    2,
    [[-20, -10],
    [- 0,  10],
    [23,  -10]],
    chamfer_angle = 45,
    
    align = "inner"
);


module ChamferedPolygon(
    thickness = 1,
    points,
    chamfer,
    chamfer_angle,
    align = "inner"
) {
    assert(is_num(thickness));
    assert(align == "inner" || align == "outer");
    
    offsets = thickness * [for(i = [0 : len(points) - 1]) (
        let(
            num   = is_list(chamfer      ) ? chamfer[i]       : chamfer,
            angle = is_list(chamfer_angle) ? chamfer_angle[i] : chamfer_angle
        ) (!is_undef(num) && (is_undef(angle) || (is_list(chamfer) && !is_list(chamfer_angle)))) ? (
            assert(is_num(num))
            num
        ) : (!is_undef(angle) && (is_undef(num) || (is_list(chamfer_angle) && !is_list(chamfer)))) ? (
            assert(is_num(angle))
            assert(abs(angle) < 90, "Absolute angle cannot be greater than 90")
            tan(angle)
        ) : (is_undef(angle) && (is_undef(num))) ? (
            (is_undef(chamfer) && is_undef(chamfer_angle)) ? 1 : 0
        ) :(
            assert(false, "'chamfer_angle' and 'chamfer' are conflicting")
        )
    )];
    
    points_2d_inner = (align=="inner")?points:points_with_offset(points, offset=-offsets);
    points_2d_outer = (align=="inner")?points_with_offset(points, offset=offsets):points;
    
    point_count_inner = len(points_2d_inner);
    point_count_outer = len(points_2d_outer);
    assert(point_count_inner == point_count_outer);
    point_count = point_count_inner;
    
    points_3d_inner = [for (p = points_2d_inner) [p[0], p[1], (align=="inner")?0:-thickness]];
    points_3d_outer = [for (p = points_2d_outer) [p[0], p[1], (align=="inner")?thickness:0]];
    points_3d       = concat(points_3d_inner, points_3d_outer);
    
    faces_bottom = range(
        point_count - 1,
        0,
        -1
    );
    faces_top = range(
        point_count,    
        2 * point_count - 1
    );
    faces_side = [
        for(i = [0:point_count - 1]) [
            i,
            ((i + 1) % point_count),
            point_count + ((i + 1) % point_count),
            point_count + i
        ]
    ];
    
    faces = concat([faces_bottom, faces_top], faces_side);
    
    polyhedron(
        points= points_3d,
        faces = faces
    );
        
    function range(from, to, step = 1) = [for (i=[from:step:to]) i];
}

module ChamferedSquare(
    size,
    thickness = 1,
    chamfer_angle, 
    chamfer,
    bound,
    x_size,
    x_from,
    x_to,
    x_bound,
    y_size,
    y_from,
    y_to,
    y_bound,
    align = "inner"
) {
    _chamfer = [for(i = [0 : 3]) (
        let(
            num   = is_list(chamfer      ) ? chamfer[i]       : chamfer,
            angle = is_list(chamfer_angle) ? chamfer_angle[i] : chamfer_angle
        ) (!is_undef(num) && (is_undef(angle) || (is_list(chamfer) && !is_list(chamfer_angle)))) ? (
            assert(is_num(num))
            num
        ) : (!is_undef(angle) && (is_undef(num) || (is_list(chamfer_angle) && !is_list(chamfer)))) ? (
            assert(is_num(angle))
            assert(abs(angle) < 90, "Absolute angle cannot be greater than 90")
            tan(angle)
        ) : (is_undef(angle) && (is_undef(num))) ? (
            (is_undef(chamfer) && is_undef(chamfer_angle)) ? 1 : 0
        ) :(
            assert(false, "'chamfer_angle' and 'chamfer' are conflicting")
        )
    )];
    points_square = points_of_square(
        size    = size,
        bound   = bound,
        x_size  = x_size,
        x_from  = x_from,
        x_to    = x_to,
        x_bound = x_bound,
        y_size  = y_size,
        y_from  = y_from,
        y_to    = y_to,
        y_bound = y_bound
    );
    ChamferedPolygonByFunction(
        thickness       = thickness,
        points_function = function (thickness) [
            [
                points_square[0][0] - thickness * _chamfer[3],
                points_square[0][1] + thickness * _chamfer[0]
            ], [
                points_square[1][0] + thickness * _chamfer[1],
                points_square[1][1] + thickness * _chamfer[0]
            ], [
                points_square[2][0] + thickness * _chamfer[1],
                points_square[2][1] - thickness * _chamfer[2]
            ], [
                points_square[3][0] - thickness * _chamfer[3],
                points_square[3][1] - thickness * _chamfer[2]
            ]
        ],
        align = align
    );
}

module ChamferedPolygonByFunction(
    thickness = 1,
    points_function,
    align = "inner"
) {
    assert(is_num(thickness));
    assert(is_function(points_function));
    assert(align == "inner" || align == "outer");
    
    points_2d_inner = points_function((align=="inner")?0:-thickness);
    points_2d_outer = points_function((align=="inner")?thickness:0);
    
    point_count_inner = len(points_2d_inner);
    point_count_outer = len(points_2d_outer);
    assert(point_count_inner == point_count_outer);
    point_count = point_count_inner;
    
    points_3d_inner = [for (p = points_2d_inner) [p[0], p[1], (align=="inner")?0:-thickness]];
    points_3d_outer = [for (p = points_2d_outer) [p[0], p[1], (align=="inner")?thickness:0]];
    points_3d       = concat(points_3d_inner, points_3d_outer);
    
    faces_bottom = range(
        point_count - 1,
        0,
        -1
    );
    faces_top = range(
        point_count,    
        2 * point_count - 1
    );
    faces_side = [
        for(i = [0:point_count - 1]) [
            i,
            ((i + 1) % point_count),
            point_count + ((i + 1) % point_count),
            point_count + i
        ]
    ];
    
    faces = concat([faces_bottom, faces_top], faces_side);
    
    polyhedron(
        points= points_3d,
        faces = faces
    );
        
    function range(from, to, step = 1) = [for (i=[from:step:to]) i];
}