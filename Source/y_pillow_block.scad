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
// y_pillow_block.scad
//
// Clamps the y axis LM8UUs into place
//
// Print two.
//

include <more_configuration.scad>
include <frame_computations.scad>

use <teardrops.scad>
use <pill.scad>

print_orientation = true;

mounting_screw_spacing = 24;

linear_bearing_length = lm8uu[bearing_length]+lm8uu_clearance[bearing_length];
linear_bearing_radius = (lm8uu[bearing_body_diameter]+lm8uu_clearance[bearing_body_diameter])/2;

y_pillow_block_body_min = [-bearing_clamp_radius, -linear_bearing_length/2, 0];
y_pillow_block_body_max = [bearing_clamp_radius, linear_bearing_length/2, y_linear_rod_offset[z]];
y_pillow_block_body_center = centerof(y_pillow_block_body_min, y_pillow_block_body_max);
y_pillow_block_body_size = sizeof(y_pillow_block_body_min, y_pillow_block_body_max);

y_pillow_block_bolt_mount_min = [-mounting_screw_spacing/2, y_pillow_block_body_min[y], y_pillow_block_body_max[z]-15];
y_pillow_block_bolt_mount_max = [mounting_screw_spacing/2, y_pillow_block_body_min[y]+10, y_pillow_block_body_max[z]];
y_pillow_block_bolt_mount_center = centerof(y_pillow_block_bolt_mount_min, y_pillow_block_bolt_mount_max);
y_pillow_block_bolt_mount_size = sizeof(y_pillow_block_bolt_mount_min, y_pillow_block_bolt_mount_max);

y_pillow_block_clamp_center = [0, 0, -linear_bearing_radius-4];
y_pillow_block_clamp_size = [15, 12, 12];

y_roller_bearing_block_body_min = [-bearing_clamp_radius, -linear_bearing_length/2, 0];
y_roller_bearing_block_body_max = [bearing_clamp_radius, linear_bearing_length/2, y_linear_rod_offset[z]];
y_roller_bearing_block_body_center = centerof(y_roller_bearing_block_body_min, y_roller_bearing_block_body_max);
y_roller_bearing_block_body_size = sizeof(y_roller_bearing_block_body_min, y_roller_bearing_block_body_max);

y_roller_bearing_block_bolt_mount_min = [-mounting_screw_spacing/2, y_roller_bearing_block_body_min[y], y_roller_bearing_block_body_max[z]-15];
y_roller_bearing_block_bolt_mount_max = [mounting_screw_spacing/2, y_roller_bearing_block_body_min[y]+10, y_roller_bearing_block_body_max[z]];
y_roller_bearing_block_bolt_mount_center = centerof(y_roller_bearing_block_bolt_mount_min, y_roller_bearing_block_bolt_mount_max);
y_roller_bearing_block_bolt_mount_size = sizeof(y_roller_bearing_block_bolt_mount_min, y_roller_bearing_block_bolt_mount_max);

y_roller_bearing_block_clamp_center = [0, 0, -(actual_smooth_rod_diameter+linear_roller_bearing[bearing_body_diameter])/2];
y_roller_bearing_block_clamp_size = [15, 12, 12];

for(i=[-1, 1])
	translate([0, i*16, 0])
y_pillow_block();

translate([0, 48, 0])
y_roller_bearing_block();

module y_pillow_block(print_orientation=print_orientation)
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;

	rotate(p1*[90, 0, 0])

	difference()
	{
		y_pillow_block_solid();
		y_pillow_block_void();
	}
}

module y_pillow_block_solid()
{
	translate(y_pillow_block_body_center)
	cube(y_pillow_block_body_size, center=true);

	rotate([90, 0, 0])
	cylinder(h=y_pillow_block_body_size[y], r=y_pillow_block_body_size[x]/2, center=true);

	translate(y_pillow_block_bolt_mount_center)
	cube(y_pillow_block_bolt_mount_size, center=true);

	for(i=[-1, 1])
		translate(y_pillow_block_bolt_mount_center+[i*mounting_screw_spacing/2, 0, 0])
		rotate([0, 0, 180])
		octylinder(h=y_pillow_block_bolt_mount_size[z], r=y_pillow_block_bolt_mount_size[y]/2, center=true);

	translate(y_pillow_block_clamp_center)
	rotate([0, 90, 0])
	{
		cylinder(h=y_pillow_block_clamp_size[x], r=y_pillow_block_clamp_size[z]/2, center=true);

		intersection()
		{
			for(i=[-1, 1])
				rotate([0, 0, i*45])
				translate([-10, 0, 0])
				cube([20, y_pillow_block_clamp_size[y], y_pillow_block_clamp_size[x]], center=true);

			cube([y_pillow_block_clamp_size[z], y_pillow_block_body_size[y], y_pillow_block_clamp_size[x]], center=true);
		}
	}
}

