include <Config.inc>

CONFIG_INDEX_NAME       = 0;
CONFIG_INDEX_BODY       = 1;
CONFIG_ITEM_INDEX_KEY   = 0;
CONFIG_ITEM_INDEX_VALUE = 1;

function Config(parent, name, array) = [
    assert(is_string(name)) name,
    ((is_undef(parent))?(
        array
    ): (
        assert(name == parent[CONFIG_INDEX_NAME])
        [ for (i = [0:len(array)-1]) (
                assert(
                    parent[CONFIG_INDEX_BODY][i][CONFIG_ITEM_INDEX_KEY]
                    ==
                    array[i][CONFIG_ITEM_INDEX_KEY]
                )
                (is_undef(array[i][CONFIG_ITEM_INDEX_VALUE]) ? (
                    parent[CONFIG_INDEX_BODY][i]
                ) : (
                    array[i]
                ))       
            )
        ]
    ))
];
function MyConfig(
    a,
    b,
    c,
    parent
) = Config(parent,
    "MyConfig", [
        ["a", a],
        ["b", b],
        ["c", c]
    ]
);
assert(
    MyConfig(
        a = 10,
        c = 30,
        parent = MyConfig(
            a = 666,
            b = 20
        )
    )
    ==
    ["MyConfig", [
        ["a", 10],
        ["b", 20],
        ["c", 30]
    ]]
);

function ConfigGetName(
    config
) = (
    config[CONFIG_INDEX_NAME]
);
assert(
    ConfigGetName(
        MyConfig(
            a = 10,
            c = 30
        )
    )
    ==
    "MyConfig"
);

function ConfigGet(
    config,
    key,
    default       = undef,
    name          = undef,
    _config_index = 0,
    _key_index    = undef
) = (
    assert(
        is_undef(name) || config[CONFIG_INDEX_NAME] == name, 
        str(name, " != ", config[CONFIG_INDEX_NAME])
    )
    (is_list(key)) ? (
        ((is_undef(_key_index)) ? (
            ConfigGet(
                config  = config,
                key     = key,
                default = default,
                _key_index = len(key) - 1
            )
        ) : (
            ConfigGet(
                config  = (
                    (_key_index <= 0) ? (
                        config
                    ) : (
                        ConfigGet(
                            config     = config,
                            key        = key,
                            default    = default,
                            _key_index = _key_index - 1
                        )
                    )
                ),
                key     = key[_key_index],
                default = default
            )
        ))
    ) : (
        ((!is_list(config) || _config_index >= len(config[CONFIG_INDEX_BODY]))?(
            default
        ):(
            ((config[CONFIG_INDEX_BODY][_config_index][CONFIG_ITEM_INDEX_KEY] == key)?(
                config[CONFIG_INDEX_BODY][_config_index][CONFIG_ITEM_INDEX_VALUE]
            ):(
                ConfigGet(
                    config        = config,
                    key           = key,
                    default       = default,
                    _config_index = _config_index + 1
                )
            ))
        ))
    )
);
assert(ConfigGet(name="MyConfig", MyConfig(a= 10, b=MyConfig(b=20, c=30)), ["a"]) == 10);     
assert(ConfigGet(MyConfig(a= 10, b=MyConfig(b=20, c=30)), ["a", "b"]) == undef);     
assert(ConfigGet(MyConfig(a= 10, b=MyConfig(b=20, c=30)), ["c"     ]) == undef);
assert(ConfigGet(MyConfig(a= 10, b=MyConfig(b=20, c=30)), ["b", "c"]) == 30);
assert(ConfigGet(MyConfig(a= 10, b=MyConfig(b=20, c=30)), ["b", "a"]) == undef);

function ConfigGetKeys(
    config,
    name       = undef
) = (
    assert(
        is_undef(name) || config[CONFIG_INDEX_NAME] == name, 
        str(name, " != ", config[CONFIG_INDEX_NAME])
    )
    [for(item = config[CONFIG_INDEX_BODY]) item[CONFIG_ITEM_INDEX_KEY]]
);
assert(ConfigGetKeys(MyConfig(a= 10, b=MyConfig(b=20, c=30))) == ["a", "b", "c"]);

function ConfigBodyToString(body, _index=0) = (
    (_index < len(body)) ? (
        let(item = body[_index])
        str(
            str(item[CONFIG_ITEM_INDEX_KEY], " = ", item[CONFIG_ITEM_INDEX_VALUE]),
            "\n",
            ConfigBodyToString(body, _index + 1)
        )
    ) : (
        ""
    )
);

function ConfigToString(config) = str(
    "Config: ", ConfigGetName(config), "\n",
    ConfigBodyToString(config[CONFIG_INDEX_BODY])
);

echo(ConfigToString(MyConfig(a= 10, b=MyConfig(b=20, c=30))));