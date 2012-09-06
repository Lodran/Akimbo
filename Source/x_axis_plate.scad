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

plate=1;

if (plate==1)
  x_ends();

if (plate==2)
	extruders();
  
module x_ends()
{
	for(i=[-1, 1])
	{
		rotate([0, 0, i*90+90])
		translate([33, -13, 0])
		akimbo_x_end(print_orientation=true, constrained=(i==1), motor_bracket=true, idler_bracket=true);
	}

	%cube([150, 150, 1], center=true);
}

module extruders()
{
	for(i=[-1, 1])
	{
		scale([i, 1, 1])
		{
			translate([12, 31, 0])
			akimbo_extruder(print_orientation=true);

			translate([-12, 31, 0])
			akimbo_extruder_idler(print_orientation=true);
		}

		translate([i*32+20, -37, 0])
		akimbo_carriage(print_orientation=true);

		translate([i*32, 7, 0])
		rotate([0, 0, i*90-90])
		akimbo_x_endstop_flag();
	}

	%cube([150, 150, 1], center=true);
}