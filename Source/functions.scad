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
// functions.scad
//
// Functions commonly used within Akimbo's sources.
//

x=0;
y=1;
z=2;

function average(va, vb) = [
	(va[x]+vb[x])/2,
	(va[y]+vb[y])/2,
	(va[z]+vb[z])/2];

function centerof(a, b) = [(a[x]+b[x])/2, (a[y]+b[y])/2, (a[z]+b[z])/2];
function sizeof(a, b) = [abs(b[x]-a[x]), abs(b[y]-a[y]), abs(b[z]-a[z])];
function minof(a, b) = [a[x]-b[x]/2, a[y]-b[y]/2, a[z]-b[z]/2];
function maxof(a, b) = [a[x]+b[x]/2, a[y]+b[y]/2, a[z]+b[z]/2];

function centerof_2(a, b) = [(a[x]+b[x])/2, (a[y]+b[y])/2];
function sizeof_2(a, b) = [abs(b[x]-a[x]), abs(b[y]-a[y])];
function minof_2(a, b) = [a[x]-b[x]/2, a[y]-b[y]/2];
function maxof_2(a, b) = [a[x]+b[x]/2, a[y]+b[y]/2];
function vec_length_2(a) = sqrt(a[x]*a[x]+a[y]*a[y]);

function pitch_radius(number_of_teeth, modulus=1) = number_of_teeth * modulus / 2;

function rotate_vec(v,a)=[cos(a)*v[0]-sin(a)*v[1],sin(a)*v[0]+cos(a)*v[1]];

function matrix_multiply(a, b) = [
	[a[0][0]*b[0][0]+a[0][1]*b[1][0]+a[0][2]*b[2][0], a[0][0]*b[0][1]+a[0][1]*b[1][1]+a[0][2]*b[2][1], a[0][0]*b[0][2]+a[0][1]*b[1][2]+a[0][2]*b[2][2]],
	[a[1][0]*b[0][0]+a[1][1]*b[1][0]+a[1][2]*b[2][0], a[1][0]*b[0][1]+a[1][1]*b[1][1]+a[1][2]*b[2][1], a[1][0]*b[0][2]+a[1][1]*b[1][2]+a[1][2]*b[2][2]],
	[a[2][0]*b[0][0]+a[2][1]*b[1][0]+a[2][2]*b[2][0], a[2][0]*b[0][1]+a[2][1]*b[1][1]+a[2][2]*b[2][1], a[2][0]*b[0][2]+a[2][1]*b[1][2]+a[2][2]*b[2][2]]
];

function matrix_rotate_x(t) = [ [1, 0, 0], [0, cos(t), -sin(t)], [0, sin(t), cos(t)] ];
function matrix_rotate_y(t) = [ [cos(t), 0, sin(t)], [0, 1, 0], [-sin(t), 0, cos(t)] ];
function matrix_rotate_z(t) = [ [cos(t), -sin(t), 0], [sin(t), cos(t), 0], [0, 0, 1] ];

function matrix_rotate(a) = matrix_multiply( matrix_multiply(matrix_rotate_x(a[x]), matrix_rotate_y(a[y])), matrix_rotate_z(a[z]) );


function vector_rotate(v, a) = matrix_multiply([v, [0, 0, 0], [0, 0, 0]], matrix_rotate(a))[0];
