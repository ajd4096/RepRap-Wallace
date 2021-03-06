rod_size = 6;
rod_nut_size = 12; //12 for M6, 15 for M8
bearing_size = 12.5; //12.5 for LM6UU, 15.5 for LM8UU,LM8SUU
bearing_length = 19.5; //19.5 for LM6UU, 17.5 for LM8SUU, 24.5 for LM8UU
yz_motor_distance = 25;
motor_screw_spacing = 26; //26 for NEMA14, 31 for NEMA17
motor_casing = 38; //38 for NEMA14, 45 for NEMA17
end_height = 40; //measure the height of your motor casing and add 4mm. Suggestion: 40 for NEMA14, 55 for NEMA17
bed_mount_height = 16;
//x_rod_spacing = motor_screw_spacing + 3 + rod_size;
x_rod_spacing = 30;
x_carriage_width = 70;
carriage_extruder_offset = 5;
pulley_size = 20;
idler_pulley_width = 10;
// 623Z id=3 od=10 w=4
// 608ZZ id=8, od=22, w=8
idler_bearing_size = 10;
gusset_size = 15;
m3_size = 3;
m3_nut_size = 6;
m4_size = 4;
motor_shaft_size = 5;
build_volume = [200, 200, 95];
printbed_screw_spacing = [209, 209];


// Derived measurements
z_rod_offset = yz_motor_distance / 2 - rod_size;
y_bearing_offset = yz_motor_distance / 2 - bearing_size / 2;
yz_motor_offset = yz_motor_distance + motor_casing;
base_width = yz_motor_offset - motor_screw_spacing + 10;
z_rod_leadscrew_offset = yz_motor_offset / 2 - z_rod_offset;

platform_screw_spacing = [build_volume[0] + x_carriage_width + (-y_bearing_offset * 2) - (rod_size + m3_size) - z_rod_offset * 2 + (bearing_size + 6), build_volume[1] + motor_casing + rod_size * 4 + 10];
x_rod_length = platform_screw_spacing[0] + (rod_size + m3_size) + y_bearing_offset * 2 * 2 + z_rod_leadscrew_offset - (-(motor_casing / 2 + rod_size + bearing_size + 10) / 2 + rod_size / 2 + 2) * 2;
y_rod_length = platform_screw_spacing[1] + 10;
z_rod_length = rod_size * 2 + gusset_size + bearing_size * sqrt(2) / 4 + bed_mount_height + (x_rod_spacing / 2 + bearing_size / 2 + 4) + (x_rod_spacing + 8 + rod_size) / 2 + build_volume[2] + 55 + end_height - motor_casing / 4;
foot_rod_length = y_rod_length * 3/4;
leadscrew_length = z_rod_length - end_height - 60;
base_rod_length = platform_screw_spacing[0] + y_bearing_offset * 2 + (rod_size + m3_size) + base_width + rod_size * 2;
top_rod_length = platform_screw_spacing[0] + y_bearing_offset * 2 + (rod_size + m3_size) + z_rod_offset * 2 + rod_size * 5;

x_belt_loop = (z_rod_leadscrew_offset + bearing_size + 8) / 2 + motor_casing / 2 + x_rod_length + (-(motor_casing / 2 + rod_size + bearing_size + 10) / 2 + rod_size / 2 + 2) * 2;

echo("X rod length: ", x_rod_length);
echo("Y rod length: ", y_rod_length);
echo("Z rod length: ", z_rod_length);
echo("foot rod length: ", foot_rod_length);
echo("leadscrew length: ", leadscrew_length);
echo("base rod length: ", base_rod_length);
echo("top rod length: ", top_rod_length);



// ratio for converting diameter to apothem
da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;
da12 = 1 / cos(180 / 12) / 2;

//Comment out all of the lines in the following section to render the assembled machine. Uncomment one of them to export that part for printing. You can also use the individual files to export each part.

//!platform();
//!base_end();
//!for(b = [0:1]) mirror([0, b, 0]) for(a = [-1,1]) translate([a * bearing_size / 4, bearing_size - (bearing_size * 2/3) * a, 0]) rotate(90 + 90 * a) y_bearing_retainer();
//!for(b = [0:1]) mirror([0, b, 0]) for(a = [-1,1]) translate([a * -7.5, 18 - 5 * a, 0]) rotate(180 + 90 * a) bed_mount();
//!x_end(2);
//!x_end(0);
//!x_carriage();
//!for(side = [-1,1]) translate([0, side * motor_screw_spacing / 2, 0]) leadscrew_coupler();
//!y_idler();
//!for(x = [1, -1]) for(y = [1, -1]) translate([x * (pulley_size / 2 + 3), y * (pulley_size / 2 + 3), 0]) idler_pulley(true);
//!for(x = [1, -1]) for(y = [1, -1]) translate([x * (rod_size * 1.5 + 2), y * (rod_size * 1.5 + 2), 0]) foot();
//!for(side = [0, 1]) mirror([side, 0, 0]) translate([-rod_size * 2.5, 0, 0]) z_top_clamp();


