function unique_color(number, count) = (
    let(colors = [
        "#00FF00",
        "#0000FF",
        "#FF0000",
        "#01FFFE",
        "#FFA6FE",
        "#FFDB66",
        "#006401",
        "#010067",
        "#95003A",
        "#007DB5",
        "#FF00F6",
        "#FFEEE8",
        "#774D00",
        "#90FB92",
        "#0076FF",
        "#D5FF00",
        "#FF937E",
        "#6A826C",
        "#FF029D",
        "#FE8900",
        "#7A4782",
        "#7E2DD2",
        "#85A900",
        "#FF0056",
        "#A42400",
        "#00AE7E",
        "#683D3B",
        "#BDC6FF",
        "#263400",
        "#BDD393",
        "#00B917",
        "#9E008E",
        "#001544"
    ])
    colors[number % len(colors)]
);

module color_if(condition, c, alpha) {
    if (condition) {
        color(c = c, alpha = alpha) children();
    } else {
        children();
    }
}