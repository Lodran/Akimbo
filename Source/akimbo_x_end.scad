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
// akimbo_x_end.scad
//

print_orientation = true;
constrained = true;

include <more_configuration.scad>
include <frame_computations.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>
use <pill.scad>
use <akimbo_z_endstop_holder.scad>
use <optical_endstop.scad>

belt_idler_bearing = 608_bearing;

belt_idler_bearing_length = belt_idler_bearing[bearing_length];
belt_idler_bearing_radius = belt_idler_bearing[bearing_body_diameter]/2;

linear_bearing_length = lm8uu[bearing_length]+lm8uu_clearance[bearing_length];
linear_bearing_radius = (lm8uu[bearing_body_diameter]+lm8uu_clearance[bearing_body_diameter])/2;

m5_nut_thickness = 3;

z_screw_nut_thickness = m5_nut_thickness;
z_screw_nut_radius = m5_nut_diameter/2;
z_screw_radius = 5/2;

/*
z_screw_nut_thickness = m8_nut_thickness;
z_screw_nut_radius = m8_nut_diameter/2;
z_screw_radius = m8_diameter/2;
*/

z_bearing_clamp_radius = bearing_clamp_radius;
z_screw_clamp_radius = z_screw_nut_radius+2;


x_end_min = [-(z_linear_to_screw_separation/2+z_screw_clamp_radius), -(x_linear_rod_offset+linear_clamp_radius), -(z_bearing_clamp_length-linear_clamp_radius)];
x_end_max = [z_linear_to_screw_separation/2+z_bearing_clamp_radius, x_linear_rod_offset+linear_clamp_radius, linear_clamp_radius];
x_end_center = centerof(x_end_min, x_end_max);
x_end_size = sizeof(x_end_min, x_end_max);

z_bearing_clamp_center = [z_linear_to_screw_separation/2, 0, x_end_center[z]];
z_screw_clamp_center = [-z_linear_to_screw_separation/2, 0, x_end_max[z]-z_screw_clamp_length/2];



belt_idler_center = [0, x_linear_rod_offset+belt_idler_bearing_radius+3, belt_offset_z];
motor_center = [0, -(x_linear_rod_offset+belt_idler_bearing_radius+3), belt_offset_z-18];

motor_brace_thickness = 6;

motor_bolt_hole_spacing = motor_bolt_hole_spacing();

motor_bracket_p1 = [motor_center[x]-motor_bolt_hole_spacing/2, motor_center[y]+motor_bolt_hole_spacing/2];
motor_bracket_p2 = [motor_center[x]+motor_bolt_hole_spacing/2, motor_center[y]+motor_bolt_hole_spacing/2];
motor_bracket_p3 = [motor_center[x]+motor_bolt_hole_spacing/2, motor_center[y]-motor_bolt_hole_spacing/2];
motor_bracket_p4 = [-z_linear_to_screw_separation/2, 0];

motor_bracket_r1 = 8;
motor_bracket_r2 = motor_bolt_hole_spacing*sqrt(2)/2-motor_bracket_r1;

motor_bracket_fill_1_min = [motor_bracket_p3[x], motor_bracket_p3[y]-motor_bracket_r1, motor_center[z]];
motor_bracket_fill_1_max = [x_end_max[x], 0, motor_bracket_fill_1_min[z]+motor_brace_thickness];
motor_bracket_fill_1_center = centerof(motor_bracket_fill_1_min, motor_bracket_fill_1_max);
motor_bracket_fill_1_size = sizeof(motor_bracket_fill_1_min, motor_bracket_fill_1_max);

motor_bracket_fill_2_min = [motor_bracket_p1[x], motor_bracket_p1[y], motor_bracket_fill_1_min[z]];
motor_bracket_fill_2_max = motor_bracket_fill_1_max;
motor_bracket_fill_2_center = centerof(motor_bracket_fill_2_min, motor_bracket_fill_2_max);
motor_bracket_fill_2_size = sizeof(motor_bracket_fill_2_min, motor_bracket_fill_2_max);


motor_brace_center_x = x_end_max[x]-motor_brace_thickness/2; // (x_end_size[x]-motor_brace_thickness)/2;

motor_brace_r2 = 7;

