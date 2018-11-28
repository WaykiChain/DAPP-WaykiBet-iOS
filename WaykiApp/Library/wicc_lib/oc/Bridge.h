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
//获取钱包地址和私钥
+ (NSArray *)getAddressAndPrivateKeyWithHelpString:(NSString *)helpStr password:(NSString *)password;

//获取助记词
+ (NSArray *)getWalletHelpCodes;

//
+ (NSString *)getWaletHelpStringWithCodes:(NSArray *)helpcodes;
+ (NSArray *)getWalletHelpCodesFrom:(NSString *)codestring;

//检验钱包地址格式
+ (BOOL)addressIsAble:(NSString *)address;

//检查助记词列表

+(BOOL) checkMnemonicCode:(NSArray*)words;

//打乱助记词数组词语顺序
+ (NSArray *)getRamdomArrayWithArray:(NSArray *)array;

//获取钱包哈希
+ (NSString *)getWalletHashFrom:(NSString *)codestring;

+ (NSString *)getBetSignWithHelpString:(NSString *)helpString
                           oldPassword:(NSString *)password
                           blockHeight:(double)height
                                 regID:(NSString *)regid
                             lotteryID:(NSString *)lottID
                           destAddress:(NSString *)destAdress
                              gameType:(int) gameType
                              playType:(int)playtype
                               betType:(int)bettype
                              betCount:(int)betcount;
//获取激活hex
+ (NSString *)getActrivateHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight ;

//获取转账wicc hex
+ (NSString *)getTransfetWICCHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr transferValue:(double)value ;

//获取转账SPC hex
+ (NSString *)getTransfetSPCHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value;

// 获取锁仓的hex
+ (NSString *)getLockHexWithHelpStr:(NSString *)helpStr blockHeight:(double)validHeight regessID:(NSString *)regessID appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value;

// 获取解仓的hex
+ (NSString *)getUnlockHexWithHelpStr:(NSString *)helpStr blockHeight:(double)validHeight regessID:(NSString *)regessID appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value;

//获取 wicc兑换wusd 的 hex(string) 和 合约命令(str)
+ (NSArray *)getExchangeHexWithHelpStr:(NSString *)helpStr blockHeight:(double)validHeight regessID:(NSString *)regessID destAddr:(NSString *)destAddr exchangeValue:(double)value fee:(double)fee rate:(double)rate exchangeToken:(double)tokenNum;

//判断地址是否有效
+(BOOL) validateAddress:(NSString*) address;

+ (UInt64)getRandomMaxValue:(int)max minValue:(int)min;

+ (NSString *)int64ToHex:(int64_t)tmpid;

+ (NSMutableData *)getLockDataWithCount:(double)value;

@end
