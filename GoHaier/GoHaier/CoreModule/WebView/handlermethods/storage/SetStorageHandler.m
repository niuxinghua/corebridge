//
//  SetStorageHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "SetStorageHandler.h"
static SetStorageHandler *sharedInstance;
@implementation SetStorageHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_setStorage";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSDictionary *syncDic = (NSDictionary *)data;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (syncDic && syncDic.allKeys.count > 0) {
            NSString *key = syncDic.allKeys.firstObject;
            [[NSUserDefaults standardUserDefaults] setObject:[syncDic objectForKey:key] forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
    
}
@end