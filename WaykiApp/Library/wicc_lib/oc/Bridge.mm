//
//  Bridge.m
//  Wayki
//
//  Created by louis on 2018/3/27.
//  Copyright © 2018年 JuFeng. All rights reserved.
//

#import "Bridge.h"

#import "CoinApi.h"
#import "CANetParams.h"
#import "CAKeyPath.h"

#import "CABtWallet.h"
#import "CASmcContractTxParams.h"

#import "CASmcRegisterAccountTxParams.h"
#import "CASmcCommonTxParams.h"
#import "CABetItem.h"
#import "Constants.h"
#import "LotteryConst.h"
#import "NSString+Hash.h"
#import "NSString+HWHSize.h"
#import "WaykiApp-Swift.h"

@implementation Bridge

+ (CAKeyPath*)getCAKeyPath{
    CAKeyPath* keyPath = [[CAKeyPath alloc] init];
    keyPath.symbol = @"WICC";
    keyPath.path1 = 44;
    keyPath.hd1 = YES;
    keyPath.path2 = 99999;
    keyPath.hd2 = YES;
    keyPath.path3 = 0;
    keyPath.hd3 = YES;
    keyPath.path4 = 0;
    keyPath.hd4 = NO;
    keyPath.path5 = 0;
    keyPath.hd5 = NO;
    return  keyPath;
}

+ (CANetParams*)getCANetParamsText{
    CANetParams* netParams = [[CANetParams alloc]init];
    netParams.csymbol = COIN_SYMBOL_WICC;
    netParams.coinType = COIN_TYPE_WICC;
    netParams.netType = NETWORK_TYPE_TEST;
    netParams.version = 1;
    netParams.keyPath = self.getCAKeyPath;
    netParams.ApiVersion =2;
    netParams.HDprivate = 0x7d5c5a26;
    netParams.HDpublic = 0x7d573a2c;
    netParams.P2KH = 135;
    netParams.P2SH = 88;
    netParams.keyprefixes = 210;
    netParams.N = 32768;
    netParams.R = 8;
    netParams.P = 1;
    return netParams;
}

+ (CANetParams*)getCANetParamsMain{
    CANetParams* netParams = [[CANetParams alloc]init];
    netParams.csymbol = COIN_SYMBOL_WICC;
    netParams.coinType = COIN_TYPE_WICC;
    netParams.netType = NETWORK_TYPE_MAIN;
    netParams.version = 1;
    netParams.keyPath = self.getCAKeyPath;
    netParams.ApiVersion =2;
    netParams.HDprivate = 0x4c233f4b;
    netParams.HDpublic = 0x4c1d3d5f;
    netParams.P2KH = 73;
    netParams.P2SH = 51;
    netParams.keyprefixes = 153;
    netParams.N = 32768;
    netParams.R = 8;
    netParams.P = 1;
    return netParams;
}
    
+ (CANetParams*)getCANetParam{
    if ([Tools getWalletConfigure] == 1) {
        return [self getCANetParamsText];
    }
    
    return [self getCANetParamsMain];
}


+ (NSArray *)getAddressAndPrivateKeyWithHelpString:(NSString *)helpStr password:(NSString *)password{
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:password withNetParams:[self getCANetParam]];
    NSString * privateKey = [coinApi getPriKeyFromBtSeed:wallet.btSeed withPassword:password withNetParams:[self getCANetParam]];
    return  @[wallet.address,privateKey];
}

