//
//  BtWallet.hpp
//  Test
//
//  Created by xgc on 12/19/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef BtWallet_hpp
#define BtWallet_hpp

#include <stdio.h>
#include "BtSeed.hpp"

class BtWallet
{
public:
    string getAddress();
    void setAddress(string address);
    string getSymbol();
    void setSymbol(string symbol);
    BtSeed* getBtSeed();
    void setBtSeed(BtSeed* btSeed);
private:
    BtSeed* btSeed;
    string address;
    string symbol;
};

#endif /* BtWallet_hpp */
