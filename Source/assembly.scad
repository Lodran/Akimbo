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

use <akimbo_extruder.scad>
use <akimbo_carriage.scad>
use <akimbo_x_end.scad>

carriage_offset = 110;

assembly();

module rp_assembly()
{
	// Frame

	render(convexity=8)
	for(i=[-1, 1]) scale([i, 1, 1])
	{
		for(j=[-1, 1]) scale([1, j, 1])
			bottom_vertex(print_orientation=false);

		top_vertex(print_orientation=false);

		z_clamp(print_orientation=false);

		translate([z_linear_rod_center[x], 0, 6])
			rotate([0, 90, 0])
			z_linear_clamp();

		translate([z_linear_rod_center[x], 0, upper_vertex_p1[z]-4])
			rotate([0, 90, 0])
			z_linear_clamp();
      
	}

	// Z axis (X ends)

	for(i=[0, 1]) rotate([0, 0, i*180])
	{
		render(convexity=8)
		akimbo_x_end(print_orientation=false, constrained=(i==0), motor_bracket=true, idler_bracket=true);
	}

	// X axis (Carriages, Extruders)

	translate([carriage_offset, extruder_offset, x_axis_height])
	{
		render(convexity=8)
		akimbo_carriage(print_orientation=false);

		akimbo_x_endstop_flag(print_orientation=false);

		translate([0, 0, linear_clamp_radius+8])
		{
			render(convexity=8)
			{
				akimbo_extruder(print_orientation=false);
				akimbo_extruder_idler(print_orientation=false);
			}
		}
	}

	translate([carriage_offset-21, extruder_offset, x_axis_height])
	{
		render(convexity=8)
		rotate([0, 0, 180])
		akimbo_carriage(print_orientation=false);

		scale([-1, 1, 1])
		translate([0, 0, linear_clamp_radius+8])
		{
			render(convexity=8)
			{
				akimbo_extruder(print_orientation=false);
				akimbo_extruder_idler(print_orientation=false);
			}
		}
	}
}

module vitamin_assembly()
{
	// Frame

	render(convexity=8) frame_annotations();
	render(convexity=8) x_annotations();

	// Z axis (X ends)

	for(i=[0, 1]) rotate([0, 0, i*180])
	{
		render(convexity=8) x_end_annotations(print_orientation=false);
	}

	// X axis (Carriages, Extruders)

	translate([carriage_offset, extruder_offset, x_axis_height])
	{
		translate([0, 0, linear_clamp_radius+8])
		{
			render(convexity=8) akimbo_extruder_annotations(print_orientation=false, mirrored=false);
		}
	}

	translate([carriage_offset-21, extruder_offset, x_axis_height])
	{
		scale([-1, 1, 1])
		translate([0, 0, linear_clamp_radius+8])
		{
			render(convexity=8) akimbo_extruder_annotations(print_orientation=false, mirrored=false);
		}
	}

}


module assembly()
{
	rp_assembly();
	color([.75, .75, .75]) vitamin_assembly();
}