//
//  CABtcVout.h
//  Test
//
//  Created by xgc on 12/26/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CABtSeed.h"
#import "SmcCreateSignTransactionParams.hpp"
#import "TransactionSignParams.h"

@interface SmcBaseTransactionSignParams : TransactionSignParams


-(SmcBaseCreateSignTransactionParams*) toSmcBaseCreateSignTransactionParams;

@property(nonatomic, retain) CABtSeed* btSeed;
@property(nonatomic, copy) NSString* password;
@property(nonatomic, assign) NSInteger txType;
@property(nonatomic, assign) NSInteger txVersion;
@property(nonatomic, assign) NSInteger validHeight;
@property(nonatomic, assign) UInt64 fees;

@end
