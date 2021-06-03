/*
 * Parametric Cable Raceway and Lid
 * =======================================================================================
 * remixed from an amazing design by Thomas Hessling
 * remix by Kayos Maker
 *
 * Parametric cable duct creator / raceway & lid with OpenSCAD
 * Copyright (C) 2021  Kayos Maker     <faithblinded@gmail.com>
 * Copyright (C) 2019  Thomas Hessling <mail@dream-dimensions.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see https://www.gnu.org/licenses/.
 *
 * ========================================================================================
 *
 *      Features
 * - fully parametric width, height, and length
 * - separate length and width variables for the lid, for increased flexibility
 * - parametric cable slots that maintain static spacing across any length, width, or height of raceway
 * - optional keyholes to improve cable carrying capacity of each slot without the need to use wider slots
 * - optional mounting holes along raceway bottom, on user defined centers, starting at a user defined distance from raceway end
 * - imprinted text on the lid
 * - able to render just the raceway, just the lid, to allow the creation of separate stl's
 * - optional "skeletonized" raceway with punched out raceway bottom saves material(may be incompatible with mounting holes)
 *
 *      USAGE NOTES
 *
 *
 * ========================================================================================
 *
 *      Current Version v2.60 (5-18-2021)
 *
 *      Changelog
 * v2.60 - add plastic saving "skeletonizing" feature for raceway base    (5-18-2021)
 * v2.50 - fix User Variables section formatting to work with customizer
 * v2.46 - fix slot count equation to speed rendering(and count accurately)
 * v2.45 - add optional raceway mounting holes
 *       - fix some erroneous math and remove redundant factors 
 *       - seperated slot rounding from keyholes and fixed how keyholes are located to prevent model errors
 * v2.40 - remove resource intensive rcube function for slots and add keyhole instead.  both renders faster, and increases versatility
 * v2.33 - remove unwanted optional lid style
 * v2.32 - add seperate lid width variable
 * v2.31 - add feature wishlist to motivate myself  
 * v2.30 - add separate lid length variable
 * v2.21 - fixed some really dumb equation errors of mine
 * v2.20 - rounded bottoms of slots using rcube function(hulled spheres)
 * v2.10 - change slot assignment and spacing variables to stay static across different lengths of raceway
 * v2.00 - change variable naming and formatting to my taste  (my neurosis, no insult to the original author)
 * v2    - establish new version for my fork/changes
 * 
 * =======================================================================================
 *       
 *      Original Author's ChangeLog
 * v1.1a   - Changed the license to GPLv3. (2019-09-21)
 * v1.1    - Add some custom text to your duct's cover (2019-08-03)
 *         - Option to create a cover with the same width as the duct, for narrow places
 * v1.0    - model creation works, first print successful. (2019-07-28)
 * ========================================================================================
 *
 *      Feature Wishlist
 * - entry port option for single large diameter hole in raceway bottom, located wherever the user wants
 * - corner pieces
 * - optional interlocking ends for long runs (only on raceways, not lids. kinda like those wooden toy train tracks is what im thinking)
 * - optional cable hold down clips that match the selected slot width(primarily to assist layout before the lids are in place)
 * - optional slots in the lid to reduce material usage, improve airflow, and maybe look cool
 * - insertable text as seperate item (should be easyish to add this using the code already in the file, with perhaps a dedicated tolerance variable, and added to the list of "what to render")
 * - optional 2 line text stamping for lids 
 * - optional logo/vector file stamping for lids
 * - optional honeycomb style lids
 * - optional cable combs at intervals  (steal code from literal comb design found on thingi)
 * - option to center the slots across the raceway length, at the given spacing, instead of starting with a full tooth and ending where it ends, even if its mid slot.  this way the spacing would be locked, but the first and last tooth of the raceway would be equal in length to each other
 * - same as above but for mounting holes(optional)
 * - add countersink option to mounting holes
 * - fix rw_height to reflect combined outside dimensions rather than just the raceway height - half assed fix in place until I can decipher original author's equations - rw_height is used in damn near every calculation for the 2d shapes that are extruded and unweaving the mess to fix the height problem properly might be over my head.  the hack solution I put in place works and gives a raceway+lid with an overall height that match the figure defined for the variable.
*/
// =========================================================================================
//      User Definable Variables
//      all measurements in mm

/*[PRIMARY DIMENSIONS (all in mm)]*/
//Raceway Overall Length
rw_length = 150;           

