//
//  ESXMLText.h
//  ESXML
//
//  Created by Tracy E(tracy.cpp@gmail.com) on 12-9-8.
//  Copyright (c) 2012 EsoftMobile.com. All rights reserved.
//

#import "ESXMLNode.h"

@interface ESXMLText : ESXMLNode

@property (nonatomic, readonly) unsigned length;
@property (nonatomic, copy) NSString *wholeText;

- (id)initWithText:(NSString *)text;

- (void)insertData:(NSRange)range withText:(NSString *)text;
- (void)replaceData:(NSRange)range withText:(NSString *)text;
@end
