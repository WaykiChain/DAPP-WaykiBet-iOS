
#import <Foundation/Foundation.h>

//币类型
extern int const COIN_TYPE_WICC;

//币符号
extern NSString* const COIN_SYMBOL_WICC;

//网络类型
extern int const NETWORK_TYPE_MAIN;
extern int const NETWORK_TYPE_TEST;
extern int const NETWORK_TYPE_REGTEST;

//交易类型
extern int const TX_NONE;
//激活
extern int const TX_WICC_REGISTERACCOUNT;
//wicc转账
extern int const TX_WICC_COMMON;
//spc转账
extern int const TX_WICC_TRANSFER_SPC;
//投注
extern int const TX_WICC_BET;
