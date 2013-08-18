//
//  ESXMLHttpRequest.h
//  ESXML
//
//  Created by Tracy E on 13-7-1.
//  Copyright (c) 2013 EsoftMobile.com All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESXMLHttpRequest;

typedef void (^ESXMLHttpRequestCallbackBlock) (ESXMLHttpRequest *req);

typedef enum {
    Uninitialized = 0,
    Open = 1,
    Send = 2,
    Receiving = 3,
    Loaded = 4
}ESXMLHttpRequestState;

@class ESXMLDocument;
@interface ESXMLHttpRequest : NSObject

@property (nonatomic, readonly) NSUInteger status;
@property (nonatomic, readonly, copy) NSString *statusText;
@property (nonatomic) ESXMLHttpRequestState readyState;
@property (nonatomic, copy) NSString *responseText;
@property (nonatomic, strong) ESXMLDocument *responseXML;
@property (nonatomic, copy) ESXMLHttpRequestCallbackBlock onreadystatechange;

- (NSDictionary *)getAllResponseHeaders;
- (void)setRequestHeader:(NSString *)header value:(NSString *)value;
- (NSString *)getResponseHeader:(NSString *)field;

- (void)open:(NSString *)method url:(NSString *)url async:(BOOL)async;
- (NSString *)send:(NSString *)body;
- (void)abort;

@end
