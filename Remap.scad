include <Remap.inc>

function remap(array, dims) = [
    for(dim = dims) (
        array[dim]
    )
];

assert(
    remap(["X", "Y", "Z"], [2, 1])
    ==
    ["Z", "Y"]
);
    