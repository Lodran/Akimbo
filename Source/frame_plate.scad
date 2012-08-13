use <bottom_vertex.scad>
use <top_vertex.scad>
use <z_clamp.scad>

z_plate();

module bottom_plate()
{
	translate([0, 37, 0])
	for(i=[-1,1]) scale([i, 1, 1])
	{
		for(j=[-1,1])
		{
			translate([0, i*40+j*20, 0])
			bottom_vertex(print_orientation=true);
		}
	}
}

module z_plate()
{
	for(i=[-1, 1])
	{
		translate([i*20, 0, 0])
		top_vertex(print_orientation=true);

		translate([52, i*19, 0])
		scale([1, i, 1])
		z_clamp(print_orientation=true);
	}

}