//The following section positions parts for rendering the assembled machine.

	platform();
	for(side = [0, 1]) mirror([side, 0, 0]) translate([-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2, 0, -bearing_size * sqrt(2) / 4 - bed_mount_height]) {
		rotate([0, 180, 0]) {
			base_end();
			%for(end = (side) ? [1] : [1, -1]) translate([end * yz_motor_offset / 2, 0, 3]) {
				linear_extrude(height = end_height - 5, convexity = 5) intersection() {
					square(motor_casing - 2, center = true);
					rotate(45) square(motor_casing * 1.2, center = true);
				}
				cylinder(r = 2.5, h = 40, center = true);
			}
		}
		for(end = [1, -1]) translate([0, end * motor_screw_spacing / 2 + 5, bearing_size * sqrt(2) / 4]) rotate([-90, 0, 180]) y_bearing_retainer();
		for(side = [0, 1]) mirror([0, side, 0]) translate([y_bearing_offset, y_rod_length / 2, bearing_size * sqrt(2) / 4]) rotate([90, 0, 0]) bed_mount();
		for(side = [0, 1]) mirror([0, side, 0]) translate([0, foot_rod_length / 2, -end_height + rod_size * 1.5]) rotate([90, 0, 0]) foot();
		translate([-z_rod_offset - z_rod_leadscrew_offset / 2, 0, 60 + (x_rod_spacing + 8 + rod_size) / 2]) rotate([0, 180, 0]) mirror([side, 0, 0]) {
			x_end(side * 2);
			translate([0, 8 + rod_size, 0]) rotate([90, 0, 0]) translate([0, (x_rod_spacing + 8 + rod_size) / 2, rod_size / 2 - 2 - bearing_size / 2 - 4 - idler_pulley_width - 1.5]) idler_pulley(true);
		}
		translate([-z_rod_offset, 0, z_rod_length - (end_height - motor_casing / 4)]) rotate([180, 0, 90]) z_top_clamp(0);
		translate([-yz_motor_offset / 2, 0, bearing_size / 2]) leadscrew_coupler();
		if (side == 0) {
			translate([-(-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2) - 5 - pulley_size / 2, 0, -rod_size / 2 - bearing_size / 2]) {
				rotate([0, 90, 0]) y_idler();
				for(side = [1, -1]) {
					translate([5, side * (motor_casing / 2 - rod_size / 2), idler_pulley_width + 1.5 + rod_size]) rotate([180, 0, 0]) idler_pulley(true);
					
				}
			}
			translate([-x_carriage_width / 2 - (-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2) + 0, rod_size + bearing_size / 2 + 1 - rod_size / 2 + 2, 60]) {
				rotate([90, 0, 90]) x_carriage();
				translate([x_carriage_width / 2 + carriage_extruder_offset, -14 - bearing_size / 2 - 4, x_rod_spacing / 2 + bearing_size / 2 + 4]) {
					rotate([90, 0, 180]) translate([10.57, 30.3, -14]) import("gregs/gregs_accessible_wade-wildseyed_mount.stl", convexity = 5);
					%rotate(180 / 8) cylinder(r = 2, h = 120, center = true, $fn = 8);
				}
			}
		}
	}


//**************************************************
// platform

module platform() difference() {
	// base plate - rounded square
	minkowski() {
		square(platform_screw_spacing, center = true);
		circle(10);
	}
	// screw holes down both sides
	for(y = [-1, 1]) {
		for(x = [-1, 1]) translate([platform_screw_spacing[0] / 2 * x, platform_screw_spacing[1] / 2 * y, 0]) circle(m3_size * da12, $fn = 12);
		for(i = [-2: 2]) translate([platform_screw_spacing[0] / 8 * i, (platform_screw_spacing[1] / 2 + 3) * y, 0]) circle(m3_size * da12, $fn = 12);
	}
	// show work volume
	translate([carriage_extruder_offset, (-bearing_size / 2 - 4 - 14) / 2, 0]) {
		#%difference() {
			linear_extrude(height = build_volume[2], convexity = 5) difference() {
				square([build_volume[0], build_volume[1]], center = true);
				//square([build_volume[0] - 5, build_volume[1] - 5], center = true);
			}
			translate([0, 0, 2.5]) linear_extrude(height = build_volume[2] - 5, convexity = 5) {
				square([build_volume[0] + 5, build_volume[1] - 5], center = true);
				square([build_volume[0] - 5, build_volume[1] + 5], center = true);
			}
			translate([0, 0, 2.5]) linear_extrude(height = build_volume[2], convexity = 5) {
				square([build_volume[0] - 5, build_volume[1] - 5], center = true);
			}
		}
		if(printbed_screw_spacing) for(x = [-1, 1]) for(y = [-1, 1]) translate([printbed_screw_spacing[0] / 2 * x, printbed_screw_spacing[1] / 2 * y, 0]) circle(m3_size * da12, $fn = 12);
	}
}


