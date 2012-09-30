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
// assembly.scad
//
// Frame Assembly
//

include <more_configuration.scad>
include <frame_computations.scad>

use <functions.scad>
use <barbell.scad>
use <teardrops.scad>
use <motor.scad>

use <akimbo_extruder.scad>
use <akimbo_x_end.scad>

include <vitamin.scad>

part_name = "akimbo_carriage";
part_count = 2;

print_orientation = true;

carriage_length = 60;

linear_bearing_length = lm8uu[bearing_length]+lm8uu_clearance[bearing_length];
linear_bearing_radius = (lm8uu[bearing_body_diameter]+lm8uu_clearance[bearing_body_diameter])/2;

/*
connector_min = [-carriage_length/2, x_axis_offset-x_linear_rod_offset, bearing_clamp_radius-5];
connector_max = [carriage_length/2, x_axis_offset+x_linear_rod_offset, bearing_clamp_radius];
connector_center = centerof(connector_min, connector_max);
connector_size = sizeof(connector_min, connector_max);
*/

//rotate([0, 90, 0])
akimbo_carriage(print_orientation=print_orientation);
akimbo_x_endstop_flag(print_orientation=print_orientation);

*translate([0, extruder_offset, bearing_clamp_radius+5])
	akimbo_extruder(print_orientation=print_orientation);

*translate([-116, 0, -x_axis_height])
{
	%akimbo_x_end(print_orientation=print_orientation);
	%x_end_annotations(print_orientation=print_orientation);
}

carriage_min = [-(carriage_length-10), -x_linear_rod_offset-bearing_clamp_radius, -bearing_clamp_radius];
carriage_max = [carriage_min[x]+carriage_length, x_linear_rod_offset+bearing_clamp_radius, bearing_clamp_radius];
carriage_center = centerof(carriage_min, carriage_max);
carriage_size = sizeof(carriage_min, carriage_max);

connector_min = [carriage_min[x], -x_linear_rod_offset-3, carriage_max[z]-5];
connector_max = [carriage_max[x], x_linear_rod_offset+3, linear_bearing_radius+7];
connector_center = centerof(connector_min, connector_max);
connector_size = sizeof(connector_min, connector_max);

belt_clamp_min = [-carriage_length/2, x_linear_rod_offset-8, belt_offset_z-belt_width/2];
belt_clamp_max = [belt_clamp_min[x]+30, belt_clamp_min[y]+16, -linear_bearing_radius];

belt_clamp_size = sizeof(belt_clamp_min, belt_clamp_max);
belt_clamp_center = centerof(belt_clamp_min, belt_clamp_max);

module akimbo_carriage(print_orientation=true)
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;

	rotate(p2*[0, 0, 180])
	rotate(p1*[0, -90, 0])
	translate(p1*[-connector_min[x], 0, 0])
	difference()
	{
		akimbo_carriage_solid();
		akimbo_carriage_void();
	}
}

module belt_clamp_profile(clearance_r=0)
{
	bc_r = -(linear_bearing_radius+4)-belt_clamp_min[z]+clearance_r;

	circle(bc_r);
	for(i=[-1, 1])
		rotate(i*43)
		translate([0, 8])
		square([bc_r*2, 16], center=true);
}

module akimbo_carriage_solid()
{
	bc_r = -(linear_bearing_radius+4)-belt_clamp_min[z];

	// Main body

	intersection()
	{
		union()
		{
			translate(carriage_center)
			rotate([0, -90, 0])
			linear_extrude(height=carriage_length, center=true, convexity=4)
			{
				barbell([0, x_linear_rod_offset], [0, -x_linear_rod_offset], bearing_clamp_radius, bearing_clamp_radius, 100, 14);

				translate([connector_center[z], connector_center[y]])
				square([connector_size[z], connector_size[y]], center=true);

				for(i=[-1, 1]) scale([1, i])
				{
					barbell([connector_center[z], connector_max[y]], [0, x_linear_rod_offset], connector_size[z]/2-.1, bearing_clamp_radius, 5, 5);

					translate([connector_center[z], connector_max[y]])
					rotate(-90)
					octircle(connector_size[z]/2, $fn=24);
				}
			}

			// Belt and linear bearing clamps


			translate(carriage_center)
			for(i=[-1, 1])
			{
				translate([i*belt_clamp_center[x], belt_clamp_center[y], -(linear_bearing_radius+4)])
				rotate([90, 0, 0])
				linear_extrude(height=belt_clamp_size[y], convexity=4, center=true)
				belt_clamp_profile();
			}
		}

		linear_extrude(height=100, center=true, convexity=4)
		{
			difference()
			{
				union()
				{
					barbell([connector_max[x]-bearing_clamp_radius, 25], [connector_max[x]-bearing_clamp_radius, -25], bearing_clamp_radius, bearing_clamp_radius, 14.5, 2000);

					polygon([[connector_max[x]-21, x_linear_rod_offset],
				          [connector_max[x], x_linear_rod_offset],
				          [carriage_max[x], carriage_max[y]],
				          [carriage_min[x], carriage_max[y]],
				          [carriage_min[x], carriage_min[y]],
				          [carriage_max[x], carriage_min[y]],
				          [connector_max[x], -x_linear_rod_offset],
				          [connector_max[x]-21, -x_linear_rod_offset],
				          [connector_max[x]-21, 0]]);
				}
				translate([0, 0])
				scale([1.5, 1, 1])
				circle(r=13.8);
			}
		}
	}

