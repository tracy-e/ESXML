//
//  ESXMLNode.m
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLNode.h"

@implementation ESXMLNode

- (id)init{
    self = [super init];
    if (self) {
        _childNodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setOwnerDocument:(ESXMLDocument *)ownerDocument{
    _ownerDocument = ownerDocument;
    
    ESXMLNode *child = self.firstChild;
    while (child) {
        child.ownerDocument = ownerDocument;
        child = child.nextSibling;
    }
}

- (void)visitTree{
    NSLog(@"%@",self);
    ESXMLNode *child = self.firstChild;
    while (child) {
        [child visitTree];
        child = [child nextSibling];
    }
}

- (ESXMLNode *)insertBefore:(ESXMLNode *)newChild refChild:(ESXMLNode *)refChild{
    if (refChild == _firstChild) {
        newChild.parentNode = self;
        newChild.nextSibling = refChild;
        refChild.previousSibling = newChild;
        _firstChild = newChild;
    } else {
        newChild.parentNode = self;
        refChild.previousSibling.nextSibling = newChild;
        newChild.previousSibling = refChild.previousSibling;
        newChild.nextSibling = refChild;
        refChild.previousSibling = newChild;
        if (refChild == _lastChild) {
            _lastChild = newChild;
        }
    }
    [_childNodes insertObject:newChild atIndex:[_childNodes indexOfObject:refChild]];
    return newChild;
}

- (ESXMLNode *)replaceChild:(ESXMLNode *)newChild oldChild:(ESXMLNode *)oldChild{
    if (oldChild == _firstChild) {
        oldChild.nextSibling.previousSibling = newChild;
        newChild.nextSibling = oldChild.nextSibling;
        oldChild.nextSibling = nil;
        _firstChild = newChild;
    }else{
        ESXMLNode *node = _firstChild;
        while (node) {
            if (node.nextSibling == oldChild) {
                if (newChild) {
                    newChild.nextSibling = oldChild.nextSibling;
                    node.nextSibling = newChild;
                } else {
                    node.nextSibling = oldChild.nextSibling;
                }
                oldChild.nextSibling = nil;
                newChild.parentNode = self;
                if (oldChild == _lastChild) {
                    _lastChild = newChild ? newChild : node;
                }
                break;
            }
            node = node.nextSibling;
        }
    }
    _childNodes[[_childNodes indexOfObject:oldChild]] = newChild;
    return newChild;
}

- (ESXMLNode *)removeChild:(ESXMLNode *)oldChild{
    if (oldChild == _firstChild) {
        _firstChild = oldChild.nextSibling;
        oldChild.nextSibling = nil;
        oldChild.previousSibling = nil;
    }else if (oldChild == _lastChild){
        _lastChild = oldChild.previousSibling;
        oldChild.previousSibling.nextSibling = nil;
        oldChild.previousSibling = nil;
    }else{
        oldChild.previousSibling.nextSibling = oldChild.nextSibling;
        oldChild.nextSibling.previousSibling = oldChild.previousSibling;
        oldChild.nextSibling = nil;
        oldChild.previousSibling = nil;
    }
    oldChild.parentNode = nil;
    [_childNodes removeObject:oldChild];
    return oldChild;
}

- (ESXMLNode *)appendChild:(ESXMLNode *)newChild{
    if (!_firstChild) {
        _firstChild = newChild;
        _lastChild = newChild;
    } else {
        _lastChild.nextSibling = newChild;
        newChild.previousSibling = _lastChild;
        _lastChild = newChild;
    }
    newChild.parentNode = self;
    [_childNodes addObject:newChild];
    return newChild;
}

- (BOOL)hasChildNodes{
    return [_childNodes count] ? YES : NO;
}

- (id)cloneNode:(BOOL)deep{
    ESXMLNode *clone = [self copy];
    if (!deep) {
        clone.firstChild = nil;
        clone.lastChild = nil;
        [clone.childNodes removeAllObjects];
    } 
    return clone;
}

- (BOOL)isSameNode:(ESXMLNode *)other{
    if (other && other == self) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualNode:(ESXMLNode *)other{
    if (!other) {
        return NO;
    }
    if (_nodeType != [other nodeType]) {
        return NO;
    }
    if (![_nodeName isEqualToString:[other nodeName]]) {
        return NO;
    }
    if (![_nodeValue isEqualToString:[other nodeValue]]) {
        return NO;
    }
    if (!_attributes && [other attributes]) {
        return NO;
    }
    if (!_childNodes && [other childNodes]) {
        return NO;
    }
    if (![_childNodes isEqualToArray:[other childNodes]]) {
        return NO;
    }
    if (![_attributes isEqualToDictionary:[other attributes]]) {
        return NO;
    }
    
    ESXMLNode *child = _firstChild;
    ESXMLNode *otherChild = other.firstChild;
    while (child) {
        return [child isEqualNode:otherChild];
        
        child = child.nextSibling;
        otherChild = otherChild.nextSibling;
    }
    return YES;
}


@end
