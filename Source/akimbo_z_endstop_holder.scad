include <more_configuration.scad>

use <teardrops.scad>
use <functions.scad>
use <optical_endstop.scad>

$fa=1;
$fs=1;

print_orientation = true;

// Tweakable parameters.

smooth_rod_clamp_radius = 4;				// Even though you'll end up with some shrinkage on the hole, you want it tight.

smooth_rod_glide_radius = 3.85;			// The geometry of the smooth rod glide hole generally makes
											// a larger hole than you coded for.  I aimed for a hole
											// that would require some reaming and polishing to glide
											// smoothly, so that the glide would still be tight.

smooth_rod_glide_point_radius = 3.35;	// needs to be smaller than smooth_rod_glide_radius.

adjustment_bolt_offset = 14;

endstop_offset = 22;
endstop_button_height = 1.5;

endstop_bolt_spacing = 19;

glide_body_radius = endstop_offset-endstop_button_height-adjustment_bolt_offset;
glide_body_max = [(endstop_bolt_spacing/2+glide_body_radius), endstop_offset-endstop_button_height, 12];
glide_body_min = [-(endstop_bolt_spacing/2+glide_body_radius), glide_body_max[y]-glide_body_radius*2, 0];

echo(glide_body_max);

glide_body_size = sizeof(glide_body_min, glide_body_max);
glide_body_center = centerof(glide_body_min, glide_body_max);

glide_riser_radius = 8;
glide_riser_size = [16, 16, glide_body_size[z]+10];
glide_riser_center = [0, 0, glide_riser_size[z]/2];

glide_filler_min = [-glide_riser_size[x]/2, glide_riser_center[y], 0];
glide_filler_max = [glide_riser_size[x]/2, adjustment_bolt_offset, glide_body_size[z]];
glide_filler_size = sizeof(glide_filler_min, glide_filler_max);
glide_filler_center = centerof(glide_filler_min, glide_filler_max);

akimbo_z_endstop_glide(print_orientation = print_orientation);
*%akimbo_z_endstop_glide_annotations(print_orientation = print_orientation);

akimbo_z_endstop_clamp(print_orientation = print_orientation);

module akimbo_z_endstop_glide(print_orientation)
{
	p1 = (print_orientation == true) ? 1 : 0;
	p2 = (print_orientation == false) ? 1 : 0;

	translate(p1*[-18, 18, 0])
	translate(p2*[0, 0, 20])

	difference()
	{
		z_endstop_glide_solid();
		z_endstop_glide_void();
	}
}

module akimbo_z_endstop_glide_annotations(print_orientation)
{
	if (print_orientation == false)
	{
		translate([0, 0, 20])
		translate([0, glide_body_max[y]+endstop_button_height, glide_body_center[z]])
		rotate([90, 0, 0])
		rotate([0, 0, 90])
		rotate([0, 180, 0])
		optical_endstop();
	}
}

module z_endstop_glide_solid()
{
	button_radius = m3_diameter/2+2;

	hull()
	{
		translate(glide_body_center)
		for(i=[-1, 1])
			translate([i*(endstop_bolt_spacing/2), 0, 0])
			cylinder(h=glide_body_size[z], r=glide_body_radius, center=true);
	}

	translate([glide_riser_center[x], glide_riser_center[y], glide_body_center[z]])
	cylinder(h=glide_body_size[z], r=glide_riser_size[y]/2, center=true);

	for(i=[-1, 1])
	{
		translate(glide_body_center+[i*endstop_bolt_spacing/2, glide_body_size[y]/2, 0])
		rotate([90, 0, 0])
		rotate([0, 0, 180])
		cylinder(h=endstop_button_height*2, r=button_radius, $fn=12, center=true);

		intersection()
		{
			translate(glide_body_center+[i*endstop_bolt_spacing/2, glide_body_size[y]/2, 0])
			rotate([0, 30, 0])
			translate([0, 0, -5])
			cube([button_radius*2, endstop_button_height*2, 10], center=true);

			translate(glide_body_center+[i*endstop_bolt_spacing/2, glide_body_size[y]/2, 0])
			rotate([0, -30, 0])
			translate([0, 0, -5])
			cube([button_radius*2, endstop_button_height*2, 10], center=true);

			translate(glide_body_center+[i*endstop_bolt_spacing/2, glide_body_size[y]/2, 0])
			cube([button_radius*2, endstop_button_height*2, glide_body_size[z]], center=true);

			translate(glide_body_center+[i*endstop_bolt_spacing/2, glide_body_size[y]/2+endstop_button_height/2, 0])
			rotate([-45, 0, 0])
			cube([button_radius*2, button_radius*1.675, glide_body_size[z]], center=true);
		}
	}

