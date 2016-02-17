//
//  CoreDataBase.h
//  AppFrame
//
//  Created by SYETC11 on 15/12/21.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataBase : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark 保存上下文
-(void)saveContext;

#pragma mark 获取app沙盒路径
-(NSURL*)applicationDocumentsDirectory;

#pragma mark 单例方法
+(id)sharedCoreDataBase;

@end