motor_brace_p0 = [0, 0];
motor_brace_p1 = [-x_linear_rod_offset, 0];
motor_brace_p2 = [motor_bracket_p3[y]-motor_bracket_r1+motor_brace_r2, motor_center[z]+motor_brace_r2];
motor_brace_p2b = motor_brace_p2+[0, -motor_brace_thickness];
motor_brace_p3 = [0, x_end_min[z]+bearing_clamp_radius];

motor_brace_poly_1 = [motor_brace_p0,
                    motor_brace_p1,
                    motor_brace_p2,
                    motor_brace_p2b,
                    motor_brace_p3];

motor_brace_poly_2 = [motor_brace_p0,
                    motor_brace_p1,
                    motor_brace_p2,
                    motor_brace_p2b,
                    motor_brace_p3+[0, 3]];

x_endstop_center = [x_end_min[x]+4, -x_linear_rod_offset, x_end_max[z]];

/*
for(i=[-1, 1])
	rotate([0, 0, i*90+90])
	translate([33, -13, 0])
	akimbo_x_end(print_orientation=true, constrained=(i==1), motor_bracket=true, idler_bracket=true);
*/

akimbo_x_end(print_orientation=print_orientation, constrained=constrained, motor_bracket=true, idler_bracket=true);
*%x_end_annotations(print_orientation=print_orientation);

module akimbo_x_end(print_orientation=true, constrained=false, motor_bracket=true, idler_bracket=true)
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;
  
	translate(p2*[z_motor_center[x]+z_linear_to_screw_separation/2, 0, x_axis_height])
	rotate(p1*[0, 90, 0])
	translate(p1*[-x_end_max[x], 0, 0])
	difference()
	{
		akimbo_x_end_solid(constrained, motor_bracket, idler_bracket);
		render(convexity=8) akimbo_x_end_void(constrained, motor_bracket, idler_bracket);
	}
}

module z_extrusion(clearance_r = 0, clearance_z = 0)
{
	translate([0, 0, z_screw_clamp_center[z]])
	linear_extrude(height=z_screw_clamp_length+clearance_z, center=true, convexity=4)
	{
		barbell([z_bearing_clamp_center[x], z_bearing_clamp_center[y]], [-z_bearing_clamp_center[x], z_bearing_clamp_center[y]], bearing_clamp_radius+clearance_r, z_screw_clamp_radius+clearance_r, 30-clearance_r, 30-clearance_r, $fn=40);
	}
}


module akimbo_x_end_solid(constrained, motor_bracket, idler_bracket)
{
	// X Linear rod clamp.

	intersection()
	{
		translate([x_end_center[x], 0, 0])
		rotate([0, 90, 0])
		linear_extrude(height=x_end_size[x], center=true, convexity=4)
		barbell([0, x_linear_rod_offset], [0, -x_linear_rod_offset], linear_clamp_radius, linear_clamp_radius, 70, 70);

		translate(x_end_center)
		cube(x_end_size, center=true);
	}

	// Z bearing clamp.

	if (constrained == true)
	{
		translate(z_bearing_clamp_center)
		rotate([0, 0, -90])
		octylinder(h=z_bearing_clamp_length, r=bearing_clamp_radius, center=true, $fn=40);

		// Z endstop flag mount.

		hull()
		{
			translate(z_bearing_clamp_center+[0, linear_bearing_radius+6/2, -(z_bearing_clamp_length/2-5)])
			rotate([90, 0, 0])
			cylinder(h=6, r=5, center=true);

			translate(z_bearing_clamp_center+[bearing_clamp_radius-1/2, 0, -(z_bearing_clamp_length/2-5)])
			rotate([0, 90, 0])
			cylinder(h=1, r=5, center=true);
		}
	}
	else
	{
		translate([z_bearing_clamp_center[x], z_bearing_clamp_center[y], z_screw_clamp_center[z]])
		rotate([0, 0, -90])
		octylinder(h=z_screw_clamp_length, r=bearing_clamp_radius, center=true, $fn=40);
	}


	// Z screw clamp.

	z_extrusion();

	if (motor_bracket == true)
		motor_bracket_solid(constrained);

	if (idler_bracket == true)
		idler_bracket_solid();