//**************************************************
// z_top_clamp

module z_top_clamp() difference() {
	union() {
		linear_extrude(height = rod_size * 2 + gusset_size, convexity = 5) difference() {
			union() {
				circle(r = rod_size * da6 * 2, $fn = 6);
				translate([0, -rod_size, 0]) square([rod_size * (1 + da6), rod_size * 2]);
				translate([rod_size - rod_size * da6, rod_size / 2, rod_size]) square([rod_size * da6 * 2, rod_size / 2 + gusset_size]);
			}
		}
		translate([rod_size, -rod_size - 1, rod_size]) rotate([-90, 0, 0]) cylinder(r = rod_size / cos(180 / 6), h = rod_size * 2 + gusset_size + 2, $fn = 6);
	}
	translate([rod_size, -rod_size - 2, rod_size]) rotate([-90, 0, 0]) cylinder(r = rod_size * da6, h = gusset_size + rod_size * 2 + 4, $fn = 6);
	translate([rod_size, rod_size + gusset_size, rod_size * 2 + gusset_size]) rotate([45, 0, 0]) cube([rod_size * 2, gusset_size * sqrt(2), gusset_size * sqrt(2)], center = true);
	translate([0, 0, -1]) linear_extrude(height = rod_size * 2 + gusset_size + 2, convexity = 5) {
		circle(r = rod_size * da6, $fn = 6);
		%translate([rod_size, -(-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2) + z_rod_offset, rod_size * da6 * 2]) rotate([-90, 0, 0]) cylinder(r = rod_size * da6, h = top_rod_length, center = true, $fn = 6);
		translate([0, -rod_size / 2, 0]) square([gusset_size + rod_size * 2 + 1, rod_size]);
	}
}


//**************************************************
// foot

module foot() difference() {
	linear_extrude(height = rod_size, convexity = 5) difference() {
		// rounded square
		minkowski() {
			square(rod_size + 2, center = true);
			circle(rod_size, $fn = 16);
		}
		// hole for foot rod
		circle(rod_size / 2, $fn = 12);
	}

	// counter-sink top (as printed) hole
	translate([0, 0, -rod_size / 16]) cylinder(r1 = rod_size * 3/4, r2 = rod_size / 4, h = rod_size / 2, $fn = 12);
	// counter-sink top (as printed) hole
	translate([0, 0, rod_size / 2 + rod_size / 16]) cylinder(r2 = rod_size * 3/4, r1 = rod_size / 4, h = rod_size / 2, $fn = 12);
}


//**************************************************
// idler_pulley

module idler_pulley(double_bearing = true) difference() {
	intersection() {
		// cylinder height truncates sphere to width, dia limits flange
		linear_extrude(height = idler_pulley_width + 1, convexity = 5) difference() {
			circle(pulley_size / 2 + 2);
			// inner shaft - fn=4 makes a square hole to help bridging
			circle(5, $fn = 4);
		}
		union() {
			// main body - a partial sphere stretched vertically
			translate([0, 0, idler_pulley_width / 2 + 1]) scale([1, 1, 1.25]) sphere(pulley_size / 2);
			// flange 
			cylinder(r = pulley_size / 2 + 5, h = 1);
		}
	}
	// holes for bearings
	// +-4 is the depth
	for(h = [-idler_pulley_width + 4, idler_pulley_width * 2 + 1 - 4]) rotate(180 / 8) translate([0, 0, (double_bearing) ? h:0]) cylinder(r = idler_bearing_size * da8, h = idler_pulley_width * 2, center = true, $fn = 8);
}


//**************************************************
// y_idler

