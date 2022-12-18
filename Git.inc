GIT_REVISION = "";

module CommitText(
    size   = nozzle(8),
    font   = "Arial",
    halign = "center",
    valign = "center"
) {
    text(GIT_REVISION,
        size   = size,
        font   = font,
        valign = valign,
        halign = halign
    );
}
