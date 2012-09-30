//
// RepRap Mendel Akimbo
//
// A Mendel variant which improves the frame's clearance and stability
//  by increasing its triangulation.
//
// Copyright 2012 by Ron Aldrich.
//
// Licensed under GNU GPL v2
//
// akimbo_extruder.scad
//
// Formerly, Ron's Compact Extruder, Mark 3
//

$fa=1;
$fs=.5;

include <more_configuration.scad>
include <drive_wheels.scad>

use <functions.scad>
use <teardrops.scad>
use <pill.scad>

use <extruder_fan_shroud.scad>

print=true;

i3_mount_offset=12;

drive_bearing = 115_bearing;
drive_bearing_clearance = 115_bearing_clearance;

idler_bearing_length = 624_bearing[bearing_length];
idler_bearing_radius = 624_bearing[bearing_body_diameter]/2;

motor_mount_hole_spacing = 42;
motor_rotation = 95;
motor_nut_depth = 5;

filament_radius = 1.5;
filament_compression = 0.25;

carriage_bracket_offset = 5;
carriage_bracket_height = 8;

mk7_filament_x = -(makerbot_mk7[drive_wheel_hob_radius]-filament_compression/2+filament_radius);
hyena_filament_x = -(arcol_11x5[drive_wheel_hob_radius]-filament_compression/2+filament_radius);

drive_bearing_radius = (drive_bearing[bearing_body_diameter]+drive_bearing_clearance[bearing_body_diameter])/2;
drive_bearing_length = drive_bearing[bearing_length];

drive_bearing_min = [-drive_bearing_radius, -drive_bearing_radius, 1];
drive_bearing_max = [drive_bearing_radius, drive_bearing_radius, drive_bearing_min[z]+drive_bearing_length];
drive_bearing_center = centerof(drive_bearing_min, drive_bearing_max);
drive_bearing_size = sizeof(drive_bearing_min, drive_bearing_max);

drive_wheel_min = [-makerbot_mk7[drive_wheel_radius], -makerbot_mk7[drive_wheel_radius], drive_bearing_max[z]+.5];
drive_wheel_max = [makerbot_mk7[drive_wheel_radius], makerbot_mk7[drive_wheel_radius], drive_wheel_min[z]+makerbot_mk7[drive_wheel_length]];
drive_wheel_center = centerof(drive_wheel_min, drive_wheel_max);
drive_wheel_size = sizeof(drive_wheel_min, drive_wheel_max);

drive_clearance_radius = makerbot_mk7[drive_wheel_radius]+2;
drive_clearance_min = [-drive_clearance_radius, -drive_clearance_radius, drive_bearing_max[z]];
drive_clearance_max = [drive_clearance_radius, drive_clearance_radius, drive_clearance_min[z]++makerbot_mk7[drive_wheel_length]+6];
drive_clearance_center = centerof(drive_clearance_min, drive_clearance_max);
drive_clearance_size = sizeof(drive_clearance_min, drive_clearance_max);

filament_center = drive_wheel_center+[0, (mk7_filament_x+hyena_filament_x)/2, drive_wheel_size[z]/2-makerbot_mk7[drive_wheel_hob_center]];
idler_center = filament_center+[0, -(filament_radius+idler_bearing_radius-filament_compression/2), 0];

drive_bracket_min =
	[-(35/2+carriage_bracket_offset+carriage_bracket_height),
	 idler_center[y]+4,
	 0];

drive_bracket_max = 
	[35/2,
	 drive_bracket_min[y]+17.5,
	 drive_clearance_max[z]];

drive_bracket_center = centerof(drive_bracket_min, drive_bracket_max);
drive_bracket_size = sizeof(drive_bracket_min, drive_bracket_max);

drive_bracket_fill_center = [0, 0, drive_clearance_min[z]/2];
drive_bracket_fill_radius = 11;
drive_bracket_fill_length = drive_clearance_min[z];

idler_clearance_center = [idler_center[x], idler_center[y]+2, drive_bracket_center[z]];
idler_clearance_length = drive_bracket_size[z];
idler_clearance_radius = idler_bearing_radius+1;

carriage_bracket_length = 70;
carriage_bolt_spacing = 50;

carriage_bracket_min = [drive_bracket_min[x], filament_center[y]-carriage_bracket_length/2, drive_bracket_min[z]];
carriage_bracket_max = [carriage_bracket_min[x]+carriage_bracket_height, filament_center[y]+carriage_bracket_length/2, drive_bracket_max[z]];
carriage_bracket_center = centerof(carriage_bracket_min, carriage_bracket_max);
carriage_bracket_size = sizeof(carriage_bracket_min, carriage_bracket_max);