module y_idler() difference() {
	linear_extrude(height = 10, convexity = 5) difference() {
		union() {
			// rectangular body
			square([rod_size * 2, motor_casing + rod_size * 2], center = true);
			// rounded ends
			for(side = [1, -1]) translate([0, side * (motor_casing / 2 + rod_size), rod_size / 2 + bearing_size / 2]) rotate(180 / 8) circle(rod_size * 13/12, center = true, $fn = 8);
		}
		// holes for base rods
		for(side = [1, -1]) translate([0, side * (motor_casing / 2 + rod_size), rod_size / 2 + bearing_size / 2]) rotate(180 / 8) circle(rod_size * da8, center = true, $fn = 8);

	}
	// holes for pulley mounting bolts
	rotate([90, 0, 90]) {
		// -3 = nut depth
		for(side = [1, -1]) translate([side * (motor_casing / 2 - rod_size / 2), 5, -3]) {
			cylinder(r = m3_size * da6, h = rod_size * 2, center = true, $fn = 6);
			translate([0, 0, rod_size]) cylinder(r = m3_nut_size * da6, h = 4, $fn = 6);
		}
		//belt
		%translate([0, 5, -rod_size - idler_pulley_width / 2]) linear_extrude(height = 5, center = true, convexity = 5) for(side = [1, 0]) mirror([side, 0, 0]) {
			translate([-(motor_casing / 2 - rod_size / 2), 0, 0]) {
				// belt around idler puller
				intersection() {
					difference() {
						// +2 = belt thickness
						circle(pulley_size / 2 + 2);
						circle(pulley_size / 2);
					}
					// limit to 1/4 turn
					square(pulley_size);
				}
				// belt running outwards along Y
				rotate(90) difference() {
					translate([2, 0, 0]) square([pulley_size / 2, platform_screw_spacing[1] / 2]);
					square([pulley_size / 2, platform_screw_spacing[1] / 2]);
				}
				// belt to/from Y motor
				rotate(-90) difference() {
					translate([0, 2, 0]) square([-(-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2) - 5 - pulley_size / 2 - yz_motor_distance / 2 - motor_screw_spacing / 2, pulley_size / 2]);
					square([-(-platform_screw_spacing[0] / 2  - y_bearing_offset - (rod_size + m3_size) / 2) - 5 - pulley_size / 2, pulley_size / 2]);
				}
			}
			// belt loop around Y motor pulley
			translate([0, -(-(-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2) - 5 - pulley_size / 2 - yz_motor_distance / 2 - motor_screw_spacing / 2), 0]) difference() {
				// outer radius
				circle(motor_casing / 2 - rod_size / 2 - pulley_size / 2);
				// inner radius
				circle(motor_casing / 2 - rod_size / 2 - pulley_size / 2 - 2);
				// only show semi-circle
				translate([-(motor_casing / 2 - rod_size / 2 - pulley_size / 2), 0, 0]) square(motor_casing - rod_size - pulley_size);
			}
		}
	}
}


//**************************************************
// leadscrew_coupler

module leadscrew_coupler() difference() {
	linear_extrude(height = 10 + rod_nut_size / 2 + 1, convexity = 5) difference() {
		// body sized to suit motor
		circle(motor_screw_spacing / 2 - 1);
		// remove shaft hole
		circle(motor_shaft_size * da6, $fn = 6);
	}
	translate([0, 0, m3_nut_size / 2]) rotate([-90, 0, 90]) {
		// screw hole
		cylinder(r = m3_size * da6, h = motor_screw_spacing / 2 + 1);
		// show nut for assembly
		%rotate(90) cylinder(r = m3_nut_size / 2, h = 5.5, $fn = 6);
		// cut clearance for screw head (? doesn't actually touch)
		translate([0, 0, 12]) cylinder(r = m3_size * da6 * 2, h = motor_screw_spacing / 2);
		// nut trap
		translate([-m3_nut_size / da6 / 4, -m3_nut_size / 2, 0]) cube([m3_nut_size / da6 / 2, m3_nut_size + 1, 5.7]);
	}
	translate([0, 0, 10]) {
		// hole for rod nut
		cylinder(r = rod_nut_size / 2, h = rod_nut_size + 1, $fn = 6);
		// show Z-rod nut for assembly
		%cylinder(r = rod_nut_size / 2, h = rod_nut_size * 2/3, $fn = 6);
		// show Z-rod for assembly
		%cylinder(r = rod_size * da8, h = leadscrew_length, $fn = 8);
	}
}


//**************************************************
// x_carriage

