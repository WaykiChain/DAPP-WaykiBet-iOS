//
//  UUIDTool.h
//  WaykiApp
//
//  Created by sorath on 2018/9/19.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDTool : NSObject
+ (NSString *)getUUIDInKeychain;

//s生成随机字符串
+ (NSString *)createRandomStringWithKey:(NSString *)key;
@end
