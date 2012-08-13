module hexircle(r, $fn)
{
	intersection()
	{
		circle(r=r/cos(30), $fn=6);
		translate([0, r*3/4])
		square([r*2, r/2], center=true);
	}

	rotate([0, 0, 180/$fn])
	circle(r=r, $fn=$fn);
}

module teardrop(h, r, center=false, $fn)
{
	render(convexity=1)
	cylinder(h=h, r=r, center=center, $fn=$fn);
	translate([0, r/2*sqrt(2), 0])
	cylinder(h=h, r=r*cos(45), center=center, $fn=4);
}

teardrop(h=1, r=10, $fn=40, center=true);

module hexylinder(h, r, center=false, $fn)
{
	render(convexity=1)
	intersection()
	{
		rotate([0, 0, 0])
		cylinder(h=h, r=r/cos(30), center=center, $fn=6);
		if (center)
		{
			translate([0, r*3/4, 0])
			cube([r*2, r/2, h+.1], center=true);
		}
		else
		{
			translate([0, r*3/4, h/2])
			cube([r*2, r/2, h+.1], center=true);
		}
	}
	rotate([0, 0, 180/$fn])
	cylinder(h=h, r=r, $fn=$fn, center=center);
}

module hexasphere(r, $fn)
{
	render(convexity=1)
	{
		intersection()
		{
			cylinder(h=r, r1=r/cos(30), r2=r/cos(30)/2, $fn=$fn);
			translate([0, 0, r*3/4])
			cube([r*2, r*2, r/2], center=true);
		}
		sphere(r, $fn);
	}
}

module octylinder(h, r, center=false, $fn)
{
	a=r/(1+sqrt(2));
	b=(r-a)/2;

	render(convexity=1)
	intersection()
	{
		rotate([0, 0, 45/2])
		cylinder(h=h, r=r/cos(45/2), center=center, $fn=8);
		if (center)
		{
			translate([0, r-b/2, 0])
			cube([r*2, b, h+.1], center=true);
		}
		else
		{
			translate([0, r-b/2, h/2])
			cube([r*2, b, h+.1], center=true);
		}
	}
	rotate([0, 0, 180/$fn])
	cylinder(h=h, r=r, $fn=$fn, center=center);
}

module octasphere(r, $fn)
{
	a=r/(1+sqrt(2));
	b=(r-a)/2;

	render(convexity=1)
	intersection()
	{
		translate([0, 0, a])
		cylinder(h=r-a, r1=r, r2=a, $fn=$fn);
		translate([0, 0, r-b/2])
		cube([r*2, r*2, b], center=true);
	}
	sphere(r, $fn=$fn);
}