module x_carriage() difference() {
	intersection() {
		linear_extrude(height = x_carriage_width, convexity = 5) difference() {
			union() {
				// main body between rods
				square([bearing_size + 8, x_rod_spacing], center = true);

				// bottom of belt clamp
				translate([0, -x_rod_spacing / 2 - bearing_size / 2 - 4, 0]) square([bearing_size / 2 + 4 + 15, x_rod_spacing / 2 + bearing_size / 2 + 4 - 2 - pulley_size / 2]);

				// top of belt clamp
				translate([0, -pulley_size / 2, 0]) {
					square([bearing_size / 2 + 4 + 15, 8]);
					translate([bearing_size / 2 + 4 + 15, 4, 0]) circle(4);
				}

				// body of extruder mounting plate
				rotate(180) translate([0, -x_rod_spacing / 2 - bearing_size / 2 - 4, 0]) square([bearing_size / 2 + 4 + 28, bearing_size / 2 + 4 + 3]);

				// rounded corner on top and bottom of bearing holder
				for(side = [1, -1]) translate([0, side * x_rod_spacing / 2, 0]) circle(bearing_size / 2 + 4, $fn = 30);
			}

			// slot in flexible part of belt clamp
			translate([bearing_size / 2 + 4, 2 - pulley_size / 2, 0]) {
				square([15, 4]);
				translate([0, -3, 0]) square([2, 4]);
				translate([15, 2, 0]) circle(2);
			}

			// top and bottom bearing holders
			for(side = [1, -1]) translate([0, side * x_rod_spacing / 2, 0]) {

				// hole for bearing (slightly undersize)
				circle(bearing_size / 2 -1, $fn = 30);

				// clamping slot 
				rotate(90 * side) square([2, bearing_size / 2 + 40]);
			}
		}
		// reduce width of lower bearing
		difference() {
			rotate([0, -90, 0]) linear_extrude(height = bearing_size + 100, convexity = 5, center = true) difference() {
				polygon([
					[
						0,
						(x_rod_spacing / 2 + bearing_size / 2 + 4)
					],[
						0,
						-(x_rod_spacing / 2 + bearing_size / 2 + 4)
					],[
						bearing_length + 4,
						-(x_rod_spacing / 2 + bearing_size / 2 + 4)
					],[
						bearing_length + 4,
						-(x_rod_spacing / 2 - bearing_size / 2 - 4)
					],[
						x_carriage_width,
						(x_rod_spacing / 2 - bearing_size / 2 - 4)
					],[
						x_carriage_width,
						(x_rod_spacing / 2 + bearing_size / 2 + 4)
					]
				]);
			}
			translate([bearing_size / 2 + 4, -50, bearing_length + 4]) cube(100);
		}
	}
	// linear bearings
	// top X-rod
	translate([0, x_rod_spacing / 2, 0]) rotate([0, 0, 0]) {
		// show top X-rod for assembly
		//%translate([0, 0, x_carriage_width / 2]) rotate(180 / 8) cylinder(r = rod_size * da8, h = x_rod_length, center = true, $fn = 8);
		// hole for top bearings
		for(end = [0, 1]) mirror([0, 0, end]) translate([0, 0, end * -x_carriage_width - 1]) cylinder(r = bearing_size / 2, h = bearing_length, $fn = 30);
	}
	// bottom X-rod
	translate([0, -x_rod_spacing / 2, 0]) rotate([0, 0, 0]) {
		// hole for bottom bearing
		translate([0, 0, 4]) cylinder(r = bearing_size / 2, h = x_carriage_width + 1, center = false, $fn = 30);
		// show bottom X-rod for assembly
		//%translate([0, 0, 20]) rotate(180 / 8) cylinder(r = rod_size * da8, h = 200, center = true, $fn = 8);
	}
	// screw holes
	translate([bearing_size / 2 + 4 + 10, 5 - pulley_size / 2, bearing_length / 2 + 2]) rotate([90, 0, 0]) {
		// screw hole for belt clamp
		cylinder(r = m3_size * da6, h = x_rod_spacing + bearing_size + 10, center = true, $fn = 6);
		// screw head in top of clamp
		rotate([180, 0, 0]) cylinder(r = m3_size * da6 * 2, h = x_rod_spacing + bearing_size + 10, center = false, $fn = 6);
		// nut trap in bottom of clamp
		translate([0, 0, x_rod_spacing / 2 + bearing_size / 2 + 6 - pulley_size / 2]) cylinder(r = m3_nut_size * da6, h = x_rod_spacing + bearing_size + 10, center = false, $fn = 6);
	}
	// extruder bolt clearance?
	//#for(side = [1, -1]) translate([-bearing_size / 2 - 4 - 14, 0, x_carriage_width / 2 + carriage_extruder_offset + side * 25]) rotate([90, 0, 0]) cylinder(r = 4.1, h = x_rod_spacing - 10, center = true, $fn = 6);

	// shape extruder clearance
	translate([-bearing_size / 2 - 4 - 14, 0, x_carriage_width / 2 + carriage_extruder_offset]) rotate([90, 0, 0]) linear_extrude(height = bearing_size + x_rod_spacing + 10, center = true, convexity = 5) {
		*translate([-14, 0, 0]) {
			circle(20);
			rotate(45) square(5);
		}
		intersection() {
			// remove V-shape section
			translate([18, 0, 0]) rotate(135) square(100);
			// truncate V
			translate([-14, 0, 0]) square([56, 100], center = true);
		}
		// extruder mounting holes
		for(side = [1, -1]) translate([0, side * 25, 0]) circle(m4_size * da6, $fn = 6);
	}
}


//**************************************************
// x_end

