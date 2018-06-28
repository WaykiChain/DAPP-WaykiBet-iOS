//
//  CANetParams.h
//  Test
//
//  Created by xgc on 12/25/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAKeyPath.h"
#import "NetParams.hpp"

@interface CANetParams : NSObject

+(id)initWithNetParams: (NetParams*)params;
-(NetParams*) toNetParams;

@property(nonatomic, copy) NSString* csymbol;
@property(nonatomic, assign) NSInteger coinType;
@property(nonatomic, assign) NSInteger netType;
@property(nonatomic, retain) CAKeyPath* keyPath;
@property(nonatomic, assign) NSInteger version;

@property(nonatomic, assign) NSInteger HDprivate;
@property(nonatomic, assign) NSInteger HDpublic;
@property(nonatomic, assign) NSInteger P2KH;
@property(nonatomic, assign) NSInteger P2SH;
@property(nonatomic, assign) NSInteger keyprefixes;
@property(nonatomic, assign) NSInteger ApiVersion;
@property(nonatomic, assign) NSInteger N;
@property(nonatomic, assign) NSInteger R;
@property(nonatomic, assign) NSInteger P;

@end
