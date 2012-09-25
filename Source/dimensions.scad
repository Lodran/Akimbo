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
// dimensions.scad
//
// Frame dimensions.
//
// Threaded rods (frame)

triangle_rod_length = 370;		// edges of the frame triangles.
frame_bottom_rod_length = 294;	// connectors for the bottom vertices.
frame_top_rod_length = 440;		// connectors for the top vertices.

// Threaded rods (z screws)

z_screw_length = 260;

// Linear rods

z_axis_linear_rod_length = 360;
x_axis_linear_rod_length = 405;
y_axis_linear_rod_length = 405;

j1 = 290;						// vertex separation along edge of triangles.
j2 = 234;						// vertex separation along bottom connectors.

vertex_width = 18;				// Size of vertex along frame horizontal rods.
vertex_depth = 30;				// Size of vertex along frame triangle rods.

motor_clearance = 43;
motor_offset = 35;

frame_horizontal_lower_rod_separation = 58.5;	// Distance between frame horizontal rods.
frame_horizontal_upper_rod_separation = 80;
frame_triangle_rod_offset = 38;		// Distance from center of vertex to frame triangle rods.
frame_triangle_angle_offset = -8;

clamp_rod_separation = 9.6;

z_rod_clamp_bolt_separation = 18;

z_linear_to_screw_separation = 30;

z_motor_clamp_bolt_separation = 14;

extruder_offset = 0; // Offset the extruder 15mm in y
x_axis_offset = 0;    // Offset the x axis 5mm in y

x_linear_rod_offset = 25; // How far to offset the X linear rods from the center of the X.

y_linear_rod_offset = [80, 0, 12]; // Relative to center of the printer (x and y) and underside of the build platform (z).

linear_clamp_radius = 7;
bearing_clamp_radius = 11;

linear_roller_bearing = 683_bearing;
linear_roller_bearing_clearance = 683_bearing_clearance;

x_axis_height = 250;

belt_offset_z = -17;
belt_width = 6;
belt_height = 1.5;
belt_tooth_height = 1.5;

release_quality = false;

$fa = 1;
$fs = (release_quality == true) ? 1 : 2;
