/*
  Rain macros
  --
  Jaime Vives Piqueres, 2007-2008.
*/

// auxiliar objects & macros
// + rain drop
#declare p_drop_base=
pigment{
 function{abs(y)}
 pigment_map{
  [0 rgb 1]
  [1 rgbt 1]
 }
}
#declare t_drop=
texture{
 pigment{
  cylindrical
  pigment_map{
   [0 p_drop_base]
   [.75 p_drop_base]
   [1 rgbt 1]
  }
 }
 finish{ambient 1}
}
#declare rain_drop=
cylinder{-y,y,.02
 texture{t_drop}
 scale .5
 double_illuminate
}
// + splash
#declare t_splash=
texture{
 Mirror
}
#declare splash_torus=
intersection{
 torus{1,.5
  texture{
   gradient y turbulence .33 scale <.02,1,.02>
   warp{toroidal}
   texture_map{
    [0 t_splash]
    [0.25 t_splash]
    [.25 pigment{rgbt 1} finish{ambient 0 brilliance 0}]
    [1 pigment{rgbt 1} finish{ambient 0 brilliance 0}]
   }
  }
 }
 plane{y,0 inverse pigment{rgbt 1}  finish{ambient 0 brilliance 0}}
 hollow 
}
#declare splash_drop=
cylinder{0,y*.5,.025
 scale .5
}
#declare r_spld=seed(77);
#declare i_spld=0;
#declare n_spld=32;
#declare splash=
union{
 #while (i_spld<n_spld)
  #declare spt=pow(rand(r_spld),2);
  object{splash_drop
   rotate 180*spt*x// curvature
   translate spt*z*2 // distance
   translate spt*sin(pi*spt)*y*rand(r_spld)*1 // height
   rotate 360*rand(r_spld)*y // randomize
  }
  #declare i_spld=i_spld+1;
 #end
// object{splash_torus}
}



// rain macro
// place the rain drops randomly over the area
// with variable wind angle and drop density
#macro rain_over(
 num_drops        // number of drops 
 rain_area,        // rain over this area
 rain_wind_angle,  // rotation vector
 rain_scale        // scale for the drops 
 rain_seed         // seed for the random placement
 )

 #local r_rain=seed(rain_seed); 
 #local i_drops=0;

 #while (i_drops<num_drops)
  #local rain_drop_pos=<
   -rain_area.x*.5+rain_area.x*rand(r_rain),
   rain_area.y*rand(r_rain),
   -rain_area.z*.5+rain_area.z*rand(r_rain),
  >;
  object{rain_drop
   scale rain_scale
   rotate rain_wind_angle*rand(r_rain)
   translate rain_drop_pos    
  }
  #local i_drops=i_drops+1;
 #end
 
#end

// rain macro:
// place splashes from drops falling over an area
// using trace to detect surfaces to rain over
#macro rain_splashes(
  object_to_trace // object to rain over
  num_splash,   // num of splashes
  rain_area,      // area to trace
  splash_scale,   // scale of the splashes
  splash_seed   // random seed for placement
)

#local r_splash=seed(splash_seed);
#local i_splash=0;

union{
#while (i_splash<num_splash)
 #local rain_drop_pos=<
  -rain_area.x*.5+rain_area.x*rand(r_splash),
  rain_area.y,
  -rain_area.z*.5+rain_area.z*rand(r_splash),
 >;
 // trace vertically to find splash pos
 #local Norm=<0,0,0>;
 #local Inter=trace(object_to_trace,rain_drop_pos,-y,Norm);
 #if (vlength(Norm)!=0)
  object{splash
   scale <1,1+2*rand(r_splash),1>
   scale splash_scale*(.1+.3*rand(r_splash))
   rotate 360*rand(r_splash)*y
   translate Inter
  }
  #local i_splash=i_splash+1;
 #end
#end
 texture{t_splash}
}

#end

// variant with rings
#macro rain_splashes_with_rings(
  object_to_trace // object to rain over
  num_splash,   // num of splashes
  rain_area,      // area to trace
  splash_scale,   // scale of the splashes
  splash_seed   // random seed for placement
)

#local r_splash=seed(splash_seed);
#local i_splash=0;

union{
#while (i_splash<num_splash)
 #local rain_drop_pos=<
  -rain_area.x*.5+rain_area.x*rand(r_splash),
  rain_area.y,
  -rain_area.z*.5+rain_area.z*rand(r_splash),
 >;
 #local ring_rad=rand(r_splash);
 // trace vertically to find splash pos
 #local Norm=<0,0,0>;
 #local Inter=trace(object_to_trace,rain_drop_pos,-y,Norm);
 #if (vlength(Norm)!=0)
  object{splash
   scale <1,1+2*rand(r_splash),1>
   scale splash_scale*(.1+.3*rand(r_splash))
   rotate 360*rand(r_splash)*y
   translate Inter
  }
  torus{ring_rad*splash_scale*.5,splash_scale*.05
   scale <1,.25,1>
   translate Inter
  }
  torus{ring_rad*splash_scale,splash_scale*.025
   scale <1,.25,1>
   translate Inter
  }
  #local i_splash=i_splash+1;
 #end
#end
 texture{t_splash}
}

