include <dimensions.scad>
include <functions.scad>
use <motor.scad>

frame_horizontal_upper_rod_separation = 100;

frame_triangle_edge_length = j1 + vertex_depth + frame_triangle_rod_offset*2;

//top_vertex_offset = vertex_width/2+motor_clearance+motor_offset;
top_vertex_offset = motor_offset+z_linear_to_screw_separation;

front_left = [(j2+vertex_width)/2, frame_triangle_edge_length/2, 0];

_h1 = frame_triangle_edge_length;
_b1 = (frame_triangle_edge_length-(frame_horizontal_upper_rod_separation-frame_horizontal_lower_rod_separation))/2;
frame_triangle_height = sqrt(_h1*_h1-_b1*_b1);

frame_height = sqrt((frame_triangle_height*frame_triangle_height)-(top_vertex_offset*top_vertex_offset));

frame_triangle_angle = [asin(_b1/frame_triangle_edge_length), asin(top_vertex_offset/frame_triangle_height)+3.25, 0];

frame_horizontal_lower_rod_offset = [0, -frame_triangle_rod_offset, tan(30)*frame_triangle_rod_offset-(frame_horizontal_lower_rod_separation/2)/sin(60)];

//frame_horizontal_upper_rod_offset = [0, -frame_triangle_rod_offset, tan(30)*frame_triangle_rod_offset-(frame_horizontal_upper_rod_separation/2)/sin(60)];

frame_horizontal_upper_rod_offset = [0, frame_horizontal_upper_rod_separation/2, -32];

top_left = [front_left[x]+top_vertex_offset, (frame_horizontal_upper_rod_separation-frame_horizontal_lower_rod_separation)/2, frame_height];

lower_vertex_p1 = front_left+[frame_triangle_angle_offset, 0, 0]+vector_rotate([0, 0, frame_triangle_rod_offset], -frame_triangle_angle);
upper_vertex_p1 = front_left+[frame_triangle_angle_offset, 0, 0]+vector_rotate([0, 0, frame_triangle_rod_offset+j1+vertex_depth], -frame_triangle_angle);

upper_vertex_p2 = [top_left[x], 0, top_left[z]]+frame_horizontal_upper_rod_offset;

z_motor_center = [(j2+motor_clearance)/2+motor_offset, 0, upper_vertex_p2[z]];

z_linear_rod_center = [z_motor_center[x]+z_linear_to_screw_separation, 0, upper_vertex_p1[z]/2];

z_horizontal_rod_center = [0, clamp_rod_separation, -clamp_rod_separation];

*frame_annotations();
*vertex_annotations();

module frame_annotations()
{
	for(i=[-1, 1]) scale([i, 1, 1])
	{
		translate([front_left[x], 0, front_left[z]])
		rotate([90, 0, 0])
		cylinder(h=triangle_rod_length, r=4, center=true);

		for(j=[-1, 1]) scale([1, j, 1])
		{
			translate(average(lower_vertex_p1, upper_vertex_p1))
			rotate(frame_triangle_angle)
			cylinder(h=triangle_rod_length, r=4, center=true);
		}

		translate(z_linear_rod_center)
		cylinder(h=z_axis_linear_rod_length, r=4, center=true);

		translate(z_motor_center)
		rotate([180, 0, 0])
		motor();
	}

	for (i=[-1, 1]) scale([1, i, 1])
	{
		translate([0, front_left[y], front_left[z]])
		{
			translate(frame_horizontal_lower_rod_offset)
			rotate([0, 90, 0])
			cylinder(h=frame_bottom_rod_length, r=4, center=true);

			rotate([-60, 0, 0])
			translate([frame_horizontal_lower_rod_offset[x], frame_horizontal_lower_rod_offset[y], -frame_horizontal_lower_rod_offset[z]])
			rotate([0, 90, 0])
			cylinder(h=frame_bottom_rod_length, r=4, center=true);
		}

		translate([0, 0, top_left[z]])
		translate(frame_horizontal_upper_rod_offset)
		rotate([0, 90, 0])
		cylinder(h=frame_top_rod_length, r=4, center=true);
	}

	translate(z_horizontal_rod_center)
	rotate([0, 90, 0])
	cylinder(h=frame_top_rod_length, r=4, center=true);
}

module vertex_annotations()
{
	translate(lower_vertex_p1)
	sphere(6);

	translate(upper_vertex_p1)
	sphere(6);

	translate(upper_vertex_p2)
	sphere(6);

	translate(front_left)
	{
		translate([frame_triangle_angle_offset, 0, 0])
		rotate(frame_triangle_angle)
		{
			translate([0, 0, frame_triangle_rod_offset])
			sphere(6);

			translate([0, 0, frame_triangle_rod_offset+j1+vertex_depth])
			sphere(6);
		}
	}

	translate([(j2+vertex_width)/2, front_left[y], front_left[z]])
	{
		translate(frame_horizontal_lower_rod_offset)
		sphere(6);

		rotate([-60, 0, 0])
		translate([frame_horizontal_lower_rod_offset[x], frame_horizontal_lower_rod_offset[y], -frame_horizontal_lower_rod_offset[z]])
		sphere(6);
	}
}
