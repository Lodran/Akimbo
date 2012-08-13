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
// moreConfiguration.scad
//
//	General configuration settings that didn't exist in prusajr's configuration.scad
//
//	These settings are here, rather than in configuration.scad, in
//		order to keep configuration.scad interchangable with prusajr.s version.
//
// Edit extrusion_width to be greater than the width of one shell, but less than the width of two shells.

include <configuration.scad>

extrusion_width = .6;

vertical_slop = .6;
horizontal_slop = .3;

_actual_m3_nut_thickness = 2.5;
_actual_m4_nut_thickness = 3.5;
_actual_6_32_nut_thickness = 3.25;

_m3_nut_thickness = [_actual_m3_nut_thickness, _actual_6_32_nut_thickness, _actual_m3_nut_thickness, _actual_m3_nut_thickness];

_m4_nut_thickness = [_actual_m4_nut_thickness, _actual_6_32_nut_thickness, _actual_m3_nut_thickness, _actual_6_32_nut_thickness];

m3_nut_thickness = _m3_nut_thickness[variant];
m3_washer_diameter = 7.5;

m4_nut_thickness = _m4_nut_thickness[variant];

m3_bolt_head_height = 3;
m3_bolt_head_diameter = 6+horizontal_slop;

m4_bolt_head_height = 4;
m4_bolt_head_diameter = 7+horizontal_slop;

// Don't edit things after here.

x = 0;
y = 1;
z = 2;

bearing_length = 0;
bearing_body_diameter = 1;
bearing_flange_diameter = 2;
bearing_flange_width = 3;
bearing_rod_diameter = 4;

624_bearing = [5, 13, 13, 0, 4];
624_bearing_clearance = [0.4, 0.4, 0.4, 0, 2];

608_bearing = [7, 22, 22, 0, 8];
608_bearing_clearance = [0.4, 0.4, 0.4, 0, 2];

115_bearing = [4, 11, 11, 0, 5];
115_bearing_clearance = [0.4, 0.4, 0.4, 0, 3];

106_bearing = [3, 10, 10, 0, 6];
106_bearing_clearance = [0.4, 0.4, 0.4, 0, 0];

126_bearing = [4, 12, 12, 0, 6];
126_bearing_clearance = [0.4, 0.4, 0.4, 0, 3];

128_bearing = [3.5, 12, 12, 0, 8];
128_bearing_clearance = [0.4, 0.4, 0.4, 4];

lm8uu = [24, 15, 15, 0, 8];
lm8uu_clearance = [0.7, 0.7, 0.7, 0, 0];

igus = [10, 10, 15, 1, 8];
igus_clearance = [0.4, 0.4, 0.4, 0.4, 0];

part_color_1 = [1, .9, 0];
part_color_2 = [.9, 1, 0];

wood_color_1 = [111/256, 78/256, 55/256];
wood_color_2 = wood_color_1+[.2, .2, .2];
wood_color_3 = wood_color_1-[.2, .2, .2];

nema17_hole_spacing = 1.25*25.4;

ramps_size = [102, 60];

ramps_mounts = [[-35.76, -20.86],
                [-35.76, 27.4],
                [39.17, 27.4],
                [45.52, -20.86]];

//echo(ramps_mounts);
