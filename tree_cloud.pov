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


/*
#declare Init_Height    = 12;
#declare Spread_Ang     = 10;
#declare Branches       = 10;
#declare Scaling_Factor = 0.5;

#macro Stick(P0, P1)
  cylinder {
    P0, P1, 0.02
    texture { pigment { Green } }
  }
#end

#macro FractalTree(O, D, S, R, B)
  #if (B > 0)
    Stick(O, O+D*S)
    FractalTree(O+D*S, vtransform(D, transform{rotate y*R}),
      S*Scaling_Factor, R, B-1)
    FractalTree(O+D*S, vtransform(D, transform{rotate -y*R}),
      S*Scaling_Factor, R, B-1)  
      FractalTree(O+D*S, vtransform(D, transform{rotate -y*R}),
      S*Scaling_Factor, R, B-1)
  #end
#end

union {
  FractalTree(<-2,0,0>, <1,0,0>, 1, Spread_Ang, Branches)
}     
*/

#declare tree_height = 10;
#declare branching_factor = 15;
#declare scaling_factor = 0.75;
#declare radius_decay = 0.55;
#declare min_spread_angle = 12;
#declare max_spread_angle = 40;
#declare random_generator = seed(10);


#declare Stem_Texture =
texture{ pigment{ color rgb< 0.85, 0.6, 0.40>*0.25}
        normal{bumps 0.45 scale<0.015,0.045,0.015>}
         finish { phong 0.05 }}

#macro Section(Start, End, base_radius, top_radius)
    cone{
        Start, base_radius, End, top_radius
        texture{ Stem_Texture
        } // end of texture

    }                               
#end
      
     
#macro FractalTree(Origin, Destination, Size, Branches, Radius)
    #if (Branches > 0)
        Section(Origin, Origin+Destination*Size, Radius, radius_decay*Radius)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0,(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle)>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0,-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle)>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
    #end

#end

#declare tree = union {
   FractalTree(<0,-2,0>,<0,1,0>,1,branching_factor,0.17)  
   //rotate 90*x
}    

#declare cloud = sphere { 0,2 hollow no_shadow
  texture { pigment { rgbt 1 } }
  interior {
    media { absorption 8 emission 8 method 3 samples 30,30 intervals 1
      density { spherical
        warp { turbulence .75*.3+.05 lambda 2.75 }
        density_map {
          [1-.99*.75 rgb <0,0,0>]
          [1-.99*.75 rgb <max(0,1-.75*1.5),max(0,1-.75*4.5),max(0,1-.75*6)>]
          [1 rgb <.75,.25,0>] }
      }
    }
   
    media { absorption 3 scattering { 1 .3 } method 3 samples 30,30 intervals 1
      density { spherical
        warp { turbulence .75*.3+.05 lambda 2.75 }
        density_map {
          [1-.99*.75 rgb 0]
          [1-.99*.75 rgb 1]
          [1-.49*.75 rgb 1]
          [1-.49*.75 rgb 0]
         }
      }
    }
  }
  scale<2.5,1.2,3.0> translate<-0.2,0.3,0.0>
}

#declare tree_cloud = union {object{tree} object{cloud}}
 
 
object {tree}    