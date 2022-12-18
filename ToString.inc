
function ToString(value) = (
    is_string(value)?(
        str("\"", value, "\"")
    ):(
        str(value)
    )
);