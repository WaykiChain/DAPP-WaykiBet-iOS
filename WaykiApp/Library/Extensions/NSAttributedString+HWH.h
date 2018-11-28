//
//  NSAttributedString+HWH.h
//  MES
//
//  Created by Louis.hwh on 2017/4/7.
//  Copyright © 2017年 louiskin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (HWH)


+ (NSAttributedString *)getAttributedString:(NSString *)string
                               defaultColor:(UIColor *)dColor
                                defaultFont:(CGFloat)dFont
                                      range:(NSRange )range
                                      color:(UIColor *)color
                                       font:(CGFloat)font
                                  lineSpace:(CGFloat)lineSpace
                              aligementType:(NSTextAlignment)textAilgement;


@end
