//
//  LocalLanague.m
//  WaykiApp
//
//  Created by sorath on 2018/9/4.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

#import "LocalLanague.h"

@implementation LocalLanague
#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])

+ (NSString *)dPLocalizedString:(NSString *)translation_key {
    
    NSString * LocalizableStr = NSLocalizedString(translation_key, nil);
    
    if (!([CURR_LANG rangeOfString:@"zh-Hant"].length >0) &&
        !([CURR_LANG rangeOfString:@"zh-Hans"].length >0)) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        
        LocalizableStr = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
        
    }
    
    return LocalizableStr;
}
@end
