//
//  MainViewController.m
//  MorningWeather
//
//  Created by SYETC11 on 15/12/28.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import "AFNetWorkingOperation.h"
#import "Macro.h"
#import "MainViewController.h"

@interface MainViewController ()<AFNetWorkingOperationDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
#pragma mark 变换背景页面相关
    
    UIImageView* bgView;//背景View
    UIButton* title;//标题按钮
    UIView* bgChangeView;//变换背景的View
    
#pragma mark 设置页相关
    
    UIView* subView;//弹出的设置页
    UIButton* subViewBG;//设置页的半透明背景
    UIImageView* tempBgView;//临时用于遮罩的背景view
    UIPickerView* cityPicker;//显示城市的PickerView
    NSArray* provinceArray;//省数据的数组
    NSArray* cityArray;//城市数据的数组
    NSArray* subCityArray;//地级市的数组
    UISwitch* noticeSwitch;//通知功能开关
    NSString* cityName;//用于临时存储选择的城市
    NSString* savedCityName;//用于存储选择的城市
    
#pragma mark 定时页面相关
    
    UIView* addView;//弹出的添加定时页
    UIButton* addViewBG;//添加页的半透明背景
    NSMutableArray* hourArray;//显示小时的数组
    NSMutableArray* minuteArray;//显示分钟的数组
    UIPickerView* datePicker;//显示时间的PickerView
    NSString* hour;//存储临时的hour数据
    NSString* minute;//存储临时的minute数据
    NSString* savedHour;//存储保存的hour数据
    NSString* savedMinute;//存储保存的minute数据
    UILabel* currentTime;//显示当前时间的label
    
#pragma mark 各个开关的判断值
    
    int switchValue;//用于判断设置页是否打开
    int viewValue;//用于判断tableView是否弹出
    int addValue;//用于判断addView是否弹出
    int backgroundValue;//用于判断backgroundChangePage是否弹出

#pragma mark 今日天气的view及显示内容的label
    
    UIView* todayView;//今天天气的view
    UILabel* temperature;//今天的天气
    UILabel* crawlerTime;//今天的更新时间
    UIButton* city;//当前的城市
    UILabel* sunrise;//日出时间
    UILabel* sunSet;//日落时间
    UILabel* weather;//当前天气
    UILabel* airCondition;//天气质量
    
#pragma mark 用于table点击后弹出的view及显示内容的label
    
    UIView* detailView;//详情页view
    UILabel* dateDetail;//日期详情
    UILabel* weekDetail;//星期详情
    UILabel* temperatureDetail;//温度详情
    UILabel* dayTimeDetail;//白天天气
    UILabel* nightDetail;//夜晚天气
    UILabel* windDetail;//风向详情
    NSArray* array;//表单数据的数组
    UITableView* table;//表单
    NSDictionary* todayDic;//今天的数据
    UIImage* tableImage;//用于tableViewCell的图片
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载基础功能
    [self loadBaseFunction];
    //加载设置页
    [self loadSettingPage];
    //加载定时页
    [self loadTimerPage];
    //加载今天天气view
    [self loadTodayWeatherView];
    //加载天气预报表格
    [self loadWeatherForecastTable];
    //获取网络数据
    [self loadNetWorkingData];
    //通知中心加载网络数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNetWorkingData) name:@"LoadNetWorkingData" object:nil];
}

#pragma mark ******************************以下是方法的实现******************************

//***************************************************************************************************************

#pragma mark 加载基础功能 初始化值 设置背景
-(void)loadBaseFunction
{
    //根据UserDefaults的值设置背景图片 初始化设置为1
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSInteger p=[user integerForKey:@"Background"];
    
    //设置背景色
    bgView=[UIImageView new];
    bgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self backgroundStyle:p];//加载背景
    [self.view addSubview:bgView];
    
    //初始化开关值
    switchValue=0;
    viewValue=0;
    addValue=0;
    backgroundValue=0;
    
    //标题按钮
    title=[UIButton new];
    [title setImage:[UIImage imageNamed:@"title"] forState:UIControlStateNormal];
    title.frame=CGRectMake(SCREEN_WIDTH/2-60, 30, 120, 44);
    [title addTarget:self action:@selector(loadBackgroundChangePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:title];
    
    //背景颜色选择的主View
    bgChangeView=[UIView new];
    bgChangeView.frame=CGRectMake(SCREEN_WIDTH/2-90, -44, 180, 44);
    bgChangeView.backgroundColor=COLOR_CLEAR;
    bgChangeView.layer.cornerRadius=10;
    [self.view addSubview:bgChangeView];
    
    //改变背景的按钮
    for (int i=0; i<=3; i++) {
        UIButton* bgChangeButton=[UIButton new];
        bgChangeButton.frame=CGRectMake(7+i*45, 7, 30, 30);
        bgChangeButton.backgroundColor=[UIColor whiteColor];
        bgChangeButton.tag=i;
        [bgChangeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_0%d",i+1]] forState:UIControlStateNormal];
        bgChangeButton.layer.cornerRadius=15;
        [bgChangeButton addTarget:self action:@selector(changeBackground:) forControlEvents:UIControlEventTouchUpInside];
        [bgChangeView addSubview:bgChangeButton];
    }
}

//***************************************************************************************************************

#pragma mark 加载变换背景页面
-(void)loadBackgroundChangePage
{
    if (backgroundValue==0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            title.frame=CGRectMake(SCREEN_WIDTH/2-60, -44, 120, 44);
            bgChangeView.frame=CGRectMake(SCREEN_WIDTH/2-90, 30, 180, 44);
        } completion:^(BOOL finished) {
            backgroundValue=1;
        }];
    }
}

