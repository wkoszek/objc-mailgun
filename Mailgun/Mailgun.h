//
//  MailGun.h
//  MailGunExample
//
//  Created by Jay Baird on 1/11/13.
//  Copyright (c) 2013 Rackspace Hosting. All rights reserved.
//

#if !__has_feature(objc_arc)
#error Mailgun must be built with ARC.
// You can turn on ARC for Mailgun by adding -fobjc-arc on the build phase tab for each of its files.
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#import <Cocoa/Cocoa.h>
#endif

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPClient.h>
#import <Foundation/Foundation.h>

#import "MGMessage.h"

@interface Mailgun : AFHTTPClient

@property (nonatomic, retain) NSString *domain;

+ (instancetype)client;

- (void)setDomain:(NSString *)domain;
- (void)setAPIKey:(NSString *)apiKey;
- (void)sendMessage:(MGMessage *)message;
- (void)sendMessage:(MGMessage *)message success:(void (^)(NSString *messageId))success failure:(void (^)(NSError *error))failure;

@end
