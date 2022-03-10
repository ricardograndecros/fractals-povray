#include "tree_cloud.inc"

object {tree_cloud}

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
               
         translate <-1,-1.5,1>

}


 

