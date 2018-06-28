//
//  CABtcVout.h
//  Test
//
//  Created by xgc on 12/26/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "smcutil.h"

@interface CABetItem : NSObject

+(id)initWithBetItem: (BetItem*)betItem;

-(BetItem*) toBetItem;

@property(nonatomic, assign) NSInteger playType;
@property(nonatomic, assign) NSInteger betType;
@property(nonatomic, assign) UInt64 money;

@end
