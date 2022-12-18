include <Optional.inc>

function optional(o, def) = is_undef(o) ? def : o;

assert(optional(undef,      "default") == "default");
assert(optional("my_value", "default") == "my_value");