module y_pillow_block_void()
{
	rotate([90, 0, 0])
	cylinder(h=y_pillow_block_body_size[y]+.1, r=linear_bearing_radius, center=true);

	for(i=[-1, 1])
	{
		translate(y_pillow_block_bolt_mount_center+[i*mounting_screw_spacing/2, 0, 0])
		cylinder(h=y_pillow_block_bolt_mount_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);

		translate([y_pillow_block_bolt_mount_center[x]+i*mounting_screw_spacing/2, y_pillow_block_bolt_mount_center[y], y_pillow_block_bolt_mount_min[z]-5])
		cylinder(h=10, r=m3_washer_diameter/2, $fn=12, center=true);
	}

	translate(y_pillow_block_clamp_center)
	{
		cube([1.5, y_pillow_block_body_size[y]+.1, y_pillow_block_clamp_size[z]+.1], center=true);

		rotate([0, 90, 0])
		{
			cylinder(h=y_pillow_block_clamp_size[x]+.1, r=m3_diameter/2, $fn=12, center=true);

			translate([0, 0, (y_pillow_block_clamp_size[x]-3)/2+.05])
			cylinder(h=3+.1, r=m3_washer_diameter/2, center=true);

			translate([0, 0, -((y_pillow_block_clamp_size[x]-3)/2+.05)])
			cylinder(h=3+.1, r=m3_nut_diameter/2, $fn=6, center=true);
		}
	}
}

module y_roller_bearing_block()
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;

	rotate(p1*[90, 0, 0])
	difference()
	{
		y_roller_bearing_block_solid();
		y_roller_bearing_block_void();
	}
}

module y_roller_bearing_block_solid()
{
	translate(y_roller_bearing_block_body_center)
	cube(y_roller_bearing_block_body_size, center=true);

	rotate([90, 0, 0])
	cylinder(h=y_roller_bearing_block_body_size[y], r=y_roller_bearing_block_body_size[x]/2, center=true);

	translate(y_roller_bearing_block_bolt_mount_center)
	cube(y_roller_bearing_block_bolt_mount_size, center=true);

	for(i=[-1, 1])
		translate(y_roller_bearing_block_bolt_mount_center+[i*mounting_screw_spacing/2, 0, 0])
		rotate([0, 0, 180])
		octylinder(h=y_roller_bearing_block_bolt_mount_size[z], r=y_roller_bearing_block_bolt_mount_size[y]/2, center=true);

	translate(y_roller_bearing_block_clamp_center)
	rotate([0, 90, 0])
	{
		cylinder(h=y_roller_bearing_block_clamp_size[x], r=y_roller_bearing_block_clamp_size[z]/2, center=true);

		intersection()
		{
			for(i=[-1, 1])
				rotate([0, 0, i*45])
				translate([-10, 0, 0])
				cube([20, y_roller_bearing_block_clamp_size[y], y_roller_bearing_block_clamp_size[x]], center=true);

			cube([y_roller_bearing_block_clamp_size[z], y_roller_bearing_block_body_size[y], y_roller_bearing_block_clamp_size[x]], center=true);
		}
	}
}

module y_roller_bearing_block_void()
{
	rotate([90, 0, 0])
	cylinder(h=y_roller_bearing_block_body_size[y]+.1, r=actual_smooth_rod_diameter/2+1, center=true);

	for(i=[-1, 1])
	{
		translate(y_pillow_block_bolt_mount_center+[i*mounting_screw_spacing/2, 0, 0])
		cylinder(h=y_pillow_block_bolt_mount_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);

		translate([y_pillow_block_bolt_mount_center[x]+i*mounting_screw_spacing/2, y_pillow_block_bolt_mount_center[y], y_pillow_block_bolt_mount_min[z]-5])
		cylinder(h=10, r=m3_washer_diameter/2, $fn=12, center=true);
	}

	lb_h = linear_roller_bearing[bearing_length];
	lb_r = linear_roller_bearing[bearing_body_diameter]/2;

	lb_x1 = -20;
	lb_x2 = lb_h/2+1;
  
	for(i=[-1, 1])
		translate([0, 0, i*(actual_smooth_rod_diameter/2+lb_r)])
		{
			difference()
			{
				translate([(lb_x1+lb_x2)/2, 0, 0])
				rotate([0, 90, 0])
				cylinder(h=lb_x2-lb_x1, r=lb_r+.5, $fn=24, center=true);

				translate([lb_x2-.5+.05, 0, 0])
				rotate([0, 90, 0])
				cylinder(h=1+.1, r1=2.5, r2=3.5, $fn=24, center=true);
			}

			translate([y_roller_bearing_block_body_size[x]/4, 0, 0])
			rotate([0, 90, 0])
			octylinder(h=y_roller_bearing_block_body_size[x]/2+.1, r=m3_diameter/2, $fn=12, center=true);

			translate([lb_x2+4, 0, 0])
			rotate([0, 90, 0])
			cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);
		}
}
