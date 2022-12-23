
function bezier_coordinate(t, p0, p1, p2) = (
    let(
        u  = 1.0 - t,
        q0 = p0 * u + p1 * t,
        q1 = p1 * u + p2 * t
    )
    q0 * u + q1 * t
);

function bezier_point(t, p0, p1, p2) = [
    for(i = [0:len(p0)-1]) (
        bezier_coordinate(t, p0[i], p1[i], p2[i])
    )
];

function bezier_points(p0, p1, p2, count = 10) = [
    let(max = count - 1)
    for(i = [0 : max]) let(t = i / max) (
        bezier_point(t, p0, p1, p2)
    )
];

p0 = [-10, 0, 10];
p1 = [-2, 10,  20];
p2 = [10,  2, -10];

for (p = bezier_points(p0, p1, p2)) {
    translate(p) cube(1, true);
}