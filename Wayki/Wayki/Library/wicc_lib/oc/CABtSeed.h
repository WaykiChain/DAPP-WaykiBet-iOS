//
//  CABtSeed.h
//  Test
//
//  Created by xgc on 12/25/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAEncryptedData.h"

@interface CABtSeed : NSObject

+(id)initWithBtSeed: (BtSeed*)seed;

-(BtSeed*)toBtSeed;

@property(nonatomic, copy) NSMutableData* seed;
@property(nonatomic, copy) NSMutableArray* mnemonicCode;
@property(nonatomic, assign) NSInteger creationTimeSeconds;
@property(nonatomic, copy) NSString* pwdhash;
@property(nonatomic, copy) NSMutableData* randomSalt;
@property(nonatomic, retain) CAEncryptedData* encryptedMnemonicCode;
@property(nonatomic, retain) CAEncryptedData* encryptedSeed;

@end
