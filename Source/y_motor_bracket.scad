//
// Triffid Hunter's derivitave of the Prusa i2 Y motor bracket.
//
//	http://www.thingiverse.com/thing:30898
//
// Licensed under http://creativecommons.org/licenses/by/3.0/
//

$fa = 0.01;
$fs = 0.5;

m8_nut_diameter = 10 / cos(180 / 6);
m8_diameter = 8.6;
m3_diameter = 3.2 / cos(180 / 8);

m3_washer_diameter = 8.5;
m8_washer_diameter = 17;

endstop_height = 24;
endstop_mount = 0;

module ybrac_base() {
	difference() {
		hull() {
			translate([3.4,30.05,0])
				cylinder(h=12,r=m8_washer_diameter/2 + 1);
			translate([-26,-21,0])
				cylinder(h=12,r=m8_washer_diameter/2 + 1);
			translate([33.5,-20.5,0])
				cylinder(h=12,r=m3_washer_diameter/2 + 2.5);
			translate([15,19.2,0])
				cylinder(h=12,r=m3_washer_diameter/2 + 2.5);
		}
		translate([0, 0, -1])
		hull() {
			translate([-17, 8, 0]) cylinder(r=20, h=50, center=true);
			difference() {
				translate([-27, 0, -25]) mirror([0, 1, 0]) cube([1, 25, 50]);
				translate([-26,-21,0]) cylinder(h=60, r=m8_washer_diameter/2 + 1, center=true);
			}
			difference() {
				translate([3.4,30.05,-25]) rotate([0, 0, 123]) cube([1, 35, 50]);
				translate([3.4,30.05,0]) cylinder(h=60,r=m8_washer_diameter/2 + 1, center=true);
			}
		}
		difference() {
			translate([-47, 0, -25]) mirror([0, 1, 0]) cube([20, 25, 50]);
			translate([-26,-21,0]) cylinder(h=60, r=m8_washer_diameter/2 + 1, center=true);
		}
		difference() {
			translate([-17, 0, -25]) rotate([0, 0, -30]) mirror([1, 0, 0]) cube([20, 35, 50]);
			translate([3.4,30.05,0]) cylinder(h=12,r=m8_washer_diameter/2 + 1);
		}
		hull() {
			translate([(15 + 33.5) / 2, (19.2 - 20.5) / 2, 0]) cylinder(r=12.5, h=50, center=true);
			difference() {
				translate([33.5,-20.5,-25]) cube([1, 25, 50]);
				translate([33.5,-20.5,0]) cylinder(h=50,r=m3_washer_diameter/2 + 2.5, center=true);
			}
			difference() {
				translate([15,19.2,-25]) rotate([0, 0, -115]) cube([1, 25, 50]);
				translate([15,19.2,0]) cylinder(h=50,r=m3_washer_diameter/2 + 2.5, center=true);
			}
		}
		difference() {
			translate([33.5,-20.5,-25]) cube([20, 25, 50]);
			translate([33.5,-20.5,0]) cylinder(h=50,r=m3_washer_diameter/2 + 2.5, center=true);
		}
		difference() {
			difference() {
				translate([15,19.2,-25]) rotate([0, 0, -115]) translate([0.5, 0, 0]) mirror([1, 0, 0]) cube([20, 25, 50]);
				translate([15,19.2,-30]) rotate([0, 0, -115 + 55]) mirror([1, 0, 0]) cube([25, 25, 60]);
			}
			translate([15,19.2,0]) cylinder(h=60,r=m3_washer_diameter/2 + 2.5, center=true);
		}
	}
	*%translate([7,4.5])
		rotate([0,0,90])
			mirror()
				linear_extrude(file="ybrac-t.dxf",height=12);
}

module ybract() {
	difference() {
		union() {
			ybrac_base()
			if (endstop_mount != 0) {
				// endstop mount bubble
				translate([-20, endstop_height, 6])
					cylinder(r=7.5, h=12, center=true);

				// endstop mount curve
				translate([14, -18, 6])
					intersection() {
						difference() {
							cylinder(r=50, h=11.99, center=true);
							cylinder(r=45, h=15, center=true);
						}
							translate([-61, -5, -25])
							cube([51, 100, 50]);
					}
			}
		}

		if (endstop_mount != 0) {
			// endstop zip-tie points
			translate([-20, endstop_height + 4.5, 6])
				cube([m3_diameter, 2.5, 50], center=true);
			translate([-20, endstop_height - 4.5, 6])
				cube([m3_diameter, 2.5, 50], center=true);
		}

		// M8 rod holes
		translate([3.4,30.05,10])
			cylinder(h=30,r=m8_diameter/2, center=true);
		translate([-26,-21,10])
			cylinder(h=30,r=m8_diameter/2, center=true);

		// M8 washer recesses, top
		translate([3.4, 30.05, 12])
			cylinder(h=2, r=m8_washer_diameter/2, center=true);
		translate([-26,-21,12])
			cylinder(h=2, r=m8_washer_diameter/2, center=true);

		// motor mount screw holes
		translate([33.5,-20.5,10])
			cylinder(h=30,r=m3_diameter/2, center=true, $fs=0.5);
		translate([4.5,-10,10])
			cylinder(h=30,r=m3_diameter/2, center=true, $fs=0.5);
		translate([15,19.2,10])
			cylinder(h=30,r=m3_diameter/2, center=true, $fs=0.5);

		// motor mount screw countersinks
		translate([33.5,-20.5,12])
			cylinder(h=10,r=m3_washer_diameter/2, center=true);
		translate([4.5,-10,12])
			cylinder(h=10,r=m3_washer_diameter/2, center=true);
		translate([15,19.2,12])
			cylinder(h=10,r=m3_washer_diameter/2, center=true);

		// CIRCULAR slot for top rod, based on bottom slot position!
		intersection() {
			translate([-26, -21, 6])
				difference() {
					cylinder(h=15, r=sqrt((3.4 - -26) * (3.4 - -26) + (30.05 - -21) * (30.05 - -21)) + (m8_diameter - 1)/2, center=true);
					cylinder(h=16, r=sqrt((3.4 - -26) * (3.4 - -26) + (30.05 - -21) * (30.05 - -21)) - (m8_diameter - 1)/2, center=true);
				}
			translate([3.4 - m8_washer_diameter / 2, 32, 6])
				rotate([0, 0, 335])
					cube([m8_washer_diameter, m8_washer_diameter, 15], center=true);
		}

		// slot for low rod
		translate([-26,-31,6])
			cube([m8_diameter - 1, 20, 30], center=true);
		translate([-26,-30,6])
			rotate([0, 0, 45])
				cube([m8_diameter, m8_diameter, 30], center=true);
	}
}

mirror()
	ybract();
