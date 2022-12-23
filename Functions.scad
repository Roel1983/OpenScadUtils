function reduce_value(values, func, start_index = 0, end_index = undef) = (
    assert(is_function(func))
    is_undef(end_index)?(
        let(new_end_index = len(values) - 1) (
            assert(!is_undef(new_end_index))
            reduce_value(
                values      = values,
                func        = func,
                start_index = start_index,
                end_index   = new_end_index
            )
        )
    ):(start_index >= end_index) ? (
        assert(start_index == end_index)
        values[start_index]
    ):(
        func(
            values[start_index],
            reduce_value(
                values      = values,
                func        = func,
                start_index = start_index + 1,
                end_index   = end_index
            )
        )
    )
);
function sum_value(values) = (
    reduce_value(
        values      = values,
        func        = function(a, b) (a + b)
    )
);
function avg_value(values) = (
    sum_value(values) / len(values)
);
function minimum_value(values) = (
    reduce_value(
        values      = values,
        func        = function(a, b) min(a, b)
    )
);
function maximum_value(values) = (
    reduce_value(
        values      = values,
        func        = function(a, b) max(a, b)
    )
);