#pragma mark 改变背景
-(void)changeBackground:(UIButton*)sender
{
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    [user setInteger:(NSInteger)sender.tag forKey:@"Background"];
    NSInteger p=[user integerForKey:@"Background"];
    [self backgroundStyle:p];
    if (backgroundValue==1) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            title.frame=CGRectMake(SCREEN_WIDTH/2-60, 30, 120, 44);
            bgChangeView.frame=CGRectMake(SCREEN_WIDTH/2-90, -44, 180, 44);
        } completion:^(BOOL finished) {
            backgroundValue=0;
        }];
    }
}

#pragma mark 加载背景样式
-(void)backgroundStyle:(NSInteger)sender
{
    switch (sender) {
        case 0:
            bgView.image=[UIImage imageNamed:@"bg_01"];
            tempBgView.image=[UIImage imageNamed:@"bg_01"];
            break;
        case 1:
            bgView.image=[UIImage imageNamed:@"bg_02"];
            tempBgView.image=[UIImage imageNamed:@"bg_02"];
            break;
        case 2:
            bgView.image=[UIImage imageNamed:@"bg_03"];
            tempBgView.image=[UIImage imageNamed:@"bg_03"];
            break;
        case 3:
            bgView.image=[UIImage imageNamed:@"bg_04"];
            tempBgView.image=[UIImage imageNamed:@"bg_04"];
            break;
        default:
            break;
    }
}

//***************************************************************************************************************

#pragma mark 调用本地通知方法
- (void)localNotification
{
    #warning 非常重要 修正了添加新通知无法移除原通知的bug
    //关闭本地通知 先把之前的通知移除 非常重要 否则会多次通知
    [MainViewController cancelLocalNotificationWithKey:@"weather"];
     #warning 格林威治时间是从1970年1月1日8点开始计算 所以传入本地通知的时间要减掉8*60*60
    //设置定时时间的秒数
    NSInteger p=[savedHour integerValue]*60*60+[savedMinute integerValue]*60-8*60*60;
    //调用本地通知方法
    [MainViewController registerLocalNotification:p];
    NSLog(@"开启本地通知");
}

#pragma mark 本地通知功能
+ (void)registerLocalNotification:(NSInteger)alertTime {
    //建立本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置触发通知的时间
    NSDate *fireDate=[NSDate dateWithTimeIntervalSince1970:alertTime];
    NSLog(@"触发通知的时间=%@",fireDate);
    notification.fireDate=fireDate;
    //设置时区
    notification.timeZone=[NSTimeZone defaultTimeZone];
    //设置重复的间隔
    notification.repeatInterval=kCFCalendarUnitDay;
    //设置通知内容
    notification.alertBody=@"早安~美好的一天从早安天气开始";
    notification.applicationIconBadgeNumber=1;
    //通知被触发时播放的声音
    notification.soundName=UILocalNotificationDefaultSoundName;
    //创建本地通知的info信息 用于取消通知
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"NOTICE"forKey:@"weather"];
    notification.userInfo = info;
    //ios8后 需要添加这个注册 才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        //通知重复提示的单位 可以是天 周 月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        //通知重复提示的单位 可以是天 周 月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark 取消某个本地通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    //获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            //根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            //如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

//***************************************************************************************************************

