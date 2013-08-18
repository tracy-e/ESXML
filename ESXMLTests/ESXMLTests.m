//
//  ESXMLTests.m
//  ESXMLTests
//
//  Created by Tracy E on 13-7-1.
//  Copyright (c) 2013 EsoftMobile.com All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ESDOMCore.h"

@interface ESXMLTests : XCTestCase

@end

@implementation ESXMLTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSString *xmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];

    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        ESXMLElement *x = [xmlDoc getElementsByTagName:@"title"][0];
        ESXMLElement *y = [x childNodes][0];
        XCTAssertTrue([y.nodeValue isEqualToString:@"Everyday Italian"], @"Get an Element Value");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        NSString *txt = [[xmlDoc getElementsByTagName:@"title"][0] getAttribute:@"lang"];
        XCTAssertTrue([txt isEqualToString:@"en"], @"Get an Attribute Value");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        ESXMLElement *x = [[xmlDoc getElementsByTagName:@"title"][0] childNodes][0];
        x.nodeValue = @"Easy Cooking";
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@"Easy Cooking"], @"Change the Value of a Text Node");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        NSArray *x = [xmlDoc getElementsByTagName:@"book"];
        [x[0] setAttribute:@"Category" value:@"food"];
        XCTAssertTrue([[[xmlDoc getElementsByTagName:@"book"][0] getAttribute:@"Category"] isEqualToString:@"food"], @"Change an Attribute Using setAttribute()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"] count] == 4, @"Number of book nodes");
        ESXMLElement *y = [xmlDoc getElementsByTagName:@"book"][0];
        [xmlDoc.documentElement removeChild:y];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"] count] == 3, @"Number of book nodes after removeChild()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"] count] == 4, @"Number of book nodes before removeChild()");
        ESXMLElement *x = [xmlDoc getElementsByTagName:@"book"][0];
        [x.parentNode removeChild:x];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"] count] == 3, @"Number of book nodes after removeChild()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        XCTAssertTrue([[[xmlDoc getElementsByTagName:@"title"][0] childNodes] count] == 1, @"Child nodes before removeChild()");
        ESXMLElement *x = [xmlDoc getElementsByTagName:@"title"][0];
        ESXMLNode *y = [x childNodes][0];
        [x removeChild:y];
        XCTAssertTrue([[[xmlDoc getElementsByTagName:@"title"][0] childNodes] count] == 0, @"Child nodes after removeChild()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@"Everyday Italian"], @"nodeValue");
        ESXMLElement *x = [[xmlDoc getElementsByTagName:@"title"][0] childNodes][0];
        x.nodeValue = @"";
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@""], @"nodeValue");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        XCTAssertTrue([[[xmlDoc getElementsByTagName:@"book"][0] getAttribute:@"category"] isEqualToString:@"cooking"], @"attribute before removeAttribute()");
        NSArray *x = [xmlDoc getElementsByTagName:@"book"];
        [x[0] removeAttribute:@"category"];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"][0] getAttribute:@"category"] == nil, @"attribute after removeAttribute()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        NSArray *x = [xmlDoc getElementsByTagName:@"book"];
        
        for (int i = 0; i < [x count]; i++) {
            while ([[x[i] attributes] count] > 0) {
                ESXMLElement *y = x[i];
                NSString *attnode = [[y attributes] allKeys][0];
                NSLog(@"Removed: %@ : %@", attnode, [y getAttribute:attnode]);
                [x[i] removeAttribute:attnode];
            }
        }
        
        x = [xmlDoc getElementsByTagName:@"book"];
        for (int i = 0; i < [x count]; i++) {
            ESXMLElement *y = x[i];
            XCTAssertTrue([[y attributes] count] == 0, @"after removed all attributes");
        }
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        
        ESXMLElement *x = [xmlDoc documentElement];
        ESXMLElement *newNode = [xmlDoc createElement:@"book"];
        ESXMLElement *newTitle = [xmlDoc createElement:@"title"];
        ESXMLText *newText = [xmlDoc createTextNode:@"A Notebook"];
        
        [newTitle appendChild:newText];
        [newNode appendChild:newTitle];
        
        ESXMLElement *y = [xmlDoc getElementsByTagName:@"book"][0];
        [x replaceChild:newNode oldChild:y];

        NSArray *z = [xmlDoc getElementsByTagName:@"title"];
        for (int i = 0; i < [z count]; i++) {
            NSLog(@"%@",[[z[i] childNodes][0] nodeValue]);
        }
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@"A Notebook"], @"Replace an Element Node");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@"Everyday Italian"], @"Before");
        
        ESXMLText *x = [[xmlDoc getElementsByTagName:@"title"][0] childNodes][0];
        [x replaceData:NSMakeRange(0, 8) withText:@"Easy"];
        
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@"Easy Italian"], @"After");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        ESXMLElement *newel = [xmlDoc createElement:@"edition"];
        
        ESXMLElement *x = [xmlDoc getElementsByTagName:@"book"][0];
        [x appendChild:newel];
        
        XCTAssertTrue([[[xmlDoc getElementsByTagName:@"edition"][0] nodeName] isEqualToString:@"edition"], @"Create a New Element Node");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        ESXMLElement *x = [xmlDoc getElementsByTagName:@"book"][0];
        [x setAttribute:@"edition" value:@"first"];
        
        XCTAssertTrue([[x getAttribute:@"edition"] isEqualToString:@"first"], @"Create an Attribute Using setAttribute()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        ESXMLElement *newel = [xmlDoc createElement:@"edition"];
        ESXMLText *newtext = [xmlDoc createTextNode:@"first"];
        [newel appendChild:newtext];
        
        ESXMLElement *x = [xmlDoc getElementsByTagName:@"book"][0];
        [x appendChild:newel];
        
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"edition"][0] childNodes][0] nodeValue] isEqualToString:@"first"], @"Create a Text Node");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"] count] == 4, @"Book elements before");
        ESXMLElement *newel = [xmlDoc createElement:@"book"];
        ESXMLElement *x = [xmlDoc documentElement];
        ESXMLElement *y = [xmlDoc getElementsByTagName:@"book"][3];
        [x insertBefore:newel refChild:y];
        XCTAssertTrue([[xmlDoc getElementsByTagName:@"book"] count] == 5, @"Book elements after");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        ESXMLText *x = [[xmlDoc getElementsByTagName:@"title"][0] childNodes][0];
        [x insertData:NSMakeRange(0, 0) withText:@"Easy "];
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue] isEqualToString:@"Easy Everyday Italian"], @"Add Text to Text Node, insertData()");
    }
    
    @autoreleasepool {
        ESXMLDocument *xmlDoc = [[ESXMLDocument alloc] initWithXMLString:xmlString baseURL:nil];
        
        ESXMLElement *oldNode = [xmlDoc getElementsByTagName:@"book"][0];
        ESXMLElement *newNode = [oldNode cloneNode:YES];
        [[xmlDoc documentElement] appendChild:newNode];
        NSArray *y = [xmlDoc getElementsByTagName:@"title"];
        NSLog(@"==============");
        for (int i = 0; i < [y count]; i++) {
            NSLog(@"%@", [[y[i] childNodes][0] nodeValue]);
        }
        XCTAssertTrue([[[[xmlDoc getElementsByTagName:@"title"][4] childNodes][0] nodeValue] isEqualToString:[[[xmlDoc getElementsByTagName:@"title"][0] childNodes][0] nodeValue]], @"Copy a Node");
    }
    
    @autoreleasepool {
        ESXMLHttpRequest *xmlhttp = [[ESXMLHttpRequest alloc] init];
        xmlhttp.onreadystatechange = ^(ESXMLHttpRequest *req) {
            NSLog(@"readyState:%d", req.readyState);
            NSLog(@"status:%d", req.status);
            if (req.readyState == 4 && req.status == 200) {
                NSLog(@"responseText: %@", req.responseText);
                NSLog(@"responseXML: %@", req.responseXML);
                ESXMLDocument *xmlDoc = req.responseXML;
                NSArray *titles = [xmlDoc getElementsByTagName:@"title"];
                for (ESXMLElement *element in titles) {
                    NSLog(@"%@",[[element childNodes][0] nodeValue]);
                }
            }
        };
        [xmlhttp open:@"GET" url:@"http://w3school.com.cn/example/xdom/books1.xml" async:YES];
        [xmlhttp send:nil];
    }
}

@end
