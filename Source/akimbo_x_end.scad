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
// Installation order:
//    Remove support membranes.
//    Nuts into nut traps.
//    Roller Bearing and bolts.
//    Idler bearings, bolt, washer and nut.
//    Endstop, loosely.
//    Motor, bolts and washers.


print_orientation = true;
constrained = false;

include <more_configuration.scad>
include <frame_computations.scad>
include <vitamin.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>
use <pill.scad>
use <akimbo_endstop_mount.scad>
use <optical_endstop.scad>

part_name = (constrained) ? "akimbo_x_end_left" : "akimbo_x_end_right";
part_count = 1;

belt_idler_bearing = 608_bearing;

belt_idler_bearing_length = belt_idler_bearing[bearing_length];
belt_idler_bearing_radius = belt_idler_bearing[bearing_body_diameter]/2;

linear_bearing_length = lm8uu[bearing_length]+lm8uu_clearance[bearing_length];
linear_bearing_radius = (lm8uu[bearing_body_diameter]+lm8uu_clearance[bearing_body_diameter])/2;

m5_nut_thickness = 3;

z_screw_nut_thickness = m5_nut_thickness;
z_screw_nut_radius = (m5_nut_diameter+.2)/2;  // Increase the size a bit - we want a loose fit.
z_screw_radius = 5/2;

/*
z_screw_nut_thickness = m8_nut_thickness;
z_screw_nut_radius = m8_nut_diameter/2;
z_screw_radius = m8_diameter/2;
*/

function z_bearing_clamp_length(constrained) = (constrained) ? 60 : 45;
z_screw_clamp_length = 10;

z_bearing_clamp_radius = bearing_clamp_radius;
z_screw_clamp_radius = z_screw_nut_radius+2;


x_end_min = [-(z_linear_to_screw_separation/2+z_screw_clamp_radius), -(x_linear_rod_offset+linear_clamp_radius), -(z_bearing_clamp_length(constrained)-linear_clamp_radius)];
x_end_max = [z_linear_to_screw_separation/2+z_bearing_clamp_radius, x_linear_rod_offset+linear_clamp_radius, linear_clamp_radius];
x_end_center = centerof(x_end_min, x_end_max);
x_end_size = sizeof(x_end_min, x_end_max);

function z_bearing_clamp_center(constrained) = [z_linear_to_screw_separation/2, 0, x_end_max[z]-z_bearing_clamp_length(constrained)/2];
z_screw_clamp_center = [-z_linear_to_screw_separation/2, 0, x_end_max[z]-z_screw_clamp_length/2];

belt_idler_center = [0, x_linear_rod_offset+belt_idler_bearing_radius+3, belt_offset_z];
motor_center = [0, -(x_linear_rod_offset+belt_idler_bearing_radius+3), belt_offset_z-18];

motor_brace_thickness = 6;

motor_bolt_hole_spacing = motor_bolt_hole_spacing();

motor_bracket_p1 = [motor_center[x]-motor_bolt_hole_spacing/2, motor_center[y]+motor_bolt_hole_spacing/2];
motor_bracket_p2 = [motor_center[x]+motor_bolt_hole_spacing/2, motor_center[y]+motor_bolt_hole_spacing/2];
motor_bracket_p3 = [motor_center[x]+motor_bolt_hole_spacing/2, motor_center[y]-motor_bolt_hole_spacing/2];
motor_bracket_p4 = [z_linear_to_screw_separation/2, 0];

motor_bracket_r1 = 8;
motor_bracket_r2 = motor_bolt_hole_spacing*sqrt(2)/2-motor_bracket_r1;
motor_bracket_r4 = z_bearing_clamp_radius;