-(void)loadSettingPage
{
    //获取本地plist文件数据 导出省市名称
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"plist"];
    NSMutableDictionary * localData=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    provinceArray=localData[@"result"];
    //NSLog(@"%@", provinceArray);//直接打印数据。
    
    //设置按钮
    UIButton* settingButton=[UIButton new];
    [settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    settingButton.frame=CGRectMake(20, 32, 40, 40);
    [settingButton addTarget:self action:@selector(settingPageSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    //设置页及半透明遮罩
    subView=[UIView new];
    subView.frame=CGRectMake(-0.75*SCREEN_WIDTH, 0, 0.75*SCREEN_WIDTH, SCREEN_HEIGHT);
    subView.backgroundColor=COLOR_CLEAR;
    subViewBG=[UIButton new];
    subViewBG.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    subViewBG.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    [subViewBG addTarget:self action:@selector(settingPageSwitch) forControlEvents:UIControlEventTouchUpInside];
    
    //设置页的背景
    tempBgView=[UIImageView new];
    tempBgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSInteger p=[user integerForKey:@"Background"];
    [self backgroundStyle:p];
    
    //设置页的图片view
    UIImageView* subImageView=[UIImageView new];
    subImageView.frame=CGRectMake(60, 45, SCREEN_WIDTH*0.75-120, SCREEN_WIDTH*0.75-120);
    subImageView.image=[UIImage imageNamed:@"weather"];
    subImageView.layer.borderWidth=4;
    subImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    subImageView.layer.cornerRadius=10;
    [subView addSubview:subImageView];
    
    //副标题view
    UIImageView* subTitle=[UIImageView new];
    subTitle.frame=CGRectMake(SCREEN_WIDTH*0.75/2-60, SCREEN_WIDTH*0.75-120+45+10, 120, 44);
    subTitle.image=[UIImage imageNamed:@"title"];
    [subView addSubview:subTitle];
    
    //城市选择器
    cityPicker=[UIPickerView new];
    cityPicker.frame=CGRectMake(20, SCREEN_WIDTH*0.75-10, SCREEN_WIDTH*0.75-40, SCREEN_HEIGHT-SCREEN_WIDTH*0.75-190);
    cityPicker.delegate=self;
    cityPicker.dataSource=self;
    cityPicker.backgroundColor=[UIColor clearColor];
    cityPicker.layer.cornerRadius=10;
    [subView addSubview:cityPicker];
    
    //保存城市的按钮
    UIButton* saveCityButton=[UIButton new];
    saveCityButton.frame=CGRectMake(40, SCREEN_HEIGHT-170-10, SCREEN_WIDTH*0.75-80, 30);
    saveCityButton.layer.cornerRadius=5;
    saveCityButton.backgroundColor=[UIColor colorWithWhite:1 alpha:0.4];
    [saveCityButton setTitle:@"保存" forState:UIControlStateNormal];
    saveCityButton.titleLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [saveCityButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [saveCityButton addTarget:self action:@selector(saveCityData) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:saveCityButton];
    
    //推送开关标签
    UILabel* switchLabel=[UILabel new];
    switchLabel.frame=CGRectMake(40, SCREEN_HEIGHT-130, SCREEN_WIDTH*0.75-80-51, 31);
    switchLabel.text=@"推送通知";
    switchLabel.textAlignment=1;
    switchLabel.textColor=[UIColor whiteColor];
    [subView addSubview:switchLabel];
    
    //推送功能开关
    noticeSwitch=[UISwitch new];
    noticeSwitch.frame=CGRectMake(SCREEN_WIDTH*0.75-51-40, SCREEN_HEIGHT-130, 0, 0);
    noticeSwitch.onTintColor=[UIColor whiteColor];
    BOOL on=[user boolForKey:@"NOTICE"];
    noticeSwitch.on=on;
    [noticeSwitch addTarget:self action:@selector(notificationSwitch) forControlEvents:UIControlEventValueChanged];
    [subView addSubview:noticeSwitch];
    
    //版权页标签1
    UILabel* Copyright1=[UILabel new];
    Copyright1.frame=CGRectMake(20, SCREEN_HEIGHT-60-20, SCREEN_WIDTH*0.75-40, 16);
    Copyright1.text=@"混乱位面 版权所有";
    Copyright1.font=[UIFont systemFontOfSize:12];
    Copyright1.textAlignment=1;
    Copyright1.textColor=[UIColor whiteColor];
    [subView addSubview:Copyright1];
    
    //版权页标签2
    UILabel* Copyright2=[UILabel new];
    Copyright2.frame=CGRectMake(20, SCREEN_HEIGHT-60+14-20, SCREEN_WIDTH*0.75-40, 16);
    Copyright2.text=@"Copyright@2010-2016 ChaosPlanes.";
    Copyright2.font=[UIFont systemFontOfSize:10];
    Copyright2.textAlignment=1;
    Copyright2.textColor=[UIColor whiteColor];
    [subView addSubview:Copyright2];
    
    //版权页标签3
    UILabel* Copyright3=[UILabel new];
    Copyright3.frame=CGRectMake(20, SCREEN_HEIGHT-60+14+12-20, SCREEN_WIDTH*0.75-40, 16);
    Copyright3.text=@"All Rights Reserved.";
    Copyright3.font=[UIFont systemFontOfSize:10];
    Copyright3.textAlignment=1;
    Copyright3.textColor=[UIColor whiteColor];
    [subView addSubview:Copyright3];
}

#pragma mark 设置页面进出
-(void)settingPageSwitch
{
    if (switchValue==0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view addSubview:tempBgView];
            [self.view addSubview:subViewBG];
            [self.view addSubview:subView];
            subView.frame=CGRectMake(0, 0, 0.75*SCREEN_WIDTH, SCREEN_HEIGHT);
            subViewBG.backgroundColor=[UIColor colorWithWhite:0.25 alpha:0.15];
        } completion:^(BOOL finished) {
            switchValue=1;
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            subView.frame=CGRectMake(-0.75*SCREEN_WIDTH, 0, 0.75*SCREEN_WIDTH, SCREEN_HEIGHT);
            subViewBG.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
            [subViewBG removeFromSuperview];
        } completion:^(BOOL finished) {
            switchValue=0;
            [tempBgView removeFromSuperview];
        }];
    }
}

-(void)saveCityData
{
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSInteger p=[user integerForKey:@"province"];
    //进行判断 如果cityName没有值 直接给当前省数组下的第一个城市
    if (cityName==nil) {
        [user setObject:provinceArray[p][@"city"][0][@"city"] forKey:@"weatherCity"];
    }
    else{
        [user setObject:cityName forKey:@"weatherCity"];
    }
    //取出保存的城市名
    savedCityName=[user objectForKey:@"weatherCity"];
    //输出保存城市名
    NSLog(@"%@",savedCityName);
    //重新加载网络数据
    [self loadNetWorkingData];
    //调用设置页面开关方法
    [self settingPageSwitch];
}

