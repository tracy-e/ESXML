

//
//  ESXMLNode.h
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ES_ELEMENT_NODE = 1,
    ES_ATTRIBUTE_NODE = 2,
    ES_TEXT_NODE = 3,
    ES_COMMENT_NODE = 8,
    ES_DOCUMENT_NODE = 9,
};

@class ESXMLDocument;
@interface ESXMLNode : NSObject{
    NSMutableDictionary *   _attributes;
    NSMutableArray *        _childNodes;
}

@property (readonly, copy) NSString *nodeName;
@property (nonatomic, copy) NSString *nodeValue;
@property (readonly) unsigned short nodeType;

@property (nonatomic, weak) ESXMLDocument *ownerDocument;
@property (nonatomic, weak) ESXMLNode *parentNode;
@property (nonatomic, weak) ESXMLNode *firstChild;
@property (nonatomic, weak) ESXMLNode *lastChild;
@property (nonatomic, weak) ESXMLNode *previousSibling;
@property (nonatomic, weak) ESXMLNode *nextSibling;

@property (nonatomic, strong) NSMutableArray *childNodes;
@property (nonatomic, strong) NSMutableDictionary *attributes;

- (ESXMLNode *)insertBefore:(ESXMLNode *)newChild refChild:(ESXMLNode *)refChild;
- (ESXMLNode *)replaceChild:(ESXMLNode *)newChild oldChild:(ESXMLNode *)oldChild;
- (ESXMLNode *)removeChild:(ESXMLNode *)oldChild;
- (ESXMLNode *)appendChild:(ESXMLNode *)newChild;

- (BOOL)hasChildNodes;
- (id)cloneNode:(BOOL)deep;
- (BOOL)isSameNode:(ESXMLNode *)other;
- (BOOL)isEqualNode:(ESXMLNode *)other;

- (void)visitTree;
@end