motor_bracket_fill_1_min = [motor_bracket_p3[x], motor_bracket_p3[y]-motor_bracket_r1, motor_center[z]];
motor_bracket_fill_1_max = [x_end_max[x], 0, motor_bracket_fill_1_min[z]+motor_brace_thickness];
motor_bracket_fill_1_center = centerof(motor_bracket_fill_1_min, motor_bracket_fill_1_max);
motor_bracket_fill_1_size = sizeof(motor_bracket_fill_1_min, motor_bracket_fill_1_max);

motor_brace_center_x = x_end_max[x]-motor_brace_thickness/2; // (x_end_size[x]-motor_brace_thickness)/2;

motor_brace_r2 = 7;

motor_brace_p0 = [0, 0];
motor_brace_p1 = [-x_linear_rod_offset, 0];
motor_brace_p2 = [motor_bracket_p3[y]-motor_bracket_r1+motor_brace_r2, motor_center[z]+motor_brace_r2];
motor_brace_p2b = motor_brace_p2+[0, -motor_brace_thickness];
motor_brace_p3 = [0, x_end_min[z]+z_bearing_clamp_radius];

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
	echo(z_bearing_clamp_center(constrained), z_bearing_clamp_length(constrained));

	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;
  
	translate(p2*[z_motor_center[x]+z_linear_to_screw_separation/2, 0, x_axis_height])
	rotate(p1*[0, 90, 0])
	translate(p1*[-x_end_max[x], 0, 0])
	difference()
	{
		akimbo_x_end_solid(constrained, motor_bracket, idler_bracket);
		akimbo_x_end_void(constrained, motor_bracket, idler_bracket);
	}
}

module z_extrusion_profile(clearance_r = 0)
{
	p1=[z_bearing_clamp_center(constrained)[x], z_bearing_clamp_center(constrained)[y]];
	p2=[-z_bearing_clamp_center(constrained)[x], z_bearing_clamp_center(constrained)[y]];

	r1=z_bearing_clamp_radius+clearance_r;
	r2=z_screw_clamp_radius+clearance_r;

	barbell(p1, p2, r1, r2, 30-clearance_r, 30-clearance_r, $fn=40);
	translate(p1)
	rotate(-90)
	octircle(r=r1, $fn=40);
}

module z_extrusion(clearance_r = 0, clearance_z = 0)
{
	translate([0, 0, z_screw_clamp_center[z]])
	linear_extrude(height=z_screw_clamp_length+clearance_z, center=true, convexity=4)
  	z_extrusion_profile(clearance_r);
}

module z_extrusion_profile_plus(clearance_r = 0, clearance_z = 0)
{
	p1=[z_bearing_clamp_center(constrained)[x], z_bearing_clamp_center(constrained)[y]];
	p2=[-z_bearing_clamp_center(constrained)[x], z_bearing_clamp_center(constrained)[y]];
	p3=[z_bearing_clamp_center(constrained)[x]-(linear_bearing_radius+4), -7];

	r1=z_bearing_clamp_radius+clearance_r;
	r2=z_screw_clamp_radius+clearance_r;
	r3=5+clearance_r;

	r4=7-clearance_r;

	barbell(p1, p2, r1, r2, 30-clearance_r, 30-clearance_r, $fn=40);
	barbell(p2, p3, r2, r3, r4, r4, $fn=40);
	barbell(p3, p1, r3, r1, r4, r4, $fn=40);
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


	for(i=[-1, 1])
	{
		translate([x_end_center[x], i*x_linear_rod_offset, 0])
		{
			translate([0, -i*(smooth_rod_diameter/2+4), 5/2])
			rotate([0, 0, 90])
			cylinder(h=5, r1=m3_washer_diameter/2+5, r2=m3_washer_diameter/2, center=true);

			translate([0, -i*(smooth_rod_diameter/2+4), -8/2])
			rotate([0, 0, 90])
			cylinder(h=8, r1=m3_nut_diameter/2+1.5, r2=m3_nut_diameter/2+1.5+8, center=true);
		}
	}

	// Z bearing clamp.

	lb_h = linear_roller_bearing[bearing_length];
	lb_r = (linear_roller_bearing[bearing_body_diameter]+1)/2;

