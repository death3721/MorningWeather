//
//  CoreDataBase+Operation.m
//  AppFrame
//
//  Created by SYETC11 on 15/12/21.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import "CoreDataBase+Operation.h"

@implementation CoreDataBase (Operation)

#pragma mark 封装查询方法
-(NSMutableArray*)queryEntityName:(NSString*)name where:(NSString*)wherename;
{
    NSMutableArray* array;
    NSFetchRequest* request=[[NSFetchRequest alloc]init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    if (wherename!=nil) {
        //有条件查询
        NSPredicate* predicate=[NSPredicate predicateWithFormat:wherename];
        request.predicate=predicate;
    }
    [request setEntity:entity];
    array=[[self.managedObjectContext executeFetchRequest:request error:nil]mutableCopy];
    return array;
}
#pragma mark 封装查询排序
-(NSMutableArray*)queryEntityName:(NSString *)name where:(NSString *)wherename orderBy:(NSString *)ordername sort:(BOOL)b;
{
    NSMutableArray * data;
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    if (wherename!=nil) {
        request.predicate=[NSPredicate predicateWithFormat:wherename];
    }
    if (ordername!=nil) {
        NSSortDescriptor * sort=[NSSortDescriptor sortDescriptorWithKey:ordername ascending:b];
        request.sortDescriptors=@[sort];
    }
    [request setEntity:entity];
    data=[[self.managedObjectContext executeFetchRequest:request error:nil]mutableCopy];
    return data;
}

@end