#pragma mark 通知功能开关
-(void)notificationSwitch
{
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    BOOL on=[user boolForKey:@"NOTICE"];
    if (on) {
        //关闭本地通知
        [MainViewController cancelLocalNotificationWithKey:@"weather"];
        NSLog(@"关闭本地通知");
        [user setBool:NO forKey:@"NOTICE"];
    }
    else {
        //调用本地通知
        [self localNotification];
        NSLog(@"开启本地通知");
        [user setBool:YES forKey:@"NOTICE"];
    }
}

-(void)loadTimerPage
{
    //添加定时按钮
    UIButton* addButton=[UIButton new];
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addButton.frame=CGRectMake(SCREEN_WIDTH-20-40, 32, 40, 40);
    [addButton addTarget:self action:@selector(addTimerPageSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    //添加定时页背景及半透明
    addView=[UIView new];
    addView.frame=CGRectMake(20, -(SCREEN_HEIGHT-84-44*5-30), SCREEN_WIDTH-40, SCREEN_HEIGHT-84-44*5-30);
    addView.backgroundColor=COLOR_CLEAR;
    addView.layer.cornerRadius=10;
    
    //定时页的背景遮罩
    addViewBG=[UIButton new];
    addViewBG.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    addViewBG.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    [addViewBG addTarget:self action:@selector(addTimerPageSwitch) forControlEvents:UIControlEventTouchUpInside];
    
    //时间选择器
    datePicker=[UIPickerView new];
    datePicker.frame=CGRectMake(20, 40, SCREEN_WIDTH-80, SCREEN_HEIGHT-84-44*5-30-60-40);
    datePicker.delegate=self;
    datePicker.dataSource=self;
    datePicker.backgroundColor=[UIColor colorWithWhite:1 alpha:0.0];
    datePicker.layer.cornerRadius=10;
    [addView addSubview:datePicker];
    
    //给存储小时的数组添加数据
    hourArray=[[NSMutableArray alloc]initWithCapacity:24];
    for (int i=0; i<=24; i++) {
        [hourArray addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    
    //给存储分钟的数组添加数据
    minuteArray=[[NSMutableArray alloc]initWithCapacity:60];
    for (int i=0; i<=60; i++) {
        [minuteArray addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    
    //显示当前设定的时间
    currentTime=[UILabel new];
    currentTime.frame=CGRectMake(10, 10, SCREEN_WIDTH-60, 20);
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    savedHour= [NSString stringWithFormat:@"%@",([user objectForKey:@"HOUR"]==nil)?@"00":[user objectForKey:@"HOUR"]];
    savedMinute= [NSString stringWithFormat:@"%@",([user objectForKey:@"MINUTE"]==nil)?@"00":[user objectForKey:@"MINUTE"]];
    currentTime.text=[NSString stringWithFormat:@"当前设置时间: %@:%@",savedHour,savedMinute];
    currentTime.shadowColor=[UIColor darkGrayColor];
    currentTime.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    currentTime.textColor=[UIColor whiteColor];
    currentTime.textAlignment=1;
    [addView addSubview:currentTime];
    
    //保存按钮
    UIButton* saveButton=[UIButton new];
    saveButton.frame=CGRectMake(40, SCREEN_HEIGHT-84-44*5-30-50, SCREEN_WIDTH-120, 40);
    saveButton.layer.cornerRadius=5;
    saveButton.backgroundColor=[UIColor colorWithWhite:1 alpha:0.4];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [saveButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveTimerData) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:saveButton];
}

#pragma mark 保存设置时间的数据
-(void)saveTimerData
{
    //本地存储设定的时间数据
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    [user setObject:hour forKey:@"HOUR"];
    [user setObject:minute forKey:@"MINUTE"];
    //进行判断 如果时间选择是空 则存储00
    savedHour= [NSString stringWithFormat:@"%@",([user objectForKey:@"HOUR"]==nil)?@"00":[user objectForKey:@"HOUR"]];
    savedMinute= [NSString stringWithFormat:@"%@",([user objectForKey:@"MINUTE"]==nil)?@"00":[user objectForKey:@"MINUTE"]];
    //显示当前设置的时间
    currentTime.text=[NSString stringWithFormat:@"当前设置时间: %@:%@",savedHour,savedMinute];
    //调用本地通知
    [self localNotification];
    //开启通知开关
    [user setBool:YES forKey:@"NOTICE"];
    BOOL on=[user boolForKey:@"NOTICE"];
    noticeSwitch.on=on;
    //调用定时页面开关方法
    [self addTimerPageSwitch];
    NSLog(@"保存成功");
}

#pragma mark 定时页面进出
-(void)addTimerPageSwitch
{
    if (addValue==0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            //todayView的宽度
            float todayWidth=SCREEN_WIDTH-40;
            //todayView的高度
            float todayHeight=SCREEN_HEIGHT-84-44*5-30;
            //今日天气界面弹出主屏
            todayView.frame=CGRectMake(-todayWidth, 84, todayWidth, todayHeight);
            //载入定时界面并加背景
            [self.view addSubview:addViewBG];
            [self.view addSubview:addView];
            addViewBG.backgroundColor=[UIColor colorWithWhite:0.25 alpha:0.15];
            addView.frame=CGRectMake(20, 84, SCREEN_WIDTH-40, SCREEN_HEIGHT-84-44*5-30);
        } completion:^(BOOL finished) {
            addValue=1;
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            addViewBG.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
            //todayView的宽度
            float todayWidth=SCREEN_WIDTH-40;
            //todayView的高度
            float todayHeight=SCREEN_HEIGHT-84-44*5-30;
            //今日天气界面弹入主屏
            todayView.frame=CGRectMake(20, 84, todayWidth, todayHeight);
            //弹出定时界面并去除背景
            addView.frame=CGRectMake(20, -(SCREEN_HEIGHT-84-44*5-30), SCREEN_WIDTH-40, SCREEN_HEIGHT-84-44*5-30);
            [addViewBG removeFromSuperview];
        } completion:^(BOOL finished) {
            addValue=0;
        }];
    }
}

#pragma mark ********** UIPickerViewDataSource **********

#pragma mark 返回UIPickerView的选择的数据
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (pickerView==datePicker) {
        if (component==0) {
            hour=hourArray[row];
        }
        else{
            minute=minuteArray[row];
        }
            
    }
    if (pickerView==cityPicker) {
        NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
        if (component==0) {
            //存储选择的省的行数
            [user setInteger:row forKey:@"province"];
            //取出刚才存储的行数
            NSInteger p=[user integerForKey:@"province"];
            //获取相应的市的数据
            NSArray* tempArray=provinceArray[p][@"city"];
            //遍历字典中的键 存到临时数组 最后给到cityArray
            NSMutableArray* arr=[[NSMutableArray alloc]initWithCapacity:20];
            for (int i=0; i<tempArray.count; i++) {
                [arr addObject:tempArray[i][@"city"]];
            }
            //相应城市的数组
            cityArray=arr;
            //加载临时的地级市数据
            NSArray* _tempArray=provinceArray[p][@"city"][0][@"district"];
            NSMutableArray* _arr=[[NSMutableArray alloc]initWithCapacity:20];
            for (int i=0; i<_tempArray.count; i++) {
                [_arr addObject:_tempArray[i][@"district"]];
            }
            subCityArray=_arr;
            //刷新所有picker
            [cityPicker reloadAllComponents];
            #warning Picker自动选择动画
            //非常重要的方法 在没有选择下一列时候让下一列默认选择0
            [cityPicker selectRow:0 inComponent:1 animated:YES];
            [cityPicker selectRow:0 inComponent:2 animated:YES];
            //如果没有选择下一列 默认选第三列的第一个地级市
            cityName=subCityArray[0];
        }
        if (component==1) {
            //存储选择的市的行数
            [user setInteger:row forKey:@"city"];
            //取出省的行数
            NSInteger p=[user integerForKey:@"province"];
            //取出市的行数
            NSInteger c=[user integerForKey:@"city"];
            
            NSArray* tempArray=provinceArray[p][@"city"][c][@"district"];
            NSMutableArray* arr=[[NSMutableArray alloc]initWithCapacity:20];
            for (int i=0; i<tempArray.count; i++) {
                [arr addObject:tempArray[i][@"district"]];
            }
            subCityArray=arr;
            //刷新所有picker
            [cityPicker reloadAllComponents];
            //非常重要的方法 在没有选择下一列时候让下一列默认选择0
            [cityPicker selectRow:0 inComponent:2 animated:YES];
            //如果没有选择下一列 默认选第三列的第一个地级市
            cityName=subCityArray[0];
        }
        if (component==2) {
            //获取当前选择的地级市
            cityName=subCityArray[row];
            NSLog(@"当前选择的城市是%@",cityName);
        }
    }
}

#pragma mark 返回UIPickerView的分组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    int count=0;
    if (pickerView==datePicker) {
        count=2;
    }
    if (pickerView==cityPicker) {
        count=3;
    }
    return count;
}

#pragma mark 返回UIPickerView的每组行数 component为每组的索引
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    int count=0;
    if (pickerView==datePicker) {
        if(component==0) {
            //24个小时
            count=24;
        }
        else{
            //60分钟
            count=60;
        }
    }
    if (pickerView==cityPicker) {
        if (component==0) {
            //返回省数据数组的计数
            count=(int)provinceArray.count;
        }
        if (component==1) {
            //返回市数据数组的计数
            count=(int)cityArray.count;
        }
        if (component==2) {
            //返回地级市数据数组的计数
            count=(int)subCityArray.count;
        }
    }
    return count;
}

