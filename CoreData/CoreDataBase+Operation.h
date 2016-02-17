//
//  CoreDataBase+Operation.h
//  AppFrame
//
//  Created by SYETC11 on 15/12/21.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import "CoreDataBase.h"

@interface CoreDataBase (Operation)

#pragma mark 封装查询方法
-(NSMutableArray*)queryEntityName:(NSString*)name where:(NSString*)wherename;

#pragma mark 封装查询排序
-(NSMutableArray*)queryEntityName:(NSString *)name where:(NSString *)wherename orderBy:(NSString *)ordername sort:(BOOL)b;

@end
