#include "colors.inc"
#include "transforms.inc"
#include "textures.inc"

#declare CamLoc = <0, 0, -5>;
#declare CamLocTop = <0,5,0>;
#declare CamLook = <0,0,0>;
camera
{
  location CamLoc
  look_at CamLook
}

light_source
{
  CamLoc
  color White
}

// create a regular point light source
light_source {
  <0,100,-50>                 // light's position (translated below)
  color rgb <1,1,1>    // light's color
}



polygon {
 4,
 <1,1><-1,1><-1,-1><1,-1>
 texture{ pigment{ julia <-0.151,1.0285>, 40 
                color_map {[0.0 color rgbt <0,0,0,1>]
                           [0.95 color White]}
                rotate -20*z
               }
                 normal { julia <-0.15,1.03>, 40
                          scale 1.0 turbulence 0}
               } // end of texture

}