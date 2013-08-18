//
//  ESXMLElement.m
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLElement.h"
#import "ESXMLDocument.h"
#import "ESXMLText.h"

@implementation ESXMLElement

- (id)initWithName:(NSString *)tagName attributes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        _tagName = tagName;
        
        if (attributes) {
            _attributes = [attributes mutableCopy];
        } else {
            _attributes = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    ESXMLElement *copy = [[[self class] allocWithZone:zone] init];
    copy.tagName = self.tagName;
    copy.attributes = self.attributes;
    copy.childNodes = self.childNodes;
    copy.firstChild = self.firstChild;
    copy.lastChild = self.lastChild;
    copy.ownerDocument = self.ownerDocument;
    return copy;
}

- (NSString *)nodeName{
    return _tagName;
}

- (unsigned short)nodeType{
    return ES_ELEMENT_NODE;
}

- (void)setInnerText:(NSString *)innerText{
    [_childNodes removeAllObjects];

    ESXMLText *node = [[ESXMLText alloc] initWithText:innerText];
    node.parentNode = self;
    node.ownerDocument = self.ownerDocument;
    self.firstChild = node;
    self.lastChild = node;
    [_childNodes addObject:node];
}

- (NSString *)innerText{
    NSMutableString *text = [[NSMutableString alloc] init];
    ESXMLNode *child = self.firstChild;
    while (child) {
        if (child.nodeType == ES_TEXT_NODE) {
            [text appendString:child.nodeValue];
        }
        if (child.nodeType == ES_ELEMENT_NODE) {
            NSString *subString = [(ESXMLElement *)child innerText];
            if (subString && [subString length]) {
                [text appendString:subString];
            }
        }
        child = child.nextSibling;
    }
    return text;
}

- (void)setInnerHTML:(NSString *)html{
    [_childNodes removeAllObjects];
    self.firstChild = nil;
    self.lastChild = nil;
    
    NSString *inner = [NSString stringWithFormat:@"<inner>%@</inner>",html];
    NSString *url = self.ownerDocument.URL;
    ESXMLDocument *document = [[ESXMLDocument alloc] initWithXMLString:inner baseURL:url];
    ESXMLNode *root = [document documentElement];
    ESXMLNode *child = root.firstChild;
    while (child) {
        [_childNodes addObject:child];
        
        child.ownerDocument = self.ownerDocument;
        child.parentNode = self;
        self.lastChild.nextSibling = child;
        child.previousSibling = self.lastChild;
        
        if (!self.firstChild) {
            self.firstChild = child;
        }
        self.lastChild = child;

        child = child.nextSibling;
    }
}

- (NSString *)innerHTML{
    NSMutableString *html = [[NSMutableString alloc] init];
    ESXMLNode *child = self.firstChild;
    while (child) {
        if (child.nodeType == ES_ELEMENT_NODE) {
            [html appendFormat:@"<%@",child.nodeName];
            for (NSString *attrName in [child.attributes allKeys]){
                NSString *attrValue = [child.attributes valueForKey:attrName];
                [html appendFormat:@" %@=\"%@\"",attrName,attrValue];
            }
            [html appendFormat:@">"];
        } else if (child.nodeType == ES_TEXT_NODE) {
            [html appendString:child.nodeValue];
        }
        
        if (child.nodeType == ES_ELEMENT_NODE) {
            NSString *subString = [(ESXMLElement *)child innerHTML];
            if (subString && [subString length]) {
                [html appendString:subString];
            }
            
            [html appendFormat:@"</%@>",child.nodeName];
        }
        child = child.nextSibling;
    }
    return html;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@ %p>",_tagName,self];
}


- (ESXMLElement *)getElementById:(NSString *)elementId{
    ESXMLElement *child = (ESXMLElement *)self.firstChild;
    while (child) {
        if (child.nodeType == ES_ELEMENT_NODE) {
            NSString *eleID = [child getAttribute:@"id"];
            if ([eleID isEqualToString:elementId]) {
                return child;
            }
            ESXMLElement *subElement = [child getElementById:elementId];
            if (subElement) {
                return subElement;
            }
        }
        child = (ESXMLElement *)child.nextSibling;
    }
    return nil;
}

- (NSArray *)getElementsByTagName:(NSString *)tagName{
    NSMutableArray *nodelist = [[NSMutableArray alloc] init];
    ESXMLElement *child = (ESXMLElement *)self.firstChild;
    while (child) {
        if (child.nodeType == ES_ELEMENT_NODE) {
            if ([child.nodeName isEqualToString:tagName]) {
                [nodelist addObject:child];
            } else if ([tagName isEqualToString:@"*"]){
                [nodelist addObject:child];
            }
            
            NSArray *sublist = [child getElementsByTagName:tagName];
            if (sublist && [sublist count]) {
                [nodelist addObjectsFromArray:sublist];
            }
        }
        child = (ESXMLElement *)child.nextSibling;
    }
    return nodelist;
}

- (NSArray *)getElementsByClassName:(NSString *)clsNames{
    NSMutableArray *nodeList = [[NSMutableArray alloc] init];
    ESXMLElement *child = (ESXMLElement *)self.firstChild;
    while (child) {
        NSArray *clsNameArray = [clsNames componentsSeparatedByString:@" "];
        NSArray *childClsArray = [[child getAttribute:@"class"] componentsSeparatedByString:@" "];
        BOOL match = YES;
        for (int i = 0; i < [clsNameArray count]; i++) {
            NSString *thisClassName = clsNameArray[i];
            if (![childClsArray containsObject:thisClassName]) {
                match = NO;
                continue;
            }
        }
        if (match) {
            [nodeList addObject:child]; 
        }
        
        NSArray *subList = [child getElementsByClassName:clsNames];
        if (subList && [subList count]) {
            [nodeList addObjectsFromArray:subList];
        }
        
        child = (ESXMLElement *)child.nextSibling;
    }
    return nodeList;
}

- (NSArray *)getElementsByName:(NSString *)name{
    NSMutableArray *nodeList = [[NSMutableArray alloc] init];
    ESXMLElement *child = (ESXMLElement *)self.firstChild;
    while (child) {
        if ([[child getAttribute:@"name"] isEqualToString:name]) {
            [nodeList addObject:child];
        }
        NSArray *subList = [child getElementsByName:name];
        if (subList && [subList count]) {
            [nodeList addObjectsFromArray:subList];
        }
        child = (ESXMLElement *)child.nextSibling;
    }
    return nodeList;
}

- (BOOL)hasAttribute:(NSString *)attrName{
    return [[_attributes allKeys] containsObject:attrName];
}

- (NSString *)getAttribute:(NSString *)attributeName{
    return [_attributes valueForKey:attributeName];
}

- (void)setAttribute:(NSString *)attributeName value:(NSString *)attributeValue{
    [_attributes setValue:attributeValue forKey:attributeName];
}

- (void)removeAttribute:(NSString *)attributeName{
    [_attributes removeObjectForKey:attributeName];
}

@end
