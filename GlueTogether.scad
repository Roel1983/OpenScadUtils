include <Colors.inc>
include <GlueTogether.inc>

$fn=32;

GlueTogether(xray=true) {
    difference() {
        cube(10, true);
        cylinder(d = 8, h = 11, center =true);
    }
    translate([0,0,7]) sphere(d=9);
    rotate(.5, [1,0,0])translate([0,0,-10.0]) cylinder(d1=9, d2=7, h= 10);
}



module GlueTogether(xray = false, colorize = true) {
    if($children >= 1) {
        if (xray) {
            
            if($children >= 2) {
                color("red") {
                    for (i = [0:$children-2]) {
                        for(j = [i+1:$children-1]) {
                            intersection() {
                                children(i);
                                children(j);
                            }
                        }
                    }
                }
            }
            if (colorize) {
                for (i = [0:$children-1]) {
                    color(unique_color(i, $children), alpha = .1) children(i);
                }
            } else {
                %for (i = [0:$children-1]) {
                    children(i);
                }
            }
        } else {
            for (i = [0:$children-1]) {
                color_if(colorize, unique_color(i, $children)) children(i);
            }
        }
    }
}