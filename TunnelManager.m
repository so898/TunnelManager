//
//  TunnelManager.m
//  MonoProxy
//
//  Created by Bill Cheng on 2017/5/12.
//  Copyright © 2017年 XXX. All rights reserved.
//

#import "TunnelManager.h"

@implementation TunnelManager

+ (void)VPNStarted:(void (^)(BOOL isStarted))complete{
    [TunnelManager loadProviderManager:^(NETunnelProviderManager *manager) {
        if (nil == manager || manager.connection.status == NEVPNStatusDisconnected || manager.connection.status == NEVPNStatusDisconnecting || manager.connection.status == NEVPNStatusInvalid){
            complete(NO);
            return;
        }
        complete(YES);
    }];
}

+ (void)loadProviderManager:(void (^)(NETunnelProviderManager *manager))complete {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error);
        }
        if (managers.count > 0){
            complete([managers objectAtIndex:0]);
        } else {
            complete(nil);
        }
    }];
}

+ (void)loadAndCreateProviderManager:(void (^)(NETunnelProviderManager *manager))complete {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error);
        }
        NETunnelProviderManager *manager = nil;
        if (managers.count > 0){
            manager = [managers objectAtIndex:0];
        } else {
            manager = [NETunnelProviderManager new];
            manager.protocolConfiguration = [NETunnelProviderProtocol new];
        }
        manager.enabled = YES;
        manager.localizedDescription = @"xxx";
        manager.protocolConfiguration.serverAddress = @"xxx";
        manager.onDemandEnabled = YES;
        NEOnDemandRuleEvaluateConnection *quickStartRule = [NEOnDemandRuleEvaluateConnection new];
        quickStartRule.connectionRules = @[[[NEEvaluateConnectionRule alloc] initWithMatchDomains:@[@"com.xxx.proxy"] andAction:NEEvaluateConnectionRuleActionConnectIfNeeded]];
        manager.onDemandRules = @[quickStartRule];
        [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            if (nil != error){
                complete(nil);
            } else {
                [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                    if (nil != error){
                        complete(nil);
                    } else {
                        complete(manager);
                    }
                }];
            }
        }];
    }];
}

@end