#pragma mark 返回UIPickerView的每个单元显示的数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    NSString* string;
    if (pickerView==datePicker) {
        if (component==0) {
            string=hourArray[row];
        }
        if (component==1) {
            string=minuteArray[row];
        }
    }
    if (pickerView==cityPicker) {
        if (component==0) {
            //获取省的数据
            string=provinceArray[row][@"province"];
        }
        if (component==1) {
            //获取市的数据
            string=cityArray[row];
        }
        if (component==2) {
            //获取地级市的数据
            string=subCityArray[row];
        }
    }
    return string;
}

#pragma mark 更改UIPickerView的文字样式 通过修改label实现
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view;
{
    UILabel* pickerLabel = (UILabel*)view;
    if (pickerView==datePicker) {
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.font=[UIFont systemFontOfSize:36*FONTSIZE weight:1];
            pickerLabel.textColor=[UIColor whiteColor];
            pickerLabel.textAlignment=1;
            pickerLabel.shadowColor=[UIColor darkGrayColor];
            pickerLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
        }
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    }
    if (pickerView==cityPicker) {
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.font=[UIFont systemFontOfSize:14*FONTSIZE weight:1];
            pickerLabel.textColor=[UIColor whiteColor];
            pickerLabel.textAlignment=1;
            pickerLabel.shadowColor=[UIColor darkGrayColor];
            pickerLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
        }
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return pickerLabel;
}

