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
// extruder_fan_shroud.scad
//

include <more_configuration.scad>

$fa=1;
$fs=2;

motor_angle = 90;

mount_thickness = 5;
motor_length = 45;
motor_radius = 35/2;
motor_bolt_offset = 42/2;		// offset from center of motor to bolt hole.

extruder_fan_shroud();

module extruder_fan_shroud()
{
	difference()
	{
		extruder_fan_shroud_solid();
		extruder_fan_shroud_void();
	}
}

module extruder_fan_shroud_solid()
{
	hull()
	{
		translate([21, 0, -40/2-5])
		for(i=[-1, 1]) for(j=[-1, 1])
			translate([0, i*(20-3), j*(20-3)])
			rotate([0, 90, 0])
			cylinder(h=2, r=3, $fn=16, center=true);

		translate([0, 0, -40/2-5])
		cylinder(h=40, r=motor_radius+4, center=true);

		for(i=[0:1])
			rotate([0, 0, motor_angle+i*180])
			translate([motor_bolt_offset, 0, -40/2-5])
			cylinder(h=40, r=m3_washer_diameter/2+1, center=true);
	}
}

module extruder_fan_shroud_void()
{
	translate([0, 0, -motor_length/2])
	cylinder(h=motor_length+.1, r=motor_radius+.5, center=true);

	hull()
	{
		translate([0, 0, -40/2-5])
		cylinder(h=40-4, r=motor_radius+2, center=true);

		translate([19, 0, -40/2-5])
		rotate([0, 90, 0])
		cylinder(h=2, r=35/2, center=true);

		for(i=[0:1])
			rotate([0, 0, motor_angle+i*180])
			translate([motor_bolt_offset, 0, -40/2-5])
			cylinder(h=40-4, r=2, center=true);

	}

	translate([21, 0, -40/2-5])
	rotate([0, 90, 0])
	cylinder(h=2.1, r=35/2, center=true);

	translate([22-5, 0, -40/2-5])
	for(i=[-1, 1]) for(j=[-1, 1])
		translate([0, i*(20-4), j*(20-4)])
		rotate([0, 90, 0])
		cylinder(h=10.1, r=m3_diameter/2, $fn=12, center=true);

	translate([22-3.5, 0, -40/2-5])
	for(i=[-1, 1]) for(j=[-1, 1])
		translate([0, i*(20-4), j*(20-4)])
		rotate([0, -90, 0])
		rotate([0, 0, 90])
		{
			cylinder(h=8.1, r=m3_nut_diameter/2, $fn=6, center=false);
			translate([0, 0, 8])
			cylinder(h=3, r1=m3_nut_diameter/2, r2=m3_nut_diameter/2-2, $fn=6, center=false);
		}


	for(i=[0:1])
		rotate([0, 0, motor_angle+i*180])
		translate([motor_bolt_offset, 0, -40/2-5])
		{
			cylinder(h=40-4, r=m3_washer_diameter/2, center=true);
			cylinder(h=40.1, r=m3_diameter/2, $fn=12, center=true);
		}

	for(i=[-1, 1])
		rotate([0, 0, i*30])
		translate([-(35/2)-4, i*2, -40/2-5])
		cube([35, 24, 40.1], center=true);

	translate([-12, 0, -50/2])
	cube([2, 50, 45], center=true);

}

	
