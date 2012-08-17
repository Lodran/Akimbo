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
// z_clamp.scad
//
// Clamps the lower end of the Z axis linear rod to the frame.
//
// Print one with normal orientation, and one with mirrored orientation.
//

include <more_configuration.scad>
include <frame_computations.scad>

m8_washer_diameter = 20;

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>
use <pill.scad>

print_orientation = false;
mirrored = false;

z_frame_rod_clamp_min = [j2/2, z_horizontal_rod_center[y]-12, -12-clamp_rod_separation/2];
z_frame_rod_clamp_max = z_frame_rod_clamp_min+[vertex_width, 24, 24];

z_frame_rod_clamp_center = centerof(z_frame_rod_clamp_min, z_frame_rod_clamp_max);
z_frame_rod_clamp_size = sizeof(z_frame_rod_clamp_min, z_frame_rod_clamp_max);

z_linear_rod_clamp_min = [z_linear_rod_center[x]-vertex_width, -16, z_frame_rod_clamp_min[z]];
z_linear_rod_clamp_max = [z_linear_rod_clamp_min[x]+vertex_width, z_frame_rod_clamp_max[y], z_linear_rod_clamp_min[z]+32];
z_linear_rod_clamp_center = centerof(z_linear_rod_clamp_min, z_linear_rod_clamp_max);
z_linear_rod_clamp_size = sizeof(z_linear_rod_clamp_min, z_linear_rod_clamp_max);

connector_min = [z_frame_rod_clamp_max[x], z_frame_rod_clamp_min[y], z_frame_rod_clamp_min[z]];
connector_max = [z_linear_rod_clamp_min[x], z_frame_rod_clamp_max[y], z_frame_rod_clamp_max[z]];
connector_center = centerof(connector_min, connector_max);
connector_size = sizeof(connector_min, connector_max);

/*
z_clamp_min = [j2/2, -16, -12-clamp_rod_separation/2];
z_clamp_max = [z_linear_rod_center[x], 16, z_clamp_min[z]+30];

z_clamp_center = centerof(z_clamp_min, z_clamp_max);
z_clamp_size = sizeof(z_clamp_min, z_clamp_max);
*/

frame_bracket_end_radius = m8_washer_diameter/2;
frame_bracket_center_radius = 6;

frame_horizontal_bracket_center = [(j2/2+z_linear_rod_center[x])/2, z_horizontal_rod_center[y], z_horizontal_rod_center[z]];
frame_horizontal_bracket_length = z_linear_rod_center[x]-j2/2;

frame_bottom_bracket_center = [front_left[x], frame_horizontal_bracket_center[y], front_left[z]];
frame_bottom_bracket_length = 24;

z_linear_rod_bracket_radius = 15/2;
z_linear_rod_bracket_length = z_rod_clamp_bolt_separation;
z_linear_rod_bracket_size = [8, z_linear_rod_bracket_length, z_linear_rod_bracket_radius*2];
z_linear_rod_bracket_center = [z_linear_rod_center[x]-z_linear_rod_bracket_size[x]/2, z_linear_rod_center[y], 6];

j1b=j1/2-z_frame_rod_clamp_max[y];

echo(str("jig 1b length = ", j1b, "mm"));

%frame_annotations();

z_clamp(print_orientation=print_orientation, mirrored=mirrored);

module z_clamp(print_orientation=true, mirrored=false)
{
	p1=(print_orientation==true) ? 1 : 0;
  	s1=(mirrored==true) ? -1 : 1;
  
  	scale([s1, 1, 1])
	rotate(p1*[0, 90, 0])
	translate(p1*[-z_linear_rod_clamp_max[x], -z_linear_rod_clamp_center[y], -z_linear_rod_clamp_center[z]])

	difference()
	{
		z_clamp_solid();
		z_clamp_void();
	}
}

module z_clamp_solid()
{
	hull()
	{
		translate(z_linear_rod_bracket_center)
		rotate([0, 90, 0])
		pill(length=z_linear_rod_bracket_length, h=z_linear_rod_bracket_size[x], r=z_linear_rod_bracket_radius, center=true);

		translate([z_linear_rod_clamp_max[x]-vertex_width/2, connector_center[y], z_horizontal_rod_center[z]])
		rotate([0, 90 , 0])
		cylinder(h=vertex_width, r=frame_bracket_center_radius/2, center=true);
	}

	translate(frame_horizontal_bracket_center)
	rotate([0, 90 , 0])
	bone(h=frame_horizontal_bracket_length, r1=frame_bracket_end_radius, r2=frame_bracket_center_radius);

	hull()
	{
		translate(frame_bottom_bracket_center)
		rotate([90, 0 , 0])
		cylinder(h=frame_bottom_bracket_length, r=frame_bracket_end_radius, center=true);

		translate([z_frame_rod_clamp_max[x]+20, connector_center[y], z_horizontal_rod_center[z]])
		rotate([0, 90 , 0])
		cylinder(h=1, r=frame_bracket_center_radius/2, center=true);
	}

}

module z_clamp_void()
{
	frame_void();

	// Linear rod clamp

	for(i=[-1, 1])
		translate([z_linear_rod_clamp_max[x]-vertex_width/2, i*z_rod_clamp_bolt_separation/2, 6])
		rotate([0, 90, 0])
		{
			cylinder(h=vertex_width+.1, r=m3_diameter/2, $fn=12, center=true);
			translate([0, 0, -(vertex_width-10)/2-.05])
			cylinder(h=10+.1, r=m3_nut_diameter/2, $fn=6, center=true);
		}

	translate(frame_horizontal_bracket_center+[-(frame_horizontal_bracket_length+4)/2, 0, 0])
	rotate([0, 90, 0])
	cylinder(h=4, r=frame_bracket_end_radius, center=true);

}

module frame_void()
{
	translate([front_left[x], 0, front_left[z]])
	rotate([90, 0, 0])
	rotate([0, 0, 90])
	octylinder(h=triangle_rod_length, r=threaded_rod_diameter/2, center=true);

	translate(z_linear_rod_center)
	rotate([0, 0, 90])
	octylinder(h=z_axis_linear_rod_length, r=smooth_rod_diameter/2, center=true);

	translate(z_horizontal_rod_center)
	rotate([0, 90, 0])
	cylinder(h=frame_top_rod_length, r=threaded_rod_diameter/2, center=true);
}

module bone(h, r1, r2)
{
	cylinder(h=h-.1, r=r2, center=true, $fn=32);

	for(i=[-1, 1]) scale([1, 1, i])
	{
		translate([0, 0, h/2-4])
		cylinder(h=8, r=r1, center=true, $fn=32);

		translate([0, 0, 12])
		cylinder(h=h-40, r1=0, r2=r1, center=true, $fn=32);
	}
	
}