//Lid Length - It can be useful to print the lid longer than the raceway where panel openings occur, to hide wires entering the raceway, or in shorter lengths to use multiple colors / text labels
rw_lid_length = 150;

//Raceway Overall Width - Outside Dimensions
rw_width = 30;	  

//Lid Width - This should generally be the same as your raceway width.  Tall raceways, thin shells, and flexible mats like ABS can lead to a loose feeling lid fit regardless of tolerance. Reducing the lid width can mitigate this effect and snug up the fit considerably.  Print short test pieces before committing to large prints of raceways.
rw_lid_width = 30;

//Raceway Height - Outside Dimensions Including Lid
rw_height = 20;

//Slot Density - Number of slots per 100mm of raceway.  Raceway can be any length. 100mm is just an arbitrary figure that makes it easy to conceptualize the spacing.  If you keep slot density and slot width fixed, any combination of raceway lengths, widths, and heights will have slots that line up with each other.  In this way you can create a custom raceway set to perfectly fit your device, that all share the same slot configuration.
rw_slot_density = 8;

//Cable Slot Width - Measure to make sure the slots are at least wide enough for your widest wiring to slide into.
rw_slot_width = 2.5;

//Shell Thickness - 1.2 shell with .4 nozzle works well for most materials.  You can reduce the flex of tall fingers by increasing shell thickness, though it will cost more filament.  Reducing Lid Width very slightly may be a more economical solution.
rw_shell = 1.2;

//Keyhole Diameter - Places a keyhole at the slot bottom to allow a single narrow slot to carry more wires without them stacking in the slot.  This feature can break the model, and even without breaking it, can produce extreme overhangs.  A good general rule is use a keyhole diameter no more than twice the Slot Width.  Entering a value lower than the slot width will simply result in plain rounded bottoms for each slot.
kh_dia = 3.5;


/*[WHAT TO RENDER]*/

//Determines which components to render.  This is useful for creating seperate stl's of the individual components.
part = "both";  //[both,raceway,lid]


/*[MOUNTING HOLES]*/

//Enables mounting holes along raceway bottom - 0:false, 1:true
punch_holes = 0;//[0,1]

//Mounting Hole Spacing - Center to center spacing of holes.
mnt_hole_spacing = 80;              

//First Mounting Hole Position - Distance from the end of the raceway to the center of the first hole.
mnt_hole_pos = 20;

//Mounting Hole Diameter
mnt_hole_dia = 4.5;
                                    

/*[MATERIAL SAVER RACEWAY]*/
//Enables plastic saving skeletonized cutouts along raceway bottom.  May not work with very short raceways. - 0:false, 1:true
saver_track = 1; //[0,1]


/*[LID TEXT]*/
//Enable stamped text on lid.  0:false, 1:true
text_enable = 0;//[0,1]        

//Text to stamp on lid.
text_string = "Your Text Here";

//Stamping Depth - should be a multiple of layer height.  Consider your selected shell thickness when selecting a value here.  You can simply stamp your text, or you can punch it all the way through(by choosing a value higher than the shell thickness).  The choice is yours.
text_depth = 0.6;                  

//Vertical Scaling of the text relative to raceway width.
text_scale = 0.6;

//Font to use - it must be installed on the rendering machine.
text_font = "Play-Bold";            



/*[LID to RACEWAY INTERFACE - experts only - make small changes one at a time and render to observe what each value does to the interface]*/
//Interface height
int_height = 5;

//Interface Angle - 45 degrees recommended, as almost all well tuned FDM printers can handle it with no supports. 
int_angle = 45;                      

//Interface Depth
int_depth = 2;                       

//Interface offset from top of teeth/inside of lid
int_top_offset = 0.6;                

//Tolerance between raceway and lid.  This figure is most important to rigid materials like PLA.  With ABS you may reduce this to 0 and still find the lid fit is not as tight as you want.  That is down to tooth flex.  Use lid width to adjust for fitment if tolerance doesn't help.
int_top_tolerance = 0.1;             




                                    
//--------------------------------------------------------------------------------------------------
//      End User Definable Variables
//      experiment below at your own risk
//      if you fix my mess or add features, consider sharing the result -KM

/* [Hidden] */

//safety offset for boolean operations, prevents spurious surfaces
s = 0.01;

