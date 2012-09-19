//
// RepRap Mendel Akimbo
//
// A Mendel variant which improves the frame's clearance and stability
//  by increasing it's triangulation.
//
// Copyright 2012 by Ron Aldrich.
//
// Licensed under GNU GPL v2
//
// akimbo_extruder.scad
//

include <more_configuration.scad>
include <functions.scad>
include <drive_wheels.scad>
use <teardrops.scad>
use <extruder_fan_shroud.scad>

print_orientation = true;
mirrored = false;

use <barbell.scad>

x_linear_rail_separation = 50;

drive_wheel = makerbot_mk7;

drive_bearing = 115_bearing;
drive_bearing_clearance = 115_bearing_clearance;

idler_bearing_length = 624_bearing[bearing_length];
idler_bearing_radius = 624_bearing[bearing_body_diameter]/2;

idler_bearing_length = 683_bearing[bearing_length];
idler_bearing_radius = 683_bearing[bearing_body_diameter]/2;

bushing_clamp_radius = 11;
bushing_radius = 8;
carriage_length = 40;

filament_radius = 1.5;
filament_compression = 0.75;

filament_offset = [(drive_wheel[drive_wheel_hob_radius]-filament_compression/2+filament_radius),
-(drive_wheel[drive_wheel_length]/2-drive_wheel[drive_wheel_hob_center]),
0];
filament_center = filament_offset;

drive_wheel_center = [0, 0, 0];
motor_center = drive_wheel_center-[0, 5+(drive_wheel[drive_wheel_length]+1)/2, 0];

idler_center = filament_center+[(filament_radius+idler_bearing_radius-filament_compression/2), 0, 0];

idler_mount_radius = idler_bearing_radius+0.75;
idler_clamp_clearance = 1.5;

motor_mount_hole_spacing = 42;
motor_bolt_offset = motor_mount_hole_spacing/2;		// offset from center of motor to bolt hole.

motor_angle = -40;

drive_bearing_min_y = drive_wheel_center[y]+(drive_wheel[drive_wheel_length]+1)/2;
drive_bearing_max_y = drive_bearing_min_y+drive_bearing[bearing_length];

drive_bearing_center = [motor_center[x], (drive_bearing_min_y+drive_bearing_max_y)/2, motor_center[z]];

drive_bracket_min_y = motor_center[y];
drive_bracket_max_y = motor_center[y]+22;

drive_bracket_size_y = drive_bracket_max_y-drive_bracket_min_y;

drive_bracket_center = motor_center+[0, drive_bracket_size_y/2, 0];

motor_brace_size_y = 5;
motor_brace_center = motor_center+[0, motor_brace_size_y/2, 0];

idler_hinge_offset = rotate_vec([motor_bolt_offset, 0], motor_angle);

motor_mount_radius = 6;
idler_hinge_radius = 5;

idler_bolt_offset = [-12, 4, 0];
idler_bolt_length = 40;
idler_bolt_angle = motor_angle;

idler_hinge_center = drive_bracket_center+[idler_hinge_offset[x], 0, idler_hinge_offset[y]];
motor_mount_center = drive_bracket_center+[-idler_hinge_offset[x], 0, -idler_hinge_offset[y]];

drive_bracket_size = [(idler_hinge_offset[x]+motor_mount_radius)*2, drive_bracket_size_y, (-idler_hinge_offset[y]+motor_mount_radius)*2];
drive_bracket_min = minof(drive_bracket_center, drive_bracket_size);
drive_bracket_max = maxof(drive_bracket_center, drive_bracket_size);

drive_wheel_clearance_radius = drive_wheel[drive_wheel_radius]+2;

drive_wheel_clearance_min_y = 5;
drive_wheel_clearance_max_y = drive_wheel_clearance_min_y+drive_wheel[drive_wheel_length]+1;

drive_wheel_clearance_size_y = drive_wheel_clearance_max_y-drive_wheel_clearance_min_y;
drive_wheel_clearance_center = motor_center+[0, (drive_wheel_clearance_min_y+drive_wheel_clearance_max_y)/2, 0];

drive_bearing_brace_size_y = motor_brace_size_y;
drive_bearing_brace_center = motor_center+[0, drive_bracket_size_y-drive_bearing_brace_size_y/2, 0];

carriage_bracket_length = 70;
carriage_bracket_thickness = 7;


carriage_bracket_max = [filament_center[x]+carriage_bracket_length/2, drive_bracket_max[y], drive_bracket_min[z]+1];
//carriage_bracket_max = [drive_bracket_max[x], filament_center[y]+carriage_bracket_length/2, drive_bracket_min[z]+1];
carriage_bracket_min = [filament_center[x]-carriage_bracket_length/2, drive_bracket_min[y], carriage_bracket_max[z]-carriage_bracket_thickness];

