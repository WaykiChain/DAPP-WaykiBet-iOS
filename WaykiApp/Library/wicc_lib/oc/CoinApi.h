//
//  CoinApi.h
//  Test
//
//  Created by xgc on 12/25/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CABtSeed;
@class CANetParams;
@class CABtWallet;
@class TransactionSignParams;

@interface CoinApi : NSObject

+(id)sharedManager;

/*
 获取助记词列表
 */
-(NSMutableArray*) createAllCoinMnemonicCode;

/*
 检查助记词列表
 */
-(BOOL) checkMnemonicCode:(NSArray*)words;

/*
 根据 加密种子获取 解密后的私钥
 */
-(NSString*) getPriKeyFromBtSeed:(CABtSeed*) btSeed withPassword:(NSString*) password withNetParams:(CANetParams*) netParams;

/*
 根据 加密种子获取 解密后的助记词
 */
-(NSMutableArray*) getMnemonicCodeFromBtSeed:(CABtSeed*) btSeed withPassword:(NSString*) password withNetParams:(CANetParams*) netParams;

/*
 验证地址有效性
 */
-(BOOL) validateAddress:(NSString*) address withNetParams:(CANetParams*) netParams;

/*
 修改密码
 */
-(CABtSeed*) changePassword: (CABtSeed*) btSeed withOldPassword: (NSString*)oldPassword withNewPassword: (NSString*) newPassword withNetParams:(CANetParams*) netParams;

/*
 一次创建一个地址
 */
-(CABtWallet*) createWallet: (NSString*) words withPassword: (NSString*)password withNetParams: (CANetParams*) netParams;


/*
 创建签名交易
 */
-(NSMutableDictionary*) createSignTransaction: (TransactionSignParams*) signParams withNetParams: (CANetParams*) netParams;

/*
 wicc 超级币转账合约
 */
-(NSMutableData*) getSpcContractData: (NSString*) address withSpc: (UInt64) spc;

/*
 wicc 投注合约
 */
-(NSMutableData*) getBetContractData: (NSString*) lid withAddr: (NSString*) address withType: (NSInteger)ltype withBetItemList: (NSArray*) betList;

@end
