use <teardrops.scad>

module pill(length, h, r, $fn, center)
{
	render(convexity=4)
	cube([r*2, length, h], center=center);
	for(i=[-1, 1])
	{
		translate([0, i*length/2, 0])
		rotate([0, 0, 90])
		cylinder(h=h, r=r, $fn=$fn, center=center);
	}
}

module hexypill(length, h, r, $fn, center)
{
	render(convexity=4)
	cube([r*2, length, h], center=center);
	for(i=[-1, 1])
	{
		translate([0, i*length/2, 0])
		rotate([0, 0, 90])
		hexylinder(h=h, r=r, $fn=$fn, center=center);
	}
}

module octypill(length, h, r, $fn, center)
{
	render(convexity=4)
	cube([r*2, length, h], center=center);
	for(i=[-1, 1])
	{
		translate([0, i*length/2, 0])
		rotate([0, 0, 90])
		octylinder(h=h, r=r, $fn=$fn, center=center);
	}
}