//carriage_bracket_min = [filament_center[x]-(carriage_bracket_max[x]-filament_center[x]), carriage_bracket_max[y]-carriage_bracket_length, carriage_bracket_max[z]-carriage_bracket_thickness];

carriage_bracket_center = centerof(carriage_bracket_min, carriage_bracket_max);
carriage_bracket_size = sizeof(carriage_bracket_min, carriage_bracket_max);

idler_void_min = [idler_center[x]-4, idler_hinge_center[z], 0];
idler_void_max = [drive_bracket_max[x], idler_center[z], 0];
idler_void_center = centerof(idler_void_min, idler_void_max);
idler_void_size = sizeof(idler_void_min, idler_void_max);

idler_void_2_min = [idler_hinge_center[x], idler_hinge_center[z]-motor_mount_radius, 0];
idler_void_2_max = idler_void_max;
idler_void_2_center = centerof(idler_void_2_min, idler_void_2_max);
idler_void_2_size = sizeof(idler_void_2_min, idler_void_2_max);


nozzle_length = 5;
nozzle_radius = 16.25/2;
nozzle_center = [filament_center[x], filament_center[y], carriage_bracket_min[z]+nozzle_length/2];

akimbo_extruder(print_orientation=print_orientation, mirrored=mirrored);

akimbo_extruder_idler(print_orientation=print_orientation, mirrored=mirrored);

%akimbo_extruder_annotations(print_orientation=print_orientation, mirrored=mirrored);

%translate([0, 0, .5])
cube([100, 100, 1], center=true);

module akimbo_extruder(print_orientation=true, mirrored=false)
{
	t1=(print_orientation==true) ? 1 : 0;
	t2=(print_orientation==false) ? 1 : 0;

	scale(mirrored ? [-1, 1, 1] : [1, 1, 1])
	rotate([0, 0, 90])
	translate(t1*[0, 0, -carriage_bracket_min[z]])
	translate(t2*[-filament_center[x], -filament_center[y], -carriage_bracket_min[z]])
	{
	difference()
	{
		drive_bracket_solid();

		drive_bracket_void();
	}
	}
}

module akimbo_extruder_annotations(print_orientation=true, mirrored=false)
{
	t1=(print_orientation==true) ? 1 : 0;
	t2=(print_orientation==false) ? 1 : 0;

	color([.75, .75, .75])
	scale(mirrored ? [-1, 1, 1] : [1, 1, 1])
	rotate([0, 0, 90])
	translate(t1*[0, 0, -carriage_bracket_min[z]])
	translate(t2*[-filament_center[x], -filament_center[y], -carriage_bracket_min[z]])
  {
    translate(drive_wheel_center)
    rotate([-90, 0, 0])
    drive_wheel();

    translate(drive_bearing_center)
    rotate([90, 0, 0])
    cylinder(h=drive_bearing_max_y-drive_bearing_min_y, r=5, center=true);

    translate(motor_center)
    rotate([-90, 0, 0])
    rotate([0, 0, -motor_angle+180])
	{
    		minebea_motor();
	}

    translate(motor_center)
    rotate([-90, 0, 0])
	rotate([0, 0, -90])
	rotate([0, 0, -motor_angle])
	extruder_fan_shroud();
  }
}

module drive_bracket_profile(clearance=0)
{
	p1 = [-9+carriage_bracket_size[z], carriage_bracket_max[z]];

	rx=carriage_bracket_size[z];
	ry=-carriage_bracket_max[z]-drive_wheel_clearance_radius;

	difference()
	{
		union()
		{
			barbell(idler_hinge_offset, [0, 0], motor_mount_radius+clearance, drive_wheel_clearance_radius+2+clearance, 30-clearance, 30-clearance);
			barbell(-idler_hinge_offset, [0, 0], motor_mount_radius+clearance, drive_wheel_clearance_radius+2+clearance, 30-clearance, 30-clearance);

			barbell(p1, -idler_hinge_offset, rx+clearance, motor_mount_radius+clearance, 36-clearance, 36-clearance);


			polygon([idler_hinge_offset+[0, -motor_mount_radius], -idler_hinge_offset, p1]);
		}

		translate([idler_center[x], idler_center[z]])
		if (clearance != 0)
			circle(idler_mount_radius+.2);
		else
			circle(idler_mount_radius+1.02, center=true);
	}		
}

module drive_bracket_solid()
{
	p1 = [carriage_bracket_min[x]+carriage_bracket_size[z], carriage_bracket_max[z]];