+ (NSArray *)getRamdomArrayWithArray:(NSArray *)array
{
    //随机数从这里边产生
    NSMutableArray *startArray=[NSMutableArray arrayWithArray:array];
    //随机数产生结果
    NSMutableArray *resultArray= [NSMutableArray array];
    //随机数个数
    for (int i=0; i<array.count; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

    
+ (NSArray *)getWalletHelpCodes{
    CoinApi* coinApi = [CoinApi sharedManager];
    return  [coinApi createAllCoinMnemonicCode];
}

+ (NSArray *)getWalletHelpCodesFrom:(NSString *)codestring
{
    NSArray *arr = [codestring componentsSeparatedByString:@" "];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];
    [arr1 removeObject:@" "];
    [arr1 removeObject:@""];
    return arr1;
}

+ (NSString *)getWalletHashFrom:(NSString *)codestring
{
    NSArray * helpcodes = [self getWalletHelpCodesFrom:codestring];
    int size = (int)helpcodes.count;
    int i = 0;
    NSMutableString* strWords = [[NSMutableString alloc]init];
    for(id word in helpcodes) {
        [strWords appendString:word];
        if(i != size - 1) {
            [strWords appendString:@" "];
        }
        i++;
    }
    return  strWords.sha512String;
}

+ (NSString *)getWaletHelpStringWithCodes:(NSArray *)helpcodes{
    // 产生钱包字符串
    int size = (int)helpcodes.count;
    int i = 0;
    NSMutableString* strWords = [[NSMutableString alloc]init];
    for(id word in helpcodes) {
        [strWords appendString:word];
        if(i != size - 1) {
            [strWords appendString:@" "];
        }
        i++;
    }
    return  strWords;
}

+ (BOOL)addressIsAble:(NSString *)address{
    return [[CoinApi sharedManager] validateAddress:address withNetParams:[self getCANetParam]];
}

+(BOOL) checkMnemonicCode:(NSArray*)words{
    return [[CoinApi sharedManager] checkMnemonicCode:words];
}

# pragma mark - 获取投注的签名
+ (NSString *)getBetSignWithHelpString:(NSString *)helpString
                           oldPassword:(NSString *)password
                           blockHeight:(double)height
                                 regID:(NSString *)regid
                             lotteryID:(NSString *)lottID
                           destAddress:(NSString *)destAdress
                              gameType:(int) gameType
                              playType:(int)playtype
                               betType:(int)bettype
                              betCount:(int)betcount
{
    CABtWallet *wallet = [[CoinApi sharedManager] createWallet:helpString withPassword:password withNetParams:[self getCANetParam]];
    CASmcContractTxParams* signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = password;
    signParams.fees =  [self getRandomMaxValue:500000 minValue:1000001];
    
    // NSLog(@"小费小费小费小费小费小费小费小费小费：%llu",signParams.fees);
    
    signParams.validHeight = height; //
    signParams.srcRegId = regid; //
    signParams.destAddr = destAdress; //
    signParams.txType = TX_WICC_BET;
    
    NSString* lid = lottID;
    NSString* addr = wallet.address;
    Byte ltype = gameType==0 ? lottery_basketball:lottery_football;
    
    CABetItem * item = [[CABetItem alloc]init];
    item.playType = playtype;
    item.betType = bettype;
    item.money =  UInt64(betcount)*100000000;

    NSMutableData * bin2 = [[CoinApi sharedManager] getBetContractData:lid withAddr:addr withType:ltype withBetItemList:@[item]];
    signParams.contract = bin2;
    
    NSMutableDictionary* resultMap = [[CoinApi sharedManager] createSignTransaction:signParams withNetParams:[self getCANetParam]];
    return resultMap[@"hex"];
}

+ (UInt64)getRandomMaxValue:(int)max minValue:(int)min {
    return UInt64(arc4random() % max)+min;
}


//获取激活hex
+ (NSString *)getActrivateHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight{
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:password withNetParams:[self getCANetParam]];

    CASmcRegisterAccountTxParams* signParams = [[CASmcRegisterAccountTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = password;
    signParams.fees = fees*100000000+UInt64(arc4random() % 100);
    signParams.validHeight = validHeight;
    signParams.txType = TX_WICC_REGISTERACCOUNT;
    
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParam]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
        
    }else{
        return @"";
    }
    
}

//获取转账wicc hex
+ (NSString *)getTransfetWICCHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr transferValue:(double)value {
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:password withNetParams:[self getCANetParam]];
    
    CASmcCommonTxParams* signParams = [[CASmcCommonTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = password;
    signParams.fees = fees*100000000+UInt64(arc4random() % 100);
    signParams.validHeight = validHeight;
    signParams.srcRegId = srcRegId;
    signParams.destAddr = destAddr;
    signParams.value = value*100000000;
    signParams.txType = TX_WICC_COMMON;
    
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParam]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
        
    }else{
        return @"";
    }
}

//获取转账SPC hex
+ (NSString *)getTransfetSPCHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value {
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:password withNetParams:[self getCANetParam]];
    
    CASmcContractTxParams*  signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = password;
    signParams.fees = fees * 100000000;
    signParams.validHeight = validHeight;
    signParams.srcRegId = srcRegId;
    signParams.destAddr = appId;
    signParams.txType = TX_WICC_TRANSFER_SPC;
    NSMutableData* bin = [coinApi getSpcContractData:destAddr withSpc: UInt64(value)*100000000];
    signParams.contract = bin;
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParam]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
        
    }else{
        return @"";
    }
}

