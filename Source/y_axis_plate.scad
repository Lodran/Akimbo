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
// y_axis_plate.scad
//

use <akimbo_barclamp.scad>
use <akimbo_endstop_mount.scad>
use <y_pillow_block.scad>

%translate([0, 0, 0.5])
cube([150, 150, 1], center=true);

y_axis_parts();

module y_axis_parts()
{
  for (i=[-1, 1]) for (j=[-1, 1])
    translate([i*30-15, j*15, 0])
    barclamp(print_orientation=true);

	for(i=[-1, 1])
		translate([i*37, 43, 0])
		y_pillow_block(print_orientation=true);

	translate([0, 43, 0])
	y_roller_bearing_block(print_orientation=true);

	translate([0, -41, 0])
	akimbo_endstop_mount(print_orientation=true);
}
