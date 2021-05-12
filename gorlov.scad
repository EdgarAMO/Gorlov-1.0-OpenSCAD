use <naca.scad>;

$fa = 1;
$fs = 0.4;
$fn = 100;

// blade's parameters
MPXX = "2415";              
MOUNTING_POINT = 0.25;      
CHORD = 1.0;                
POINTS = 300;

// helical parameters
CENTER = true;
HEIGHT = 10;
CONVEXITY = 10;
TWIST = 45;

// turbine's parameters
RADIUS = 6;
BLADES = 3;

// shaft parameters
SHAFT_RADIUS1 = 0.12;
SHAFT_RADIUS2 = 0.15;

// struts parameters
WIDTH = SHAFT_RADIUS1 * 2.0;
THICK = SHAFT_RADIUS1 / 4.0;
LENGTH = RADIUS;

module blade() {
    // take arguments from globals
    a1 = HEIGHT;
    a2 = CENTER;
    a3 = CONVEXITY;
    a4 = TWIST;
    
    // extrude and twist the blade
    linear_extrude(height=a1, center=a2, convexity=a3, twist=a4)
    translate([0, RADIUS, 0])
        naca(MPXX, MOUNTING_POINT, CHORD, POINTS);
}

module turbine() {
    for ( i = [0 : BLADES-1] ) {
        rotate( i*360/BLADES, [0, 0, 1])
            blade();
    }
}

module shaft() {
    difference() {
        cylinder(h=HEIGHT, r=SHAFT_RADIUS2, center=true);
        cylinder(h=1.1*HEIGHT, r=SHAFT_RADIUS1, center=true);
    }
}

module frame() {
    offsets = [0, TWIST/2.0, TWIST];
    heights = [-0.95*HEIGHT/2, 0, 0.95*HEIGHT/2];
    for ( k = [0:2] ) {
        rotate(offsets[k], [0, 0, -1]) {
            // rotate the struts every vertical level
            for ( j = [0 : 360/BLADES : 359] ) {
                translate([0, 0, heights[k]]) {
                    rotate(j, [0, 0, 1]) {
                        translate([0, RADIUS/2, 0])
                            cube(size=[WIDTH, LENGTH, THICK], center=true);
                    }
                }
            }
        }
    }
}



/* set SINGLE=true if you only want one blade to 3D-print it */

SINGLE = false;

if (SINGLE == true) {
    color("PowderBlue")
        blade();
}
else {
    rotate(3600*$t, [0, 0, 1]) {
        turbine();
        shaft();
        frame();  
    }
} 
 





