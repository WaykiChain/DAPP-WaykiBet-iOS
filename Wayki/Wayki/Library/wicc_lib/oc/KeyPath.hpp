//
//  KeyPath.hpp
//  Test
//
//  Created by xgc on 12/19/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef KeyPath_hpp
#define KeyPath_hpp

#include <string>
using namespace std;

class KeyPath
{
public:
    KeyPath();
    int getPath1();
    int getPath2();
    int getPath3();
    int getPath4();
    int getPath5();
    string getSymbol();
    bool getHd1();
    bool getHd2();
    bool getHd3();
    bool getHd4();
    bool getHd5();
    void setPath1(int path1);
    void setPath2(int path2);
    void setPath3(int path3);
    void setPath4(int path4);
    void setPath5(int path5);
    void setSymbol(string symbol);
    void setHd1(bool hd1);
    void setHd2(bool hd2);
    void setHd3(bool hd3);
    void setHd4(bool hd4);
    void setHd5(bool hd5);
private:
    int path1;
    int path2;
    int path3;
    int path4;
    int path5;
    string symbol;
    bool hd1;
    bool hd2;
    bool hd3;
    bool hd4;
    bool hd5;
};

#endif /* KeyPath_hpp */
