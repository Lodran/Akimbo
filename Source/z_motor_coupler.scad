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
// z_motor_coupler.scad
//
// Clamps the z motor coupling tube into place.
//
// Print four.
//

include <more_configuration.scad>
include <frame_computations.scad>

$fa=1;
$fs=.5;

use <teardrops.scad>
use <pill.scad>

include <vitamin.scad>

part_name = "z_motor_coupler";
part_count = 4;

z_motor_coupler_thickness = 6;
z_motor_coupler_width = 10;
z_motor_clamp_bolt_separation = 11;

*z_motor_coupler(print_orientation=true);

z_motor_coupler_plate(print_orientation=true);


module z_motor_coupler_plate(print_orientation)
{
	for(i=[-1, 1]) for(j=[-1, 1]) translate([i*13, j*(z_motor_clamp_bolt_separation+1), 0])
		z_motor_coupler(print_orientation);
}

module z_motor_coupler(print_orientation)
{
	t1=(print_orientation == true) ? 1 : 0;
	t2=(print_orientation == false) ? 1 : 0;
	
	translate(t1*[-6.5, 0, 0])
	rotate(t2*[0, 90, 0])
	translate(t2*[0, 0, .25])
	difference()
	{
		z_motor_coupler_solid();
		z_motor_coupler_void();
	}

	translate(t1*[6.5, 0, 0])
	rotate(t2*[0, -90, 0])
	translate(t2*[0, 0, .25])
	difference()
	{
		z_motor_coupler_solid();
		z_motor_coupler_void();
	}
}

module z_motor_coupler_solid()
{
	hull()
	intersection()
	{
		union()
		{
			translate([0, 0, z_motor_coupler_thickness/2])
			pill(h=z_motor_coupler_thickness, r=z_motor_coupler_width/2+.1, length=z_motor_clamp_bolt_separation, center=true);
			rotate([0, 90, 0])
			cylinder(h=z_motor_coupler_width+.1, r=9, center=true);
		}

		translate([0, 0, z_motor_clamp_bolt_separation/2])
		cube([z_motor_coupler_width, z_motor_clamp_bolt_separation+15, z_motor_clamp_bolt_separation], center=true);

		rotate([0, 90, 0])
		cylinder(h=z_motor_coupler_width+.1, r=11, center=true);
	}
}

module z_motor_coupler_void()
{
	translate([0, z_motor_clamp_bolt_separation/2, 0])
	{
		translate([0, 0, z_motor_coupler_thickness/2])
		cylinder(h=z_motor_coupler_thickness+.1, r=m3_diameter/2, $fn=12, center=true);

		translate([0, 0, 4])
		cylinder(h=z_motor_clamp_bolt_separation/2, r=m3_washer_diameter/2, center=false);
	}

	translate([0, -z_motor_clamp_bolt_separation/2, 0])
	{
		translate([0, 0, z_motor_coupler_thickness/2])
		cylinder(h=z_motor_coupler_thickness+.1, r=m3_diameter/2, $fn=12, center=true);

		translate([0, 0, 4])
		cylinder(h=z_motor_clamp_bolt_separation/2, r=m3_nut_diameter/2, $fn=6, center=false);
	}

	rotate([0, 90, 0])
	rotate([0, 0, 90])
	octylinder(h=z_motor_coupler_width+.1, r=6.25/2, $fn=16, center=true);
  
  vitamin(part_name, part_count, 1, M3x12);
  vitamin(part_name, part_count, 1, M3_washer);
  vitamin(part_name, part_count, 1, M3_nylock, M3_nut);
}
