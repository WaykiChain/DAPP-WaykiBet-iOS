//
//  NSAttributedString+HWH.m
//  MES
//
//  Created by Louis.hwh on 2017/4/7.
//  Copyright © 2017年 louiskin. All rights reserved.
//

#import "NSAttributedString+HWH.h"
#define HWHGrayColor(R)  [UIColor colorWithRed:(R)/255.0 green:(R)/255.0 blue:(R)/255.0 alpha:1.0]

@implementation NSAttributedString (HWH)



+ (NSAttributedString *)getAttributedString:(NSString *)string
                               defaultColor:(UIColor *)dColor
                                defaultFont:(CGFloat)dFont
                                      range:(NSRange )range
                                      color:(UIColor *)color
                                       font:(CGFloat)font
                                  lineSpace:(CGFloat)lineSpace
                              aligementType:(NSTextAlignment)textAilgement
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 调整行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = textAilgement;
    
    // 设置整体颜色
    NSDictionary * dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:dFont],
                            NSForegroundColorAttributeName:dColor,
                            NSStrokeColorAttributeName:dColor,
                            NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:dic1 range:NSMakeRange(0, string.length)];
    
    // 设置参数
    NSDictionary * dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:font],
                            NSForegroundColorAttributeName:color,
                            NSStrokeColorAttributeName:color,
                            NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:dic2 range:range];
    
    return attributedString;
}



@end