module x_end(motor = 0) mirror([(motor == 0) ? 1 : 0, 0, 0]) difference() {
	union() {
		if(motor > 0) translate([-(z_rod_leadscrew_offset + bearing_size + 8) / 2 - motor_casing, 8 + rod_size, 0]) rotate([90, 0, 0]) {
			// Motor holder
			linear_extrude(height = 7) difference() {
				// motor plate
				square([motor_casing + 3, x_rod_spacing + 8 + rod_size]);
				translate([motor_casing / 2, (x_rod_spacing + 8 + rod_size) / 2, 0]) {
					// shaft clearance
					circle(motor_screw_spacing / 2);
					// mounting screws
					for(x = [1, -1]) for(y = [1, -1]) translate([x * motor_screw_spacing / 2, y * motor_screw_spacing / 2, 0]) circle(m3_size * da6, $fn = 6);
					// remove 1/4 of plate
					translate([-(motor_casing * 1.5 - motor_screw_spacing), (motor > 1) ? (motor_casing / 2 - motor_screw_spacing) : 0, 0]) square([motor_casing, x_rod_spacing + 8 + rod_size]);
				}
			}
			// show motor for assembly
			%translate([motor_casing / 2, motor_casing / 2, 7]) {
				linear_extrude(height = end_height - 5, convexity = 5) intersection() {
					square(motor_casing - 2, center = true);
					rotate(45) square(motor_casing * 1.2, center = true);
				}
				cylinder(r = 2.5, h = 40, center = true);
			}
			// Belt
			// show belt for assembly
			%translate([motor_casing / 2, (x_rod_spacing + 8 + rod_size) / 2, rod_size / 2 - 2 - bearing_size / 2 - 2 - idler_pulley_width / 2]) rotate([180, 0, 0]) linear_extrude(height = 5, convexity = 5) difference() {
				union() {
					// outer circle motor end
					circle(pulley_size / 2 + 2);
					// straight runs
					translate([0, -pulley_size / 2 - 2, 0]) square([x_belt_loop, pulley_size + 4]);
					// outer circle idler end
					translate([x_belt_loop, 0, 0]) circle(pulley_size / 2 + 2);
				}
				// inner circle motor end
				circle(pulley_size / 2);
				// straight run
				translate([0, -pulley_size / 2, 0]) square([x_belt_loop, pulley_size]);
				// inner circle idler end
				translate([x_belt_loop, 0, 0]) circle(pulley_size / 2);
			}

		}
		linear_extrude(height = x_rod_spacing + 8 + rod_size, convexity = 5) difference() {
			union() {
				// rounded face on front of Z-rods
				for(side = [1, -1]) translate([side * z_rod_leadscrew_offset / 2, 0, 0]) circle(bearing_size / 2 + 3, $fn = 30);
				// front flat between rods
				square([z_rod_leadscrew_offset, bearing_size / 2 + 3], center = true);

				// rear X-rod clamp
				translate([-(z_rod_leadscrew_offset + bearing_size + 6) / 2, 0, 0]) {
					// fill in outer side of clamp between threaded rod and clamp
					square([(z_rod_leadscrew_offset + bearing_size / 2 + 3 + 3) / 2, bearing_size / 2 + 4 + rod_size / 2]);
					// extend flat past smooth rod
					square([z_rod_leadscrew_offset + bearing_size / 2 + 3 + 3, bearing_size / 2 + 3 + rod_size / 2]);
					translate([rod_size / 2 + 2, 0, 0]) {
						// rear flat of clamp
						square([(z_rod_leadscrew_offset + bearing_size + 6) / 2 + 5 - rod_size / 2 - 2, bearing_size / 2 + 6 + rod_size]);
						// curve at base of clamp
						translate([0, bearing_size / 2 + rod_size / 2 + 4, 0]) circle(rod_size / 2 + 2);
					}
				}
				// extra thickness on rear clamp
				translate([0, bearing_size / 2 + rod_size + 6, 0]) square(10, center = true);
			}
			// slot between smooth and threaded Z-rods
			square([z_rod_leadscrew_offset, 3], center = true);

			// Z-rod bearing clamp (slightly undersize)
			translate([(z_rod_leadscrew_offset / 2), 0, 0]) circle(bearing_size / 2 - .5, $fn = 30);

			// Z-rod threaded nut clamp
			translate([-(z_rod_leadscrew_offset / 2), 0, 0]) circle(rod_nut_size * 6/14, $fn = 6);

			// slot for rear X-rod clamp
			translate([4 + rod_size / 2, bearing_size / 2 + rod_size / 2 + 3, 0]) {
				// main part of slot
				square([z_rod_leadscrew_offset + bearing_size + 8, rod_size / 2], center = true);
				// rounded end
				translate([-(z_rod_leadscrew_offset + bearing_size + 8) / 2, .5, 0]) circle(rod_size / 4 + .5, $fn = 12);
			}
		}
	}
	translate([0, 0, (x_rod_spacing + rod_size + 8) / 2]) {
		// hole for Z-rod bearing
		for(end = [0, 1]) mirror([0, 0, end]) translate([z_rod_leadscrew_offset / 2, 0, -(x_rod_spacing + rod_size + 8) / 2 - 1]) cylinder(r = bearing_size / 2 - .05, h = bearing_length, $fn = 30);

		for(side = [1, -1]) render(convexity = 5) translate([0, bearing_size / 2 + rod_size / 2 + 3, side * x_rod_spacing / 2]) rotate([0, 90, 0]) {
			// I think this should show an X-rod, but I don't get anything rendered
			if(motor) %translate([0, 0, -(z_rod_leadscrew_offset + bearing_size + 10)  / 2 + rod_size / 2 + 2]) rotate(180 / 8) cylinder(r = rod_size * da8, h = x_rod_length, $fn = 8);

			// uncomment to extend the X-rods through the clamp
			//cylinder(r = rod_size / 2, h = z_rod_leadscrew_offset + bearing_size + 10, center = true, $fn = 30);
			difference() {
				translate([0, 0, (motor > -1) ? rod_size / 2 + 2 : 0]) intersection() {
					// clearance for X-rod on front side
					rotate(45) cube([rod_size + 2, rod_size + 2, z_rod_leadscrew_offset + bearing_size + 10], center = true);
					// limit length to within clamp
					cube([rod_size * 2, rod_size + 2, z_rod_leadscrew_offset + bearing_size + 10], center = true);
				}
				// clamping block on rear side
				translate([0, rod_size, 0]) cube([rod_size * 2, rod_size * 2, 6], center = true);

				// ends on front clearance
				for(end = [1, -1]) translate([0, -rod_size, end * (z_rod_leadscrew_offset / 2)]) cube([rod_size * 2, rod_size * 2, 6], center = true);
			}

			translate([0, 0, rod_size / 2 + 2]) intersection() {
				// remove hole for X-rod
				rotate(45) cube([rod_size, rod_size, z_rod_leadscrew_offset + bearing_size + 10], center = true);
				// limit size of hole
				cube([rod_size * 2, rod_size + 1, z_rod_leadscrew_offset + bearing_size + 10], center = true);
			}
		}
		// holes for clamping screws
		rotate([90, 0, 0]) {
			// X-rod clamp screw
			cylinder(r = m3_size * da6, h = 100, center = true, $fn = 6);
			// X-rod clamp screw nut trap
			translate([0, 0, bearing_size / 4 + .5]) cylinder(r = m3_nut_size * da6, h = 100, center = false, $fn = 6);
		}
	}
	// clearance for Z-rod
	translate([-(z_rod_leadscrew_offset / 2), 0, 5]) rotate(90) cylinder(r = rod_nut_size / 2, h = x_rod_spacing + 8 + rod_size, $fn = 6);
}


