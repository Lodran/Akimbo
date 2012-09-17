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
// top_vertex.scad
//
// The Akimbo top vertex, and motor mount.
//
// Print two.
//

include <more_configuration.scad>
include <frame_computations.scad>

m8_washer_diameter = 20;

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>

short_bracket = true;

print_orientation = false;

*frame_annotations();

*translate(z_motor_center)
rotate([180, 0, 0])
motor();

top_vertex();

vertex_hub_radius = 18;

top_vertex_min = [z_linear_rod_center[x]-vertex_width, -upper_vertex_p1[y]-30, upper_vertex_p1[z]-25];
top_vertex_max = [z_linear_rod_center[x], upper_vertex_p1[y]+30, upper_vertex_p1[z]+25];
top_vertex_center = centerof(top_vertex_min, top_vertex_max);
top_vertex_size = sizeof(top_vertex_min, top_vertex_max);

motor_bracket_end_radius = m8_washer_diameter/2;
motor_bracket_center_radius = 6;

motor_bolt_hole_spacing = 1.2*25.4;

j2b = (short_bracket) ? z_motor_center[x]*2-motor_clearance : j2;

echo(str("j2b = ", j2b));

motor_bracket_min = [j2b/2, -upper_vertex_p2[y], upper_vertex_p2[z]-motor_bracket_end_radius];
motor_bracket_max = [top_vertex_max[x], upper_vertex_p2[y], upper_vertex_p2[z]+motor_bracket_end_radius];
motor_bracket_center = centerof(motor_bracket_min, motor_bracket_max);
motor_bracket_size = sizeof(motor_bracket_min, motor_bracket_max);

motor_floor_thickness = 4;
motor_web_thickness = 1.5;

motor_bolt_hole_spacing = 1.2*25.4;
motor_frame_width = 45-motor_bolt_hole_spacing;
motor_hole_radius = sqrt((motor_bolt_hole_spacing/2*motor_bolt_hole_spacing/2)+(motor_bolt_hole_spacing/2*motor_bolt_hole_spacing/2)) - motor_frame_width/2;

module top_vertex(print_orientation=print_orientation)
{
	p1=(print_orientation==true) ? 1 : 0;
	rotate(p1*[0, 90, 0])
	translate(p1*[-top_vertex_max[x], -top_vertex_center[y], -top_vertex_center[z]])
	difference()
	{
		top_vertex_solid();
		top_vertex_void();
	}
}

module top_vertex_solid()
{
	p1=[upper_vertex_p1[y], upper_vertex_p1[z]-2];
	p2=[-p1[x], p1[y]];

	r1=vertex_hub_radius-4;
	r2=150;

	mp1=[z_motor_center[x]+motor_bolt_hole_spacing/2, z_motor_center[y]+motor_bolt_hole_spacing/2];
	mp2=[z_motor_center[x]-motor_bolt_hole_spacing/2, z_motor_center[y]+motor_bolt_hole_spacing/2];
	mp3=[motor_bracket_min[x]+motor_bracket_end_radius/2, motor_bracket_max[y]-motor_bracket_end_radius/2];
	mp4=[mp3[x], motor_bracket_max[y]];
	mp5=[mp1[x], mp4[y]];

	intersection()
	{
		union()
		{
			for(i=[-1, 1]) scale([1, i, 1])
			{
				intersection()
				{
					union()
					{
						translate(upper_vertex_p1)
						rotate(frame_triangle_angle)
						rotate([0, 90, 0])
						cylinder(h=vertex_hub_radius*2, r=vertex_hub_radius, center=true);

						*translate([top_vertex_center[x], 0, 0])
						rotate([0, 0, 90])
						rotate([90, 0, 0])
						linear_extrude(height=vertex_depth+1, center=true, convexity=4)
						barbell(p1, p2, r1, r1, r2, r2);
					}

					union()
					{
						translate(upper_vertex_p1)
						rotate(frame_triangle_angle)
						translate([0, -10, 0])
						cube([vertex_hub_radius*2, vertex_hub_radius*4, vertex_depth], center=true);
						
						*translate(top_vertex_center)
						cube([vertex_hub_radius*2, 60, 16], center=true);
					}
				}
			}

		}

		translate(top_vertex_center)
		cube(top_vertex_size, center=true);
	}

	translate(top_vertex_center+[4.75, 0, -4])
	cube([8.5, 60, 20], center=true);


