//
// RepRap Mendel Akimbo
//
// A Mendel variant, which improves the frame's clearance and stability
//  by increasing its triangulation.
//
// Copyright 2012 by Ron Aldrich.
//
// Licensed under GNU GPL v2
//
// motor.scad
//
// Generates a rough drawing of a NEMA 17 motor, for annotation purposes.
//

include <more_configuration.scad>

motor_size = [40, 40, 47];
hub_height = 2;
hub_radius = 17/2;
shaft_radius = 5/2;
shaft_length = 20;

function motor_bolt_hole_spacing() = 1.22*25.4;

motor_bolt_hole_length = 6;

module motor()
{
	difference()
	{
		union()
		{
			translate([0, 0, -motor_size[2]/2])
			cube(motor_size, center=true);

			translate([0, 0, hub_height/2-.05])
			cylinder(h=hub_height+.1, r=hub_radius, center=true);

			translate([0, 0, shaft_length/2])
			cylinder(h=shaft_length, r=shaft_radius, $fn=24, center=true);
		}

		for(i=[-1, 1]) for (j=[-1, 1])
			translate([i*motor_bolt_hole_spacing()/2, j*motor_bolt_hole_spacing()/2, -motor_bolt_hole_length/2+.05])
			cylinder(h=motor_bolt_hole_length+.1, r=3/2, $fn=12, center=true);
	}
}

motor();
