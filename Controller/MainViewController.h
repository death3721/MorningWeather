//
//  MainViewController.h
//  MorningWeather
//
//  Created by SYETC11 on 15/12/28.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;

//加载网络数据
-(void)loadNetWorkingData;

@end