	for(i=[-1, 1]) scale([1, i, 1])
	{
		translate([motor_bracket_center[x], motor_bracket_max[y], motor_bracket_center[z]])
		rotate([0, 90, 0])
		bone(h=motor_bracket_size[x], r1=motor_bracket_end_radius, r2=motor_bracket_center_radius, center=true);
	}

	translate([0, 0, z_motor_center[z]-motor_floor_thickness/2])
	linear_extrude(height=motor_floor_thickness, center=true, convexity=4)
	{
		for(i=[-1, 1]) scale([1, i])
		{
			barbell(mp1, mp2, motor_frame_width/2, motor_frame_width/2, motor_hole_radius, 40);

			barbell(mp2, mp3, motor_frame_width/2, motor_bracket_end_radius/2, 50, 200);

			barbell(mp1, mp3, motor_frame_width/2, motor_bracket_end_radius/2, 200, 100);

			polygon([mp1, mp2, mp3]);
		}
		translate([z_motor_center[x]+7, z_motor_center[y]])
		square([motor_bolt_hole_spacing+4, motor_bolt_hole_spacing+15], center=true);
	}

	translate([0, 0, z_motor_center[z]-motor_floor_thickness/2])
	linear_extrude(height=motor_web_thickness, center=true, convexity=4)
	{
		for(i=[-1, 1]) scale([1, i])
			polygon([mp1, mp2, mp4, mp5]);
	}

}

module top_vertex_void()
{
	translate(z_motor_center+[5, 0, 10])
	cube([motor_clearance+10, motor_clearance, 20], center=true);

	translate(z_motor_center-[0, 0, motor_floor_thickness/2])
	cylinder(h=motor_floor_thickness+.1, r=motor_hole_radius, center=true);

	translate(z_motor_center-[0, 0, motor_floor_thickness+(30/2)])
	cube([motor_clearance, motor_clearance, 30], center=true);

	for(i=[-1, 1]) for(j=[-1, 1])
	{
		translate(z_motor_center+[i*motor_bolt_hole_spacing/2, j*motor_bolt_hole_spacing/2, 0])
		{
			translate([0, 0, -motor_bracket_end_radius/2])
			cylinder(h=motor_bracket_end_radius+.1, r=m3_diameter/2, $fn=12, center=true);
		}
	}

	for(i=[-1, 1])
		translate(top_vertex_center+[0, i*z_rod_clamp_bolt_separation/2, -4])
		rotate([0, 90, 0])
		{
			cylinder(h=vertex_width+.1, r=m3_diameter/2, $fn=12, center=true);

			cylinder(h=vertex_width-10, r=m3_nut_diameter/2, $fn=6, center=true);
		}


	frame_void();
}

module frame_void()
{
	for(i=[-1, 1]) scale([i, 1, 1])
	{
		for(j=[-1, 1]) scale([1, j, 1])
		{
			translate(average(lower_vertex_p1, upper_vertex_p1))
			rotate(frame_triangle_angle)
			rotate([0, 0, 96.25])	// hand tweaked.
			octylinder(h=triangle_rod_length, r=threaded_rod_diameter/2, center=true);
		}
	}

	for (i=[-1, 1]) scale([1, i, 1])
	{
		translate([0, 0, top_left[z]])
		translate(frame_horizontal_upper_rod_offset)
		rotate([0, 90, 0])
		cylinder(h=frame_top_rod_length, r=threaded_rod_diameter/2, center=true);
	}

	translate(z_linear_rod_center)
	rotate([0, 0, 90])
	octylinder(h=z_axis_linear_rod_length, r=smooth_rod_diameter/2, center=true);
}

module bone(h, r1, r2)
{
	rotate_extrude(convexity=16)
	{
		intersection()
		{
			union()
			{
				barbell([0, -(h/2-4)], [0, (h/2-4)], r1, r1, 50, 50);
				for(i=[-1, 1])
					translate([0, i*(h/2-2)])
					square([r1*2, 4], center=true);
			}

			translate([r1/2, 0])
			square([r1, h], center=true);
		}
	}
}

/*
module bone(h, r1, r2)
{
	cylinder(h=h-.1, r=r2, center=true, $fn=32);

	for(i=[-1, 1]) scale([1, 1, i])
	{
		hull()
		{
			translate([0, 0, h/2-4])
			cylinder(h=8, r=r1, center=true, $fn=32);

			translate([0, 0, h/8])
			cylinder(h=1, r=r2, center=true, $fn=32);
		}
	}
}
*/
