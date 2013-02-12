//
//  MailGun.h
//  MailGunExample
//
//  Created by Jay Baird on 1/11/13.
//  Copyright (c) 2013 Rackspace Hosting. All rights reserved.
//

#import "Mailgun.h"

NSString * const kMailgunURL = @"https://api.mailgun.net/v2";

@implementation Mailgun

+ (instancetype)client {
    static dispatch_once_t onceToken;
    static Mailgun *client;
    dispatch_once(&onceToken, ^{
        client = [[Mailgun alloc] initWithBaseURL:[NSURL URLWithString:kMailgunURL]];
    });
    return client;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        self.parameterEncoding = AFFormURLParameterEncoding;
    }
    return self;
}

- (void)setAPIKey:(NSString *)apiKey {
    NSParameterAssert(apiKey);
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithUsername:@"api" password:apiKey];
}

- (void)buildFormData:(id<AFMultipartFormData>)formData withAttachments:(NSDictionary *)attachments {
    NSUInteger idx = 1;
    [attachments enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *type = obj[0];
        NSData *data = obj[1];
        NSString *name = [NSString stringWithFormat:@"attachment[%d]", idx];
        [formData appendPartWithFileData:data name:name fileName:key mimeType:type];
    }];
}

- (NSURLRequest *)createSendRequest:(MGMessage *)message {
    NSString *messagePath = [NSString stringWithFormat:@"%@/%@", self.domain, @"messages"];
    NSDictionary *params = [message dictionary];
    NSURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                            path:messagePath
                                                      parameters:params
                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                           [self buildFormData:formData withAttachments:message.attachments];
                                           [self buildFormData:formData withAttachments:message.inlineAttachments];
        
                                       }];
    return request;
}

- (void)sendMessage:(MGMessage *)message {
    [self sendMessage:message success:nil failure:nil];
}

- (void)sendMessage:(MGMessage *)message
            success:(void (^)(NSString *messageId))success
            failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:[self createSendRequest:message]
                                                                      success:^(AFHTTPRequestOperation *_operation, id responseObject) {
                                                                          if (success) {
                                                                              success(responseObject[@"id"]);
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *_operation, NSError *error) {
                                                                          NSLog(@"%@", error);
                                                                          if (failure) {
                                                                              failure(error);
                                                                          }
                                                                      }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)checkSubscriptionToList:(NSString *)list
                        address:(NSString *)emailAddress
                        success:(void (^)(NSDictionary *member))success
                        failure:(void (^)(NSError *error))failure {
    NSString *messagePath = [NSString stringWithFormat:@"lists/%@/%@/%@", list, @"members", emailAddress];
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:messagePath
                                         parameters:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *_operation, id responseObject) {
                                                                          if (success) {
                                                                              success(responseObject);
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *_operation, NSError *error) {
                                                                          NSLog(@"%@", error);
                                                                          if (failure) {
                                                                              failure(error);
                                                                          }
                                                                      }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)unsubscribeToList:(NSString *)list
                  address:(NSString *)emailAddress
                  success:(void (^)())success
                  failure:(void (^)(NSError *error))failure {
    NSString *messagePath = [NSString stringWithFormat:@"lists/%@/%@/%@", list, @"members", emailAddress];
    NSURLRequest *request = [self requestWithMethod:@"DELETE"
                                               path:messagePath
                                         parameters:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *_operation, id responseObject) {
                                                                          if (success) {
                                                                              success();
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *_operation, NSError *error) {
                                                                          NSLog(@"%@", error);
                                                                          if (failure) {
                                                                              failure(error);
                                                                          }
                                                                      }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)subscribeToList:(NSString *)list 
                address:(NSString *)emailAddress
                success:(void (^)())success
                failure:(void (^)(NSError *error))failure {
    NSString *messagePath = [NSString stringWithFormat:@"lists/%@/%@", list, @"members"];
    NSDictionary *params = @{@"address": emailAddress,
                             @"subscribed": @"yes",
                             @"upsert": @"yes"};
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:messagePath
                                         parameters:params];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *_operation, id responseObject) {
                                                                          if (success) {
                                                                              success();
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *_operation, NSError *error) {
                                                                          NSLog(@"%@", error);
                                                                          if (failure) {
                                                                              failure(error);
                                                                          }
                                                                      }];
    [self enqueueHTTPRequestOperation:operation];
}

@end