	lb_x1 = lb_h/2+1;
	lb_x2 = x_end_max[x]-z_bearing_clamp_center(constrained)[x];

	translate(z_bearing_clamp_center(constrained))
	rotate([0, 0, -90])
	octylinder(h=z_bearing_clamp_length(constrained), r=z_bearing_clamp_radius, center=true, $fn=40);

	if (constrained == true)
	{
		lm8uu_clamp_solid();

		// Z endstop flag mount.

		hull()
		{
			translate(z_bearing_clamp_center(constrained)+[0, linear_bearing_radius+7/2, -(z_bearing_clamp_length(constrained)/2-5)])
			rotate([90, 0, 0])
			cylinder(h=7, r=5, center=true);

			intersection()
			{
				translate(z_bearing_clamp_center(constrained)+[z_bearing_clamp_radius-1/2, 0, -(z_bearing_clamp_length(constrained)/2-5)])
				rotate([0, 90, 0])
				cylinder(h=1, r=7, center=true);

				translate(z_bearing_clamp_center(constrained)+[z_bearing_clamp_radius-1/2, 6, -(z_bearing_clamp_length(constrained)/2-6)])
				cube([1, 12, 12], center=true);
			}
		}
	}
	else
	{
		// Roller bearing nut trap.

		hull()
		for(i=[-1, 1]) scale([1, i, 1])
		translate(z_bearing_clamp_center(constrained)+[0, (actual_smooth_rod_diameter/2+lb_r), 0])
		{
			translate([(lb_x1+lb_x2)/2, 0, 0])
			rotate([0, 90, 0])
			cylinder(h=lb_x2-lb_x1, r=m3_nut_diameter/2+2, center=true);
		}
	}


	// Z screw clamp.

	z_extrusion();

	if (motor_bracket == true)
		motor_bracket_solid(constrained);

	if (idler_bracket == true)
		idler_bracket_solid();

	// X endstop mount (s)

	for(i=[-1, 1])
		hull()
		{
			translate(x_endstop_center+[0, i*endstop_bolt_spacing()/2, -linear_clamp_radius])
			cylinder(h=linear_clamp_radius*2, r=4, $fn=24, center=true);

			translate(x_endstop_center+[endstop_bolt_spacing()/2, 0, -linear_clamp_radius])
			cylinder(h=1, r=4, $fn=24, center=true);
		}

	translate(x_endstop_center+[0, 0, -linear_clamp_radius])
	cube([8, endstop_bolt_spacing(), (linear_clamp_radius-1.5)*2], center=true);
}

module akimbo_x_end_void(constrained, motor_bracket, idler_bracket)
{
	// X Linear rod.

