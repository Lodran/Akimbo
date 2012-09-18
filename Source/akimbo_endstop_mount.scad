include <more_configuration.scad>

use <teardrops.scad>
use <functions.scad>
use <optical_endstop.scad>

print_orientation = false;

smooth_rod_clamp_radius = 4;

endstop_bolt_spacing = 19;
endstop_button_height = 2;
endstop_button_radius = m3_diameter/2+2;

clamp_body_radius = 8;
clamp_body_size = [endstop_bolt_spacing, clamp_body_radius*2, 12];
clamp_body_center = [0, 0, clamp_body_size[z]/2];

akimbo_endstop_mount(print_orientation = print_orientation);

%akimbo_endstop_annotations(print_orientation = print_orientation);

module akimbo_endstop_mount(print_orientation)
{
	p1 = (print_orientation == true) ? 1 : 0;
	p2 = (print_orientation == false) ? 1 : 0;

	difference()
	{
		akimbo_endstop_mount_solid();
		akimbo_endstop_mount_void();
	}
}

module akimbo_endstop_mount_solid()
{
	translate(clamp_body_center)
	cube(clamp_body_size, center=true);

	for(i=[-1, 1])
		translate(clamp_body_center+[i*endstop_bolt_spacing/2, 0, 0])
		{
			cylinder(h=clamp_body_size[z], r=clamp_body_radius, center=true);

			translate([0, -(clamp_body_size[y]/2-2), 0])
			rotate([90, 0, 0])
			rotate([0, 0, 180])
			octylinder(h=4, r=clamp_body_size[z]/2, center=true);

			intersection()
			{
				hull()
				{
					translate([0, (clamp_body_size[y])/2, 0])
					rotate([90, 0, 0])
					cylinder(h=endstop_button_height*2, r=endstop_button_radius, center=true);

					rotate([-90, 0, 0])
					translate([0, (clamp_body_size[y])/2, 0])
					rotate([90, 0, 0])
					cylinder(h=endstop_button_height*2, r=endstop_button_radius, center=true);
				}

				cube([endstop_button_radius*2+.1, clamp_body_size[y]+endstop_button_height*2+.1, clamp_body_size[z]], center=true);
			}
		}
}

module akimbo_endstop_mount_void()
{
	translate(clamp_body_center)
	{
		cylinder(h=clamp_body_size[z]+.1, r=smooth_rod_clamp_radius, center=true);

		cube([clamp_body_size[x]+clamp_body_radius, 1.5, clamp_body_size[z]+.1], center=true);

		for(i=[-1, 1])
			translate([i*endstop_bolt_spacing/2, 0, 0])
			rotate([90, 0, 0])
			{
				octylinder(h=clamp_body_size[y]+endstop_button_height*2+.1, r=m3_diameter/2, $fn=12, center=true);
				translate([0, 0, 4])
				cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);
			}
	}
}

module akimbo_endstop_annotations(print_orientation)
{
	if (print_orientation == false)
	{
		translate([0, clamp_body_center[y]+clamp_body_size[y]/2+endstop_button_height+.05, clamp_body_center[z]])
		rotate([90, 0, 0])
		rotate([0, 0, 90])
		rotate([0, 180, 0])
		optical_endstop();
	}
}
