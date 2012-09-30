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
// z_linear_rod_clamp.scad
//
// Clamps the z linear rods into place.
//
// Print four.
//

include <more_configuration.scad>
include <frame_computations.scad>

use <teardrops.scad>
use <pill.scad>

include <vitamin.scad>

part_name = "z_linear_rod_clamp";
part_count = 4;

z_linear_clamp_thickness = 8;
z_linear_clamp_width = 15;

z_linear_clamp();


module z_linear_clamp()
{
	difference()
	{
		z_linear_clamp_solid();
		z_linear_clamp_void();
	}
}

module z_linear_clamp_solid()
{
	intersection()
	{
		union()
		{
			translate([0, 0, z_linear_clamp_thickness/2])
			pill(h=z_linear_clamp_thickness, r=z_linear_clamp_width/2+.1, length=z_rod_clamp_bolt_separation, center=true);
			rotate([0, 90, 0])
			scale([1.2, 1, 1])
			cylinder(h=z_linear_clamp_width+.1, r=10, center=true);
		}

		translate([0, 0, z_rod_clamp_bolt_separation/2])
		cube([z_linear_clamp_width, z_rod_clamp_bolt_separation+15, z_rod_clamp_bolt_separation], center=true);
	}
}

module z_linear_clamp_void()
{
	for(i=[-1, 1]) translate([0, i*z_rod_clamp_bolt_separation/2, 0])
	{
		translate([0, 0, z_linear_clamp_thickness/2])
		cylinder(h=z_linear_clamp_thickness+.1, r=m3_diameter/2, $fn=12, center=true);

		translate([0, 0, z_linear_clamp_thickness])
		cylinder(h=z_rod_clamp_bolt_separation/2, r=m3_washer_diameter/2, center=false);
	}

	rotate([0, 90, 0])
	rotate([0, 0, 90])
	octylinder(h=z_linear_clamp_width+.1, r=smooth_rod_diameter/2, center=true);
  
  vitamin(part_name, part_count, 2, M3x20);
  vitamin(part_name, part_count, 2, M3_washer);
}
