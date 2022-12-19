use <Git.scad>

module CommitText(
    size   = undef,
    len    = undef,
    font   = "Arial",
    halign = "center",
    valign = "center"
) {
    _CommitText(
        size   = size,
        len    = len,
        font   = font,
        halign = halign,
        valign = valign
    );
}
