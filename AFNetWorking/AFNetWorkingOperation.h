//
//  AFNetWorkingOperation.h
//  AppFrame
//
//  Created by SYETC11 on 15/12/21.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorkingOperationDelegate.h"

@interface AFNetWorkingOperation : NSObject<AFNetWorkingOperationDelegate>

@property(nonatomic,assign)id<AFNetWorkingOperationDelegate>delegate;

#pragma mark get方式
-(void)getURL:(NSString*)url data:(NSDictionary*)dic;

#pragma mark post方式
-(void)postURL:(NSString*)url data:(NSDictionary*)dic;

@end
