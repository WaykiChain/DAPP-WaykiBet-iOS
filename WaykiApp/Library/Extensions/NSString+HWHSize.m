//
//  NSString+HWHSize.m
//  MES
//
//  Created by Louis.hwh on 2017/4/7.
//  Copyright © 2017年 louiskin. All rights reserved.
//

#import "NSString+HWHSize.h"

@implementation NSString (HWHSize)
+(CGSize)calStrSize:(NSString*)text andHeight:(CGFloat)height andFontSize:(CGFloat)fontsize
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    
    return size;
}

+(CGSize)calStrSize:(NSString*)text andWidth:(CGFloat)width andFontSize:(CGFloat)fontsize;
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    
    return size;
}

+(CGFloat)getStringWidthWithText:(NSString*)text height:(CGFloat)height fontSize:(CGFloat)fontsize
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return size.width;
}

+(CGFloat)getStringHeightWithText:(NSString*)text width:(CGFloat)width fontSize:(CGFloat)fontsize lineSpacing:(CGFloat)lineSpacing
{
    
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = lineSpacing;
    
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize],
                            NSParagraphStyleAttributeName:paragraph};
    
    //一定要先确定宽度，再根据宽度和字体计算size
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size.height;
}

- (NSString *)reverse {
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=self.length; i>0; i--) {
        [s appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

@end