	// X endstop mount

	for(i=[-1, 1])
		hull()
		{
			translate(x_endstop_center+[0, i*endstop_bolt_spacing()/2, -linear_clamp_radius])
			cylinder(h=linear_clamp_radius*2, r=4, $fn=24, center=true);

			translate(x_endstop_center+[endstop_bolt_spacing(), 0, -linear_clamp_radius])
			cylinder(h=1, r=4, $fn=24, center=true);
		}
}

module akimbo_x_end_void(constrained, motor_bracket, idler_bracket)
{
	// X Linear rod.

	for(i=[-1, 1])
	{
		translate([x_end_center[x], i*x_linear_rod_offset, 0])
		{
			rotate([0, 90, 0])
			cylinder(h=x_end_size[x]+.1, r=smooth_rod_diameter/2, center=true);

			difference()
			{
				translate([0, -i*(smooth_rod_diameter/2+6), 0])
				cube([x_end_size[x]+.1, 20, 1.5], center=true);

				translate(-[x_end_center[x], i*x_linear_rod_offset, 0])
				z_extrusion(clearance_z=.2);
			}

			translate([0, -i*(smooth_rod_diameter/2+4), 0])
			rotate([0, 0, 90])
			octylinder(h=25, r=m3_diameter/2, $fn=12, center=true);

			translate([0, -i*(smooth_rod_diameter/2+4), -5])
			rotate([180, 0, 0])
			rotate([0, 0, 90])
			cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);

			translate([0, -i*(smooth_rod_diameter/2+4), 5])
			rotate([0, 0, 90])
			octylinder(h=10, r=m3_bolt_head_diameter/2, center=false);
		}
	}

	translate(z_bearing_clamp_center)
	{
		rotate([0, 0, 90])
		octylinder(h=z_bearing_clamp_length+.1, r=smooth_rod_diameter/2+1, center=true);
	}

	if (constrained == true)
	{
		lm8uu_void();

		translate(z_bearing_clamp_center+[0, linear_bearing_radius+7/2, -(z_bearing_clamp_length/2-5)])
		rotate([90, 0, 0])
		rotate([0, 0, 90])
		octylinder(h=7.1, r=m3_diameter/2, $fn=12, center=true);

		translate(z_bearing_clamp_center+[0, linear_bearing_radius+4/2-1, -(z_bearing_clamp_length/2-5)])
		rotate([90, 0, 0])
		cylinder(h=4+2, r=m3_nut_diameter/2, $fn=6, center=true);
	}
	else
	{
		roller_void();
	}

	// Z screw.

	z1=x_end_max[z]-z_screw_clamp_length;
	z2=z1+z_screw_nut_thickness;
	z3=z2+5;
	z4=x_end_max[z];

	translate([z_screw_clamp_center[x], z_screw_clamp_center[y], 0])
	{
		translate([0, 0, (z1+z2)/2-.05])
		rotate([0, 0, 90])
		cylinder(h=z2-z1+.1, r=z_screw_nut_radius, $fn=6, center=true);

		translate([0, 0, (z2+z3)/2])
		rotate([0, 0, 90])
		octylinder(h=z3-z2+.1, r=z_screw_radius+.5, center=true);

		translate([0, 0, (z3+z4)/2+.05])
		rotate([0, 0, 90])
		cylinder(h=z4-z3+.1, r=z_screw_nut_radius, $fn=6, center=true);
	}

	if (motor_bracket == true)
		motor_bracket_void();

	if (idler_bracket == true)
		idler_bracket_void();

	// X endstop mount

	translate(x_endstop_center+[0, 0, -linear_clamp_radius])
	{
		for(i=[-1, 1])
			translate([0, i*endstop_bolt_spacing()/2, 0])
			{
				rotate([0, 0, 90])
				octylinder(h=linear_clamp_radius*2+.1, r=m3_diameter/2, $fn=12, center=true);
				translate([0, 0, -(linear_clamp_radius-2)-.05])
				rotate([0, 0, 90])
				cylinder(h=4+.1, r=m3_nut_diameter/2, $fn=6, center=true);
			}
	}
}

