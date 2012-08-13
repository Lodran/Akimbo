include <more_configuration.scad>
include <frame_computations.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>

$fa=1;
$fs=2;

z_clamp_min = [j2/2, -16, -12-clamp_rod_separation/2];
z_clamp_max = [z_linear_rod_center[x], 16, z_clamp_min[z]+24];

z_clamp_center = centerof(z_clamp_min, z_clamp_max);
z_clamp_size = sizeof(z_clamp_min, z_clamp_max);

*%frame_annotations();

z_clamp();

module z_clamp(print_orientation=true)
{
	p1=(print_orientation==true) ? 1 : 0;
	rotate(p1*[0, 90, 0])
	translate(p1*[-z_clamp_max[x], -z_clamp_center[y], -z_clamp_center[z]])

	difference()
	{
		z_clamp_solid();
		z_clamp_void();
	}
}

module z_clamp_solid()
{
	translate(z_clamp_center)
	cube(z_clamp_size, center=true);
}

module z_clamp_void()
{
	frame_void();

	// Linear rod clamp

	for(i=[-1, 1])
		translate([z_clamp_max[x]-vertex_width/2, i*z_rod_clamp_bolt_separation/2, 1])
		rotate([0, 90, 0])
		{
			cylinder(h=vertex_width+.1, r=m3_diameter/2, $fn=12, center=true);
			translate([0, 0, -(vertex_width-8)/2-.05])
			cylinder(h=8+.1, r=m3_nut_diameter/2, $fn=6, center=true);
		}

	// Save some plastic.

	v1_min = [z_clamp_min[x]+vertex_width, z_clamp_min[y], z_clamp_min[z]+6];
	v1_max = [z_clamp_max[x]-vertex_width, z_clamp_max[y], z_clamp_max[z]];
	v1_center = centerof(v1_min, v1_max);
	v1_size = sizeof(v1_min, v1_max);

	translate(v1_center+[0, 0, .05])
	rotate([90, 0, 0])
	linear_extrude(height=v1_size[y]+.1, center=true)
	{
		polygon([[v1_size[x]/2, v1_size[z]/2],
				 [v1_size[x]/2, -v1_size[z]/2],
				 [-v1_size[x]/2+v1_size[z], -v1_size[z]/2],
				 [-v1_size[x]/2, v1_size[z]/2]]);
	}

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
