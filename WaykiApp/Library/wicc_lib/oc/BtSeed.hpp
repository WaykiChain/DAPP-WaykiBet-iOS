//
//  BtSeed.hpp
//  Test
//
//  Created by xgc on 12/19/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef BtSeed_hpp
#define BtSeed_hpp

#include <stdio.h>
#include <string>
#include "KeyCrypterScrypt.h"
#include "EncryptedData.h"

using namespace std;

class BtSeed
{
public:
    BtSeed();
    BtSeed(vector<uint8_t> seed, vector<string> mnemonicCode, EncryptedData encryptedMnemonicCode,
           EncryptedData encryptedSeed, long creationTimeSeconds, string pwdhash, vector<uint8_t> randomSalt);
    
    vector<uint8_t> getRandomSalt();
    EncryptedData getEncryptedSeed();
    EncryptedData getEncryptedMnemonicCode();
    long getCreationTimeSeconds();
    vector<uint8_t> getSeed();
    string getPwdhash();
    vector<string> getMnemonicCode();
    void setRandomSalt(vector<uint8_t> randomSalt);
    void setEncryptedSeed(EncryptedData encryptedSeed);
    void setEncryptedMnemonicCode(EncryptedData encryptedMnemonicCode);
    void setCreationTimeSeconds(long creationTimeSeconds);
    void setMnemonicCode(vector<string> mnemonicCode);
    void setPwdhash(string pwdhash);
    void setSeed(vector<uint8_t> seed);
private:
    vector<uint8_t> seed;
    vector<string> mnemonicCode;
    EncryptedData encryptedMnemonicCode;
    EncryptedData encryptedSeed;
    long creationTimeSeconds;
    string pwdhash;
    vector<uint8_t> randomSalt;
    
};

#endif /* BtSeed_hpp */