//**************************************************
// bed_mount

module bed_mount() difference() {
	linear_extrude(height = 10, convexity = 5) difference() {
		union() {
			// outer circle
			rotate(180 / 8) circle((rod_size + 8) * da8, $fn = 8);
			// main square body
			translate([0, -rod_size / 2 - 4, 0]) square([rod_size / 2 + 8, max(rod_size + 8, rod_size / 2 + 4 + bed_mount_height)]);
		}
		// hole for Y-rod
		rotate(180 / 8) circle(rod_size * da8, $fn = 8);
		// clamping slot
		translate([0, -rod_size / (1 + sqrt(2)) / 2, 0]) square([rod_size + 10, rod_size / (1 + sqrt(2))]);
	}
	translate([rod_size / 2 + 1.5, -rod_size / 2 - 6, 5]) rotate([-90, 0, 0]) {
		// screw hole
		cylinder(r = m3_size * da6, h = max(rod_size + 12, rod_size / 2 + 7 + bed_mount_height, $fn = 6));
		// nut trap
		cylinder(r = m3_nut_size * da6, h = 4, $fn = 6);
	}
}


//**************************************************
// y_bearing_retainer

module y_bearing_retainer() intersection() {
	difference() {
		linear_extrude(height = 10, convexity = 5) difference() {
			union() {
				intersection() {
					// rounded top
					translate([-y_bearing_offset, 0, 0]) circle(bearing_size / 2 + 4);

					// trim to 1/2 circle
					translate([-y_bearing_offset - bearing_size / 2 - 4, -bearing_size, 0]) square([bearing_size + 8, bearing_size]);
				}
				translate([-y_bearing_offset - bearing_size / 2 - 4, 0, 0]) square([bearing_size + 8, bearing_size * sqrt(2) / 4 - 1]);
				// flat base plate
				translate([0, bearing_size * sqrt(2) / 4 - 3, 0]) square([yz_motor_offset - motor_screw_spacing + 10, 4], center = true);
			}
			// hole for bearing
			translate([-y_bearing_offset, 0, 0]) circle(bearing_size / 2);
			translate([-y_bearing_offset - bearing_size / 2, 0, 0]) square(bearing_size);
		}
		//screw holes
		for(side = [1, -1]) translate([side * (yz_motor_offset - motor_screw_spacing) / 2, 0, 5]) rotate(90) rotate([90, 0, 90]) {
			cylinder(r = m3_size * da6, h = bearing_size, center = true, $fn = 6);
			// clearance for screw head in side of U-clamp
			translate([0, 0, bearing_size * sqrt(2) / 4 - 5]) rotate([180, 0, 0]) cylinder(r = m3_size, h = bearing_size, $fn = 30);
		}
	}
	// round off ends of strap
	translate([0, 0, 5]) rotate(90) rotate([90, 0, 90]) cylinder(r = (yz_motor_offset - motor_screw_spacing + 10) / 2, h = bearing_size + 10, center = true, $fn = 6);
}


