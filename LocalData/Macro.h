//
//  Macro.h
//  MorningWeather
//
//  Created by SYETC11 on 15/12/28.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//API
#define WEATHER_API @"http://apicloud.mob.com/weather/query"
#define CITY_API @"http://apicloud.mob.com/v1/weather/citys"
#define API_KEY @"d6b97078bf60"

//SIZE
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//FONTSIZE
#define FONTSIZE [UIScreen mainScreen].bounds.size.height/568

//COLOR
#define COLOR_PINK [UIColor colorWithRed:235/256.0 green:82/256.0 blue:87/256.0 alpha:1]
#define COLOR_CLEAR [UIColor colorWithWhite:1 alpha:0.15]

#endif /* Macro_h */