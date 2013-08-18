//
//  ESXMLElement.h
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLNode.h"

@interface ESXMLElement : ESXMLNode

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *innerText;
@property (nonatomic, copy) NSString *innerHTML;

- (id)initWithName:(NSString *)tagName attributes:(NSDictionary *)attributes;

//standard
- (ESXMLElement *)getElementById:(NSString *)elementId;
- (NSArray *)getElementsByTagName:(NSString *)tagName;

- (BOOL)hasAttribute:(NSString *)attributeName;
- (NSString *)getAttribute:(NSString *)attributeName;
- (void)setAttribute:(NSString *)attributeName value:(NSString *)attributeValue;
- (void)removeAttribute:(NSString *)attributeName;

//extended
- (NSArray *)getElementsByClassName:(NSString *)clsNames;
- (NSArray *)getElementsByName:(NSString *)name;
@end