	n=3;

	translate(carriage_center+[0, -x_linear_rod_offset, 0])
	translate([0, 0, -(actual_smooth_rod_diameter+linear_roller_bearing[bearing_body_diameter])/2])
	translate([0, 0, n])
	rotate([90, 0, 0])
	cylinder(h=20, r=5+n, center=true);
}

module akimbo_carriage_void()
{
	// LM8UU pockets.

	difference()
	{
		translate(carriage_center+[0, x_linear_rod_offset, 0])
		rotate([0, 90, 0])
		rotate([0, 0, -90])
		cylinder(h=carriage_size[x]+.1, r=linear_bearing_radius, center=true);

		translate(carriage_center+[0, x_linear_rod_offset, linear_bearing_radius-1])
		cube([carriage_size[x]-linear_bearing_length*2, linear_bearing_radius*2, 2], center=true);
    
		vitamin(part_name, part_count, 2, "Linear Bushing", "LM8UU", "Linear Bushings");
	}

	// Back linear rod

	difference()
	{
		translate(carriage_center+[0, -x_linear_rod_offset, 0])
		rotate([0, 90, 0])
		rotate([0, 0, -90])
		cylinder(h=carriage_size[x]+.1, r=linear_bearing_radius, center=true);

		for(i=[-1, 1])
			translate(carriage_center+[0, -x_linear_rod_offset, i*(actual_smooth_rod_diameter/2+1+1.5)])
			cube([10, 20, 4], center=true);

			translate(carriage_center+[0, -x_linear_rod_offset, 0])
			for(i=[-1, 1])
				translate([0, 0, i*(actual_smooth_rod_diameter+linear_roller_bearing[bearing_body_diameter])/2])
				rotate([90, 0, 0])
				translate([0, 0, -(3+lb_h/2+m3_nut_thickness/2)])
				sphere(r=m3_nut_diameter/2+2);
	}

	lb_h = linear_roller_bearing[bearing_length]+linear_roller_bearing_clearance[bearing_length];
	lb_r = (linear_roller_bearing[bearing_body_diameter]+1)/2;

	// Roller bearing pockets.

	translate(carriage_center+[0, -x_linear_rod_offset, 0])
	for(i=[-1, 1])
	{
		translate([0, 0, i*(actual_smooth_rod_diameter+linear_roller_bearing[bearing_body_diameter])/2])
		rotate([90, 0, 0])
		{
			difference()
			{
				union()
				{
					translate([0, 0, 10])
					rotate([0, 0, -90])
					octylinder(h=lb_h+1.9+20, r=lb_r, $fn=24, center=true);
				}

				for(j=[-1])
					scale([1, 1, j])
					translate([0, 0, (lb_h+1)/2])
					cylinder(h=1, r1=2.5, r2=3.5, $fn=24, center=true);
			}

			rotate([0, 0, -90])
			octylinder(h=24, r=m3_diameter/2, $fn=12, center=true);

			if (i==1)
			{
				translate([0, 0, -(3+lb_h/2+m3_nut_thickness/2)])
				rotate([0, 0, 90])
				{
					cylinder(h=m3_nut_thickness, r=m3_nut_diameter/2, $fn=6, center=true);
					translate([5, 0, 0])
					cube([10, m3_nut_diameter*cos(30), m3_nut_thickness], center=true);
				}
			}
			else
			{
				translate([0, 0, -(3+lb_h/2+8/2)])
				rotate([0, 0, 90])
				cylinder(h=8, r=m3_nut_diameter/2, $fn=6, center=true);
			}
		}
	}

  vitamin(part_name, part_count, 2, "683zz Bearing", comment="Linear Roller Bearings");
  vitamin(part_name, part_count, 2, M3x12, M3x20, comment="Linear Roller Bearing mounts");
  vitamin(part_name, part_count, 1, M3_nylock, M3_nut, comment="Linear Roller Bearing mount");
  vitamin(part_name, part_count, 1, M3_nut, M3_nut, comment="Linear Roller Bearing mount");

	// Belt and linear bearing clamps

	translate([carriage_center[x], belt_clamp_center[y], belt_clamp_center[z]-layer_height])
	cube([carriage_size[x]+.1, 1.5, belt_clamp_size[z]], center=true);