drive_access_min = [-(drive_clearance_radius-1), 0, drive_clearance_min[z]];
drive_access_max = [(drive_clearance_radius-1), drive_bracket_max[x], drive_clearance_max[z]];
drive_access_center = centerof(drive_access_min, drive_access_max);
drive_access_size = sizeof(drive_access_min, drive_access_max);

nozzle_mount_length = 5;
nozzle_mount_radius = 16.25/2;
nozzle_mount_center = [carriage_bracket_min[x]+nozzle_mount_length/2, filament_center[y], filament_center[z]];

idler_bolt_offset = [12, 0, 4.5];

akimbo_extruder(print_orientation=print);
akimbo_extruder_idler(print_orientation=print);
akimbo_extruder_fan_shroud(print_orientation=print);

%akimbo_extruder_annotations(print_orientation=print);

echo(carriage_bracket_min);

module akimbo_extruder(print_orientation=false, mirrored=false)
{
	t1 = (print_orientation==true) ? 1 : 0;
	t2 = (print_orientation==false) ? 1 : 0;
	
	rotate(t2*[0, 0, 180])
	translate(t2*[filament_center[z], -filament_center[y], -carriage_bracket_min[x]+5])
	rotate(t2*[0, -90, 0])

	difference()
	{
		extruder_body_solid();
		extruder_body_void();
	}
}

module extruder_body_solid()
{
	translate(drive_bracket_center)
	smooth_cube(drive_bracket_size, center=true);

	translate(drive_bracket_fill_center)
	cylinder(h=drive_bracket_fill_length, r=drive_bracket_fill_radius, center=true);

	// Motor bracket

	translate([0, 0, drive_bracket_center[z]])
	rotate([0, 0, motor_rotation])
	translate([0, -(motor_mount_hole_spacing/2), 0])
	{
		cylinder(h=drive_bracket_size[z], r=5.5, center=true);
		translate([0, 11, 0])
		cube([5.5*2, 22, drive_bracket_size[z]], center=true);
	}

	// Carriage bracket

	translate(carriage_bracket_center)
	smooth_cube(carriage_bracket_size, center=true);
}

module extruder_body_void()
{
	// Drive bearing clearance

	translate(drive_bearing_center+[0, 0, .05])
	cylinder(h=drive_bearing_size[z]+.1, r=drive_bearing_size[x]/2, center=true);

	translate(drive_bearing_center)
	cylinder(h=drive_bearing_size[z]+layer_height*2, r=drive_bearing_size[x]/2-1, $fn=40, center=true);

	// Drive wheel clearance

	translate(drive_clearance_center+[0, 0, .05])
	cylinder(h=drive_clearance_size[z]+.1, r=drive_clearance_size[x]/2, center=true);

	translate(drive_clearance_center+[0, 0, .05])
	cylinder(h=drive_clearance_size[z]+layer_height*2, r=drive_bearing_size[x]/2+1, center=true);

	translate(drive_access_center+[0, 0, .05])
	cube(drive_access_size+[0, 0, .1], center=true);

	// Idler clearance

	translate(idler_clearance_center)
	cylinder(h=idler_clearance_length+.1, r=idler_clearance_radius, center=true);

	// Filament channel

	translate(filament_center+[25, 0, 0])
	rotate([0, 90, 0])
	hexypill(length=1, h=50, r=filament_radius+.5, $fn=12, center=true);

	for(i=[-1, 1])
		translate(nozzle_mount_center)
		rotate([0, 90, 0])
		rotate([i, 0, 0])
		rotate([0, 0, 90])
		hexylinder(h=25, r=filament_radius+.5, $fn=12, center=false);

	// Nozzle mount

	translate(nozzle_mount_center+[0, 0, -.05])
	rotate([0, 90, 0])
	rotate([0, 0, 90])
	hexylinder(h=nozzle_mount_length+.1, r=nozzle_mount_radius, center=true);

	// Motor mounting holes

	z1 = drive_bracket_min[z];
	z2 = z1+5;
	z3 = z2;
	z4 = drive_bracket_max[z];

	render(convexity=4)
	for (i=[0, 1])
	{
		rotate([0, 0, motor_rotation+i*180+90])
		translate([-(motor_mount_hole_spacing/2), 0, 0])
		rotate([0, 0, -motor_rotation+90])
		{
			translate([0, 0, (z1+z2)/2-layer_height])
			cylinder(h=z2-z1, r=m3_nut_diameter/2, $fn=6, center=true);

			translate([0, 0, (z3+z4)/2+.05])
			rotate([0, 0, 90])
			cylinder(h=z4-z3+.1, r=m3_diameter/2, $fn=12, center=true);
		}
	}

	// Idler mounting holes.

