#include "tree_cloud.inc"
#include "lightning.inc"

#declare CamLoc = <0, 2, -10>;
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


// sky ---------------------------------------------------------------------
#include "skies.inc"
sky_sphere{ S_Cloud4  // 1 - 5
            scale 1         
          } //end of skysphere
//--------------------------------------------------------------------------

// fog ---------------------------------------------------------------------
fog{ fog_type   2
     distance   50
     color      White*0.5
     fog_offset 0.1
     fog_alt    2.0
     turbulence 0.8
   } // end of fog
//--------------------------------------------------------------------------









object {tree_cloud translate<0,2,0>}

//object {lightning_polygon translate<-1,-2,3> scale<0,0,0>}



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
  texture {pigment {color Red}}

 } //------------------------------------------------------ end of blob object  
 
 
#declare square_polygon = polygon {4, <4,0,4>,<-4,0,4>,<-4,0,-4>,<4,0,-4>}    


intersection {object{blob1} object{square_polygon} material{water_texture} scale <2,0,2>}    