//**************************************************
// base_end

module base_end() difference() {
	linear_extrude(height = end_height, convexity = 5) difference() {
		// main body
		square([base_width, motor_casing + rod_size * 4], center = true);
		for(end = [1, -1]) {
			// motor screws
			for(side = [1, -1]) translate([end * (yz_motor_offset - motor_screw_spacing) / 2, side * motor_screw_spacing / 2, 0]) circle(m3_size * da6, $fn = 6);

			// motor clearance circle
			translate([end * yz_motor_offset / 2, 0, 0]) circle(motor_screw_spacing / 2);
		}
	}

	// clearance for motor casing
	for(end = [1, -1]) translate([end * yz_motor_offset / 2, 0, 3]) linear_extrude(height = end_height, convexity = 5) square(motor_casing, center = true);
	for(side = [1, -1]) translate([0, side * (motor_casing / 2 + rod_size), rod_size / 2 + bearing_size / 2]) rotate([90, 180 / 8, -90]) {
		// base rod holes
		cylinder(r = rod_size * da8, h = yz_motor_offset + 20, center = true, $fn = 8);

		// show base rods for assembly
		%translate([0, 0, -(-platform_screw_spacing[0] / 2 - y_bearing_offset - (rod_size + m3_size) / 2)]) cylinder(r = rod_size * da8, h = base_rod_length, center = true, $fn = 8);
	}

	// remove arch from bottom
	translate([0, 0, end_height]) scale([1, 1, .5]) rotate([90, 0, 90]) cylinder(r = motor_casing / 2, h = yz_motor_distance + 20, center = true);

	translate([z_rod_offset, 0, 0]) {
		// show Z-rod for assembly
		%translate([0, 0, end_height - motor_casing / 4 - 3]) rotate([180, 0, 180 / 8]) cylinder(r = rod_size * da8, h = z_rod_length, $fn = 8);

		// hole for Z-rod
		#translate([0, 0, -3]) linear_extrude(height = end_height - motor_casing / 4, convexity = 5) {
			rotate(180 / 8) circle(rod_size * da8, $fn = 8);
			translate([0, -rod_size / 4, 0]) square([rod_size * .6, rod_size / 2]);
		}

		// z axis clamping
		for(h = [8, end_height - motor_casing / 4 - 8]) translate([0, 0, h]) rotate([90, 0, 90]) {

			// bolt hole through
			cylinder(r = m3_size * da6, h = yz_motor_offset, center = true, $fn = 6);

			// nut trap next to shaft
			translate([0, 0, -rod_size / 2 - 3]) cylinder(r = m3_nut_size* da6, h = yz_motor_offset, $fn = 6);

			// recess for screw head on inside (slightly larger dia)
			translate([0, 0, 0]) cylinder(r = m3_nut_size / 2 + 0.5, h = yz_motor_offset, $fn = 6);

			// access to put nut in from outside
			translate([0, 0, -rod_size / 2 - 8]) rotate([0, 180, 0]) cylinder(r = m3_size * da6 * 2, h = yz_motor_offset, $fn = 6);
		}
	}
	translate([-y_bearing_offset, 0, -bearing_size * sqrt(2) / 4]) rotate([90, -45, 0]) {
		// show Y-rod for assembly
		%cylinder(r = rod_size * da8, h = y_rod_length, center = true, $fn = 8);

		// recess for Y-rod bearing
		for(side = [0, 1]) mirror([0, 0, side]) translate([0, 0, rod_size / 2 + 2]) {
			cylinder(r = bearing_size / 2, h = bearing_length, center = false, $fn = 80);
			cube([bearing_size / 2, bearing_size / 2, bearing_length]);
		}
	}
	// foot rod hole
	translate([0, 0, end_height - rod_size * 1.5]) rotate([90, 180 / 8, 0]) cylinder(r = rod_size * da8, h = motor_casing + rod_size * 5, $fn = 8, center = true);

	// show foot rod for assembly
	%translate([0, 0, end_height - rod_size * 1.5]) rotate([90, 180 / 8, 0]) cylinder(r = rod_size * da8, h = foot_rod_length, $fn = 8, center = true);
}