//calculations to help rendering
rw_finger_width = (100 - (rw_slot_width * rw_slot_density)) / (rw_slot_density + 1);	         
rw_slot_spacing = rw_slot_width + rw_finger_width; 
rw_slots = rw_length / (rw_slot_width + rw_finger_width);
rw_hwidth = rw_width/2;
rw_ht_for_calcs = rw_height - rw_shell;  
// rw_ht_for_calcs is half assed and I hate it - since the original design produces a combined raceway/lid with a height exactly one shell thickness taller than the user entered height, this is a corrected height variable which is then used in the file rather than the entered value - i hate it please help me do it right and fix the polygon drawing with a simple -rw_shell added in the right spot.  i cant figure out where to put it with how woven into the file this variable is

mounting_holes = ((rw_length - mnt_hole_pos) / mnt_hole_spacing)+1;

//Material Saver Calculations 
//  creates cutouts along the raceway to save plastic.  they will be automatically sized, spaced, and centered
saver_hole_dia = (rw_width - (2 * rw_shell)) * 0.8;  //each cutout will have a diameter 80% of the inside width of the raceway
saver_holes_calc = (rw_length - (saver_hole_dia / 2)) / (2 * saver_hole_dia);   //calculates how many cutouts will fit on the raceway length
saver_holes = floor(saver_holes_calc);//rounds down server holes # to avoid errors in future calculations
saver_hole_spacing = (rw_length - ((saver_hole_dia * 1.5) * saver_holes))/(saver_holes+1);//calculates spacing between cutouts

//---------------------------------------------------------------------------------------------------

//Create the part
render()
print_part();


//Create the part based on the part-variable: raceway, lid or both

module print_part()
{
	if (part == "raceway") {
		create_raceway();		
	} else if (part == "lid") {
		create_lid();		
	} else if (part == "both") {
		create_raceway();
		create_lid();
	}
}



//Create each children and a mirrored version of it along the given axis.

module create_and_mirror(axis)
{
	for (i=[0:$children-1]) {
		children(i);
		mirror(axis) children(i);
	}	
}




//Generates a trapezoidal profile that serves as a mounting feature for a	lid.

module clip_profile(forlid)
{
	//Make the the angle is properly defined and does not lead to geometry errors  
	assert(int_angle > 0, "The angle must be greater than 0 deg.");
	assert(int_angle <= 90, "The angle cannot be greater than 90 deg.");
	assert(int_depth*tan(90-int_angle)*2 <= int_height, 
		   "The mounting feature length is too small. Increase length or the angle.");
	
	polyp = [[0,0], 
			 [0,-int_height], 
			 [int_depth,-int_height+int_depth*tan(90-int_angle)], 
			 [int_depth,-int_depth*tan(90-int_angle)]];
	polygon(polyp);
}



//Cut profile for the interior of the rectangle, taking into account the lid interface.

module inner_raceway_profile()
{
	
    
    polygon([[rw_hwidth-2*int_depth-rw_shell, rw_ht_for_calcs+s],
     [rw_hwidth-2*int_depth-rw_shell, rw_ht_for_calcs-int_height-int_top_offset],
     [rw_hwidth-rw_shell, rw_ht_for_calcs-int_height-int_top_offset-2*int_depth*tan(45)],
     [rw_hwidth-rw_shell, rw_shell],
     [0, rw_shell],
     [0, rw_ht_for_calcs+s]]);
}


//The raceway's cross-sectional profile, used in an extrusion.

module create_raceway_profile()
{
	
//Basic shape: rectangle
//Subtract the mounting features from it, and also the interior bulk.
//This then serves as an extrusion profile.	
	
	difference() {
		difference() {
			difference() {
				scale([rw_width, rw_ht_for_calcs])
				translate([-0.5, 0])
				square(1, center=false);				
					union() {
						create_and_mirror([1, 0]) {
							translate([-rw_width/2-s+rw_shell+int_top_tolerance, rw_ht_for_calcs-int_top_offset])
							clip_profile();
							translate([-rw_width/2, rw_ht_for_calcs-int_top_offset])
							polygon([[0,int_top_offset],
									 [rw_shell+int_top_tolerance, int_top_offset],
									 [rw_shell+int_top_tolerance, -int_height],
									 [rw_shell+int_top_tolerance*(1-cos(int_angle)), -int_height-int_top_tolerance*cos(int_angle)],
									 [0, -int_height-int_top_tolerance*cos(int_angle)]]);
						}
					}				
			}
		}
		union() {
			create_and_mirror([1,0]) {
            inner_raceway_profile();
			}
		}
	}
}


//Create the lid profile to be extruded.

module create_lid_profile()
{
	union() {
                