	render(convexity=4)
	for (i=[-1, 1]) for(j=[-1, 1])
	{
		translate([filament_center[x]+idler_bolt_offset[x]*i, drive_bracket_center[y], filament_center[z]+idler_bolt_offset[z]*j])
		rotate([90,  0, 0])
		hexylinder(h=drive_bracket_size[y]+.1, r=2, $fn=12, center=true);

		translate([filament_center[x]+idler_bolt_offset[x]*i, drive_bracket_max[y]-4, filament_center[z]+idler_bolt_offset[z]*j])
		rotate([-90, 0, 0])
		cylinder(h=m3_nut_thickness+5, r=m3_nut_diameter/2, $fn=6, center=false);
	}

	// Carriage mounting holes.

	render(convexity=4)
	for (i=[-1, 1])
	{
		translate([carriage_bracket_center[x], nozzle_mount_center[y]+i*25, nozzle_mount_center[z]])
		rotate([0, 90, 0])
		rotate([0, 0, 90])
		hexylinder(h=carriage_bracket_height+.1, r=m3_diameter/2, $fn=12, center=true);
	}

	// Prusa i3 Carriage mounting holes.

	for(i=[-1, 1])
	{
		translate(carriage_bracket_center+[0, i*i3_mount_offset, 0])
		{
			difference()
			{
				union()
				{
					cylinder(h=carriage_bracket_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);

					translate([0, 0, -carriage_bracket_size[z]/2+5])
					{
						cylinder(h=m3_nut_thickness, r=m3_nut_diameter/2, $fn=6, center=true);
						translate([-5, 0, 0])
						cube([10, m3_nut_diameter*cos(30), m3_nut_thickness], center=true);
					}

					translate([0, 0, carriage_bracket_size[z]/2-2+.05])
					rotate([0, 0, 90])
					cylinder(h=4+.1, r=m3_nut_diameter/2, $fn=6, center=true);
				}

				translate([0, 0, -carriage_bracket_size[z]/2+5+(m3_nut_thickness+layer_height)/2])
				cylinder(h=layer_height, r=m3_diameter/2+.1, $fn=12, center=true);
			}
		}

	}

}

idler_bracket_size = [19, 33, 12];
idler_bracket_center = [0, 0, idler_bracket_size[z]/2];
idler_bracket_min = minof(idler_bracket_center, idler_bracket_size);
idler_bracket_max = maxof(idler_bracket_center, idler_bracket_size);

idler_wheel_center = [0, 0, 10];

echo (idler_center);

module akimbo_extruder_idler(print_orientation=false, mirrored=false)
{
	t1 = (print_orientation==true) ? 1 : 0;
	t2 = (print_orientation==false) ? 1 : 0;

	translate(t1*[-2, -23, 0])
	rotate(t1*[0, 0, 90])

	rotate(t2*[0, 0, 180])
	translate(t2*[filament_center[z], -filament_center[y], -carriage_bracket_min[x]+5])
	rotate(t2*[0, -90, 0])
	translate(t2*idler_center)
	rotate(t2*[-90, 0, 0])
	rotate(t2*[0, 0, 90])
	translate(t2*-idler_wheel_center)

	difference()
	{
		idler_bracket_solid();
		idler_bracket_void();
	}
}


module idler_bracket_solid()
{
	translate(idler_bracket_center)
	smooth_cube(idler_bracket_size, center=true, smooth_axis=z);

	translate(idler_wheel_center)
	rotate([0, 90, 0])
	cylinder(h=idler_bracket_size[x], r=idler_bearing_radius, center=true);

}

module idler_bracket_void()
{
	bearing_void_length = idler_bearing_length+2;

	translate(idler_wheel_center)
	rotate([0, 90, 0])
	rotate([0, 0, 90])
	hexylinder(h=idler_bracket_size[x]+.1, r=2, $fn=20, center=true);

	translate([idler_bracket_min[x]+m4_bolt_head_height/2, idler_wheel_center[y], idler_wheel_center[z]])
	rotate([0, 90, 0])
	rotate([0, 0, 90])
	hexylinder(h=m4_bolt_head_height+.1, r=m4_bolt_head_diameter/2, center=true);

	translate([idler_bracket_max[x]-m4_bolt_head_height/2, idler_wheel_center[y], idler_wheel_center[z]])
	rotate([0, 90, 0])
	rotate([0, 0, 90])
	cylinder(h=m4_bolt_head_height+.1, r=m4_nut_diameter/2, $fn=6, center=true);

	difference()
	{
		translate(idler_wheel_center)
		rotate([0, 90, 0])
		cylinder(h=bearing_void_length, r=idler_bearing_radius+1, center=true);

		translate(idler_wheel_center)
		for(i=[-1, 1])
			translate([i*(idler_bearing_length/2+1), 0, 0]) scale([i, 1, 1])
			rotate([0, 90, 0])
			cylinder(h=2, r1=idler_bearing_radius-2, r2=idler_bearing_radius-1, center=true);
	}