	render(convexity = 8)
	for(i=[-1, 1])
	{
		translate([x_end_center[x], i*x_linear_rod_offset, 0])
		{
			rotate([0, 90, 0])
			cylinder(h=x_end_size[x]+.1, r=smooth_rod_diameter/2, center=true);

			translate([0, -i*(smooth_rod_diameter/2+4), 0])
			rotate([0, 0, 90])
			octylinder(h=25, r=m3_diameter/2, $fn=12, center=true);

			translate([0, -i*(smooth_rod_diameter/2+4), -5])
			rotate([180, 0, 0])
			rotate([0, 0, 90])
			cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);

			translate([0, -i*(smooth_rod_diameter/2+4), 5])
			rotate([0, 0, 90])
			octylinder(h=10, r=m3_washer_diameter/2, center=false);
		}
	}

	// X linear rod clamp relief cuts.

	difference()
	{
		translate([x_end_center[x], 0, 0])
		cube([x_end_size[x]+.1, x_linear_rod_offset*2, 1.5], center=true);

		linear_extrude(height=1.51, convexity=8, center=true)
		z_extrusion_profile(clearance_r=0);
	}

	translate([0, 0, 5])
	linear_extrude(height=10, convexity=8, center=true)
	{
		difference()
		{
			z_extrusion_profile(clearance_r=1, clearance_z=.1);
			z_extrusion_profile(clearance_r=.01, clearance_z=.2);
		}
	}

	vitamin(part_name, part_count, 2, M3x16, M3x20, "X Linear rod clamps");
	vitamin(part_name, part_count, 2, M3_nylock, M3_nut, "X Linear rod clamps");

	if (constrained == true)
	{
		lm8uu_void();

		#translate(z_bearing_clamp_center(constrained)+[0, linear_bearing_radius+7/2, -(z_bearing_clamp_length(constrained)/2-5)])
		rotate([90, 0, 0])
		rotate([0, 0, 90])
		octylinder(h=7.1, r=m3_diameter/2, $fn=12, center=true);

		translate(z_bearing_clamp_center(constrained)+[0, linear_bearing_radius+4.5/2-1, -(z_bearing_clamp_length(constrained)/2-5)])
		rotate([90, 0, 0])
		cylinder(h=4.5+2, r=m3_nut_diameter/2, $fn=6, center=true);
    
		vitamin(part_name, part_count, 2, "Linear Bushing", "LM8UU", "Linear Bushings");
		vitamin(part_name, part_count, 2, M3x16, M3x20, "Linear bushing clamps");
		vitamin(part_name, part_count, 2, M3_nylock, M3_nut, "Linear bushing clamps");
		vitamin(part_name, part_count, 1, M3x20, comment="Z endstop flag mount");
	}
	else
	{
		roller_void();

		vitamin(part_name, part_count, 2, "683zz Bearing", comment="Linear Roller Bearings");
		vitamin(part_name, part_count, 2, M3x12, M3x20, comment="Linear Roller Bearing mounts");
		vitamin(part_name, part_count, 2, M3_nylock, M3_nut, comment="Linear Roller Bearing mounts");
	}

	// Z screw.

	z1=x_end_max[z]-z_screw_clamp_length;
	z2=z1+z_screw_nut_thickness;
	z3=x_end_max[z];

	translate([z_screw_clamp_center[x], z_screw_clamp_center[y], 0])
	{
		translate([0, 0, (z1+z2)/2-.05])
		rotate([0, 0, 90])
		cylinder(h=z2-z1+.1, r=z_screw_nut_radius, $fn=6, center=true);

		translate([0, 0, (z2+z3)/2])
		rotate([0, 0, 90])
		octylinder(h=z3-z2+.1, r=z_screw_radius+.5, center=true);
	}

	vitamin(part_name, part_count, 1, M5_nut, comment="Z Axis drive nut (bottom)");
	vitamin(part_name, part_count, 1, M5_nut, "Optional", comment="Z Axis anti-backlash nut (top)");
	vitamin(part_name, part_count, 1, "Spring", "Optional", comment="Z Axis anti-backlash spring");

	if (motor_bracket == true)
		motor_bracket_void();

	if (idler_bracket == true)
		idler_bracket_void();

	// X endstop mount (s)

	translate(x_endstop_center+[0, 0, -linear_clamp_radius])
	{
		for(i=[-1, 1])
			translate([0, i*endstop_bolt_spacing()/2, 0])
			{
				rotate([0, 0, 90])
				octylinder(h=linear_clamp_radius*2+.1, r=m3_diameter/2, $fn=12, center=true);

				translate([0, 0, -(linear_clamp_radius-4)])
				rotate([180, 0, 0])
				rotate([0, 0, 90])
				cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);
			}
	}
  
	vitamin(part_name, part_count, 2, M3x25, comment="X Endstop Mount");
	vitamin(part_name, part_count, 2, M3_nylock, M3_nut, comment="X Endstop Mount");
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
		barbell(motor_bracket_p1, motor_bracket_p4, motor_bracket_r1, motor_bracket_r4, 30, 30);

		polygon([motor_bracket_p1, [motor_bracket_p2[x]+.1, motor_bracket_p2[y]], [motor_bracket_p2[x]+.1, motor_bracket_p4[y]]]);
	}

	translate(motor_bracket_fill_1_center)
	cube(motor_bracket_fill_1_size, center=true);
}