module motor_bracket_solid(constrained)
{
	translate([motor_brace_center_x, 0, 0])
	rotate([0, 90, 0])
	rotate([0, 0, 90])
	linear_extrude(height=motor_brace_thickness, convexity=4, center=true)
	{
		intersection()
		{
			barbell(motor_brace_p1, motor_brace_p2, linear_clamp_radius, motor_brace_r2, 60, 40);
	
			translate([-35, x_end_center[z]])
			square([70, x_end_size[z]], center=true);
		}
	}

	translate([0, 0, motor_center[z]+motor_brace_thickness/2])
	linear_extrude(height=motor_brace_thickness, convexity=4, center=true)
	{
		barbell(motor_bracket_p1, motor_bracket_p2, motor_bracket_r1, motor_bracket_r1, 200, motor_bracket_r2);
		barbell(motor_bracket_p2, motor_bracket_p3, motor_bracket_r1, motor_bracket_r1, 200, motor_bracket_r2);
		barbell(motor_bracket_p1, motor_bracket_p4, motor_bracket_r1, z_screw_clamp_radius, 10, 10);
	}

	translate(motor_bracket_fill_1_center)
	cube(motor_bracket_fill_1_size, center=true);

	translate(motor_bracket_fill_2_center)
	cube(motor_bracket_fill_2_size, center=true);
}

module motor_bracket_void()
{
	for(i=[-1:1])
	{
		translate(motor_center+[0, 0, motor_brace_thickness/2])
		rotate([0, 0, i*90])
		translate([motor_bolt_hole_spacing/2, motor_bolt_hole_spacing/2, 0])
		rotate([0, 0, -i*90])
		hexypill(length=5, h=motor_brace_thickness+.1, r=m3_diameter/2, $fn=12, center=true);
	}
}

module idler_bracket_solid()
{
	// Belt idler bracket

	hull()
	{
		translate(belt_idler_center+[0, 0, (belt_idler_bearing_length+motor_brace_thickness)/2+1])
		cylinder(h=motor_brace_thickness, r=belt_idler_bearing_radius, center=true);

		intersection()
		{
			union()
			{
				translate([x_end_min[x]+motor_brace_thickness/2, x_axis_offset+x_linear_rod_offset, 0])
				rotate([0, 90, 0])
				cylinder(h=motor_brace_thickness, r=linear_clamp_radius, center=true);

				translate([x_end_max[x]-motor_brace_thickness/2, x_axis_offset+x_linear_rod_offset, 0])
				rotate([0, 90, 0])
				cylinder(h=motor_brace_thickness, r=linear_clamp_radius, center=true);
			}

			translate(x_end_center)
			cube(x_end_size, center=true);
		}
	}

	translate(belt_idler_center+[0, 0, belt_idler_bearing_length/2])
	cylinder(h=1, r1=belt_idler_bearing_radius-3, r2=belt_idler_bearing_radius-2, center=false);

	
}

module idler_bracket_void()
{
	// Idler Mount

	translate(belt_idler_center+[0, 0, (belt_idler_bearing_length-1)/2])
	rotate([0, 0, 90])
	octylinder(h=14, r=threaded_rod_diameter/2, center=false);

	translate(belt_idler_center+[0, 0, (belt_idler_bearing_length+1)/2+5])
	rotate([0, 0, 90])
	cylinder(h=20, r=m8_nut_diameter/2, $fn=6, center=false);
}

module lm8uu_void()
{
	// LM8UU linear bushing/bearing pockets (Tightly constrained end).

	translate(z_bearing_clamp_center)
	{
		rotate([0, 0, 90])
		octylinder(h=z_bearing_clamp_length, r=smooth_rod_diameter/2+1, center=true);

		translate([-10, 0, 0])
		cube([20, 1.5, z_bearing_clamp_length+.1], center=true);

		for(i=[-1, 1])
		{
			translate([0, 0, i*(z_bearing_clamp_length-linear_bearing_length+.1)/2])
			rotate([0, 0, 90])
			octylinder(h=linear_bearing_length+.1, r=linear_bearing_radius, center=true);

			translate([-(linear_bearing_radius+4), 0, 0])
			rotate([90, 0, 0])
			{
				rotate([0, 0, 90])
				octylinder(h=10.1, r=m3_diameter/2, $fn=12, center=true);

				translate([0, 0, 4])
				cylinder(h=10, r=m3_bolt_head_diameter/2, center=false);

				translate([0, 0, -4])
				rotate([180, 0, 0])
				cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);
			}
		}
	}

	// Z screw clamp.

	c1 = 1.5;
	c2 = 0.1;

	intersection()
	{
		difference()
		{
			z_extrusion(clearance_r=1, clearance_z=.1);
			z_extrusion(clearance_z=.2);
		}

		translate([0, 0, z_screw_clamp_center[z]])
		cube([30, 30, z_screw_clamp_length+.1], center=true);
	}

	// Z endstop mount.
}

