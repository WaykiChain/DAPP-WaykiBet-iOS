

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

//+ (CANetParams*)getCANetParams{
//    CANetParams* netParams = [[CANetParams alloc]init];
//    netParams.csymbol = COIN_SYMBOL_WICC;
//    netParams.coinType = COIN_TYPE_WICC;
//    netParams.netType = NETWORK_TYPE_TEST;
//    netParams.version = 1;
//    netParams.keyPath = self.getCAKeyPath;
//    netParams.ApiVersion =2;
//    netParams.HDprivate = 0x7d5c5a26;
//    netParams.HDpublic = 0x7d573a2c;
//    netParams.P2KH = 135;
//    netParams.P2SH = 88;
//    netParams.keyprefixes = 210;
//    netParams.N = 32768;
//    netParams.R = 8;
//    netParams.P = 1;
//    return netParams;
//}

+ (CANetParams*)getCANetParams{
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
+ (NSArray *)getAddressAndPrivateKeyWithHelpString:(NSString *)helpStr{
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:@"" withNetParams:self.getCANetParams];
    NSString * privateKey = [coinApi getPriKeyFromBtSeed:wallet.btSeed withPassword:@"" withNetParams:self.getCANetParams];
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
    return [[CoinApi sharedManager] validateAddress:address withNetParams:self.getCANetParams];
}

+(BOOL) checkMnemonicCode:(NSArray*)words{
    return [[CoinApi sharedManager] checkMnemonicCode:words];
}

# pragma mark - 获取投注的签名
+ (NSString *)getBetSignWithHelpString:(NSString *)helpString
                           blockHeight:(double)height
                                 regID:(NSString *)regid
                             lotteryID:(NSString *)lottID
                           destAddress:(NSString *)destAdress
                              gameType:(int) gameType
                              playType:(int)playtype
                               betType:(int)bettype
                              betCount:(int)betcount
{
    CABtWallet *wallet = [[CoinApi sharedManager] createWallet:helpString withPassword:@"" withNetParams:self.getCANetParams];
    CASmcContractTxParams* signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = @"";
    signParams.fees =  [self getRandomMaxValue:500000 minValue:1000001];
    
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
    
    NSMutableDictionary* resultMap = [[CoinApi sharedManager] createSignTransaction:signParams withNetParams:self.getCANetParams];
    return resultMap[@"hex"];
}

+ (UInt64)getRandomMaxValue:(int)max minValue:(int)min {
    return UInt64(arc4random() % max)+min;
}


//获取激活hex
+ (NSString *)getActrivateHexWithHelpStr:(NSString *)helpStr withPassword:(NSString *)password Fees:(double)fees validHeight:(double)validHeight{
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:password withNetParams:self.getCANetParams];
    
    CASmcRegisterAccountTxParams* signParams = [[CASmcRegisterAccountTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = password;
    signParams.fees = fees*100000000+UInt64(arc4random() % 100);
    signParams.validHeight = validHeight;
    signParams.txType = TX_WICC_REGISTERACCOUNT;
    
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParams]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
        
    }else{
        return @"";
    }
    
}

//获取转账wicc hex
+ (NSString *)getTransfetWICCHexWithHelpStr:(NSString *)helpStr Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr transferValue:(double)value {
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:@"" withNetParams:self.getCANetParams];
    
    CASmcCommonTxParams* signParams = [[CASmcCommonTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = @"";
    signParams.fees = fees*100000000+UInt64(arc4random() % 100);
    signParams.validHeight = validHeight;
    signParams.srcRegId = srcRegId;
    signParams.destAddr = destAddr;
    signParams.value = value*100000000;
    signParams.txType = TX_WICC_COMMON;
    
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParams]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
        
    }else{
        return @"";
    }
}

//获取转账SPC hex
+ (NSString *)getTransfetSPCHexWithHelpStr:(NSString *)helpStr Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId appId:(NSString *)appId destAddr:(NSString *)destAddr transferValue:(double)value {
    CoinApi* coinApi = [CoinApi sharedManager];
    CABtWallet *wallet = [coinApi createWallet:helpStr withPassword:@"" withNetParams:self.getCANetParams];
    
    CASmcContractTxParams*  signParams = [[CASmcContractTxParams alloc]init];
    signParams.btSeed = wallet.btSeed;
    signParams.password = @"";
    signParams.fees = fees * 100000000;
    signParams.validHeight = validHeight;
    signParams.srcRegId = srcRegId;
    signParams.destAddr = appId;
    signParams.txType = TX_WICC_TRANSFER_SPC;
    NSMutableData* bin = [coinApi getSpcContractData:destAddr withSpc: UInt64(value)*100000000];
    signParams.contract = bin;
    
    NSMutableDictionary* resultMap = [coinApi createSignTransaction:signParams withNetParams:[self getCANetParams]];
    if ([resultMap.allKeys containsObject:@"hex"]) {
        NSString *hex = resultMap[@"hex"];
        return hex;
        
    }else{
        return @"";
    }
}
//判断地址是否有效
+(BOOL) validateAddress:(NSString*) address{
    CoinApi* coinApi = [CoinApi sharedManager];
    BOOL ret = [coinApi validateAddress:address withNetParams:[self getCANetParams]];
    return ret;
}



@end




