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

plate=2;

if (plate==1)
  bottom_plate();
  
if (plate==2)
  z_plate();

module bottom_plate()
{
	translate([0, 37, 0])
	for(i=[-1,1]) scale([i, 1, 1])
	{
		for(j=[-1,1])
		{
			translate([0, i*40+j*20, 0])
			bottom_vertex(print_orientation=true);
		}
	}
}

module z_plate()
{
	for(i=[-1, 1])
	{
		translate([i*35+3, 0, 0])
		top_vertex(print_orientation=true);

		translate([9, i*-55, 0])
		scale([1, i, 1])
		z_clamp(print_orientation=true);
	}

	for(i=[-1, 1]) for(j=[-1, 1]) translate([i*9, j*18, 0])
	z_linear_clamp();

}
