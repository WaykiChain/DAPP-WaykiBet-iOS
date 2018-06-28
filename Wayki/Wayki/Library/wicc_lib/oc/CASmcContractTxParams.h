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
#import "CASmcCommonTxParams.h"

@interface CASmcContractTxParams : CASmcCommonTxParams


-(SmcContractTxParams*) toSmcContractTxParams;

@property(nonatomic, copy) NSMutableData* contract;

@end