module motor_bracket_void()
{
	render(convexity = 8)
	for(i=[-1:1])
	{
		translate(motor_center+[0, 0, motor_brace_thickness/2])
		rotate([0, 0, i*90])
		translate([motor_bolt_hole_spacing/2, motor_bolt_hole_spacing/2, 0])
		rotate([0, 0, -i*90])
		hexypill(length=5, h=motor_brace_thickness+.1, r=m3_diameter/2, $fn=12, center=true);
	}

	vitamin(part_name, part_count, 1, "Nema 17", comment="X Axis Motor");
	vitamin(part_name, part_count, 3, M3x12, comment="X Axis Motor mount");
}

module idler_bracket_solid()
{
	// Belt idler bracket

	hull()
	{
		translate(belt_idler_center+[0, 0, (belt_idler_bearing_length+motor_brace_thickness)/2+1])
		cylinder(h=motor_brace_thickness, r=belt_idler_bearing_radius, center=true);

		translate([x_end_center[x], x_axis_offset+x_linear_rod_offset, 0])
		rotate([0, 90, 0])
		cylinder(h=x_end_size[x], r=linear_clamp_radius, center=true);
	}

	translate(belt_idler_center+[0, 0, belt_idler_bearing_length/2])
	cylinder(h=1, r1=belt_idler_bearing_radius-3, r2=belt_idler_bearing_radius-2, center=false);
}

module idler_bracket_void()
{
	// Idler Mount

	render(convexity = 8)
	{
	translate(belt_idler_center+[0, 0, (belt_idler_bearing_length-1)/2])
	rotate([0, 0, 90])
	octylinder(h=14, r=threaded_rod_diameter/2, center=false);

	translate(belt_idler_center+[0, 0, (belt_idler_bearing_length+1)/2+5])
	rotate([0, 0, 90])
	cylinder(h=20, r=m8_nut_diameter/2, $fn=6, center=false);
	}
  
  vitamin(part_name, part_count, 2, "608zz Bearing", comment="X Axis belt idler");
	vitamin(part_name, part_count, 1, M8x30, "M8x38 threaded rod + 1 M8 Nut", comment="X Axis belt idler");
	vitamin(part_name, part_count, 1, M8_nut, comment="X Axis belt idler");

}

module lm8uu_clamp_relief_profile()
{
	intersection()
	{
		difference()
		{
			translate(motor_bracket_p4)
			circle(motor_bracket_r4+1);

			translate(motor_bracket_p4)
			circle(motor_bracket_r4+.02, $fn=40);
		}

		translate(motor_bracket_p4+[-(motor_bracket_r4+1), 0])
		square([motor_bracket_r4*2+2, motor_bracket_r4*2+2], center=true);
	}
}

module lm8uu_clamp_solid()
{
	translate(z_bearing_clamp_center(constrained)+[-(linear_bearing_radius+4), 0, 3])
	rotate([90, 0, 0])
	{
		rotate([0, 0, 90])
		{
			cylinder(h=14, r=6, center=true);
			for(i=[-1, 1])
				rotate([0, 0, i*30])
				translate([0, -5, 0])
				cube([12, 10, 14], center=true);
		}
	}
}

module lm8uu_void()
{
	// LM8UU linear bushing/bearing pockets (Tightly constrained end).

