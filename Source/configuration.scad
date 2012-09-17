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
//	configuration.scad
//
//	General configuration settings.
//
//	Because this file is intended to be somewhat interchangable with 
//		configuration.scad from prusajr's github repository, there is 
//		more configuration in "moreConfiguration.scad".
//
//  Only the metric variant is tested. Other variants are not supported, and will most likely
//    create unworkable parts.
//
//	Edit layer_height to be greater than the height of one printed layer, 
//		but less than the height of two printed layers.
//


metric = 0;	// All parts are metric - use both M3 and M4 bolts.
sae = 1;		// All parts are SAE - use only #6/32 bolts.
m3only = 2;	// All parts are metric, but use only M3 bolts.
hybrid = 3;	// Mix of metric and SAE - use M3 and 6/32 bolts.

variant = metric;

layer_height = .25;

nut_slop = .2;		// I aim for a "interference fit" for nuts - a bit of force required to place the nut.

bolt_slop = .6;	// The aim here is to just barely allow the bolt to fit through the hole, without having to thread it in.

_actual_m3_diameter = 3+bolt_slop;
_actual_m4_diameter = 4+bolt_slop;
_actual_6_32_diameter = 3.4+bolt_slop;

_actual_m3_nut_diameter = 5.5/cos(30)+nut_slop;
_actual_m4_nut_diameter = 6.87/cos(30)+nut_slop;
_actual_m5_nut_diameter = 7.85/cos(30)+nut_slop;
_actual_6_32_nut_diameter = 7.85/cos(30)+nut_slop;

_m3_diameters = [_actual_m3_diameter, _actual_6_32_diameter, _actual_m3_diameter, _actual_m3_diameter];
_m3_nut_diameters = [_actual_m3_nut_diameter, _actual_6_32_nut_diameter, _actual_m3_nut_diameter, _actual_m3_nut_diameter];

_m4_diameters = [_actual_m4_diameter, _actual_6_32_diameter, _actual_m3_diameter, _actual_6_32_diameter];
_m4_nut_diameters = [_actual_m4_nut_diameter, _actual_6_32_nut_diameter, _actual_m3_nut_diameter, _actual_6_32_nut_diameter];

m3_diameter = _m3_diameters[variant];
m3_nut_diameter = _m3_nut_diameters[variant];

m4_diameter = _m4_diameters[variant];
m4_nut_diameter = _m4_nut_diameters[variant];

m5_diameter = 5+bolt_slop;
m5_nut_diameter = _actual_m5_nut_diameter;
m5_bolt_head_height = 4;

m6_diameter = 6+bolt_slop;
m6_nut_diameter = 10/cos(30)+nut_slop;
m6_bolt_head_height = 4;

m8_diameter = 8;

m8_nut_diameter = 12.8/cos(30)+nut_slop;
m8_nut_thickness = 7.7;
m8_bolt_head_height = 6;
m8_half_nut_height = 3.85;

threaded_rod_diameter = 8.7;

actual_smooth_rod_diameter = 8;
smooth_rod_diameter = actual_smooth_rod_diameter+.25;

