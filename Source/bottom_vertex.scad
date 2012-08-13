include <more_configuration.scad>
include <frame_computations.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>

$fa=1;
$fs=2;

vertex_hub_radius = 22;

foot_height = 35;
foot_width = vertex_width;

%frame_annotations();
bottom_vertex(print_orientation=false);

module bottom_vertex(print_orientation=true)
{
	p1=(print_orientation==true) ? 1 : 0;

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
						// Lower hub.

						rotate([90, 0, 0])
						translate([0, 0, frame_triangle_rod_offset])
						sphere(vertex_hub_radius);

						// Lower to upper hub connector

						rotate([0, 90, 0])
						linear_extrude(height=vertex_width+1, center=true)
						{
							barbell(p1, p2, vertex_hub_radius-4, vertex_hub_radius-4, 30, 30);
						}
					}

					// Lower triangle washer flats.

					rotate([90, 0, 0])
					{
						translate([0, 0, frame_triangle_rod_offset])
						cube([vertex_hub_radius*2, vertex_hub_radius*3+5, vertex_depth], center=true);
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

							sphere(vertex_hub_radius);
							translate([0, -vertex_hub_radius/2, -vertex_hub_radius/2])
							cube([vertex_hub_radius*2, vertex_hub_radius/2, vertex_hub_radius/2], center=true);
						}

						// Upper triangle washer flats.

						cube([vertex_hub_radius*2+.1, vertex_hub_radius*2+.1, vertex_depth], center=true);
					}
				}

				// Foot

				rotate([0, 90, 0])
				linear_extrude(height=vertex_width+1, center=true, convexity=4)
				{
					barbell(fp1, fp2, vertex_depth/2-2, 2, 20, 20);

					barbell(fp1, fp3, vertex_depth/2-2, 2, 20, 20);
					translate(fp3)
					circle(2);

					translate(fp1+[foot_height/2-10, 0])
					square([foot_height, foot_width-4], center=true);
				}
					

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
