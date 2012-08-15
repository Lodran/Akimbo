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
// assembly.scad
//
// Frame Assembly
//

include <more_configuration.scad>
include <frame_computations.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>

use <bottom_vertex.scad>
use <top_vertex.scad>
use <z_bottom_frame_clamp.scad>
use <z_linear_rod_clamp.scad>

assembly();

module assembly()
{
	color([.75, .75, .75]) render() frame_annotations();

	for(i=[-1, 1]) scale([i, 1, 1])
	{
		for(j=[-1, 1]) scale([1, j, 1])
			render() bottom_vertex(print_orientation=false);

		render() top_vertex(print_orientation=false);

		render() z_clamp(print_orientation=false);

		translate([z_linear_rod_center[x], 0, 6])
			rotate([0, 90, 0])
			render() z_linear_clamp();

		translate([z_linear_rod_center[x], 0, upper_vertex_p1[z]-4])
			rotate([0, 90, 0])
			render() z_linear_clamp();
	}
}