module roller_void()
{
	// Z roller bearing (Loosly constrained end).

	lb_h = linear_roller_bearing[bearing_length];
	lb_r = linear_roller_bearing[bearing_body_diameter]/2;

	x1 = (lb_h+1)/2;
	x2 = x1+3;
	x3 = x2+m3_nut_thickness;
	x4 = 15;

	x_1 = -x1;
	x_2 = -x2;
	x_3 = -15;

	echo(x_3, x_2, x_1, x1, x2, x3, x4);

	translate(z_bearing_clamp_center)
	{
		for(i=[-1, 1])
			translate([0, i*(actual_smooth_rod_diameter/2+lb_r), 0])
			{
				rotate([0, -90, 0])
				{
					translate([0, 0, (x_3+x_2)/2])
					cylinder(h=x_2-x_3, r=m3_bolt_head_diameter/2, center=true);

					translate([0, 0, (x_2+x_1)/2+layer_height])
					cylinder(h=x_1-x_2, r=m3_diameter/2, $fn=12, center=true);

					translate([0, 0, (x_1+x1)/2])
					cylinder(h=x1-x_1, r=lb_r+.5, center=true);

					translate([0, 0, (x1+x2)/2+layer_height])
					cylinder(h=x2-x1, r=m3_diameter/2, $fn=12, center=true);

					translate([0, 0, (x2+x3)/2])
					{
						rotate([0, 0, 90])
						cylinder(h=m3_nut_thickness, r=m3_nut_diameter/2, $fn=6, center=true);

						translate([0, i*5, 0])
						cube([m3_nut_diameter*cos(30), 10, m3_nut_thickness], center=true);
					}

					translate([0, 0, (x3+x4)/2+layer_height])
					cylinder(h=x4-x3, r=m3_diameter/2, $fn=12, center=true);
				}

				translate([0, i*5, 0])
				cube([lb_h+1, 10, (lb_r+.5)*2], center=true);
			}
	}

	// X clamp flex cuts

	c1 = 1.5;
	c2 = 0.1;

	intersection()
	{
		difference()
		{
			z_extrusion(clearance_r=1, clearance_z=.1);
			z_extrusion(clearance_z=.2);
		}

		cube([30, 30, 21], center=true);
	}

}

module x_annotations()
{
	for(i=[-1, 1])
	{
		translate([0, i*x_linear_rod_offset, x_axis_height])
		rotate([0, 90, 0])
		cylinder(h=x_axis_linear_rod_length, r=actual_smooth_rod_diameter/2, center=true);
	}
}

module x_end_annotations(print_orientation)
{
  p1=(print_orientation == true) ? 1 : 0;
  p2=(print_orientation == false) ? 1 : 0;
  
  translate(p2*[z_motor_center[x]+z_linear_to_screw_separation/2, 0, x_axis_height])
	{
		translate(motor_center) motor();
		translate(belt_idler_center+[0, 0, -belt_idler_bearing_length/2]) cylinder(h=belt_idler_bearing_length*2, r=belt_idler_bearing_radius, center=true);
	}

  translate(p2*[z_motor_center[x]+z_linear_to_screw_separation/2, 0, x_axis_height])
	translate(x_endstop_center)
  {
    optical_endstop();
  }
  
	render(convexity=8)
  translate(p2*[z_motor_center[x]+z_linear_to_screw_separation, 0, x_axis_height-100])
  {
    akimbo_z_endstop_clamp(print_orientation);
    akimbo_z_endstop_glide(print_orientation);
    akimbo_z_endstop_glide_annotations(print_orientation);
  }

}
