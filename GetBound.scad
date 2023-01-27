function get_bound(
    index,
    prefix,
    size,
    bound,
    a_size,
    a_bound,
    a_from,
    a_to
) = (
    assert(is_num(index),     "Internal error: 'index' not a number or not specified")
    assert(is_string(prefix), "Internal error: 'prefix' not a string or not specified")
    (!is_undef(size)) ? (
        assert(is_undef(a_size), str("You cannot have both: 'size' and ", prefix, "size"))
        assert(is_list(size) || is_num(size), "'size' must be a list or number")
        get_bound(
            index   = index,
            prefix  = prefix,
            size    = undef,
            bound   = bound,
            a_size  = (is_list(size) ? (
                assert(is_num(size[index]), str("'size[", index, "] must be a number"))
                size[index]
            ) : (
                size
            )),
            a_bound = a_bound,
            a_from  = a_from,
            a_to    = a_to
        )
    ) : (!is_undef(bound)) ? (
        assert(is_undef(a_bound), str("You cannot have both: 'bound' and ", prefix, "bound"))
        assert(is_list(bound), "'bound' must be a list of list of 2 numbers")
        get_bound(
            index   = index,
            prefix  = prefix,
            size    = undef,
            bound   = undef,
            a_size  = a_size,
            a_bound = bound[index],
            a_from  = a_from,
            a_to    = a_to
        )
    ) : (!is_undef(a_bound)) ? (
        assert(is_undef(a_from) && is_undef(a_to), str("'bound' is conflicting with '", prefix, "from' and/or '", prefix, "to'"))
        get_bound(
            index   = index,
            prefix  = prefix,
            size    = undef,
            bound   = undef,
            a_size  = a_size,
            a_bound = undef,
            a_from  = a_bound[0],
            a_to    = a_bound[1]
        )
    ) : (!is_undef(a_size)) ? (
        assert(is_undef(a_from) || is_undef(a_to), str("'size' is conflicting with '", prefix, "from' and '", prefix, "to'"))
        (is_undef(a_from) && is_undef(a_to)) ? (
            get_bound(
                index   = index,
                prefix  = prefix,
                size    = undef,
                bound   = undef,
                a_size  = undef,
                a_bound = undef,
                a_from  = -.5 * a_size,
                a_to    =  .5 * a_size
            )
        ) : (
            get_bound(
                index   = index,
                prefix  = prefix,
                size    = undef,
                bound   = undef,
                a_size  = undef,
                a_bound = undef,
                a_from  = !is_undef(a_from) ? a_from : (a_to   - a_size),
                a_to    = !is_undef(a_to  ) ? a_to   : (a_from + a_size)
            )
        )
    ) : (
        assert(is_undef(a_from) || is_num(a_from), str("'", prefix, "from' is not a number"))
        assert(is_undef(a_to)   || is_num(a_to),   str("'", prefix, "to' is not a number"))
        [
            is_undef(a_from) ? 0 : a_from,
            is_undef(a_to)   ? 0 : a_to
        ]
    )
);
