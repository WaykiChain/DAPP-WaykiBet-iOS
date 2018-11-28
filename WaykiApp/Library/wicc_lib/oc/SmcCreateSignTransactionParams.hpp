//
//  BtcCreateSignTransactionParams.hpp
//  Test
//
//  Created by xgc on 12/21/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef SmcCreateSignTransactionParams_hpp
#define SmcCreateSignTransactionParams_hpp

#include "CreateSignTransactionParams.hpp"
#include "BtSeed.hpp"

#include <vector>
#include <string>
#include "uint256.h"
#include "smcutil.h"

using namespace std;

bool toPublicKey(string strPublicKey, vector<uint8_t>& encode);

class SmcBaseCreateSignTransactionParams : public CreateSignTransactionParams
{
public:
    virtual string SerializeTx(){return "";};

    bool signtx(vector<uint8_t> secret);

    unsigned char getNTxType() const;

    void setNTxType(unsigned char nTxType);

    int getNVersion() const;

    void setNVersion(int nVersion);

    int getNValidHeight() const;

    void setNValidHeight(int nValidHeight);

    uint64_t getFees() const;

    void setFees(uint64_t fees);

    const vector<unsigned char> &getSignature() const;

    void setSignature(const vector<unsigned char> &signature);

    const string &getPassword() const;

    void setPassword(const string &password);

    const BtSeed &getBtSeed() const;

    void setBtSeed(const BtSeed &btSeed);

protected:
    virtual uint256 SignatureHash() {
        
        return uint256S("0");
    };

    BtSeed btSeed;
    string password;
    unsigned char nTxType;
    int nVersion;
    int nValidHeight;
    uint64_t fees;
    vector<unsigned char> signature;

};

class SmcRegisterAccountTxParams : public SmcBaseCreateSignTransactionParams
{
public:
    virtual string SerializeTx();

    const string &getPubkey() const;

    void setPubkey(const string &pubkey);

    const string &getMinerPubkey() const;

    void setMinerPubkey(const string &minerPubkey);

private:
    virtual uint256 SignatureHash();

    string pubkey; //pubkey
    string minerPubkey; //Miner pubkey

};

class SmcCommonTxParams : public SmcBaseCreateSignTransactionParams
{
public:
    virtual string SerializeTx();

    const string &getSrcAddr() const;

    void setSrcAddr(const string &srcAddr);

    const string &getDestAddr() const;

    void setDestAddr(const string &destAddr);

    uint64_t getValue() const;

    void setValue(uint64_t value);

protected:
    virtual uint256 SignatureHash();

    string srcAddr;
    string destAddr;
    uint64_t value;
};

class SmcContractTxParams : public SmcCommonTxParams
{
public:
    virtual string SerializeTx();

    const vector<uint8_t> &getContract() const;

    void setContract(const vector<uint8_t> &contract);
private:
    virtual uint256 SignatureHash();

    vector<uint8_t> contract;
};

class SmcVoteFund
{
public:
    const string &getPubkey() const;

    void setPubkey(const string &pubkey);

    uint64_t getValue() const;

    void setValue(uint64_t value);
private:
    string pubkey;
    uint64_t value;
};

class SmcOperVoteFund
{
public:
    uint8_t getOperType() const;

    void setOperType(uint8_t operType);

    const SmcVoteFund &getFund() const;

    void setFund(const SmcVoteFund &fund);

private:
    uint8_t operType;
    SmcVoteFund fund;
};

class SmcDelegateTxParams : public SmcBaseCreateSignTransactionParams
{
public:
    virtual string SerializeTx() {return "";}

    const string &getSrcAddr() const;

    void setSrcAddr(const string &srcAddr);

    const vector<SmcOperVoteFund> &getOperVoteFunds() const;

    void setOperVoteFunds(const vector<SmcOperVoteFund> &operVoteFunds);
private:
    string srcAddr;
    vector<SmcOperVoteFund> operVoteFunds;
};

#endif /* SmcCreateSignTransactionParams_hpp */
