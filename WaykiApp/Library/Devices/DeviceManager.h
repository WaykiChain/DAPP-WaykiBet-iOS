//
//  DeviceManager.h
//  WaykiApp
//
//  Created by sorath on 2018/11/1.
//  Copyright © 2018 WaykiChain. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceManager : NSObject

#pragma mark - 设备具体信息
/** 设备类型 */
+ (NSString *)getDeviceModel;
/** 设备UUID */
+ (NSString *)getDeviceUUID;
/** 设备名称 */
+ (NSString *)getDeviceName;
/** 系统版本 */
+ (NSString *)getDeviceSystemVersion;


#pragma mark - 电池
/** 电量 */
+ (NSString *)getBatteryQuantity;
/** 电池状态 */
+ (NSString *)getBatteryStauts;

#pragma mark - 内存
/** 总内存 */
+ (long long)getTotalMemorySize;
/** 可用内存 */
+ (long long)getAvailableMemorySize;
/** 已用内存 */
+ (double)getUsedMemory;

#pragma mark - 磁盘
/** 总磁盘容量 */
+ (long long)getTotalDiskSize;
/** 可用磁盘容量 */
+ (long long)getAvailableDiskSize;

/** 容量换算器 */
+ (NSString *)fileSizeToString:(unsigned long long)fileSize;

#pragma mark - 网络
/** IP 地址 */
+ (NSString *)currentIPAdress;
/** Mac 地址 */
+ (NSString *)currentWifiMacAddress;
/** Wifi 名称 */
+ (NSString *)currentWifiName;


@end