+ (NSString *)getLockHexWithHelpStr:(NSString *)helpStr blockHeight:(double)validHeight regessID:(NSString *)regessID appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value {
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:@"" withNetParams:[self getCANetParam]];
    
    CASmcContractTxParams*  signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = @"";
    signParams.fees = 0.01 * 100000000;
    signParams.validHeight = validHeight;
    signParams.srcRegId = regessID;
    signParams.destAddr = appId;
    signParams.value = UInt64(value*100000000);
    signParams.txType = TX_WICC_BET;
    signParams.contract = [self getLockDataWithCount:value];
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParam]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
    }else{
        return @"";
    }
}

+ (NSString *)getUnlockHexWithHelpStr:(NSString *)helpStr blockHeight:(double)validHeight regessID:(NSString *)regessID appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value {
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:@"" withNetParams:[self getCANetParam]];
    
    CASmcContractTxParams*  signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = @"";
    signParams.fees = 0.01 * 100000000;
    signParams.validHeight = validHeight;
    signParams.srcRegId = regessID;
    signParams.destAddr = appId;
    signParams.value = UInt64(value*100000000);
    signParams.txType = TX_WICC_BET;
    signParams.contract = [self getUnlockDataWithCount:value];
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParam]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
    }else{
        return @"";
    }
}

//wicc兑换wusd
+ (NSArray *)getExchangeHexWithHelpStr:(NSString *)helpStr blockHeight:(double)validHeight regessID:(NSString *)regessID destAddr:(NSString *)destAddr exchangeValue:(double)value fee:(double)fee rate:(double)rate exchangeToken:(double)tokenNum{
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:@"" withNetParams:[self getCANetParam]];
    
    CASmcContractTxParams*  signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = @"";
    signParams.fees = fee    * 100000000 + UInt64(arc4random() % 100);
    signParams.validHeight = validHeight;
    signParams.srcRegId = regessID;
    signParams.destAddr = destAddr;
    signParams.value = UInt64(value*100000000);
    signParams.txType = TX_WICC_BET;
    signParams.contract = [self getExchangeDataWithEXRate:rate andTokenNum:tokenNum];
    NSString *contractStr = [self getExchangeStrWithEXRate:rate andTokenNum:tokenNum];
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParam]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return @[hex,contractStr];
    }else{
        return @[@"",contractStr];
    }
}


//判断地址是否有效
+(BOOL) validateAddress:(NSString*) address{
    CoinApi* coinApi = [CoinApi sharedManager];
    BOOL ret = [coinApi validateAddress:address withNetParams:[self getCANetParam]];
    return ret;
}

+ (NSMutableData *)getLockDataWithCount:(double)value
{
    NSString * header = @"f202";
    NSString * hexs = [self int64ToHex:UInt64(value*100000000)];
    NSString * countreverse = [self hexToReverseHex:hexs];
    NSString * hexReveseS = [self resultHexString:countreverse];
    NSString * all = [NSString stringWithFormat:@"%@%@",header,hexReveseS];
    
    NSLog(@"%@",hexs);
    NSLog(@"%@",countreverse);
    NSLog(@"%@",hexReveseS);
    return [NSMutableData dataWithData:[self convertHexStrToData:all]];
}

+ (NSMutableData *)getUnlockDataWithCount:(double)value{
    NSString * header = @"f203";
    NSString * hexs = [self int64ToHex:UInt64(value*100000000)];
    NSString * countreverse = [self hexToReverseHex:hexs];
    NSString * hexReveseS = [self resultHexString:countreverse];
    NSString * all = [NSString stringWithFormat:@"%@%@",header,hexReveseS];
    return [NSMutableData dataWithData:[self convertHexStrToData:all]];
}


+(NSString *)getExchangeStrWithEXRate:(double)rate andTokenNum:(double)tokenNum{
    //魔法数 + 方法名 + 预留参数
    NSString * header = @"f0040000";
    //汇率，先*10000，再转化为16进制，再网络序
    NSString * hex1 = [self int64ToHex:UInt64(rate*10000)];
    NSString * countreverse1 = [self hexToReverseHex:hex1];
    NSString * hexReveseS1 = [self resultHexString:countreverse1];
    
    //兑换的token数量，先*100000000，再转化为16进制，再网络序
    NSString * hex2 = [self int64ToHex:UInt64(tokenNum*100000000)];
    NSString * countreverse2 = [self hexToReverseHex:hex2];
    NSString * hexReveseS2 = [self resultHexString:countreverse2];
    
    NSString * all = [NSString stringWithFormat:@"%@%@%@",header,hexReveseS1,hexReveseS2];
    return all;
}

