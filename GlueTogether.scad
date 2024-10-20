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

module GlueTogether(xray = false, colorize = true, index = undef) {
    indexes = (is_undef(index)) ? (
        [for (v=[0:$children-1]) v]
    ) : (is_num(index)) ? (
        [index]
    ) : (is_list(index)) ? (
        index
    ) : (
        []
    );
    
    if($children >= 1) {
        if (xray) {
            
            if($children >= 2) {
                color("red") {
                    if(len(indexes) >= 2) {
                        for (i = [0:len(indexes)-2]) {
                            for(j = [i+1:len(indexes) - 1]) {
                                intersection() {
                                    children(indexes[i]);
                                    children(indexes[j]);
                                }
                            }
                        }
                    }
                }
            }
            if (colorize) {
                for (ii = [0:len(indexes)-1]) {
                    i = indexes[ii];
                    color(unique_color(i, len(indexes)), alpha = .1) {
                       children(i);
                    }
                }
            } else {
                %for (ii = [0:len(indexes)-1]) {
                    i = indexes[ii];
                    children(i);
                }
            }
        } else {
            for (ii = [0:len(indexes)-1]) {
                i = indexes[ii];
                color_if(colorize, unique_color(i, $children)) {
                    children(i);
                }
            }
        }
    }
}