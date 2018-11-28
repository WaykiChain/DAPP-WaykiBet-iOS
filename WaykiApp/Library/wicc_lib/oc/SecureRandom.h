//
//  SecureRandom.hpp
//  Test
//
//  Created by xgc on 12/18/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#ifndef SecureRandom_hpp
#define SecureRandom_hpp

#include <stdio.h>
#include <assert.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>

class SecureRandom
{
public:
    int random_number(uint8_t array[16], int len);
};

#endif /* SecureRandom_hpp */
