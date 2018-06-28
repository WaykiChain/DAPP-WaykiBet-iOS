//
//  CAKeyPath.h
//  Test
//
//  Created by xgc on 12/25/17.
//  Copyright © 2017 xgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyPath.hpp"


@interface CAKeyPath : NSObject

+(id)initWithKeyPath: (KeyPath*)path;
-(KeyPath*)toKeyPath;

@property(nonatomic, assign) NSInteger path1;
@property(nonatomic, assign) NSInteger path2;
@property(nonatomic, assign) NSInteger path3;
@property(nonatomic, assign) NSInteger path4;
@property(nonatomic, assign) NSInteger path5;
@property(nonatomic, copy) NSString* symbol;
@property(nonatomic, assign) BOOL hd1;
@property(nonatomic, assign) BOOL hd2;
@property(nonatomic, assign) BOOL hd3;
@property(nonatomic, assign) BOOL hd4;
@property(nonatomic, assign) BOOL hd5;

@end
