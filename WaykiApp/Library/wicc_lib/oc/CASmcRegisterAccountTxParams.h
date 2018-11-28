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

@interface CASmcRegisterAccountTxParams : SmcBaseTransactionSignParams


-(SmcRegisterAccountTxParams*) toSmcRegisterAccountTxParams;


@end
