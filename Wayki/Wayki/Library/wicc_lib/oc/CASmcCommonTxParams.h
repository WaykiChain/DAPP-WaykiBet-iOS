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
#import "SmcBaseTransactionSignParams.h"

@interface CASmcCommonTxParams : SmcBaseTransactionSignParams


-(SmcCommonTxParams*) toSmcCommonTxParams;

@property(nonatomic, copy) NSString* srcRegId;
@property(nonatomic, copy) NSString* destAddr;
@property(nonatomic, assign) UInt64 value;

@end