#pragma mark 返回UIPickerView的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    float height=0;
    if (pickerView==datePicker) {
        height=48.0f;
    }
    if (pickerView==cityPicker) {
        height=36.0f;
    }
    return height;
}

//***************************************************************************************************************

//***************************************************************************************************************

-(void)loadTodayWeatherView
{
    //用于显示今日天气数据的view
    todayView=[UIView new];
    //todayView的宽度
    float todayWidth=SCREEN_WIDTH-40;
    //todayView的高度
    float todayHeight=SCREEN_HEIGHT-84-44*5-30;
    todayView.frame=CGRectMake(20, 84, todayWidth, todayHeight);
    todayView.backgroundColor=COLOR_CLEAR;
    todayView.layer.cornerRadius=10;
    [self.view addSubview:todayView];
    
    //使用通知中心获取当日数据
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(loadTodayViewData) name:@"loadingSucessed" object:nil];
    
    //显示当前选择的城市
    city=[UIButton new];
    city.frame=CGRectMake(20, 20, 125, 20);
    city.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;//button的文字左对齐
    city.titleLabel.font=[UIFont systemFontOfSize:20*FONTSIZE weight:.5];
    city.titleLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [city setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [city addTarget:self action:@selector(settingPageSwitch) forControlEvents:UIControlEventTouchUpInside];
    [todayView addSubview:city];
    
    //显示今日的温度
    temperature=[UILabel new];
    temperature.frame=CGRectMake(0, todayHeight/2-30-20, todayWidth, 60);
    temperature.textAlignment=1;
    temperature.textColor=[UIColor whiteColor];
    temperature.font=[UIFont systemFontOfSize:60 weight:1];
    temperature.shadowColor=[UIColor darkGrayColor];
    temperature.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:temperature];
    
    //显示当前的天气
    weather=[UILabel new];
    weather.frame=CGRectMake(todayWidth/2+90, todayHeight/2+10-20, 52, 14);
    weather.textAlignment=0;
    weather.textColor=[UIColor whiteColor];
    weather.font=[UIFont systemFontOfSize:14 weight:1];
    weather.shadowColor=[UIColor darkGrayColor];
    weather.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:weather];
    
    //显示日出时间
    sunrise=[UILabel new];
    sunrise.frame=CGRectMake(0, todayHeight-60, todayWidth/3, 20);
    sunrise.textAlignment=1;
    sunrise.textColor=[UIColor whiteColor];
    sunrise.font=[UIFont systemFontOfSize:14 weight:1];
    sunrise.shadowColor=[UIColor darkGrayColor];
    sunrise.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:sunrise];
    UIImageView* sunriseImage=[UIImageView new];
    sunriseImage.frame=CGRectMake(todayWidth/6-32, todayHeight-110, 64, 64);
    sunriseImage.image=[UIImage imageNamed:@"sunrise"];
    [todayView addSubview:sunriseImage];
    
    //显示日落时间
    sunSet=[UILabel new];
    sunSet.frame=CGRectMake(todayWidth/3, todayHeight-60, todayWidth/3, 20);
    sunSet.textAlignment=1;
    sunSet.textColor=[UIColor whiteColor];
    sunSet.font=[UIFont systemFontOfSize:14 weight:1];
    sunSet.shadowColor=[UIColor darkGrayColor];
    sunSet.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:sunSet];
    UIImageView* sunsetImage=[UIImageView new];
    sunsetImage.frame=CGRectMake(todayWidth/2-32, todayHeight-110, 64, 64);
    sunsetImage.image=[UIImage imageNamed:@"sunset"];
    [todayView addSubview:sunsetImage];
    
    //显示空气质量
    airCondition=[UILabel new];
    airCondition.frame=CGRectMake(todayWidth*2/3, todayHeight-60, todayWidth/3, 20);
    airCondition.textAlignment=1;
    airCondition.textColor=[UIColor whiteColor];
    airCondition.font=[UIFont systemFontOfSize:14 weight:1];
    airCondition.shadowColor=[UIColor darkGrayColor];
    airCondition.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:airCondition];
    UILabel* airLabel=[UILabel new];
    airLabel.frame=CGRectMake(todayWidth*2/3, todayHeight-78, todayWidth/3, 20);
    airLabel.textAlignment=1;
    airLabel.textColor=[UIColor whiteColor];
    airLabel.font=[UIFont systemFontOfSize:14 weight:1];
    airLabel.text=@"空气质量";
    airLabel.shadowColor=[UIColor darkGrayColor];
    airLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:airLabel];
    
    //显示数据更新时间
    crawlerTime=[UILabel new];
    crawlerTime.frame=CGRectMake(20, todayHeight-29, todayWidth-40, 14);
    crawlerTime.textAlignment=1;
    crawlerTime.textColor=[UIColor whiteColor];
    crawlerTime.font=[UIFont systemFontOfSize:14 weight:.5];
    crawlerTime.shadowColor=[UIColor darkGrayColor];
    crawlerTime.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [todayView addSubview:crawlerTime];
}

