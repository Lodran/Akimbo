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
use <z_clamp.scad>

assembly();

module assembly()
{
	%render() frame_annotations();

	for(i=[-1, 1]) scale([i, 1, 1])
	{
		for(j=[-1, 1]) scale([1, j, 1])
			render() bottom_vertex(print_orientation=false);

		render() top_vertex(print_orientation=false);

		render() z_clamp(print_orientation=false);
	}
}