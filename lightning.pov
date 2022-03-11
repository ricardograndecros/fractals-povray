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
                color_map {[0.0 color rgbt <1,1,1,1>]
                           [0.95 color White]}
                rotate -20*z
               }
                 normal { julia <-0.151,1.0285>, 40  rotate -20*z
                          scale 1.0 turbulence 0} 
                          
                 finish { reflection 0}
               } // end of texture

}       

// sky ---------------------------------------------------------------------
#include "skies.inc"
sky_sphere{ S_Cloud4  // 1 - 5
            scale 1         
          } //end of skysphere
//--------------------------------------------------------------------------
/*
// fog ---------------------------------------------------------------------
fog{ fog_type   2
     distance   50
     color      White*0.5
     fog_offset 0.1
     fog_alt    2.0
     turbulence 0.8
   } // end of fog
//--------------------------------------------------------------------------
*/ 