	translate(z_bearing_clamp_center(constrained))
	{
		difference()
		{
			rotate([0, 0, 90])
			octylinder(h=z_bearing_clamp_length(constrained)+.1, r=linear_bearing_radius, center=true);

			translate([linear_bearing_radius, 0, 0])
			cube([4, linear_bearing_radius*2, z_bearing_clamp_length(constrained)-(linear_bearing_length*2)], center=true);
		}

			translate([-(linear_bearing_radius+4), 0, 3])
			rotate([90, 0, 0])
			{
				rotate([0, 0, 90])
				octylinder(h=10.1, r=m3_diameter/2, $fn=12, center=true);

				translate([0, 0, -4])
				rotate([180, 0, 0])
				cylinder(h=10, r=m3_washer_diameter/2, center=false);

				translate([0, 0, 4])
				cylinder(h=8, r=m3_nut_diameter/2, $fn=6, center=false);
			}
	}

	x1=-12;
	x2=z_bearing_clamp_center(constrained)[x]-linear_bearing_radius-layer_height;

	translate([0, 0, 0.5])
	linear_extrude(height=x_end_max[z]*2+.1, convexity=4, center=true)
	lm8uu_clamp_relief_profile();

	translate(z_bearing_clamp_center(constrained)+[-(linear_bearing_radius+4), 0, 3])
	cube([12+.1, 1.5, 15], center=true);

	translate([0, 0, motor_center[z]+motor_brace_thickness/2])
	linear_extrude(height=motor_brace_thickness+.1, convexity=4, center=true)
	lm8uu_clamp_relief_profile();

	#translate([motor_bracket_p4[x]-motor_bracket_r4/2, 0, z_bearing_clamp_center(constrained)[z]])
	cube([motor_bracket_r4+1, 1.5, z_bearing_clamp_length(constrained)+.1], center=true);
}

module roller_void()
{
	translate(z_bearing_clamp_center(false))
	rotate([0, 0, 90])
	octylinder(h=z_bearing_clamp_length(false)+.1, r=5, center=true);

	// Z roller bearing (Loosly constrained end).

	lb_h = linear_roller_bearing[bearing_length];
	lb_r = linear_roller_bearing[bearing_body_diameter]/2;

	lb_x1 = -15;
	lb_x2 = lb_h/2+1;
  
	for(i=[-1, 1]) scale([1, i, 1])
		translate(z_bearing_clamp_center(constrained)+[0, (actual_smooth_rod_diameter/2+lb_r), 0])
	{
		difference()
		{
			union()
			{
				translate([(lb_x1+lb_x2)/2, 0, 0])
				rotate([0, 90, 0])
				cylinder(h=lb_x2-lb_x1, r=lb_r+.5, $fn=24, center=true);

				translate([(lb_x1+lb_x2)/2, 5, 0])
				cube([lb_x2-lb_x1, 10, lb_r*2+1], center=true);

				translate([lb_x1, 0, 0])
				rotate([0, -90, 0])
				octasphere(lb_r+.5, $fn=24);
			}

			translate([lb_x2-.5+.05, 0, 0])
			rotate([0, 90, 0])
			cylinder(h=1+.1, r1=2.5, r2=3.5, $fn=24, center=true);
		}

		translate([lb_x2+4, 0, 0])
		rotate([0, 90, 0])
		rotate([0, 0, 90])
		cylinder(h=10, r=m3_nut_diameter/2, $fn=6, center=false);

		translate([lb_x2+4-layer_height, 0, 0])
		rotate([0, 90, 0])
		rotate([180, 0, 0])
		cylinder(h=10, r=m3_diameter/2, $fn=12, center=false);
	}
}

if (constrained)
  akimbo_z_magnet_clamp(print_orientation = print_orientation);

module akimbo_z_magnet_clamp(print_orientation)
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;

	translate(p1*[-36, 18, 9])
	rotate(p1*[180, 0, 0])
	translate(p2*[z_motor_center[x]+z_linear_to_screw_separation/2, 0, x_axis_height])
	translate(p2*(z_bearing_clamp_center(constrained)+[0, linear_bearing_radius+7, -(z_bearing_clamp_length(constrained)/2-5)]))
	rotate(p2*[0, 0, 90])
	rotate(p2*[0, 90, 0])
	difference()
	{
		akimbo_z_magnet_solid();
		akimbo_z_magnet_void();
	}
}