#pragma mark 显示当日数据
-(void)loadTodayViewData
{
    //显示气温数据
    temperature.text=todayDic[@"temperature"];
    //显示城市数据
    [city setTitle:[NSString stringWithFormat:@"[%@]",savedCityName] forState:UIControlStateNormal];
    //显示更新时间数据
    NSString* crawlerTimeStr=todayDic[@"crawlerTime"];
    NSString* timeStr=[crawlerTimeStr substringFromIndex:8];
    NSRange hourRange={0,2};
    NSRange minuteRange={2,2};
    NSRange secondRange={4,2};
    NSString* hourStr=[timeStr substringWithRange:hourRange];
    NSString* minuteStr=[timeStr substringWithRange:minuteRange];
    NSString* secondStr=[timeStr substringWithRange:secondRange];
    crawlerTime.text=[NSString stringWithFormat:@"更新时间:[%@:%@:%@]",hourStr,minuteStr,secondStr];
    //显示天气数据
    weather.text=todayDic[@"weather"];
    //显示日出时间数据
    sunrise.text=todayDic[@"sunrise"];
    //显示日落时间数据
    sunSet.text=todayDic[@"sunSet"];
    //显示空气质量数据
    airCondition.text=todayDic[@"airCondition"];
}

//***************************************************************************************************************

//***************************************************************************************************************

#pragma mark 获取网络数据
-(void)loadNetWorkingData
{
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    savedCityName=[user objectForKey:@"weatherCity"];
    //获取网络数据
    AFNetWorkingOperation* afo=[AFNetWorkingOperation new];
    afo.delegate=self;
    NSString * url=WEATHER_API;
    NSDictionary * dic=@{@"key":API_KEY,@"cityname":savedCityName};
    [afo getURL:url data:dic];
}

#pragma mark ********** AFNetWorkingOperationDelegate **********

#pragma mark 成功
-(void)loadingSucessed:(id)data;
{
    //获取网络数据
    NSArray* resultArr=data[@"result"];
    //把获取的数据保存到本地plist文件
//    [resultArr writeToFile:@"/Users/syetc11/Desktop/result.plist" atomically:YES];
    NSDictionary* dic=resultArr[0];
    //获取天气预报
    array=dic[@"future"];
    //获取今天的天气信息
    todayDic=resultArr[0];
    //发出加载数据成功的通知
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"loadingSucessed" object:nil];
    //重载表格
    [table reloadData];
}

#pragma mark 失败
-(void)loadingFailed;
{
    NSLog(@"Loading Failed");
}

//***************************************************************************************************************

//***************************************************************************************************************

#pragma mark 封装下方的表格及点击出的view
-(void)loadWeatherForecastTable
{
    //天气预报表格
    table=[[UITableView alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-44*5-20, SCREEN_WIDTH-40, 44*5-1) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.separatorColor=[UIColor clearColor];
    table.dataSource=self;
    table.delegate=self;
    [self.view addSubview:table];
    
    //点击表格后弹出的view
    detailView=[UIView new];
    detailView.frame=CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT-44*5-20, SCREEN_WIDTH-40, 44*5-1);
    detailView.backgroundColor=COLOR_CLEAR;
    detailView.layer.cornerRadius=10;
    [self.view addSubview:detailView];
    
    //日期
    dateDetail=[UILabel new];
    dateDetail.frame=CGRectMake(20, 20, 180, 20);
    dateDetail.font=[UIFont systemFontOfSize:20 weight:1];
    dateDetail.textColor=[UIColor whiteColor];
    dateDetail.shadowColor=[UIColor darkGrayColor];
    dateDetail.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [detailView addSubview:dateDetail];
    
    //星期
    weekDetail=[UILabel new];
    weekDetail.frame=CGRectMake(SCREEN_WIDTH-120, 20, 100, 20);
    weekDetail.font=[UIFont systemFontOfSize:20 weight:1];
    weekDetail.textColor=[UIColor whiteColor];
    weekDetail.shadowColor=[UIColor darkGrayColor];
    weekDetail.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [detailView addSubview:weekDetail];
    
    //温度
    temperatureDetail=[UILabel new];
    temperatureDetail.frame=CGRectMake(10, 65, SCREEN_WIDTH-60, 40);
    temperatureDetail.font=[UIFont systemFontOfSize:36 weight:1];
    temperatureDetail.textAlignment=1;
    temperatureDetail.textColor=[UIColor whiteColor];
    temperatureDetail.shadowColor=[UIColor darkGrayColor];
    temperatureDetail.shadowOffset=CGSizeMake(1*FONTSIZE, 1*FONTSIZE);
    [detailView addSubview:temperatureDetail];
    
    //白天天气
    dayTimeDetail=[UILabel new];
    dayTimeDetail.frame=CGRectMake(10, 130, SCREEN_WIDTH-60, 20);
    dayTimeDetail.textAlignment=1;
    dayTimeDetail.font=[UIFont systemFontOfSize:16 weight:1];
    dayTimeDetail.textColor=[UIColor whiteColor];
    dayTimeDetail.shadowColor=[UIColor darkGrayColor];
    dayTimeDetail.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [detailView addSubview:dayTimeDetail];
    
    //夜间天气
    nightDetail=[UILabel new];
    nightDetail.frame=CGRectMake(10, 155, SCREEN_WIDTH-60, 20);
    nightDetail.textAlignment=1;
    nightDetail.font=[UIFont systemFontOfSize:16 weight:1];
    nightDetail.textColor=[UIColor whiteColor];
    nightDetail.shadowColor=[UIColor darkGrayColor];
    nightDetail.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [detailView addSubview:nightDetail];
    
    //风向
    windDetail=[UILabel new];
    windDetail.frame=CGRectMake(10, 180, SCREEN_WIDTH-60, 20);
    windDetail.textAlignment=1;
    windDetail.font=[UIFont systemFontOfSize:16 weight:1];
    windDetail.textColor=[UIColor whiteColor];
    windDetail.shadowColor=[UIColor darkGrayColor];
    windDetail.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    [detailView addSubview:windDetail];
    
    //取消按钮
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 44*5-1)];
    cancelButton.backgroundColor=[UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelDetailView) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:cancelButton];
}

