/*
  sawstop_drawer (c) by Robert Bieber

  sawstop_drawer is licensed under a Creative Commons
  Attribution-ShareAlike 4.0 International License.

  You should have received a copy of the license along with this
  work. If not, see <http://creativecommons.org/licenses/by-sa/4.0/>.
*/

SIDE = "left"; // ["left", "right"]

LENGTH = 200;
WIDTH = 65;
HEIGHT = 42;

FACE_WIDTH = 76;
FACE_HEIGHT = 47;
FACE_THICKNESS = 3;
FACE_RADIUS = 5;

WALL_THICKNESS = 2;

HUMP_WIDTH = 20;
HUMP_HEIGHT = 8;
HUMP_DEPTH = 105;

VERTICAL_DIVIDERS = [];
HORIZONTAL_DIVIDERS = [];
DIVIDER_HEIGHT = 8;

FINGER_HOLE_RADIUS = 10;

$fn = 100;

module base_box() {
	base_dimensions = [WIDTH, LENGTH, HEIGHT];
	difference() {
		cube(base_dimensions);
		translate([WALL_THICKNESS, WALL_THICKNESS, 2*WALL_THICKNESS + 1e-3])
			cube([for (n = base_dimensions) n - 2*WALL_THICKNESS]);
	}
}

module add_hump() {
	hump_dimensions = [HUMP_WIDTH, LENGTH-HUMP_DEPTH, HUMP_HEIGHT];
	difference() {
		union() {
			children();
			translate(
				[WALL_THICKNESS, HUMP_DEPTH-WALL_THICKNESS, WALL_THICKNESS*2]
			)
				cube(hump_dimensions);
		}
		translate([-1e-3, HUMP_DEPTH+1e-3, -1e-3])
			cube(hump_dimensions);
	}
}

module dividers() {
	for (x = VERTICAL_DIVIDERS) {
		translate([x + WALL_THICKNESS, 0, WALL_THICKNESS*2])
			cube([WALL_THICKNESS, LENGTH, DIVIDER_HEIGHT]);
	}

	for (y = HORIZONTAL_DIVIDERS) {
		translate([0, y+WALL_THICKNESS, WALL_THICKNESS*2])
			cube([WIDTH, WALL_THICKNESS, DIVIDER_HEIGHT]);
	}
}

module complete_box() {
	add_hump() {
		union() {
			base_box();
			dividers();
		}
	}
}

module face() {
	union() {
		cube([FACE_WIDTH, FACE_THICKNESS, FACE_HEIGHT-FACE_RADIUS]);

		translate([FACE_RADIUS, 0, FACE_HEIGHT-FACE_RADIUS]) {
			rotate([-90, 0, 0]) {
				cylinder(FACE_THICKNESS, FACE_RADIUS, FACE_RADIUS);
			}
		}
		translate([FACE_WIDTH-FACE_RADIUS, 0, FACE_HEIGHT-FACE_RADIUS]) {
			rotate([-90, 0, 0]) {
				cylinder(FACE_THICKNESS, FACE_RADIUS, FACE_RADIUS);
			}
		}

		translate([FACE_RADIUS, 0, FACE_HEIGHT-FACE_RADIUS])
			cube([FACE_WIDTH-2*FACE_RADIUS, FACE_THICKNESS, FACE_RADIUS]);
	}
}

module box_with_face() {
	union() {
		translate([(FACE_WIDTH-WIDTH)/2, FACE_THICKNESS, 0])
			complete_box();
		face();
	}
}

module with_finger_hole() {
	difference() {
		box_with_face();
		translate([FACE_WIDTH/2, -1e-3, FACE_HEIGHT*3/5]) {
			rotate([-90, 0, 0]) {
				cylinder(
					FACE_THICKNESS+WALL_THICKNESS+2e-3,
					FINGER_HOLE_RADIUS,
					FINGER_HOLE_RADIUS
				);
			}
		}
	}
}

mirror([SIDE == "right" ? 1 : 0, 0, 0]) {
	with_finger_hole();
}
