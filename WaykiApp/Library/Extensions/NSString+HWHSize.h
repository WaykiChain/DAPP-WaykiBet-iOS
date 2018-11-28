//
//  NSString+HWHSize.h
//  MES
//
//  Created by Louis.hwh on 2017/4/7.
//  Copyright © 2017年 louiskin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (HWHSize)

+(CGSize)calStrSize:(NSString*)text andHeight:(CGFloat)height andFontSize:(CGFloat)fontsize;

+(CGSize)calStrSize:(NSString*)text andWidth:(CGFloat)Width andFontSize:(CGFloat)fontsize;

+(CGFloat)getStringWidthWithText:(NSString*)text height:(CGFloat)height fontSize:(CGFloat)fontsize;

+(CGFloat)getStringHeightWithText:(NSString*)text width:(CGFloat)width fontSize:(CGFloat)fontsize lineSpacing:(CGFloat)lineSpacing;

- (NSString *)reverse;


@end
