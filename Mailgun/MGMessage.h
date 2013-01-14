//
//  MGMessage.h
//  MailGunExample
//
//  Created by Jay Baird on 1/11/13.
//  Copyright (c) 2013 Rackspace Hosting. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#import <Cocoa/Cocoa.h>
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
typedef NS_ENUM(NSUInteger, ImageAttachmentType) {
    PNGFileType,
    JPEGFileType,
};
#endif

typedef NS_ENUM(NSUInteger, ClickTrackingType) {
    TrackHTMLClicks,
    TrackAllClicks
};

@interface MGMessage : NSObject
@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSArray *to;
@property (nonatomic, retain) NSArray *cc;
@property (nonatomic, retain) NSArray *bcc;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *html;
@property (nonatomic, retain) NSString *campaign;
@property (nonatomic, retain, readonly) NSArray *tags;
@property (nonatomic, retain, readonly) NSMutableDictionary *headers;
@property (nonatomic, retain, readonly) NSMutableDictionary *variables;
@property (nonatomic, retain, readonly) NSMutableDictionary *attachments;
@property (nonatomic, retain, readonly) NSMutableDictionary *inlineAttachments;
@property (nonatomic) BOOL *dkim;
@property (nonatomic) BOOL *testing;
@property (nonatomic) BOOL *tracking;
@property (nonatomic) BOOL *trackOpens;
@property (nonatomic, retain) NSDate *deliverAt;
@property (nonatomic) ClickTrackingType trackClicks;
@property (nonatomic, retain) NSDictionary *recipientVariables;

+ (instancetype)messageFrom:(NSString *)from
                         to:(NSString *)to
                    subject:(NSString *)subject
                       body:(NSString *)body;

- (id)initWithFrom:(NSString *)from
                to:(NSString *)to
           subject:(NSString *)subject
              body:(NSString *)body;

- (NSDictionary *)dictionary;
- (void)addTag:(NSString *)tag;
- (void)addTags:(NSArray *)tags;
- (void)addHeader:(NSString *)header value:(NSString *)value;
- (void)addVariable:(NSString *)var value:(NSString *)value;
- (void)addRecipient:(NSString *)recipient;
- (void)addCc:(NSString *)recipient;
- (void)addBcc:(NSString *)recipient;
- (void)addAttachment:(NSData *)data withName:(NSString *)name type:(NSString *)type;
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (void)addImage:(UIImage *)image withName:(NSString *)name type:(ImageAttachmentType)type;
- (void)addImage:(UIImage *)image withName:(NSString *)name type:(ImageAttachmentType)type inline:(BOOL)inlineAttachment;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
- (void)addImage:(NSImage *)image withName:(NSString *)name type:(NSBitmapImageFileType)type;
- (void)addImage:(NSImage *)image withName:(NSString *)name type:(NSBitmapImageFileType)type inline:(BOOL)inlineAttachment;
#endif
@end