	rx=carriage_bracket_size[z];
	ry=-carriage_bracket_max[z]-drive_wheel_clearance_radius;

	translate(drive_bracket_center)
	{
		rotate([90, 0, 0])
		linear_extrude(height=drive_bracket_size_y, center=true, convexity=4)
		drive_bracket_profile();
	}

	idler_hinge_length = 13;

	difference()
	{
		translate(carriage_bracket_center)
		smooth_cube(carriage_bracket_size, center=true);

		translate(motor_center)
		rotate([-90, 0, 0])
		rotate([0, 0, -motor_angle])
		minebea_motor(clearance=1);

		translate(idler_hinge_center+[0, -5/2, 0])
		rotate([90, 0, 0])
		cylinder(h=idler_hinge_length+5, r=idler_hinge_radius+1, center=true);
	}
}


module drive_bracket_void()
{
	translate(nozzle_center+[0, 0, -.05])
	rotate([0, 0, 180])
	cylinder(h=nozzle_length+.1, r=nozzle_radius, center=true);

	hull()
	{
		translate([nozzle_center[x], nozzle_center[y], nozzle_center[z]+nozzle_length/2+.5+layer_height])
		cylinder(h=1, r=filament_radius+.5, $fn=12, center=true);

		for(i=[-1, 1])
			translate(filament_center+[i*.5, 0, 0])
			cylinder(h=1, r=filament_radius+.5, $fn=12, center=true);
	}

	translate(motor_center+[0, 5/2, 0])
	rotate([90, 0, 0])
	octylinder(h=5.1, r=10.5/2, center=true); 
	
	translate(drive_wheel_clearance_center)
	{
		rotate([90, 0, 0])
		linear_extrude(height=drive_wheel_clearance_size_y, center=true, convexity=4)
		{
				circle(drive_wheel_clearance_radius);
				
				rotate(45)
				translate([10, 0])
				square([20, drive_wheel_clearance_radius*2], center=true);

				translate([-10, 0])
				square([20, drive_wheel_clearance_radius*2-2], center=true);

		}
	}

	translate(drive_bracket_center+[0, (3/2), 0])
	{
		rotate([90, 0, 0])
		linear_extrude(height=drive_bracket_size_y-7, center=true, convexity=4)
		{
				translate(idler_void_center)
				square([idler_void_size[x], idler_void_size[y]], center=true);

				translate([idler_hinge_center[x], idler_hinge_center[z]])
				circle(idler_hinge_radius+1.1);
		}
	}

	translate(motor_mount_center)
	rotate([90, 0, 0])
	octylinder(h=drive_bracket_size[y]+.1, r=m3_diameter/2, $fn=16, center=true);

	translate([motor_mount_center[x], drive_bracket_max[y]-4/2+.05, motor_mount_center[z]])
	rotate([90, 0, 0])
	cylinder(h=4+.1, r=m3_nut_diameter/2, $fn=6, center=true);

	translate(idler_hinge_center)
	rotate([90, 0, 0])
	octylinder(h=drive_bracket_size[y]+.1, r=m3_diameter/2, $fn=12, center=true);

	translate([idler_hinge_center[x], motor_center[y]+5-m3_nut_thickness/2+.05, idler_hinge_center[z]])
	rotate([90, 0, 0])
	cylinder(h=m3_nut_thickness+.1, r=m3_nut_diameter/2, $fn=6, center=true);

	/*
	for(i=[0, 1])
		translate(drive_bracket_center)
		rotate([0, -motor_angle+i*180, 0])
		translate([motor_bolt_offset, 0, 0])
		rotate([90, 0, 0])
		rotate([0, 0, (-motor_angle+i*180)])
		{
			octylinder(h=drive_bracket_size[y]+.1, r=m3_diameter/2, $fn=12, center=true);

			translate([0, 0, -(drive_bracket_size[y]-3)/2-.05])
			cylinder(h=3+.1, r=m3_nut_diameter/2, $fn=6, center=true);
		}
	*/

	translate(drive_bearing_center)
	rotate([90, 0, 0])
	octylinder(h=drive_bearing[bearing_length], r=(drive_bearing[bearing_body_diameter]+drive_bearing_clearance[bearing_body_diameter])/2, center=true);

