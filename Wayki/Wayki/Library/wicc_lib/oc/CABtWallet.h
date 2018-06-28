//
//  CABtWallet.h
//  Test
//
//  Created by xgc on 12/26/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtWallet.hpp"
#import "CABtSeed.h"

@interface CABtWallet : NSObject

+(id)initWithBtWallet: (BtWallet*)wallet;

@property(nonatomic, retain) CABtSeed* btSeed;
@property(nonatomic, copy) NSString* address;
@property(nonatomic, copy) NSString* symbol;

@end
