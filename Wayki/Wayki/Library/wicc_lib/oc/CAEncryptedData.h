//
//  CAEncryptedData.h
//  Test
//
//  Created by xgc on 12/25/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EncryptedData.h"

@interface CAEncryptedData : NSObject

+(id)initWithEncryptedData: (EncryptedData*)data;

-(EncryptedData*) toEncryptedData;

@property(nonatomic, copy) NSMutableData* initialisationVector;
@property(nonatomic, copy) NSMutableData* encryptedBytes;

@end
