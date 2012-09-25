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
use <akimbo_barclamp.scad>
use <y_pillow_block.scad>
use <y_axis_belt_clamp.scad>
use <z_motor_coupler.scad>

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
		rotate([0, 0, 180])
		render(convexity=8)
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

	// Y axis
	
	for(i=[-1, 1]) for(j=[-1, 1]) scale([i, j, 1])
	translate(y_barclamp_center)
		barclamp(print_orientation=false);

	for(i=[-1, 1]) scale([1, i, 1])
		translate(y_pillowblock_center)
		scale([1, -1, 1])
		y_pillow_block(print_orientation=false);

	scale([-1, 1, 1])
		translate(y_pillowblock_center)
		scale([1, -1, 1])
		y_roller_bearing_block(print_orientation=false);

	translate([0, y_pillowblock_center[y], y_pillowblock_center[z]+y_linear_rod_offset[z]])
	{
		y_axis_belt_spacer(print_orientation=false);
		y_axis_belt_tensioner(print_orientation=false);
		y_axis_belt_clamp(print_orientation=false);
	}

	// Z axis
	
	for(i=[-1, 1]) for(j=[0, 1]) scale([i, 1, 1]) translate(z_motor_center+[0, 0, -(15+j*12)])
		z_motor_coupler(print_orientation=false);
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

	for(i=[-1, 1]) scale([i, 1, 1])
		translate([y_barclamp_center[x], 0, y_barclamp_center[z]])
		rotate([90, 0, 0])
		cylinder(h=y_axis_linear_rod_length, r=4, center=true);
		
	for(i=[-1, 1]) scale([1, i, 1])
		translate([0, lower_vertex_p2[y], lower_vertex_p2[z]])
		rotate([0, 90, 0])
		cylinder(h=608_bearing[bearing_length]*2, r=608_bearing[bearing_body_diameter]/2, center=true);
		
	translate([0, 0, lower_vertex_p2[z]+(608_bearing[bearing_body_diameter]+3)/2])
		cube([6, lower_vertex_p2[y]*2, 3], center=true);

	translate([0, 0, y_barclamp_center[z]+y_linear_rod_offset[z]])
	{
		translate([0, 0, 3/2])
		cube([210, 210, 3], center=true);

		translate([0, 0, 3+1/4*25.4+1.5/2])
		cube([210, 210, 1.5], center=true);
	}
	
	
}


module assembly()
{
	rp_assembly();
	color([.75, .75, .75]) vitamin_assembly();
}