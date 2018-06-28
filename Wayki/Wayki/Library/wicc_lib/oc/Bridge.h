//
//  Bridge.h
//  Wayki
//
//  Created by louis on 2018/3/27.
//  Copyright © 2018年 JuFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CABtWallet;

@interface Bridge : NSObject

/* 助记词数组 */
+ (NSArray *)getWalletHelpCodes;

/* 助记词数组 -> 助记词字符串 */
+ (NSString *)getWaletHelpStringWithCodes:(NSArray *)helpcodes;

/* 助记词字符串 -> 助记词数组 */
+ (NSArray *)getWalletHelpCodesFrom:(NSString *)codestring;

/* 助记词字符串 -> (地址,私钥) */
+ (NSArray *)getAddressAndPrivateKeyWithHelpString:(NSString *)helpStr;

/* 检验钱包地址格式 */
+ (BOOL)addressIsAble:(NSString *)address;

/* 检查助记词列表 */
+(BOOL) checkMnemonicCode:(NSArray*)words;

/* 获取随机顺序助记词数组 */
+ (NSArray *)getRamdomArrayWithArray:(NSArray *)array;

/* 获取钱包哈希值 */
+ (NSString *)getWalletHashFrom:(NSString *)codestring;

/* 获取投注签名 */
+ (NSString *)getBetSignWithHelpString:(NSString *)helpString   // 助记词
                           blockHeight:(double)height           //  区块高度
                                 regID:(NSString *)regid        //  注册的ID
                             lotteryID:(NSString *)lottID       //
                           destAddress:(NSString *)destAdress   //  合约地址
                              gameType:(int)gameType            //  竞猜种类 - 篮球,足球
                              playType:(int)playtype            //  竞猜类型 - 胜平负,大小球
                               betType:(int)bettype             //  投注类型 - 主胜,平,客胜
                              betCount:(int)betcount;           //  投注金额 - SPC数量(个)

//获取激活hex
+ (NSString *)getActrivateHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight ;

//获取转账wicc hex
+ (NSString *)getTransfetWICCHexWithHelpStr:(NSString *)helpStr Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr transferValue:(double)value ;

//获取转账SPC hex
+ (NSString *)getTransfetSPCHexWithHelpStr:(NSString *)helpStr Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value;

//判断地址是否有效
+(BOOL) validateAddress:(NSString*) address;

+ (UInt64)getRandomMaxValue:(int)max minValue:(int)min;

@end