		create_and_mirror([1,0]) {
			translate([rw_lid_width/2+int_top_tolerance, rw_ht_for_calcs-int_top_offset, 0])
			mirror([1, 0])
			clip_profile(1);
		}
		
		polygon([[rw_lid_width/2+int_top_tolerance, rw_ht_for_calcs-int_top_offset-int_height],
				 [rw_lid_width/2+int_top_tolerance, rw_ht_for_calcs+int_top_tolerance],
				 [-rw_lid_width/2-int_top_tolerance, rw_ht_for_calcs+int_top_tolerance],
				 [-rw_lid_width/2-int_top_tolerance, rw_ht_for_calcs-int_top_offset-int_height],
				 [-rw_lid_width/2-int_top_tolerance-rw_shell, rw_ht_for_calcs-int_top_offset-int_height],
				 [-rw_lid_width/2-int_top_tolerance-rw_shell, rw_ht_for_calcs+int_top_tolerance+rw_shell],
				 [rw_lid_width/2+int_top_tolerance+rw_shell, rw_ht_for_calcs+int_top_tolerance+rw_shell],
				 [rw_lid_width/2+int_top_tolerance+rw_shell, rw_ht_for_calcs-int_top_offset-int_height],
				]);
	}
}


//Extrude the raceway's cross-section profile, cut boxes in regular distance to create the
//"slots", punch holes at bottom of slots to create rounded bottoms, then add keyholes if feature is used

module create_raceway()
{
	rotate(90, [1, 0, 0])
	difference() {
		linear_extrude(height=rw_length, center=false)
		create_raceway_profile();
                
		union() {
            //cut rectangular slots
			for (i = [0:rw_slots-1]) {
				translate([-rw_width/2, 2*rw_shell+(rw_slot_width/2), (i*rw_slot_spacing) + rw_finger_width])
				cube([rw_width+rw_slot_width*2, rw_ht_for_calcs+1, rw_slot_width]); 
			}
            //cut round slot ends
            for (i = [0:rw_slots-1]) {
				translate([-rw_width/2, 2*rw_shell+(rw_slot_width/2), (i*rw_slot_spacing) + rw_finger_width+ (rw_slot_width/2) ])
                rotate(90, [0,1,0])
				cylinder(h = rw_width, r = rw_slot_width / 2 , $fn=32); 
			}
            //cut keyholes if enabled
            for (i = [0:rw_slots-1]) {
				translate([-rw_width/2, 2*rw_shell+(kh_dia/2), (i*rw_slot_spacing) + rw_finger_width+ (rw_slot_width/2) ])
                rotate(90, [0,1,0])
				cylinder(h = rw_width, r = kh_dia/2 , $fn=32); 
			}
            //cut mounting holes if enabled
            for (i = [0:mounting_holes-1]) {
                translate([0, rw_shell/2,(i*mnt_hole_spacing) + mnt_hole_pos])
                rotate(90, [-1,0,0])
                cylinder(h = rw_shell, r = (mnt_hole_dia / 2) * punch_holes, center=true, $fn=32);
            }
            //cut material saver holes if enabled
            for (i = [0:saver_holes-1]) {
                translate([0, rw_shell/2,(i*(saver_hole_spacing + (1.5 * saver_hole_dia))) + (saver_hole_dia / 2) + saver_hole_spacing])
                rotate(90, [-1,0,0]) hull(){
                  translate([0, 0, 0,]) cylinder(h = rw_shell, r = (saver_hole_dia / 2) * saver_track, center=true, $fn=32);
                  translate([0,  (-saver_hole_dia * 0.5), 0]) cylinder(h = rw_shell, r = (saver_hole_dia / 2) * saver_track, center=true, $fn=32);
                }
            }  
		}
	}
	
}


//Create a lid for the raceway.

module create_lid() 
{
    difference() {
        translate([2*rw_lid_width, 0, rw_ht_for_calcs+int_top_tolerance+rw_shell])
        rotate(180, [0, 1, 0])
        rotate(90, [1, 0, 0])
        linear_extrude(height=rw_lid_length, center=false)
        create_lid_profile();

        if (text_enable) {
            translate([2*rw_lid_width, -rw_lid_length/2, -s+0.6])
            rotate(90, [0, 0, -1])
            rotate(180, [1, 0, 0])
            linear_extrude(height=text_depth, center=false)
            text(text_string, rw_lid_width*text_scale, text_font, valign="center", halign="center", $fn=32);
        }
    }
}



