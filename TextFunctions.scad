include <TextFunctions.inc>

function sub_text(text, len = undef, offset = 0) = (
    (is_undef(len) || len + offset > len(text)) ? (
        sub_text(text, len = len(text) - offset, offset = offset)
    ) : (len <= 0) ? (
        str("")
    ) : (
        str(text[offset], sub_text(text, len = len-1, offset = offset + 1))
    )
);
assert(
    sub_text("Hello World!")
    ==
    "Hello World!"
);
assert(
    sub_text("Hello World!", len = 5)
    ==
    "Hello"
);
assert(
    sub_text("Hello World!", offset = 6)
    ==
    "World!"
);
assert(
    sub_text("Hello World!", offset = 6, len = 5)
    ==
    "World"
);

function is_hexadecimal_char(char) = (
    (char >= "0" && char <= "9") ||
    (char >= "a" && char <= "f") ||
    (char >= "A" && char <= "F")
);
assert( is_hexadecimal_char("0"));
assert( is_hexadecimal_char("9"));
assert( is_hexadecimal_char("a"));
assert( is_hexadecimal_char("f"));
assert(!is_hexadecimal_char("g"));
assert( is_hexadecimal_char("A"));
assert( is_hexadecimal_char("F"));
assert(!is_hexadecimal_char("G"));
assert(!is_hexadecimal_char("+"));
