#include "tree_cloud.inc"
#include "lightning.inc" 
#include "rain_macros.inc"

#declare CamLoc = <0, 1, -6>;
#declare CamLocTop = <0,5,0>;
#declare CamLook = <0,4,6>;
camera
{
  location CamLoc
  look_at CamLook
}

light_source
{
  CamLoc
  //<100,10, -70>
  color rgb<0.8,0.5,0.6>
}          


// sky ---------------------------------------------------------------------
#include "skies.inc"
sky_sphere{ S_Cloud3  // 1 - 5
            scale 1         
          } //end of skysphere
//--------------------------------------------------------------------------
/*
// starry sky ----------------
#include "stars.inc"
sphere{ <0,0,0>, 1
        texture{ Starfield1 scale 0.05
               } // end of texture
        scale 10000
      } //end of sphere ---------------
*/

// fog ---------------------------------------------------------------------
/*
fog{ fog_type   2
     distance   20
     color      White*0.5
     fog_offset 0.1
     fog_alt    2.0
     turbulence 0.8
   } // end of fog
*/
//--------------------------------------------------------------------------









object {tree_cloud translate<0,2,0>}

object {lightning_polygon translate<-0.7,0.6,0> scale<0,0.0,0>}


#declare tree2 = union {
   FractalTree(<0,-2,0>,<0,1,0>,1,10,0.17)  
   //rotate 90*x
   translate<5,2,7>
}
object{tree2}

#declare tree3 = union {
   FractalTree(<0,-2,0>,<0,1,0>,1,7,0.14)  
   //rotate 90*x
   translate<-5,2,7>
}
object{tree3}

/* WATER */
#declare water_texture = material{
          texture {
            pigment {
              color rgbt <0.2, 0.7, 0.3, 0.5>
            }
            finish {
              ambient 0.0 // cambia color del agua cuando no es completamente transparente
              diffuse 0.0
        
              reflection {
                0.0, 1.0 // varaible reflection (cambia según el ángulo en el que incide la luz)
                fresnel on
              }
        
              specular 0.8
              roughness 0.03
            }
            normal {
                function {
                    f_ridged_mf(x, y, z, 0.1, 3.0, 7, 0.7, 0.7, 2)
                } 0.8
                scale <0.13, 0.4, 0.13>
          }
          }
          interior {
            ior 1.3 
            fade_distance 4
            fade_power 1001
            media {
            scattering { 3 <0.5, 0.65, 0.4> }
            }
          }
 }  
                                                                          


#declare Strength = 1.0; //(+ or -) strength of component's radiating density
#declare Radius1  = 1.0; //(0 < Radius) outer sphere of influence on other components
#declare blob1 = blob{
  threshold 0.6 // threshold (0.0 < threshold <= Strength) surface falloff threshold #
  sphere{< 0.75,  0,   0>, Radius1, Strength scale <1,1,0.5>}
  sphere{<0.375,0,0>, Radius1, Strength}
  sphere{<-0.375,0,.6>, Radius1, Strength} 
  sphere{<0.475,0,.31>, Radius1, Strength}
  sphere{<-0.575,0,-0.26>, Radius1, Strength}
  //cylinder{<-1.50,0,0>,< -0.25,1.50,0>, Radius1, Strength}
  sturm 
  texture {pigment {color rgbt<1,1,1,1>}}

 } //------------------------------------------------------ end of blob object  
 
 
#declare square_polygon = polygon {4, <4,0,4>,<-4,0,4>,<-4,0,-4>,<4,0,-4>}    


//#declare watter_pudle_depth = difference {object{blob1} box{<}   }
#declare water_puddle = intersection {object{blob1} object{square_polygon} material{water_texture} scale <1.7,0,1.8> translate<0,0.01,0>}  
object {water_puddle}
 
#declare FelbriggSand = texture {
 pigment {color rgb < 1, 0.9, 0.65>}
 normal {granite 0.1 scale 0.02
 }
        normal { bumps 0.4 scale 0.1
}
 finish {
  brilliance 1.6
  specular 0.3
  ambient 0.05
 }
}
 

//---------------------------------------------------------------------
#declare desert = height_field{ png "Mount1.png" smooth double_illuminate
              // file types: 
              // gif | tga | pot | png | pgm | ppm | jpeg | tiff | sys
              //water_level 0 // truncate/clip below N (0.0 ... 1.0)
              scale<50,1.75,50>*1 
              texture{ pigment { color rgb <0.82,0.6,0.4>}
                       normal  { bumps 0.75 scale 0.015  }
                     } // end of texture
              translate<-20,0,-8>
              rotate<0, 0,0>
              
            } // end of height_field ----------------------------------
//---------------------------------------------------------------------

   
 
#declare r_rain=seed(2802); 
 
rain_over(1000,<2.6,2,1.5>,<10,0,0>,.15,int(1000*rand(r_rain))) 

rain_splashes_with_rings(water_puddle,50,<2.6,1.75,1.5>,.25,int(1000*rand(r_rain)))         


difference {object{desert} object{blob1 scale <1.8,0,1.3>} 
            texture{ pigment { color rgb <0.82,0.6,0.4>}
                       normal  { bumps 0.75 scale 0.015  }
                     } // end of texture   
}   

plane { <0,1,0>, 0  hollow // normal vector, distance to zero ----

        texture{ pigment { color rgb <0.82,0.6,0.4>}
                       normal  { bumps 0.75 scale 0.015  }
                     } // end of texture>
        translate<0,-10,0>
      } // end of plane ------------------------------------------
      
