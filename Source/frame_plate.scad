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

use <bottom_vertex.scad>
use <top_vertex.scad>
use <z_bottom_frame_clamp.scad>
use <z_linear_rod_clamp.scad>

plate=1;

%translate([0, 0, 0.5])
cube([150, 150, 1], center=true);

if (plate==1)
  bottom_plate();
  
if (plate==2)
  z_plate();

module bottom_plate()
{
	translate([-10, -23])
	bottom_vertex(print_orientation=true);

	translate([10, 12])
	bottom_vertex(print_orientation=true);


	translate([0, 48])
	bottom_vertex(print_orientation=true, mirrored=true);

	translate([-20, 83])
	bottom_vertex(print_orientation=true, mirrored=true);
}

module z_plate()
{
	for(i=[-1, 1])
	{
		translate([i*40+5, 0, 0])
		top_vertex(print_orientation=true);

		translate([9, i*-45, 0])
		scale([1, i, 1])
		z_clamp(print_orientation=true);
	}

	for(i=[-1, 1])
	{
		translate([i*9, 0, 0])
		z_linear_clamp();

		translate([i*60+1, 0, 0])
		z_linear_clamp();
	}
}
