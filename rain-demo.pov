/*
  Rain macros demo
  --
  Jaime Vives Piqueres, 2008.
*/

// *** two pass render ***
// first calculate radiosity with use_rain=0 and use_rad=2
// for the final render use_rain=1 and use_rad=1
#declare use_rain=0;
#declare use_rad =2;

global_settings {
 max_trace_level 10
 #if (use_rad>0)
 radiosity{
  #if (use_rad=2)
  pretrace_start .1 pretrace_end .01
  count 500 nearest_count 10 error_bound .5 recursion_limit 1
  brightness 1.75
  save_file "rain-demo.rad"
  #else
  load_file "rain-demo.rad"
  pretrace_start 1 pretrace_end 1
  count 1 nearest_count 10 error_bound .5 recursion_limit 1
  brightness 1.75
  #end
 }
 #end
}
#default{texture{finish{ambient 0}}}
#include "colors.inc"
#include "textures.inc"
#include "functions.inc"
#include "transforms.inc"


// *** sky lighting ***
sphere{0, 
 1000
 hollow no_shadow
 texture{
  pigment{
   wrinkles    
   color_map{
    [0.0 rgb 1.5]
    [1.0 rgb 0]
   }
   warp{turbulence .5 lambda 2.75}
   scale 4000*<1,1/3,1>
  }
  finish{ambient 1 diffuse 0}
 }
}


// *** test scenario ***
#declare test_floor=
plane{y,0
 pigment{checker color Gray20 color Gray60 scale 1}
 #if (use_rain)
 finish{reflection {.1,.9}}
 normal{bumps .05 scale .05}
 #end
}
#declare building=
union{
 difference{
  box{-.5,.5 scale <5,5,5>}
  box{-.5,.5 scale <4,2,5> translate <0,-1.51,.1>}
  box{-.5,.5 scale <5.1,2,4> translate <0,-1.51,0>}
  cylinder{<0,-.51,-2.4>,<0,-.51,2.6>,2}
  cylinder{<-2.6,-.51,0>,<2.6,-.51,0>,2}
  pigment{Flesh}
  translate <0,2.5,0>
 }
 box{-.5,.5 scale <4,5,4>
  texture{
   pigment{brick color White color Orange*.5+Red*.5 scale .075} 
   rotate 90
  }
  translate <0,2.5,0>
 }
 box{-.5,.5
  scale <5,.1,5>
  pigment{Firebrick}
  rotate 40*x
  translate <0,6.2,1>
 }
 cylinder{0.4*y,<0,0.3,.1>,.1
  pigment{Gray}
  translate <-2.5,0,2.6>
 }
 sphere{0,.1
  pigment{Gray}
  translate <-2.5,0.4,2.6>
 }
 cylinder{0.4*y,3.8*y,.1
  pigment{Gray}
  translate <-2.5,0,2.6>
 }
 sphere{0,.1
  pigment{Gray}
  translate <-2.5,3.8,2.6>
 }
 cylinder{3.8*y,<0,4.3,.2>,.1
  pigment{Gray}
  translate <-2.5,0,2.6>
 }
 cylinder{4.3*y,4.6*y,.1
  pigment{Gray}
  translate <-2.5,0,2.8>
 }
 sphere{0,.1
  pigment{Gray}
  translate <-2.5,4.3,2.8>
 }
 intersection{
  cylinder{<-2.5,4.6,2.8>,<2.5,4.6,2.8>,.12}
  plane{y,4.6}
  pigment{Gray}
 }
}
#declare buildings=
union{
 object{building translate <0,0,-5.5>}
 object{building rotate 180*y translate <0,0, 5.5>}
 object{building translate <5,0,-5.5>}
 object{building rotate 180*y translate <5,0, 5.5>}
 object{building translate <-5,0,-5.5>}
 object{building rotate 180*y translate <-5,0, 5.5>}
 object{building translate <10,0,-5.5>}
 object{building rotate 180*y translate <10,0, 5.5>}
 object{building translate <-10,0,-5.5>}
 object{building rotate 180*y translate <-10,0, 5.5>}
 box{-.5,.5
  scale <1,4,20>
  pigment{Gray}
  translate <-13.5,2,0>
 }
}
#declare test_obj=
sphere{0,1
 texture{Polished_Chrome}
 translate <0,1,0>
}
object{test_floor}
object{buildings}
object{test_obj}


// *** RAIN ***
#if (use_rain)
#include "rain_macros.inc" // raining macros
#declare r_rain=seed(2802); // random seed
// object for trace() tests
#declare everything_but_the_floor=
union{
 object{buildings}
 object{test_obj}
}
// rain on the air
rain_over(200000,<30,20,10>,<10,0,0>,.1,int(1000*rand(r_rain)))
// splashes on objects
rain_splashes(everything_but_the_floor,5000,<30,20,10>,.15,int(1000*rand(r_rain)))
rain_splashes_with_rings(test_floor,5000,<30,20,5.2>,.15,int(1000*rand(r_rain)))
// falling rain streaks (positions taken with Wings3D)
// left buildings
rain_streak(test_floor,1000,.1,10,.1,<-14,4.6,2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<-11,4.6,2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<-6,4.6,2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<4,4.6,2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<0,4.6,2.5>,int(1000*rand(r_rain)))
// right buildings
rain_streak(test_floor,1000,.1,10,.1,<-13,4.6,-2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<-9,4.6,-2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<-4,4.6,-2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<6,4.6,-2.5>,int(1000*rand(r_rain)))
rain_streak(test_floor,1000,.1,10,.1,<1,4.6,-2.5>,int(1000*rand(r_rain)))
// spurts right
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate -90*y translate <-2.5,0,-5.5+2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate -90*y translate <-2.5+5,0,-5.5+2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate -90*y translate <-2.5-5,0,-5.5+2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate -90*y translate <-2.5+5+5,0,-5.5+2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate -90*y translate <-2.5-5-5,0,-5.5+2.7>}
// spurts left
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate 90*y translate <-2.5,0,5.5-2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate 90*y translate <-2.5+5,0,5.5-2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate 90*y translate <-2.5-5,0,5.5-2.7>}
object{rain_spurt(600,<0,.3,0>,.3,.31,.07,.15,0,.2,test_floor) rotate 90*y translate <-2.5+5+5,0,5.5-2.7>}
// faked visibility loss
fog{color White transmit .5  distance 80}
#end


camera {
  perspective
  location <14, 2.6, -0.6>
  right < -3.2, 0, 0>
  up < 0, 2.4, 0>
  look_at <-10, 1.5, 0>
  direction 3.5*z
}