//兑换组装合约参数
+ (NSMutableData *)getExchangeDataWithEXRate:(double)rate andTokenNum:(double)tokenNum{
    NSString *all = [self getExchangeStrWithEXRate:rate andTokenNum:tokenNum];
    return [NSMutableData dataWithData:[self convertHexStrToData:all]];
}

+ (NSString *)int64ToHex:(int64_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    int64_t ttmpig;
    for (int i = 0; i<19; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig) {
            case 10:
                nLetterValue =@"a";break;
            case 11:
                nLetterValue =@"b";break;
            case 12:
                nLetterValue =@"c";break;
            case 13:
                nLetterValue =@"d";break;
            case 14:
                nLetterValue =@"e";break;
            case 15:
                nLetterValue =@"f";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%lld",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

+ (NSString *)resultHexString:(NSString *)str{
    NSString * result = [NSString new];
    if (str.length == 0){
        result = [NSString stringWithFormat:@"%@%@",str,@"0000000000000000"];
    }else if (str.length == 1){
        result = [NSString stringWithFormat:@"%@%@",str,@"000000000000000"];
    }else if (str.length == 2){
        result = [NSString stringWithFormat:@"%@%@",str,@"00000000000000"];
    }else if (str.length == 3){
        result = [NSString stringWithFormat:@"%@%@",str,@"0000000000000"];
    }else if (str.length == 4){
        result = [NSString stringWithFormat:@"%@%@",str,@"000000000000"];
    }else if (str.length == 5){
        result = [NSString stringWithFormat:@"%@%@",str,@"00000000000"];
    }else if (str.length == 6){
        result = [NSString stringWithFormat:@"%@%@",str,@"0000000000"];
    }else if (str.length == 7){
        result = [NSString stringWithFormat:@"%@%@",str,@"000000000"];
    }else if (str.length == 8){
        result = [NSString stringWithFormat:@"%@%@",str,@"00000000"];
    }else if (str.length == 9){
        result = [NSString stringWithFormat:@"%@%@",str,@"0000000"];
    }else if (str.length == 10){
        result = [NSString stringWithFormat:@"%@%@",str,@"000000"];
    }else if (str.length == 11){
        result = [NSString stringWithFormat:@"%@%@",str,@"00000"];
    }else if (str.length == 12){
        result = [NSString stringWithFormat:@"%@%@",str,@"0000"];
    }else if (str.length == 13){
        result = [NSString stringWithFormat:@"%@%@",str,@"000"];
    }else if (str.length == 14){
        result = [NSString stringWithFormat:@"%@%@",str,@"00"];
    }else if (str.length == 15){
        result = [NSString stringWithFormat:@"%@%@",str,@"0"];
    }else if (str.length == 16){
        return str;
    }
    return result;
}


+(NSString *)resultHexString:(NSString*)str maxLen:(int)maxLen{
    NSString *result = @"";
    
    return result;
}
//
//+(NSString *)addZero:(NSString *)str withLength:(int)length{
//    NSString *string = nil;
//    if (str.length==length) {
//        return str;
//    }
//
//    if (str.length<length) {
//        NSUInteger inter = length-str.length;
//        for (int i=0;i< inter; i++) {
//            string = [NSString stringWithFormat:@"0%@",str];
//            str = string;
//        }
//    }
//    return string;
//}

// 16进制字符串 -> 逆序16进制字符串
+ (NSString *)hexToReverseHex:(NSString *)hex{
    NSString * transferhex;
    if (hex.length % 2 == 1){
        transferhex = [NSString stringWithFormat:@"%@%@",@"0",hex];
    }else{
        transferhex = hex;
    }
    NSMutableArray * array = [NSMutableArray new];
    for(NSUInteger i=0;i<transferhex.length/2;i+=1){
        NSRange range = NSMakeRange(i*2, 2);
        NSString *sub = [transferhex substringWithRange:range];
        [array addObject:sub];
    }
    
    NSArray *nuarray = [[array reverseObjectEnumerator]allObjects];
    
//    NSLog(@"%@",nuarray);
    
    NSMutableString * numbers = [[NSMutableString alloc]init];
    for(int i = 0;i<nuarray.count;i++){
        [numbers appendString:nuarray[i]];
    }
    return numbers;
}



// 16进制字符串 -> 2进制数据
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end




 
