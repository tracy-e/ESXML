//
//  ESXMLText.m
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLText.h"

@implementation ESXMLText

- (id)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        _wholeText = text;
        _length = [text length];
    }
    return self;
}

- (void)insertData:(NSRange)range withText:(NSString *)text{
    _wholeText = [_wholeText stringByReplacingCharactersInRange:range withString:text];
}

- (void)replaceData:(NSRange)range withText:(NSString *)text{
    _wholeText = [_wholeText stringByReplacingCharactersInRange:range withString:text];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<Text %p>:%@",self,_wholeText];
}

- (NSString *)nodeName{
    return @"#text";
}

- (NSString *)nodeValue{
    return _wholeText;
}

- (void)setNodeValue:(NSString *)nodeValue{
    _wholeText = nodeValue;
}

- (unsigned short)nodeType{
    return ES_TEXT_NODE;
}

@end
