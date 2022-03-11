#include "colors.inc"
#include "transforms.inc"
#include "textures.inc"


// create a regular point light source
light_source {
  <0,100,-50>                 // light's position (translated below)
  color rgb <1,1,1>    // light's color
}



#declare lightning_polygon = polygon {
 4,
 <1,1><-1,1><-1,-1><1,-1>
 texture{ pigment{ julia <-0.151,1.0285>, 40 
                color_map {[0.00 color rgbt <1,1,1,1>]
                           [0.95 color White]}
                rotate -20*z
               }
                 normal { julia <-0.15,1.03>, 40
                          scale 1.0 turbulence 0}
                          
                 finish { reflection 0 }
               } // end of texture

}