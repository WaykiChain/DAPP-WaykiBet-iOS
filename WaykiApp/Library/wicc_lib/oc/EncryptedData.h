//
//  EncryptedData.hpp
//  Test
//
//  Created by xgc on 12/19/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef EncryptedData_hpp
#define EncryptedData_hpp

#include <stdio.h>
#include <vector>

using namespace std;

class EncryptedData
{
public:

    vector<uint8_t> getIV();
    void setIV(vector<uint8_t> initialisationVector);
    vector<uint8_t> getEncryptedBytes();
    void setEncryptedBytes(vector<uint8_t> encryptedBytes);
private:
    vector<uint8_t> initialisationVector;
    vector<uint8_t> encryptedBytes;
};

#endif /* EncryptedData_hpp */
