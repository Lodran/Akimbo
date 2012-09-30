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
// barbell.scad
//
// Barbell function extracted from "Greg's Hinged Accessible Extruder"
//  http://www.thingiverse.com/thing:8252
//

$fa=1;
$fs=1;

function triangulate (point1, point2, length1, length2) = 
point1 + 
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b)); 

function rotated(a)=[cos(a),sin(a),0];

module barbell (x1,x2,r1,r2,r3,r4) 
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference ()
	{
		union()
		{
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}
		
		translate(x3)
		circle(r=r3);
		translate(x4)
		circle(r=r4);
	}
}

module barbell_void_1 (x1,x2,r1,r2,r3,r4) 
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);

		translate(x3)
		circle(r=r3);
}

module rounded_triangle(x1, x2, x3, r1, r2, r3, r4, r5, r6)
{
	x4 = triangulate(x2, x1, r2+r4, r1+r4);
	x5 = triangulate(x3, x2, r3+r5, r2+r5);
	x6 = triangulate(x1, x3, r1+r6, r3+r6);
	difference()
	{
		union()
		{
			translate(x1) circle(r=r1);
			translate(x2) circle(r=r2);
			translate(x3) circle(r=r3);
			polygon(points = [x1, x4, x2, x5, x3, x6]);
		}

		translate(x4) circle(r=r4);
		translate(x5) circle(r=r5);
		translate(x6) circle(r=r6);
	}
}
