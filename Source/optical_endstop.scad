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
// optical_endstop.scad
//

X=0;
Y=1;
Z=2;

function endstop_bolt_spacing() = 19;
bolt_spacing = endstop_bolt_spacing();


circuit_size = [16, 30, 1.5];
endstop_size = [6, 24, 13];
endstop_void_size = [6, 3.5, 7.5];

circuit_center = [(circuit_size[X]-endstop_size[X])/2, -(circuit_size[Y]-endstop_size[Y])/2, circuit_size[Z]/2];
endstop_center = [0, 0, endstop_size[Z]/2];
endstop_void_center = [0, 0, endstop_size[Z]-endstop_void_size[Z]/2];

module optical_endstop_solid()
{
	translate(circuit_center)
	cube(circuit_size, center=true);

	translate(endstop_center+[0, 0, -.05])
	cube(endstop_size+[0, 0, .1], center=true);
}

module optical_endstop_void()
{
	translate(endstop_void_center+[0, 0, .05])
	cube(endstop_void_size+[.1, 0, .1], center=true);
}

module optical_endstop()
{
	difference()
	{
		optical_endstop_solid();
		optical_endstop_void();
	}
}

optical_endstop();