	difference()
	{
		translate([drive_bracket_center[x], idler_center[y], drive_bracket_center[z]])
		rotate([0, -idler_bolt_angle, 0])
		for(i=[-1, 1])
			scale([1, i, 1])
			translate(idler_bolt_offset)
			{
        rotate([0, 0, 90])
				octylinder(h=10, r=(m3_diameter)/2, $fn=12, center=false);
        
				translate([0, 0, -3])
				cylinder(h=14, r=m3_nut_diameter/2, $fn=6, center=true);
			}

		translate(drive_bracket_center+[-5, 0, drive_wheel_clearance_radius-1 + layer_height/2])
		cube([20, 20, layer_height], center=true);
	}

	translate([nozzle_center[x], nozzle_center[y], carriage_bracket_center[z]])
	for(i=[-1, 1])
		translate([i*25, 0, 0])
		cylinder(h=carriage_bracket_size[z]+.1, r=m3_diameter/2, $fn=12, center=true);

	*translate([nozzle_center[x], nozzle_center[y], carriage_bracket_max[z]-2+.05])
	for(i=[-1, 1])
		translate([i*25, 0, 0])
		cylinder(h=4+.1, r=m3_nut_diameter/2, $fn=6, center=true);

}

idler_bracket_size_y = 17;

idler_clamp_angle = 43;

idler_bearing_fudge_factor = 0.25;	// Allows for adjustment of the idler bearing without modification to the extruder.

module akimbo_extruder_idler(print_orientation=true)
{
	t1=(print_orientation == true) ? 1 : 0;
	t2=(print_orientation == false) ? 1 : 0;

	display_angle = 30;

	scale(mirrored ? [-1, 1, 1] : [1, 1, 1])
	rotate(t2*[0, 0, 90])
	translate(t2*[-filament_center[x], -filament_center[y], -carriage_bracket_min[z]])
	translate(t2*idler_hinge_center)
	rotate(t2*[0, display_angle, 0])
	translate(t2*-idler_hinge_center)
	translate(t1*[-20, -20, idler_mount_radius])
	rotate(t1*[0, 0, 90])
	translate(t1*idler_center)
	rotate(t1*[0, idler_clamp_angle+90, 0])
	translate(t1*-idler_center)
	difference()
	{
		idler_bracket_solid();
		idler_bracket_void();
	}
}

module idler_bracket_profile()
{
	p1 = [idler_hinge_center[x], idler_hinge_center[z]];
	r1 = idler_hinge_radius;

	p2 = [idler_center[x], idler_center[z]];
	r2 = idler_mount_radius;

	r3 = 3.5;
	p3 = p2+rotate_vec([r2-r3, 0], idler_clamp_angle);

	l4 = 25;
	r4 = r3;
	p4 = p3+rotate_vec([0, l4], idler_clamp_angle);

	intersection()
	{
		union()
		{
			barbell(p1, p2, r1, r2, 15, 15);
			barbell(p2, p4, r2, r4, 17, 100);

			translate([(p3[x]+p4[x])/2, (p3[y]+p4[y])/2])
			rotate(idler_clamp_angle)
			translate([r3/2, 0])
			square([r3, l4], center=true);

			translate(p2)
			rotate(idler_clamp_angle-90)
			octircle(r2);

			*translate(p4)
			rotate(idler_clamp_angle-90)
			octircle(r4);
		}

		translate(p2)
		rotate(idler_clamp_angle)
		translate([-12+r2, 8])
		square([24, 55], center=true);
	}
}


module idler_bracket_solid()
{
	p1 = idler_hinge_center;
	p2 = motor_mount_center+[idler_hinge_radius*2, 0, 0];
	p3 = idler_center;

	s1 = sizeof(p1, p2);
	l1 = sqrt(s1[x]*s1[x]+s1[z]*s1[z]);

	r1 = p1[x]-p2[x]+idler_hinge_radius;
	r2 = p2[z]-p1[z]+idler_hinge_radius;

	translate([drive_bracket_center[x], idler_center[y], drive_bracket_center[z]])
	rotate([90, 0, 0])
	linear_extrude(height=idler_bracket_size_y, convexity=4, center=true)
	{
		idler_bracket_profile();
	}

	translate([drive_bracket_center[x], idler_center[y], drive_bracket_center[z]])
	rotate([0, -idler_bolt_angle, 0])
	for(i=[-1, 1])
		scale([1, i, 1])
		translate(idler_bolt_offset)
		{
			*hull()
			{
				translate([0, 0, 13-4])
				cylinder(h=4, r=m3_washer_diameter/2-.1, center=false);

				translate([-1, 0, 13-4])
				cylinder(h=4, r=m3_washer_diameter/2-.1, center=false);
			}
		}


}

module idler_bracket_void()
{
	translate(motor_brace_center)
	{
		rotate([90, 0, 0])
		linear_extrude(height=motor_brace_size_y+1, center=true, convexity=4)
		drive_bracket_profile(clearance=idler_clamp_clearance);
	}

