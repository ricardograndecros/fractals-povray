#include "colors.inc"
#include "transforms.inc"
#include "textures.inc"


// create a regular point light source
light_source {
  <0,100,-50>                 // light's position (translated below)
  color rgb <1,1,1>    // light's color
}



#declare lightning_polygon = polygon {
  7,
 <0.3,0.8><0.1,0.9><-0.2,0.9><-0.1,0.9><-1,1.25><-1,-2><1.0,-2>
 texture{ pigment{ julia <-0.151,1.0285>, 40 
                color_map {[0.15 color rgbt <1,1,1,1>]
                           [0.95 color rgb <0.5,0.8,1>]}
                rotate -20*z
               }
                 normal { julia <-0.151,1.0285>, 40  rotate -20*z
                          scale 1.0 turbulence 0} 
                          
                 finish { reflection 0}
               } // end of texture 
               no_shadow

}                                         




