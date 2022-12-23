
p0 = [-20, -10];
p1 = [-20,  10];
p2 = [ 20,  10];
p3 = [ 20, -10];
for (p = bezier_points(p0, p1, p2, p3)) {
    translate(p) cube(1, true);
}

function bezier_coordinate(t, p0, p1, p2, p3 = undef) = (
    let(
        u  = 1.0 - t
    ) (is_undef(p3)) ? (
        let(
            q0 = p0 * u + p1 * t,
            q1 = p1 * u + p2 * t
        )
        q0 * u + q1 * t
    ) : (
        let(
            q0 = p0 * u + p1 * t,
            q1 = p1 * u + p2 * t,
            q2 = p2 * u + p3 * t,
            r0 = q0 * u + q1 * t,
            r1 = q1 * u + q2 * t
        )
        r0 * u + r1 * t
    )
);

function bezier_point(t, p0, p1, p2, p3) = [
    for(i = [0:len(p0)-1]) (
        bezier_coordinate(t, p0[i], p1[i], p2[i], is_undef(p3)?undef:p3[i])
    )
];

function bezier_points(p0, p1, p2, p3, count = 10) = [
    let(max = count - 1)
    for(i = [0 : max]) let(t = i / max) (
        bezier_point(t, p0, p1, p2, p3)
    )
];
    
    
    

