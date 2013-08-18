ESXML
=====

ESXML is a DOM based XML Parser for Objective-C.

**ESXMLDocument.h**

```objective-c
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
```

**ESXMLElement.h**

```objective-c
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
```

**ESXMLNode.h**

```objective-c
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

@end
```

**ESXMLText.h**

```objective-c
@interface ESXMLText : ESXMLNode

@property (nonatomic, readonly) unsigned length;
@property (nonatomic, copy) NSString *wholeText;

- (id)initWithText:(NSString *)text;

- (void)insertData:(NSRange)range withText:(NSString *)text;
- (void)replaceData:(NSRange)range withText:(NSString *)text;
@end

```

**ESXMLHttpRequest.h**

```objective-c
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
```