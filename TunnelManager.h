//
//  TunnelManager.h
//  MonoProxy
//
//  Created by Bill Cheng on 2017/5/12.
//  Copyright © 2017年 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>

@interface TunnelManager : NSObject

+ (void)VPNStarted:(void (^)(BOOL isStarted))complete;

+ (void)loadProviderManager:(void (^)(NETunnelProviderManager *manager))complete;

+ (void)loadAndCreateProviderManager:(void (^)(NETunnelProviderManager *manager))complete;

@end