	for (i=[-1, 1]) for (j=[-1, 1])
		translate(idler_bracket_center+[idler_bolt_offset[z]*i, idler_bolt_offset[x]*j, 0])
		cylinder(h=idler_bracket_size[z]+.1, r=2, $fn=12, center=true);
}



module akimbo_extruder_annotations(print_orientation)
{
	t1 = (print_orientation==true) ? 1 : 0;
	t2 = (print_orientation==false) ? 1 : 0;

	rotate(t2*[0, 0, 180])
	translate(t2*[filament_center[z], -filament_center[y], -carriage_bracket_min[x]+5])
	rotate(t2*[0, -90, 0])
	{
		translate(filament_center)
		rotate([0, 90, 0])
		cylinder(h=100, r=filament_radius, center=true);

		translate(drive_wheel_center)
		rotate([180, 0, 0])
		drive_wheel(makerbot_mk7);

		translate(idler_center)
		cylinder(h=idler_bearing_length, r=idler_bearing_radius, center=true);

		rotate([180, 0, 0])
		translate([0, 0, -drive_bracket_size[z]])
		rotate([0, 0, 90-motor_rotation])
		{
			minebea_motor();
		}
	}
}

module akimbo_extruder_fan_shroud(print_orientation)
{
	t1 = (print_orientation==true) ? 1 : 0;
	t2 = (print_orientation==false) ? 1 : 0;

	translate(t1*[0, 35, 0])
	rotate(t2*[0, 0, 180])
	translate(t2*[filament_center[z], -filament_center[y], -carriage_bracket_min[x]+5])
	rotate(t2*[0, -90, 0])
	{
		rotate(t2*[180, 0, 0])
		translate(t2*[0, 0, -drive_bracket_size[z]])
		rotate(t2*[0, 0, 90-motor_rotation])
		{
			extruder_fan_shroud(print_orientation);
		}
	}
}


module drive_wheel(drive_bolt_spec)
{
	translate([0, 0, -drive_bolt_spec[drive_wheel_length]/2])
	difference()
	{
		translate([0, 0, drive_bolt_spec[drive_wheel_length]/2])
		cylinder(h=drive_bolt_spec[drive_wheel_length],
		         r=drive_bolt_spec[drive_wheel_radius],
		         $fn=30,
		         center=true);

		translate([0, 0, drive_bolt_spec[drive_wheel_hob_center]])
		rotate_extrude(convexity=4, $fn=30)
			translate([drive_bolt_spec[drive_wheel_radius]+1, 0])
			circle(r=drive_bolt_spec[drive_wheel_radius]-drive_bolt_spec[drive_wheel_hob_radius]+1, $fn=12);
	}
}

module minebea_motor(clearance=0)
{
	mount_thickness = 5;
	motor_length = 45;
	motor_radius = 35/2;
	
	render(convexity=4)
	difference()
	{
		union()
		{
			translate([0, 0, -motor_length/2])
			cylinder(h=motor_length, r=motor_radius+clearance, center=true);

			translate([0, 0, 4.75/2])
			cylinder(h=4.75, r=5+clearance, center=true);
	
			translate([0, 0, 18/2])
			cylinder(h=18, r=5/2, $fn=20, center=true);

			translate([0, 0, -(mount_thickness+clearance)/2])
			for(i=[-1, 1])
				scale([i, 1, 1])
				translate([motor_mount_hole_spacing/2, 0, 0])
				{
					cylinder(h=mount_thickness+clearance, r=3.65+clearance, center=true);

					translate([-5, 0, 0])
					cube([10, (3.65+clearance)*2, mount_thickness+clearance], center=true);

					rotate([0, 0, -41.22])
					translate([-8, 0, 0])
					cube([16, (3.65+clearance)*2, mount_thickness+clearance], center=true);
				}
        rotate([0, 0, -120])
        translate([35/2, 0, -35])
        cube([10, 18, 15], center=true);
		}

		*union()
		{
			translate([0, 0, -mount_thickness/2])
			for(i=[-1, 1])
				scale([i, 1, 1])
				translate([motor_mount_hole_spacing/2, 0, 0])
				{
					cylinder(h=mount_thickness+.1, r=3.5/2, $fn=12, center=true);
				}
		}
	}
}

smoothing_radius = 3;

module smooth_cube(size, radius=smoothing_radius, smooth_axis=z)
{
	assign(diameter=radius*2)
	{
		minkowski()
		{
			cube(size-[diameter, diameter, diameter], center=true);
			rotate([(smooth_axis == y) ? 90 : 0, (smooth_axis == x) ? 90 : 0, 0])
			cylinder(h=diameter, r=radius, center=true);
		}
	}
}
