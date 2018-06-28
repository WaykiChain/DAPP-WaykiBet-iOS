//
//  CoinType.h
//  Test
//
//  Created by xgc on 12/18/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef CoinType_h
#define CoinType_h

#include <string>
using namespace std;

enum CoinType {
    BTC = 1,
    ETH,
    LTC,
    SBTC,
    DOGE,
    ETC,
    WBTC,
    ZEC,
    DSH,
    BCH,
    QTUM,
    LBTC,
    WICC,
    NEO,
    GAS
};


enum NetworkType {
    MAIN = 1,
    TEST = 2,
    REGTEST = 3
};

class CoinSymbol {
public:
    static const std::string BTC;
    static const std::string ETH;
    static const std::string LTC;
    static const std::string SBTC;
    static const std::string DOGE;
    static const std::string ETC;
    static const std::string WBTC;
    static const std::string ZEC;
    static const std::string DSH;
    static const std::string BCH;
    static const std::string QTUM;
    static const std::string LBTC;
    static const std::string WICC;
    static const std::string NEO;
    static const std::string GAS;
};


#endif /* CoinType_h */
