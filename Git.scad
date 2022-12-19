UNITS_NOZZLE = mm(.4);
UNITS_LAYER  = mm(0.15);
include <Units.inc>
include <Optional.inc>
include <TextFunctions.inc>
GIT_REVISION = "0123456789ABCDEF+";
include <Git.inc>

DEFAULT_SIZE = nozzle(8);

CommitText();

module _CommitText(
    size,
    len,
    font,
    halign,
    valign
) {
    if(!is_undef(GIT_REVISION)) {
        _len      = optional(len, 7);
        l         = len(GIT_REVISION);
        last_char = ((l > 0)?(GIT_REVISION[l - 1]):"");
        _text = ((is_hexadecimal_char(last_char))?(
            sub_text(GIT_REVISION, len = _len)    
        ):(
            str(sub_text(GIT_REVISION, len = _len-1), GIT_REVISION[l - 1])
        ));
        text(
            text   = _text,
            size   = optional(size, DEFAULT_SIZE),
            font   = font,
            valign = valign,
            halign = halign
        );
    }
}
