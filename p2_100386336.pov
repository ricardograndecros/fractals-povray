#include "tree_cloud.inc"
#include "lightning.inc"

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








object {tree_cloud}

object {lightning_polygon translate<-1,-2,3> scale<0,0,0>}



 

