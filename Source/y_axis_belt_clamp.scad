//
// RepRap Mendel Akimbo
//
// A Mendel variant, which improves the frame's clearance and stability
//  by increasing its triangulation.
//
// Copyright 2012 by Ron Aldrich.
//
// Licensed under GNU GPL v2
//
// y_axis_belt_clamp.scad

include <more_configuration.scad>
include <frame_computations.scad>
include <vitamin.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>
use <pill.scad>

echo(y_linear_rod_offset[z]+9.2-608_bearing[bearing_body_diameter]/2-3);

hole_spacing = 18;

base_size = [hole_spacing, 10, 12];
base_center = [0, 0, base_size[z]/2];

belt_slot_size = [7, base_size[y], 3];
belt_slot_center = [0, 0, belt_slot_size[z]/2];

belt_pitch = 3;
clamp_tooth_size = [7, belt_pitch/2, 1];
clamp_tooth_center = [0, 0, base_size[z]-clamp_tooth_size[z]/2];

adjuster_screw_center = [0, 0, (base_size[z]+belt_slot_size[z])/2];

clamp_size = [hole_spacing, base_size[y], 5];
clamp_center = [0, 0, clamp_size[z]/2];

clamp_slot_size = [7, clamp_size[y], 1];
clamp_slot_center = [0, 0, clamp_slot_size[z]/2];

spacer_size = [base_size[x], base_size[y], y_linear_rod_offset[z]+9.2-608_bearing[bearing_body_diameter]/2-belt_slot_size[z]];
spacer_center = [0, 0, spacer_size[z]/2];

y_axis_belt_spacer(print_orientation=true);
y_axis_belt_tensioner(print_orientation=true);
y_axis_belt_clamp(print_orientation=true);

translate([0, -13, 0])
y_axis_belt_spacer(print_orientation=true);

translate([0, 13, 0])
y_axis_belt_clamp(print_orientation=true);


module y_axis_belt_spacer(print_orientation)
{
	t1= (print_orientation==true) ? 1 : 0;
	t2= (print_orientation==false) ? 1 : 0;

	translate(t1*[0, -13, 0])
	rotate(t2*[180, 0, 0])
	difference()
	{
		y_axis_belt_spacer_solid();
		y_axis_belt_spacer_void();
	}
}

module y_axis_belt_spacer_solid()
{
	translate(spacer_center)
	{
		cube(spacer_size, center=true);
		for(i=[-1, 1])
			translate([i*hole_spacing/2, 0, 0])
			cylinder(h=spacer_size[z], r=spacer_size[y]/2, $fn=20, center=true);
	}
}

module y_axis_belt_spacer_void()
{
	// mounting screw holes.

	translate(spacer_center)
	for(i=[-1, 1])
		translate([i*hole_spacing/2, 0, 0])
		cylinder(h=spacer_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);
}

module y_axis_belt_tensioner(print_orientation)
{
	t1= (print_orientation==true) ? 1 : 0;
	t2= (print_orientation==false) ? 1 : 0;

	rotate(t2*[180, 0, 0])
	translate(t2*[0, 0, spacer_size[z]+.5])
	difference()
	{
		y_axis_belt_tensioner_solid();
		y_axis_belt_tensioner_void();
	}
}

module y_axis_belt_tensioner_solid()
{
	translate(base_center)
	{
		cube(base_size, center=true);
		for(i=[-1, 1])
			translate([i*hole_spacing/2, 0, 0])
			cylinder(h=base_size[z], r=base_size[y]/2, $fn=20, center=true);
	}
}

module y_axis_belt_tensioner_void()
{
	// mounting screw holes.

	translate(base_center)
	for(i=[-1, 1])
		translate([i*hole_spacing/2, 0, 0])
		cylinder(h=base_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);

	// belt slot.

	translate(belt_slot_center+[0, 0, -.05])
	cube(belt_slot_size+[0, .1, .1], center=true);

	// adjuster screw.

	translate(adjuster_screw_center)
	rotate([90, 0, 0])
	{
		hexylinder(h=base_size[y]+.1, r=m3_diameter/2, $fn=12, center=true);
		translate([0, 0, base_size[y]/2-4])
		cylinder(h=4+.1, r=m3_nut_diameter/2, $fn=6, center=false);
	}

	// belt clamp teeth

	for(i=[-2:2])
		translate(clamp_tooth_center + [0, i*belt_pitch, .05])
		cube(clamp_tooth_size+[0, 0, .1], center=true);

}

module y_axis_belt_clamp(print_orientation)
{
	t1= (print_orientation==true) ? 1 : 0;
	t2= (print_orientation==false) ? 1 : 0;

	translate(t1*[0, 13, 0])
	rotate(t2*[180, 0, 0])
	translate(t2*[0, 0, spacer_size[z]+base_size[z]+1])
	difference()
	{
		y_axis_belt_clamp_solid();
		y_axis_belt_clamp_void();
	}
}

module y_axis_belt_clamp_solid()
{
	translate(clamp_center)
	{
		cube(clamp_size, center=true);
		for(i=[-1, 1])
			translate([i*hole_spacing/2, 0, 0])
			cylinder(h=clamp_size[z], r=clamp_size[y]/2, $fn=20, center=true);
	}
}

module y_axis_belt_clamp_void()
{
	translate(clamp_center)
	for(i=[-1, 1])
		translate([i*hole_spacing/2, 0, 0])
		{
			cylinder(h=clamp_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);

			translate([0, 0, clamp_size[z]/2])
			{
				cylinder(h=4, r=3.75, $fn=20, center=true);
			}
		}

	translate(clamp_slot_center+[0, 0, -.05])
	cube(clamp_slot_size+[0, .1, .1], center=true);
}




