#include "colors.inc"
#include "transforms.inc"
#include "textures.inc"

#declare CamLoc = <0, 5, 0>;
#declare CamLook = <0,0,0>;
camera
{
  location CamLoc
  look_at CamLook
  rotate y*90
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
#declare radius_decay = 0.7;
#declare min_spread_angle = 12;
#declare max_spread_angle = 40;
#declare random_generator = seed(23);

#macro Section(Start, End, base_radius, top_radius)
    cone{
        Start, base_radius, End, top_radius 
         texture{ Tom_Wood    
                normal { wood 0.25 scale 0.05 turbulence 0.15 rotate<0,0,0> }
                finish { phong 1 } 
                rotate<0,0,0> scale 0.5 translate<0,0,0>
              } // end of texture 
    }                               
#end

#macro FractalTree(Origin, Destination, Size, Branches, Radius)
    #if (Branches > 0)
        Section(Origin, Origin+Destination*Size, Radius, radius_decay*Radius)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        /*FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate <-45-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),-(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle),0>}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate x*(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle)}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)
        FractalTree( Origin+Destination*Size, vtransform(Destination, transform{rotate -x*(rand(random_generator)*(max_spread_angle-min_spread_angle+1)+min_spread_angle)}), 
                        Size*scaling_factor, int((Branches)*rand(random_generator)), Radius*radius_decay)*/
    #end

#end

union {
   FractalTree(<-2,0,0>,<1,0,0>,1,branching_factor,0.07)  
   //rotate 90*x
}    
