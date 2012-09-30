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
// akimbo_barclamp.scad
//

include <more_configuration.scad>

include <vitamin.scad>

part_name = "akimbo_barclamp";
part_count = 4;

print_orientation = false;

h_slop = .25;

bar_separation = 9.2;

clamp_size = [26, 26, 25];
clamp_center = [0, 0, clamp_size[z]/2];
bar1_center = clamp_center+[0, 0, bar_separation/2];
bar2_center = clamp_center-[0, 0, bar_separation/2];

nut_trap_depth = 5.5;
screw_head_depth = 3.25;

screw_center = [7.5, 7.5, 0];

clamp_bottom = [0, 0, 0];
clamp_top = [0, 0, clamp_size[z]];

function centerof(a, b) = [(a[x]+b[x])/2, (a[y]+b[y])/2, (a[z]+b[z])/2];

function barclamp_size() = clamp_size;

module barclamp_solid()
{
	s1 = [0, 0, nut_trap_depth];
	s2 = [0, 0, clamp_size[z]-screw_head_depth];

	difference()
	{
		translate(clamp_center)
		minkowski()
		{
			cube(clamp_size-[4, 4, 4], center=true);
			cylinder(h=4, r=2, $fn=12, center=true);
		}

		translate(bar1_center)
		rotate([90, 0, 0])
		cylinder(h=clamp_size[y]+.1, r=4, $fn=20, center=true);

		translate(bar2_center)
		rotate([0, 90, 0])
		cylinder(h=clamp_size[x]+.1, r=4, $fn=20, center=true);

		for(i=[-1, 1]) for(j=[-1, 1]) scale([i, j, 1]) translate(screw_center)
		{
			translate(centerof(s1, s2))
			cylinder(h=s2[z]-s1[z]-2*layer_height, r=2, $fn=12, center=true);

			translate(centerof([0, 0, 0], s1) - [0, 0, .05])
			cylinder(h=nut_trap_depth+.1, r=m4_nut_diameter/2, $fn=6, center=true);

			translate(centerof([0, 0, clamp_size[z]], s2) + [0, 0, .05])
			cylinder(h=screw_head_depth+.1, r=8/2, $fn=12, center=true);
		}
	}
  
  vitamin(part_name, part_count, 4, M3x20);
  vitamin(part_name, part_count, 4, M3_nylock, M3_nut);
}

module barclamp_void()
{
	compression_slop = .25;

	translate(centerof(bar2_center, clamp_top)+[0, 0, .05])
	cube([clamp_size[x]+.1, 8, clamp_top[z]-bar2_center[z]+.1], center=true);

	translate(centerof(bar1_center-[0, 0, compression_slop], clamp_top)+[0, 0, .05])
	cube([clamp_size[x]+.1, clamp_size[y]+.1, clamp_top[z]-bar1_center[z]+compression_slop+.1], center=true);
}

module barclamp_top()
{
	difference()
	{
		union()
		{
			translate(centerof(bar2_center, clamp_top)+[0, 0, .05])
			cube([clamp_size[x]+.1, 8-h_slop, clamp_top[z]-bar2_center[z]+.1], center=true);

			translate(centerof(bar1_center, clamp_top)+[0, 0, .05])
			cube([clamp_size[x]+.1, clamp_size[y]+.1, clamp_top[z]-bar1_center[z]+.1], center=true);
		}

		translate(clamp_center)
		cube([8+h_slop, 8+h_slop, bar_separation], center=true);

		translate(bar2_center)
		cube([clamp_size[x]+.1, clamp_size[y]+.1, 3], center=true);
	}
}

module barclamp(print_orientation=print_orientation)
{
	if (print_orientation == true)
	{
		difference()
		{
			barclamp_solid();
			barclamp_void();
		}

		translate([30, 0, clamp_size[z]])
		rotate([180, 0, 0])
		intersection()
		{
			barclamp_solid();
			barclamp_top();
		}
	}
	else
	{
		translate(-bar1_center)
		{
			difference()
			{
				barclamp_solid();
				barclamp_void();
			}
		
			intersection()
			{
				barclamp_solid();
				barclamp_top();
			}
		}
	}
}

barclamp();