#end


// rain macro:
// place localized streaks falling from a point
// with autostop and added splashes
#macro rain_streak(
  object_to_trace,
  num_drops,
  drop_scale,
  num_splash,
  splash_scale,
  streak_start,
  streak_seed
)

#local r_streak=seed(streak_seed);
#local i_drops=0;
#local streak_radius=.2;

// detect end of streak
// using trace to find obstacle
// later reuse point for splash placement
#local Norm=<0,0,0>;
#local streak_end=trace(object_to_trace,streak_start,-y,Norm);

// create streak
union{
#while (i_drops<num_drops)
 #local drop_height=streak_start.y*rand(r_streak);
 //streak_end.y+(streak_start.y-streak_end.y)*rand(r_streak),
 object{rain_drop
   scale drop_scale
   translate <
    streak_start.x+(-streak_radius+streak_radius*2*rand(r_streak))*(1-(drop_height/streak_start.y)),
    drop_height,
    streak_start.z+(-streak_radius+streak_radius*2*rand(r_streak))*(1-(drop_height/streak_start.y))
    >
 }
 #local i_drops=i_drops+1;
#end
}

// add the splashes
#local i_splash=0;
union{
#while (i_splash<num_splash)
 #local rain_drop_pos=<
  streak_start.x+(-streak_radius+streak_radius*2*rand(r_streak)),
  streak_start.y,
  streak_start.z+(-streak_radius+streak_radius*2*rand(r_streak))
 >;
 // trace vertically to find splash pos
 #local Norm=<0,0,0>;
 #local Inter=trace(object_to_trace,rain_drop_pos,-y,Norm);
 #if (vlength(Norm)!=0)
  object{splash
   scale <1,1+2*rand(r_streak),1>
   scale splash_scale*(.1+.3*rand(r_streak))
   rotate 360*rand(r_streak)*y
   translate Inter
  }
  #local i_splash=i_splash+1;
 #end
#end
 texture{t_splash}
}

#end

// rain macro
// creates spurts of drops using Torricelli
// along x axis
#macro rain_spurt(
 num_drops, // number of drops
 spurt_start, // fall from here
 spurt_height, // just fall this height
 column_height, // water column height (influences the distance of the spurt)
 spurt_upper_radius,
 spurt_lower_radius,
 spurt_type, // 0=circular, 1=planar-horiz., 2=planar-vert., 3=square
 drop_scale,
 test_obj
)

// constants
#local g=9.8; 

// spurt spline
#local r_spurt=seed(55);
#local n_sp=10;
#local i_sp=0;
#local p_sp=spurt_start;
#local t_max=1+1/n_sp;
#local sp_spurt=spline{
 natural_spline
#while (i_sp<=n_sp)
 i_sp/n_sp,p_sp 
 #local p_sp=<
  spurt_start.x+sqrt(2*g*(column_height-spurt_start.y))*(t_max*i_sp/n_sp),
  spurt_start.y-g*pow(t_max*i_sp/n_sp,2)/2,
  spurt_start.z
 >;
 #local i_sp=i_sp+1;
#end
}

// create spurt
#declare i_drops=0;
#declare spurt_drop=object{rain_drop rotate 90*z}
#declare spurt=
union{
#while (i_drops<num_drops)
 #local drop_pos=rand(r_spurt);
 #local current_radius=spurt_upper_radius+(spurt_lower_radius-spurt_upper_radius)*drop_pos;
 object{spurt_drop
  scale drop_scale
  #if (spurt_type=0) // circular
  translate (current_radius)*y rotate 360*rand(r_spurt)*x
  #end
  #if (spurt_type=1) // planar, horizontal
  translate (-current_radius+current_radius*2*rand(r_spurt))*vrotate(x,90*y)
  #end
  #if (spurt_type=2) // planar, vertical
  translate (-current_radius+current_radius*2*rand(r_spurt))*y
  #end
  #if (spurt_type=3) // square
  translate (-current_radius+current_radius*2*rand(r_spurt))*vrotate(x,90*y)
  translate (-current_radius+current_radius*2*rand(r_spurt))*y
  #end
  Reorient_Trans(x,sp_spurt(drop_pos+.1)-sp_spurt(drop_pos))
  translate sp_spurt(drop_pos)
 }
 #declare i_drops=i_drops+1;
#end
}

union{
object{spurt}
union{
 rain_splashes(test_obj,num_drops*.02,<spurt_lower_radius,spurt_height,spurt_lower_radius>,.15,1000*clock)
 translate sp_spurt(.3)+.1*y
 }
}

#end // spurt macro

