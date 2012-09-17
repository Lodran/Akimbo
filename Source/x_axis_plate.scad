//
// RepRap Mendel Akimbo
//
// A Mendel variant, which improves the frame's clearance and stability
//  by increasing it's triangulation.
//
// Copyright 2012 by Ron Aldrich.
//
// Licensed under GNU GPL v2
//
// frame_plate.scad
//

use <akimbo_x_end.scad>
use <akimbo_extruder.scad>
use <akimbo_carriage.scad>

plate=2;

if (plate==1)
  x_ends();

if (plate==2)
	extruders();
  
module x_ends()
{
	for(i=[-1, 1])
	{
		rotate([0, 0, i*90+90])
		translate([47, 7, 0])
		akimbo_x_end(print_orientation=true, constrained=(i==1), motor_bracket=true, idler_bracket=true);
	}
  
	rotate([0, 0, 180])
	translate([47, 7, 0])
  	akimbo_z_magnet_clamp(print_orientation=true);

	%cube([150, 150, 1], center=true);
}

module extruders()
{
	for(i=[-1, 1])
	{
		translate([-25, 0, 0])
		scale([i, 1, 1])
		{
			translate([-13, -25, 0])
			render(convexity=8)
			akimbo_extruder(print_orientation=true);

			translate([33, 35, 0])
			render(convexity=8)
			akimbo_extruder_idler(print_orientation=true);
		}

		translate([i*9+25, i*12, 0])
		rotate([0, 0, i*90+90])
		render(convexity=8)
		akimbo_carriage(print_orientation=true);

		translate([9+i*6, 31, 0])
		rotate([0, 0, 90])
		render(convexity=8)
		akimbo_x_endstop_flag(print_orientation=true);
	}

	%cube([150, 150, 1], center=true);
}