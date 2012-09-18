#!/bin/sh
#
#  build.sh
#  Akimbo
#
#  Created by Ron Aldrich on 8/12/12.
#  Copyright 2012 Ron Aldrich.

cd Source

# Create .stl files for individual parts.

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -D constrained=true -o ../Parts/akimbo_x_end_left_@_1.stl akimbo_x_end.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -D constrained=false -o ../Parts/akimbo_x_end_right_@_1.stl akimbo_x_end.scad


/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/akimbo_carriage_@_2.stl akimbo_carriage.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/top_vertex_@_2.stl top_vertex.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/bottom_vertex_@_2.stl bottom_vertex.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -D mirrored=true -o ../Parts/bottom_vertex_mirrored_@_2.stl bottom_vertex.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/z_bottom_frame_clamp_@_1.stl z_bottom_frame_clamp.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -D mirrored=true -o ../Parts/z_bottom_frame_clamp_mirrored_@_1.stl z_bottom_frame_clamp.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/z_linear_rod_clamp_@_4.stl z_linear_rod_clamp.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/akimbo_extruder_@_1.stl akimbo_extruder.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -D mirrored=true -o ../Parts/akimbo_extruder_mirrored_@_1.stl akimbo_extruder.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D print_orientation=true -o ../Parts/y_pillow_block_@_1.stl y_pillow_block.scad

# Create .stl files for plates.

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D plate=1 -o ../Plates/frame_plate_1.stl frame_plate.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D plate=2 -o ../Plates/frame_plate_2.stl frame_plate.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D plate=1 -o ../Plates/x_axis_plate_1.stl x_axis_plate.scad

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D release_quality=true -D plate=2 -o ../Plates/x_axis_plate_2.stl x_axis_plate.scad

# Create .stl file for assembly.

/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../assembly.stl assembly.scad

cd ..

# Create a .zip containing the individual parts.

rm -f Parts.zip
mkbom -s -i Parts.files Parts.bom
ditto -c -k --keepParent --norsrc --noextattr --noacl -bom Parts.bom Parts Parts.zip
rm -f Parts.bom

rm -f Plates.zip
mkbom -s -i Plates.files Plates.bom
ditto -c -k --keepParent --norsrc --noextattr --noacl -bom Plates.bom Plates Plates.zip
rm -f Plates.bom
