//
//  AFNetWorkingOperationDelegate.h
//  AppFrame
//
//  Created by SYETC11 on 15/12/21.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFNetWorkingOperationDelegate <NSObject>

#pragma mark 成功自动调用
-(void)loadingSucessed:(id)data;

#pragma mark 失败自动调用
-(void)loadingFailed;

@end