magnet_radius = 3.2/2+.05;
magnet_thickness = 1.6*2+.1;

magnet_clamp_min = [5, -3, -4.5];
magnet_clamp_max = [magnet_clamp_min[x]+magnet_thickness+.5, 3, 9];
magnet_clamp_center = centerof(magnet_clamp_min, magnet_clamp_max);
magnet_clamp_size = sizeof(magnet_clamp_min, magnet_clamp_max);

module akimbo_z_magnet_solid()
{
	hull()
	{
		translate([0, 0, magnet_clamp_max[z]/2])
		cylinder(h=magnet_clamp_max[z], r=5, center=true);

		translate([magnet_clamp_center[x], magnet_clamp_center[y], magnet_clamp_max[z]/2])
		cube([magnet_clamp_size[x], magnet_clamp_size[y], magnet_clamp_max[z]], center=true);
	}

	translate(magnet_clamp_center)
	cube(magnet_clamp_size, center=true);
}

module akimbo_z_magnet_void()
{
	bolt_length = 12;
	bolt_offset = 6.5;

	translate([0, 0, -.05])
	rotate([0, 0, 90])
	octylinder(h=bolt_length-bolt_offset+.1, r=m3_diameter/2, $fn=12, center=false);

	translate([0, 0, (bolt_length-bolt_offset)])
	rotate([0, 0, 90])
	octylinder(h=10, r=m3_bolt_head_diameter/2, $fn=12, center=false);

	#translate([magnet_clamp_min[x]+magnet_thickness/2-.05, magnet_clamp_center[y], magnet_clamp_min[z]+magnet_radius+1.5])
	rotate([0, 90, 0])
	cylinder(h=magnet_thickness+.1, r=magnet_radius, $fn=12, center=true);
}


*akimbo_z_endstop_flag(print_orientation = print_orientation);

flag_min = [0, -1.5/2, 2];
flag_max = [16, 1.5/2, flag_min[z]+8.5];
flag_center = centerof(flag_min, flag_max);
flag_size = sizeof(flag_min, flag_max);

module akimbo_z_endstop_flag(print_orientation)
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;

	translate(p1*[-36, 18, 14+8.5])
	rotate(p1*[180, 0, 0])
	translate(p2*[z_motor_center[x]+z_linear_to_screw_separation/2, 0, x_axis_height])
	translate(p2*(z_bearing_clamp_center(constrained)+[0, linear_bearing_radius+7+.05, -(z_bearing_clamp_length(constrained)/2-5-.05)]))
	rotate(p2*[0, 0, 90])
	rotate(p2*[0, 90, 0])
	difference()
	{
		akimbo_z_endstop_flag_solid();
		akimbo_z_endstop_flag_void();
	}
}

module akimbo_z_endstop_flag_solid()
{
	translate([0, 0, flag_max[z]/2])
	cylinder(h=flag_max[z], r=5, center=true);

	translate(flag_center)
	cube(flag_size, center=true);

	translate([flag_center[x], flag_center[y], flag_max[z]-1.5/2])
	cube([flag_size[x], 10, 1.5], center=true);
}

module akimbo_z_endstop_flag_void()
{
	translate([0, 0, -.05])
	cylinder(h=13.5-layer_height+.1, r=m3_diameter/2, $fn=12, center=false);

	translate([0, 0, 13.5])
	cylinder(h=10, r=m3_bolt_head_diameter/2, $fn=12, center=false);
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
  
  translate(p2*[z_motor_center[x]+z_linear_to_screw_separation, 0, x_axis_height-70])
  {
	render(convexity=8)
	{
		*akimbo_endstop_mount(print_orientation);
		akimbo_endstop_annotations(print_orientation);
	}
  }

}