	translate([0, drive_bracket_max[y]-2.5/2, 0])
	{
		rotate([90, 0, 0])
		linear_extrude(height=2.5, center=true, convexity=4)
		drive_bracket_profile(clearance=idler_clamp_clearance);
	}

	translate([0, drive_bearing_min_y+2, 0])
	{
		rotate([90, 0, 0])
		linear_extrude(height=5, center=true, convexity=4)
			difference()
			{
				drive_bracket_profile(clearance=idler_clamp_clearance);
				
				*rotate(45)
				translate([10, 0])
				square([20, drive_wheel_clearance_radius*2], center=true);

				translate(idler_void_center)
				square([idler_void_size[x], idler_void_size[y]], center=true);

				translate(idler_void_2_center)
				square([idler_void_2_size[x]-2, idler_void_2_size[y]], center=true);

				translate([idler_hinge_center[x], idler_hinge_center[z]])
				circle(idler_hinge_radius+1);
			}
	}

	translate(idler_hinge_center)
	rotate([90, 0, 0])
	rotate([0, 0, idler_clamp_angle+90])
	octylinder(h=drive_bracket_size[y]+.1, r=m3_diameter/2, $fn=12, center=true);

	translate([idler_center[x]-idler_bearing_fudge_factor, drive_bracket_center[y], idler_center[z]])
	rotate([90, 0, 0])
	rotate([0, 0, idler_clamp_angle+90])
		octylinder(h=drive_bracket_size[y]+.1, r=m3_diameter/2, $fn=12, center=true);

	translate(idler_center+[-idler_bearing_fudge_factor, 0, 0])
	rotate([90, 0, 0])
	{
		difference()
		{
			rotate([0, 0, idler_clamp_angle/2])
			//octylinder(h=idler_bearing_length+1, r=idler_mount_radius+.5, center=true);
			cube([idler_mount_radius*2+2, idler_mount_radius*2+1, idler_bearing_length+1], center=true);
      
			for(i=[-1, 1])
				scale([1, 1, i])
				translate([0, 0, idler_bearing_length/2])
				cylinder(h=1.1, r1=2.5, r2=3.5+.1, center=false);
		}

		translate([0, 0, -((idler_bracket_size_y-3)/2+.05)])
		cylinder(h=3+.1, r=m3_bolt_head_diameter/2, center=true);

		translate([0, 0, ((idler_bracket_size_y-3)/2+.05)])
		rotate([0, 0, idler_clamp_angle+90])
		cylinder(h=3+.1, r=m3_nut_diameter/2, $fn=6, center=true);
	}


	translate([drive_bracket_center[x], idler_center[y], drive_bracket_center[z]])
	rotate([0, -idler_bolt_angle, 0])
	for(i=[-1, 1])
		scale([1, i, 1])
		translate(idler_bolt_offset)
		{
			hull()
			{
				translate([1, 0, 0])
				cylinder(h=idler_bolt_length, r=(m3_diameter+.5)/2, $fn=12, center=true);

				translate([-1, 0, 0])
				cylinder(h=idler_bolt_length, r=(m3_diameter+.5)/2, $fn=12, center=true);
			}
		}

	hull()
	{
		for(i=[-1, 1])
			translate(filament_center+[i, 0, 0])
			cylinder(h=100, r=filament_radius+.5, center=true);
	}
}

module minebea_motor(clearance=0)
{
	mount_thickness = 5;
	motor_length = 45;
	motor_radius = 35/2;
	
	difference()
	{
		union()
		{
			translate([0, 0, -motor_length/2])
			cylinder(h=motor_length, r=motor_radius+clearance, center=true);

			translate([0, 0, 4.75/2])
			cylinder(h=4.75, r=5+clearance, center=true);
	
			translate([0, 0, 18/2])
			cylinder(h=18, r=5/2, center=true);

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

module drive_wheel()
{
	translate([0, 0, -drive_wheel[drive_wheel_length]/2])
	difference()
	{
		translate([0, 0, drive_wheel[drive_wheel_length]/2])
		cylinder(h=drive_wheel[drive_wheel_length],
		         r=drive_wheel[drive_wheel_radius],
		         center=true);

		translate([0, 0, drive_wheel[drive_wheel_hob_center]])
		rotate_extrude(convexity=4)
			translate([drive_wheel[drive_wheel_radius]+1, 0])
			circle(r=drive_wheel[drive_wheel_radius]-drive_wheel[drive_wheel_hob_radius]+1, $fn=12);
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
			cylinder(h=diameter, r=radius, $fn=32, center=true);
		}
	}
}