	translate([carriage_center[x], 0, 0])
	for(i=[-1, 1]) translate([i*belt_clamp_center[x], belt_clamp_center[y], 0])
	{
		translate([0, 0, -(linear_bearing_radius+4)] )
		rotate([90, 0, 0])
		{
			rotate([0, 0, -90])
			octylinder(h=bearing_clamp_radius*2, r=m3_diameter/2, $fn=12, center=true);

			translate([0, 0, -4.5])
			rotate([180, 0, 0])
			rotate([0, 0, -90])
			octylinder(h=4, r=m3_bolt_head_diameter/2, $fn=24, center=false);

			translate([0, 0, 4.5])
			rotate([0, 0, 90])
			cylinder(h=4, r=m3_nut_diameter/2, $fn=6, center=false);
		}

		intersection()
		{
			union()
			{
				for(j=[-2 : 2])
					translate([j*3, 1.5-.05, belt_clamp_min[z]+belt_width/2-.05])
					cube([1.5, 1.5+.1, 6.1], center=true);

				for(j=[-1, 1])
					translate([j*(6+3), 1.5-.05, belt_clamp_min[z]+belt_width/2-.05])
					cube([6, 1.5+.1, 6.1], center=true);
			}

			translate([0, 0, -(linear_bearing_radius+4)])
			rotate([90, 0, 0])
			linear_extrude(height=belt_clamp_size[y]-.1, convexity=4, center=true)
			belt_clamp_profile(clearance_r=-layer_height);
		}
			
	}

	vitamin(part_name, part_count, 2, M3x20, M3x20, comment="Belt clamps");
	vitamin(part_name, part_count, 2, M3_nylock, M3_nut, comment="Belt Clamps");

	// Extruder bolts.

	for(i=[-1, 1])
		translate([0, i*x_linear_rod_offset, connector_max[z]-3])
		{
			cylinder(h=6.1, r=m3_diameter/2, $fn=12, center=true);
			rotate([180, 0, 0])
			cylinder(h=8, r=m3_nut_diameter/2, $fn=6, center=false);
		}

	vitamin(part_name, part_count, 2, M3_nylock, M3_nut, comment="Extruder Mounts");

	// Endstop mount.

	translate([-45, x_linear_rod_offset, connector_max[z]-3])
	{
		cylinder(h=6.1, r=m3_diameter/2, $fn=12, center=true);
		rotate([180, 0, 0])
		rotate([0, 0, 90])
		cylinder(h=8, r=m3_nut_diameter/2, $fn=6, center=false);
	}
	
	vitamin(part_name, part_count, 1, M3_nylock, M3_nut, comment="Endstop Flag mount");
	vitamin(part_name, part_count, 1, M3x20, M3x20, comment="Endstop Flag (!!! Verify Length)");
}

module akimbo_x_endstop_flag(print_orientation)
{
	p1=(print_orientation == true) ? 1 : 0;
	p2=(print_orientation == false) ? 1 : 0;

	rotate([0, 0, 180])
	translate(p1*[-6, 0, 9])
	rotate(p1*[180, 0, 0])
	translate(p2*[-(45+.05), x_linear_rod_offset, connector_max[z]+.05])
	rotate(p2*[0, 0, 180])
	difference()
	{
		akimbo_x_magnet_solid();
		akimbo_x_magnet_void();
	}
}

module akimbo_x_endstop_flag_solid()
{
	flag_min = [-21, -1.5/2, 0];
	flag_max = [0, 1.5/2, 8.5];
	flag_center = centerof(flag_min, flag_max);
	flag_size = sizeof(flag_min, flag_max);

	translate([0, 0, flag_max[z]/2])
	cylinder(h=flag_max[z], r=5, center=true);

	translate(flag_center)
	cube(flag_size, center=true);

	translate([flag_center[x], flag_center[y], flag_max[z]-1.5/2])
	cube([flag_size[x], 10, 1.5], center=true);
}

module akimbo_x_endstop_flag_void()
{
	translate([0, 0, 2-layer_height])
	cylinder(h=4, r=m3_diameter/2, $fn=12, center=true);

	translate([0, 0, 5])
	cylinder(h=10, r=m3_bolt_head_diameter/2, $fn=12, center=false);
}

magnet_radius = 3.2/2+.05;
magnet_thickness = 1.6*2+.1;

magnet_clamp_min = [5, -3, -4.5];
magnet_clamp_max = [magnet_clamp_min[x]+magnet_thickness+.5, 3, 9];
magnet_clamp_center = centerof(magnet_clamp_min, magnet_clamp_max);
magnet_clamp_size = sizeof(magnet_clamp_min, magnet_clamp_max);

module akimbo_x_magnet_solid()
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

module akimbo_x_magnet_void()
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
