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
// bottom_vertex.scad
//
// Bottom frame vertices, with feet and bumper mounts.
//
//  Print two with normal orientation, and two with mirrored orientation.
//
//  Bumper mounts are intended to fit SAE (#8-32) Sorbothane bumpers.
//  http://www.isolateit.com/mounts-vibration-isolators/vibration-isolating-stud-mounts-and-bumpers/sorbothane-vibration-isolating-stud-bumpers.html
//
//  Note: I chose the SAE bumpers over the metric ones, because of both size and cost.
//

include <more_configuration.scad>
include <frame_computations.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>

include <vitamin.scad>

part_name = "bottom_vertex";
part_count = 4;

print_orientation = true;
mirrored = false;

vertex_hub_radius = 18;

foot_height = 35;
foot_width = 15;

*%frame_annotations();
bottom_vertex(print_orientation=print_orientation, mirrored=mirrored);

module bottom_vertex(print_orientation=true, mirrored=false)
{
	p1=(print_orientation==true) ? 1 : 0;
	s1=(mirrored==true) ? -1 : 1;

	scale([s1, 1, 1])
	translate(p1*[0, 0, vertex_width/2])
	rotate(p1*[0, 0, -30])
	rotate(p1*[0, 90, 0])
	translate(p1*-front_left)
	difference()
	{
		bottom_vertex_solid();
		bottom_vertex_void();
	}
}

module bottom_vertex_solid()
{
	p1=[0, -frame_triangle_rod_offset];
	p2=rotate_vec(p1, -60);

	fp1=[10, -frame_triangle_rod_offset];

	fp2=fp1+[foot_height-12, -(foot_width/2-2)];
	fp3=fp1+[foot_height-12, (foot_width/2-2)];

	translate(front_left)
	{
		intersection()
		{
			union()
			{
				intersection()
				{
					union()
					{
						// Lower hub with foot.

						rotate([0, 90, 0])
						linear_extrude(height=vertex_width+1, center=true, convexity=4)
						{
							barbell(p1, fp2, vertex_hub_radius, 2, 100, 14);

							barbell(p1, fp3, vertex_hub_radius, 2, 14, 100);
	
							translate(fp1+[foot_height/2-10, 0])
							square([foot_height, foot_width-4], center=true);
						}

						// Lower to upper hub connector

						rotate([0, 90, 0])
						linear_extrude(height=vertex_width+1, center=true)
						{
							barbell(p1, p2, vertex_hub_radius, vertex_hub_radius-2.6, 25, 25);
						}
					}

					// Lower triangle washer flats.

					rotate([90, 0, 0])
					{
						translate([0, 0, frame_triangle_rod_offset])
						cube([vertex_hub_radius*2, 80, vertex_depth], center=true);
					}
				}

				translate([frame_triangle_angle_offset, 0, 0])
				rotate(frame_triangle_angle)
				{
					translate([0, 0, frame_triangle_rod_offset])
					intersection()
					{
						union()
						{
							// Upper hub.

							rotate([0, 90, 0])
							cylinder(h=vertex_hub_radius*2, r=vertex_hub_radius, center=true);

							*sphere(vertex_hub_radius);

							translate([0, -vertex_hub_radius/2, -vertex_hub_radius/2])
							cube([vertex_hub_radius*2, vertex_hub_radius, vertex_hub_radius], center=true);
						}

						// Upper triangle washer flats.

						cube([vertex_hub_radius*2+.1, vertex_hub_radius*2+.1, vertex_depth], center=true);
					}
				}

				*rotate([-60, 0, 0])
				translate([frame_horizontal_lower_rod_offset[x], frame_horizontal_lower_rod_offset[y], -frame_horizontal_lower_rod_offset[z]])
				rotate([0, 90, 0])
				cylinder(h=vertex_width+1, r=9, center=true);
			}

			// Trim the entire piece down to 18mm in width.

			translate([0, -20, 10])
			cube([vertex_width, 80, 110], center=true);
		}
	}
}

foot_nut_diameter = (11/32)*25.4/cos(30);
foot_nut_thickness = (1/8)*25.4;
foot_bolt_diameter = (11/64)*25.4;
foot_bolt_length = 15;

module bottom_vertex_void()
{
	frame_void();

	// Foot

	translate(front_left)
	{
		translate([0, -frame_triangle_rod_offset, -(foot_height-foot_bolt_length/2)-.05])
		rotate([0, 0, 90])
		octylinder(h=foot_bolt_length+.1, r=foot_bolt_diameter/2, $fn=12, center=true);

		translate([0, -frame_triangle_rod_offset, -(foot_height-3-foot_nut_thickness/2)])
		{
			cylinder(h=foot_nut_thickness, r=foot_nut_diameter/2, $fn=6, center=true);
			translate([-5, 0, 0])
			cube([10, foot_nut_diameter*cos(30), foot_nut_thickness], center=true);
		}
	}
  
  vitamin(part_name, part_count, 4, M8_nut);
  vitamin(part_name, part_count, 4, M8_washer);
  vitamin(part_name, part_count, 1, optional, "Rubber Foot", comment="Sorbothane Male Bumper - #8-32");
  vitamin(part_name, part_count, 1, optional, "#8-32 Nut", comment="For mounting Sorbothane Bumper");
}

module frame_void()
{
	translate(front_left)
	rotate([90, 0, 0])
	rotate([0, 0, 90])
	octylinder(h=frame_triangle_edge_length, r=threaded_rod_diameter/2);

	translate(front_left+[frame_triangle_angle_offset, 0, 0])
	rotate(frame_triangle_angle)
	rotate([0, 0, 90+frame_triangle_angle[y]/2-.6])	// hand tweaked - revisit if frame angles change.
	octylinder(h=frame_triangle_edge_length, r=threaded_rod_diameter/2);

	translate([0, front_left[y], front_left[z]])
	{
		translate(frame_horizontal_lower_rod_offset)
		rotate([0, 90, 0])
		cylinder(h=frame_bottom_rod_length, r=threaded_rod_diameter/2, center=true);

		rotate([-60, 0, 0])
		translate([frame_horizontal_lower_rod_offset[x], frame_horizontal_lower_rod_offset[y], -frame_horizontal_lower_rod_offset[z]])
		rotate([0, 90, 0])
		cylinder(h=frame_bottom_rod_length, r=threaded_rod_diameter/2, center=true);
	}
}
