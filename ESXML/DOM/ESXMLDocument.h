//
//  ESXMLDoument.h
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLNode.h"

@class ESXMLElement;
@class ESXMLText;
@interface ESXMLDocument : ESXMLNode<NSXMLParserDelegate>

@property (nonatomic, strong, readonly) ESXMLElement *documentElement;
@property (nonatomic, copy, readonly) NSString *URL;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, weak, readonly) ESXMLElement *head;
@property (nonatomic, weak, readonly) ESXMLElement *body;

- (id)initWithXMLString:(NSString *)string baseURL:(NSString *)url;

//standard
- (ESXMLElement *)createElement:(NSString *)tagName;
- (ESXMLText *)createTextNode:(NSString *)text;

- (ESXMLElement *)getElementById:(NSString *)elementId;
- (NSArray *)getElementsByTagName:(NSString *)tagName;

//extended
- (NSArray *)getElementsByClassName:(NSString *)clsNames;
- (NSArray *)getElementsByName:(NSString *)name;

@end
