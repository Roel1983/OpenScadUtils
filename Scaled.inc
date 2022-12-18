include <Optional.inc>
include <Config.inc>
include <ToString.inc>

_SCALED_SCALES = Config(undef,
    "Scales", [
        ["Z",   1/220],
        ["N",   1/160],
        ["TT",  1/120],
        ["H0",  1/87],
        ["S",   1/64],
        ["0",   1/45],
        ["I",   1/32],
        ["II",  1/22.5],
        ["III", 1/16],
        ["V",   1/11],
        ["VII", 1/8],
        ["X",   1/5.5],
    ]
);

_SCALED_SCALE = (
    (is_num(SCALED_SCALE)?(
        SCALED_SCALE
    ):is_string(SCALED_SCALE)?(
        let(v=ConfigGet(_SCALED_SCALES, SCALED_SCALE))
        let(scaled_check=!is_undef(v)) assert(scaled_check, str(
            "Unknown SCALED_SCALE ", ToString(SCALED_SCALE), ".", 
            " Must be one of ", ConfigGetKeys(_SCALED_SCALES),
            " or numeric" 
        ))
        v
    ):(
        let(scaled_check=false) assert(scaled_check, str(
            "SCALED_SCALE must be defined before including this header-file",
            " and have value: one of ", ConfigGetKeys(_SCALED_SCALES),
            " or numeric" 
        ))
    ))
);

function scaled(scaled) = scaled * _SCALED_SCALE;
