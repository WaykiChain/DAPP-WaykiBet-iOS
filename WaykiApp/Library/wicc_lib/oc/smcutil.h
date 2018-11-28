
#ifndef smcutil_hpp
#define smcutil_hpp

#include <string>
#include <vector>
#include <string.h>
using namespace std;

#pragma pack(1)
typedef struct {
    unsigned char systype;
    unsigned char type;
    unsigned char address[34]; //  发币地址
    uint64_t mMoney;//数量

}SPC_SEND;

typedef struct {
    uint8_t play_tpe;
    uint8_t bet_type;
    uint32_t times;
    uint64_t mMoney;
} BetItem;

typedef struct {
    uint8_t systype;
    uint8_t type;
    uint8_t lid[36];
    uint8_t address[34];
    uint8_t ltype;
} BetInfo;

#pragma pack()

template<typename T>
std::string HexStr2(const T itbegin, const T itend);

template<typename T>
inline std::string HexStr2(const T& vch);

string GetHexData(const char*pData,size_t nLen);

bool getSpcContractData(string address, uint64_t spc, vector<unsigned char>& data);

bool getBetContractData(string lid, string address, uint8_t ltype, vector<BetItem> betList, vector<unsigned char>& data);

#endif