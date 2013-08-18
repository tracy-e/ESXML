//
//  ESXMLDoument.m
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLDocument.h"
#import "ESXMLElement.h"
#import "ESXMLText.h"

@interface ESXMLDocument (PrivateMethods)

- (void)pushNode:(ESXMLElement *)element;
- (void)popNode;
- (void)addNode:(ESXMLNode *)node;
- (void)flushCharacters;

@end

@implementation ESXMLDocument{
    __unsafe_unretained ESXMLElement *   _topElement;
    __unsafe_unretained ESXMLNode *      _lastNode;
    
    NSMutableString *                    _chars;
    NSMutableArray *                     _stack;
}

- (id)initWithXMLString:(NSString *)string baseURL:(NSString *)url{
    self = [super init];
    if (self) {
        _URL = url;

        //NSXMLParser only support standard entites : &lt; &gt; &apos; &quot; &amp;
        string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        
        NSData *data = [string dataUsingEncoding:string.fastestEncoding];
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
        xmlParser.delegate = self;
        [xmlParser parse];
        
        NSError *error = [xmlParser parserError];
        if (error) {
            return nil;
        }
    }
    return self;
}

- (ESXMLElement *)createElement:(NSString *)tagName{
    ESXMLElement *element = [[ESXMLElement alloc] initWithName:tagName attributes:nil];
    element.ownerDocument = self;
    return element;
}

- (ESXMLText *)createTextNode:(NSString *)text{
    ESXMLText *textNode = [[ESXMLText alloc] initWithText:text];
    textNode.ownerDocument = self;
    return textNode;
}

- (ESXMLElement *)getElementById:(NSString *)elementId{
    return [_documentElement getElementById:elementId];
}

- (NSArray *)getElementsByTagName:(NSString *)tagName{
    return [_documentElement getElementsByTagName:tagName];
}

- (NSArray *)getElementsByClassName:(NSString *)clsNames{
    return [_documentElement getElementsByClassName:clsNames];
}

- (NSArray *)getElementsByName:(NSString *)name{
    return [_documentElement getElementsByName:name];
}

- (unsigned short)nodeType{
    return ES_DOCUMENT_NODE;
}

- (NSString *)nodeName{
    return @"#document";
}

- (NSString *)title{
    return [[self getElementsByTagName:@"title"][0] innerText];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushNode:(ESXMLElement *)element{
    if (!_stack) {
        _stack = [[NSMutableArray alloc] init];
    }
    [self addNode:element];
    [_stack addObject:element];
    _topElement = element;
    
    if ([element.tagName isEqualToString:@"head"]) {
        _head = element;
    } else if ([element.tagName isEqualToString:@"body"]){
        _body = element;
    }
}

- (void)addNode:(ESXMLNode *)node{
    node.ownerDocument = self;
    if (!_documentElement) {
        _documentElement = (ESXMLElement *)node;
        _lastNode = node;
    } else if (_topElement) {
        [_topElement appendChild:node];
    } else {
        _lastNode.nextSibling = node;
        _lastNode = node;
    }
}

- (void)popNode{
    ESXMLElement *element = [_stack lastObject];
    if (element) {
        [_stack removeLastObject];
    }
    _topElement = [_stack lastObject];
}

- (void)flushCharacters{
    if (_chars.length) {
        ESXMLText *node = [[ESXMLText alloc] initWithText:_chars];
        [self addNode:node];
    }
    _chars = nil;
}

#pragma mark NSXMLParserDelegate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict{
    NSString *tag = [elementName lowercaseString];
    ESXMLElement *element = [[ESXMLElement alloc] initWithName:tag attributes:attributeDict];
    [self pushNode:element];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!_chars) {
        _chars = [string mutableCopy];
    } else {
        [_chars appendString:string];
    }
    [self flushCharacters];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    [self flushCharacters];
    [self popNode];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error %i,Description: %@, Line: %i", [parseError code],
          [parseError localizedDescription], [parser lineNumber]);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    NSLog(@"%s  %@",__FUNCTION__,validationError);
}

@end