#pragma mark 关闭detailView
-(void)cancelDetailView
{
    if (viewValue==1) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            table.frame=CGRectMake(20, SCREEN_HEIGHT-44*5-20, SCREEN_WIDTH-40, 44*5-1);
            detailView.frame=CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT-44*5-20, SCREEN_WIDTH-40, 44*5-1);
        } completion:^(BOOL finished) {
            viewValue=0;
        }];
    }
}

#pragma mark ********** UITableViewDataSource **********

#pragma mark table返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}

#pragma mark 表示每一行显示什么数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //内存优化
    static NSString * identity=@"cell";
    //tableview 根据标识复制出一个cell
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    //获取字典数据
    NSDictionary* dic=array[indexPath.row];
    cell.backgroundColor=COLOR_CLEAR;
    //设置文字标签内容
    cell.textLabel.text=dic[@"week"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16*FONTSIZE weight:1];
    cell.textLabel.shadowColor=[UIColor darkGrayColor];
    cell.textLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    //设置详情内容
    cell.detailTextLabel.text=dic[@"temperature"];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16*FONTSIZE weight:1];
    cell.detailTextLabel.shadowColor=[UIColor darkGrayColor];
    cell.detailTextLabel.shadowOffset=CGSizeMake(.5*FONTSIZE, .5*FONTSIZE);
    //调用图片方法
    [self tableImageOutput:dic[@"dayTime"]];
    //获取图片
    cell.imageView.image=tableImage;
    //显示小箭头
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //设置cell选择颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}

#pragma mark 判断table图片的方法
-(void)tableImageOutput:(NSString*)string
{
    //如果是晴显示晴 否则默认是多云
    if ([string isEqualToString:@"晴"]) {
        tableImage=[UIImage imageNamed:@"sunny"];
    }
    else
        tableImage=[UIImage imageNamed:@"cloud"];
    //如果是小雨显示小雨
    if ([string isEqualToString:@"小雨"]) {
        tableImage=[UIImage imageNamed:@"light-rain"];
    }
    //如果是中雨显示中雨
    if ([string isEqualToString:@"中雨"]) {
        tableImage=[UIImage imageNamed:@"mid-rain"];
    }
    //如果是大雨显示大雨
    if ([string isEqualToString:@"大雨"]) {
        tableImage=[UIImage imageNamed:@"heavy-rain"];
    }
    //如果是雷阵雨显示雨
    if ([string isEqualToString:@"雷阵雨"]) {
        tableImage=[UIImage imageNamed:@"thunder-rain"];
    }
    //如果是雪显示雪
    if ([string isEqualToString:@"小雪"]||[string isEqualToString:@"中雪"]||[string isEqualToString:@"大雪"]) {
        tableImage=[UIImage imageNamed:@"snow"];
    }
}

#pragma mark ********** UITableViewDelegate **********

#pragma mark table的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (viewValue==0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            table.frame=CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH-40, 44*5-1);
            detailView.frame=CGRectMake(20, SCREEN_HEIGHT-44*5-20, SCREEN_WIDTH-40, 44*5-1);
        } completion:^(BOOL finished) {
            viewValue=1;
        }];
    }
    //通过IndexPath取数据
    NSDictionary* dic=array[indexPath.row];
    //设置detail的内容
    dateDetail.text=dic[@"date"];
    weekDetail.text=dic[@"week"];
    temperatureDetail.text=dic[@"temperature"];
    dayTimeDetail.text=[NSString stringWithFormat:@"白天天气: %@",dic[@"dayTime"]];
    nightDetail.text=[NSString stringWithFormat:@"夜晚天气: %@",dic[@"night"]];
    windDetail.text=[NSString stringWithFormat:@"风向: %@",dic[@"wind"]];
}

//***************************************************************************************************************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
