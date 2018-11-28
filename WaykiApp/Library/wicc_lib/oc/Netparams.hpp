//
//  Netparams.hpp
//  Test
//
//  Created by xgc on 12/19/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef Netparams_hpp
#define Netparams_hpp

#include "CoinType.h"
#include "KeyPath.hpp"

#include <string>
using namespace std;

class NetParams
{
private:
    string symbol;
    CoinType coinType;
    NetworkType nettype;
    KeyPath keyPath;
    uint32_t version;

    uint32_t HDprivate;
    uint32_t HDpublic;
    uint32_t P2KH;
    uint32_t P2SH;
    uint8_t keyprefixes;

    uint16_t ApiVersion;

    uint32_t N;
    uint32_t R;
    uint32_t P;
public:
    NetParams();

    string getSymbol();
    CoinType getCoinType();
    NetworkType getNetType();
    KeyPath getKeyPath();
    uint32_t getVersion();
    uint32_t getHDprivate();
    uint32_t getHDpublic();
    uint32_t getP2KH();
    uint32_t getP2SH();
    uint8_t getKeyprefixes();
    uint16_t getApiVersion();
    uint32_t getN();
    uint32_t getR();
    uint32_t getP();
    
    void setSymbol(string symbol);
    void setCoinType(CoinType coinType);
    void setNetType(NetworkType netType);
    void setKeyPath(KeyPath keyPath);
    void setVersion(uint32_t version);
    void setN(uint32_t N);
    void setR(uint32_t R);
    void setP(uint32_t P);

    void setHDprivate(uint32_t HDprivate);
    void setHDpublic(uint32_t HDpublic);
    void setP2KH(uint32_t P2KH);
    void setP2SH(uint32_t P2SH);
    void setKeyprefixes(uint8_t keyprefixes);
    void setApiVersion(uint16_t ApiVersion);
};

#endif /* Netparams_hpp */
