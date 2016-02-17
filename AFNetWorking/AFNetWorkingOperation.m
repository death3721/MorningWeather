//
//  AFNetWorkingOperation.m
//  AppFrame
//
//  Created by SYETC11 on 15/12/21.
//  Copyright © 2015年 ChaosPlanes. All rights reserved.
//

#import "AFNetWorkingOperation.h"
#import <AFNetworking/AFNetworking.h>

@implementation AFNetWorkingOperation
@synthesize delegate;

#pragma mark get方式
-(void)getURL:(NSString*)url data:(NSDictionary*)dic;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest * request;

    if (dic==nil) {
        NSURL* urldata=[NSURL URLWithString:url];
        request=[[NSMutableURLRequest alloc] initWithURL:urldata];
    }
    else
    {
        request= [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:dic error:nil];
    }
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (delegate) {
            if (error) {
                if ([delegate respondsToSelector:@selector(loadingFailed)]) {
                    [delegate loadingFailed];
                }
                NSLog(@"Error: %@", error);
            }
            else {
                if ([delegate respondsToSelector:@selector(loadingSucessed:)]) {
                    [delegate loadingSucessed:responseObject];
                }
            }
        }
    }];
    [dataTask resume];
}

#pragma mark post方式
-(void)postURL:(NSString*)url data:(NSDictionary*)dic;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest * request;
    
    if (dic==nil) {
        NSURL* urldata=[NSURL URLWithString:url];
        request=[[NSMutableURLRequest alloc] initWithURL:urldata];
    }
    else
    {
        request= [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:dic error:nil];
    }
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (delegate) {
            if (error) {
                if ([delegate respondsToSelector:@selector(loadingFailed)]) {
                    [delegate loadingFailed];
                }
                NSLog(@"Error: %@", error);
            }
            else {
                if ([delegate respondsToSelector:@selector(loadingSucessed:)]) {
                    [delegate loadingSucessed:responseObject];
                }
            }
        }
    }];
    [dataTask resume];
}

@end