	translate(glide_riser_center)
	cylinder(h=glide_riser_size[z], r=glide_riser_size[y]/2, center=true);

	translate(glide_filler_center)
	cube(glide_filler_size, center=true);
}

module z_endstop_glide_void()
{
	n=6;

	for(i=[-1, 1]) translate(glide_body_center+[i*endstop_bolt_spacing/2, 0, 0])
		rotate([90, 0, 0])
		{
			octylinder(h=glide_body_size[y]+endstop_button_height*2+.1, r=m3_diameter/2, $fn=12, center=true);
			translate([0, 0, glide_body_size[y]/2+10])
			cylinder(h=m3_nut_thickness*2+20, r=m3_nut_diameter/2, $fn=6, center=true);
		}

	translate(glide_riser_center)
	render(convexity=8)
	linear_extrude(height=glide_riser_size[z]+.1, twist=360*1.5/n, slices=glide_riser_size[z], center=true )
	union()
	{
	difference()
	{
		circle(r=smooth_rod_glide_radius+1.6, $fn=20);

		for (i=[0:360/n])
		{
			rotate(360 / n * i)
			translate([smooth_rod_glide_point_radius / sqrt(2), smooth_rod_glide_point_radius / sqrt(2)])
			square([smooth_rod_glide_point_radius*2, smooth_rod_glide_point_radius*2]);
		}
	}
	circle(r=smooth_rod_glide_radius, $fn=20);
	}

	translate([0, adjustment_bolt_offset, glide_body_center[z]])
	cylinder(h=glide_body_size[z]+.1, r=m4_diameter/2, $fn=12, center=true);

	translate([0, adjustment_bolt_offset, glide_body_max[z]-m4_nut_thickness/2+.05])
	cylinder(h=m4_nut_thickness+.1, r=m4_nut_diameter/2, $fn=6, center=true);
}


module akimbo_z_endstop_clamp(print_orientation)
{
	p1 = (print_orientation == true) ? 1 : 0;
	p2 = (print_orientation == false) ? 1 : 0;

	difference()
	{
		z_endstop_clamp_solid();
		z_endstop_clamp_void();
	}
}

module z_endstop_clamp_solid()
{
	translate([0, 0, glide_body_center[z]])
	{
		hull()
		{
			for(i=[-1, 1])
				translate([i*endstop_bolt_spacing/2, 0, 0])
				cylinder(h=glide_body_size[z], r=glide_riser_radius, center=true);
		}
		
		translate([0, adjustment_bolt_offset, 0])
		cylinder(h=glide_body_size[z], r=glide_body_radius, center=true);

		translate([0, adjustment_bolt_offset/2, 0])
		cube([glide_body_radius*2, adjustment_bolt_offset, glide_body_size[z]], center=true);
	}
}

module z_endstop_clamp_void()
{
	translate([0, 0, glide_body_center[z]])
	{
		cylinder(h=glide_body_size[z]+.1, r=smooth_rod_clamp_radius, center=true);

		translate([0, adjustment_bolt_offset, 0])
		cylinder(h=glide_body_size[z]+.1, r=m4_diameter/2, $fn=12, center=true);

		for(i=[-1, 1])
			translate([i*endstop_bolt_spacing/2, 0, 0])
			rotate([90, 0, 0])
			{
				octylinder(h=glide_riser_radius*2+.1, r=m3_diameter/2, $fn=12, center=true);

				translate([0, 0, glide_riser_radius-3])
				octylinder(h=3.1, r=m3_bolt_head_diameter/2, center=false);

				rotate([180, 0, 0])
				translate([0, 0, glide_riser_radius-3])
				cylinder(h=15, r=m3_nut_diameter/2, $fn=6, center=false);

			}

		cube([endstop_bolt_spacing+glide_riser_radius, 1.5, glide_body_size[z]+.1], center=true);
	}
}

smoothing_radius = 3;

module smooth_cube(size, radius=smoothing_radius, smooth_axis=z)
{
	hull()
	for(i=[-1, 1]) for (j=[-1, 1])
		translate([i*(size[x]-radius*2)/2, j*(size[y]-radius*2)/2, 0])
		cylinder(h=size[z], r=radius, $fn=32, center=true);
}
