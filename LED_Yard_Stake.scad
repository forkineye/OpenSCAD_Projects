/*
* LED_Yard_Stake.scad
*
* Project: LED Yard Stake - Parametric yard steak for low wattage LED modules
* Copyright (c) 2016 Shelby Merrick
* http://www.forkineye.com
*
*  This program is provided free for you to use in any way that you wish,
*  subject to the laws and regulations where you are using it.  Due diligence
*  is strongly suggested before using this code.  Please give credit where due.
*
*  The Author makes no warranty of any kind, express or implied, with regard
*  to this program or the documentation contained in this document.  The
*  Author shall not be liable in any event for incidental or consequential
*  damages in connection with, or arising out of, the furnishing, performance
*  or use of these programs.
*
*/

/******************************/
/***** USER CONFIGURATION *****/
/******************************/

base_width = 90;        // Internal width, where LED mounts
base_depth = 14;        // Internal depth, where LED mounts

shroud_height = 20;     // Height of shroud, from bottom of base
shroud_angle = 40;      // Projection angle of shroud
shroud_thickness = 1.6; // Wall thickness of shroud

stake_length = 80;      // Length of ground stake
stake_angle = 45;       // Angle of ground stake
stake_thickness = 1.6;  // Thickness of stake spikes

/*************************************/
/***** END OF USER CONFIGURATION *****/
/*************************************/

// Globals - Don't change
width = base_width + shroud_thickness * 2;
depth = base_depth + shroud_thickness * 2;

// Bottom of shroud
module base() {
    cube([width, depth, 2]);
}

// Sides of shroud
module sides() {
    // Front
    translate([0, shroud_thickness, 0]) mirror([0,1,0]) side(width);
    
    // Back
    translate([0, depth - shroud_thickness, 0]) side(width);
    
    // Left Side
    translate([shroud_thickness, 0, 0]) rotate(a=90, v=[0,0,1]) side(depth);
    
    // Right Side
    translate([width - shroud_thickness, depth, 0]) rotate(a=-90, v=[0,0,1]) side(depth);
}

// Polyhedron for a single side
module side(_width) {
    height = shroud_height;
    thick = shroud_thickness;
    offset = shroud_height / (tan(90 - (shroud_angle / 2)));
    
    points = [
      [0, 0, 0],                                    //0
      [_width, 0, 0],                               //1
      [_width, thick, 0],                           //2
      [0, thick, 0],                                //3
      [-offset, offset, height],                    //4
      [_width + offset, offset, height],            //5
      [_width + offset, thick + offset, height],    //6
      [-offset, thick + offset, height]];           //7
      
    faces = [
      [0,1,2,3],  // Bottom
      [4,5,1,0],  // Front
      [7,6,5,4],  // Top
      [5,6,2,1],  // Right
      [6,7,3,2],  // Back
      [7,4,0,3]]; // Left
      
    polyhedron(points, faces);
}

// Ground Stake
module stake() {
    thick = shroud_thickness;
    height = stake_length * cos(stake_angle);
    offset = stake_length * sin(stake_angle);

    faces = [
      [0,1,2,3],  // Bottom
      [4,5,1,0],  // Front
      [7,6,5,4],  // Top
      [5,6,2,1],  // Right
      [6,7,3,2],  // Back
      [7,4,0,3]]; // Left
    
    pointsY = [
      [0, 0, 0],                                            //0
      [thick, 0, 0],                                        //1
      [thick, depth, 0],                                    //2
      [0, depth, 0],                                        //3
      [0, depth / 2 - (thick / 2) - offset, -height],       //4
      [thick, depth / 2 - (thick / 2) - offset, -height],   //5
      [thick, depth / 2 + (thick / 2) - offset, -height],   //6
      [0, depth / 2 + (thick / 2) - offset, -height]];      //7
      
    translate([width / 2 - thick / 2, 0, 0])
        polyhedron(pointsY, faces);
    
    pointsX = [
      [0, depth / 2, 0],                                                //0
      [depth, depth / 2, 0],                                            //1
      [depth, depth / 2 + thick, 0],                                    //2
      [0, depth / 2 + thick, 0],                                        //3
      [0 + depth / 2, depth / 2 - (thick / 2) - offset, -height],       //4
      [thick + depth / 2, depth / 2 - (thick / 2) - offset, -height],   //5
      [thick + depth / 2, depth / 2 + (thick / 2) - offset, -height],   //6
      [0 + depth / 2, depth / 2 + (thick / 2) - offset, -height]];      //7
    
    translate([width / 2 - depth / 2 - thick / 2, 0, 0])
        polyhedron(pointsX, faces);    
}

// Flip everything upside down for printing
mirror([0,0,1]) {
    base();
    sides();
    stake();
}