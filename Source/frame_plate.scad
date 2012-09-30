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
// frame_plate.scad
//

use <akimbo_endstop_mount.scad>
use <akimbo_extruder.scad>
use <akimbo_carriage.scad>
use <akimbo_x_end.scad>
use <bottom_vertex.scad>
use <top_vertex.scad>
use <z_bottom_frame_clamp.scad>
use <z_linear_rod_clamp.scad>
use <y_pillow_block.scad>
use <akimbo_barclamp.scad>
use <z_motor_coupler.scad>
use <y_axis_belt_clamp.scad>

plate=4;

%translate([0, 0, 0.5])
cube([150, 150, 1], center=true);

if (plate==1)
  plate_1();
  
if (plate==2)
  plate_2();

if (plate==3)
  plate_3();

if (plate==4)
  plate_4();

if (plate==5)
  plate_5();

module plate_1()
{
	// Bottom vertices.

	color([.5, .5, 1])
	translate([-10, -23])
	bottom_vertex(print_orientation=true);

	color([.5, .5, 1])
	translate([10, 12])
	bottom_vertex(print_orientation=true);


	color([.5, .5, 1])
	translate([0, 48])
	bottom_vertex(print_orientation=true, mirrored=true);

	color([.5, .5, 1])
	translate([-20, 83])
	bottom_vertex(print_orientation=true, mirrored=true);

	// 

	color([.5, .5, 1])
	for(i=[-1, 1])
		translate([-58, i*18, 0])
		y_pillow_block(print_orientation=true);

	color([.5, .5, 1])
	translate([52, 55, 0])
	y_roller_bearing_block(print_orientation=true);

	translate([50, -50, 0])
	akimbo_endstop_mount(print_orientation=true);

}

module plate_2()
{
	for(i=[-1, 1])
	{
		color([.5, .5, 1])
		translate([i*40+5, 0, 0])
		top_vertex(print_orientation=true);

		color([.5, .5, 1])
		translate([9, i*-45, 0])
		scale([1, i, 1])
		z_clamp(print_orientation=true);
	}

	for(i=[-1, 1])
	{
		color([.5, .5, 1])
		translate([i*9, 0, 0])
		z_linear_clamp();

		color([.5, .5, 1])
		translate([i*60+1, 0, 0])
		z_linear_clamp();
	}
}

module plate_3()
{
	color([.5, .5, 1])
	for(i=[-1, 1])
	{
		rotate([0, 0, i*90+90])
		translate([55, 0, 0])
		akimbo_x_end(print_orientation=true, constrained=(i==1), motor_bracket=true, idler_bracket=true);
	}
  
	translate([25, 30, 0])
	rotate([0, 0, 90])
  	akimbo_z_magnet_clamp(print_orientation=true);

	translate([53, -53, 0])
	rotate([0, 0, 45])
	akimbo_endstop_mount(print_orientation=true);

	color([.5, .5, 1])
	translate([-3, 30, 0])
    barclamp(print_orientation=true);

	color([.5, .5, 1])
	translate([-3, 60, 0])
    barclamp(print_orientation=true);

	color([.5, .5, 1])
	translate([-28, -30, 0])
    barclamp(print_orientation=true);

	color([.5, .5, 1])
	translate([-28, -60, 0])
    barclamp(print_orientation=true);
}

module plate_4_a()
{
	render(convexity=4)
	{
		translate([40, 0, 0])
		akimbo_extruder(print_orientation=true);

		translate([-10, 0, 0])
		rotate([0, 0, 180])
		akimbo_carriage(print_orientation=true);

		translate([41, -74, 0])
		akimbo_extruder_fan_shroud(print_orientation=true);

		translate([41, 48, 0])
		akimbo_extruder_idler(print_orientation=true);

		translate([-20, 0, 0])
		akimbo_x_endstop_flag(print_orientation=true);
	}
}

module plate_4()
{
	color([.5, .5, 1])
	plate_4_a ();

	color([.5, .5, 1])
	for(i=[-1.5: 1.5])
		translate([-45, i*23+10, 0])
		z_motor_coupler(print_orientation=true);

	translate([-25, -53, 0])
	rotate([0, 0, 90])
	{
		color([.5, .5, 1])
		{
			y_axis_belt_spacer(print_orientation=true);
			y_axis_belt_tensioner(print_orientation=true);
			y_axis_belt_clamp(print_orientation=true);
		}

		translate([0, -13, 0])
		y_axis_belt_spacer(print_orientation=true);

		translate([0, 13, 0])
		y_axis_belt_clamp(print_orientation=true);
	}

}

module plate_5()
{
	scale([-1, 1, 1])
	plate_4_a();
}
