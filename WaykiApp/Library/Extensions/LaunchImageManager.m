//
//  LaunchImageManager.m
//  WaykiApp
//
//  Created by sorath on 2018/9/18.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

#import "LaunchImageManager.h"

@implementation LaunchImageManager
    
    //获取启动图
+ (UIImage *)getLaunchImage{
        
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOr = @"Portrait";//垂直
    NSString *launchImage = nil;
    NSArray *launchImages =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        
    for (NSDictionary *dict in launchImages) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            
        if (CGSizeEqualToSize(viewSize, imageSize) && [viewOr isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}
@end

