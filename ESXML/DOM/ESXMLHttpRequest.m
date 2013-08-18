//
//  ESXMLHttpRequest.m
//  ESXML
//
//  Created by Tracy E on 13-7-1.
//  Copyright (c) 2013 EsoftMobile.com All rights reserved.
//

#import "ESXMLHttpRequest.h"
#import "ESXMLDocument.h"

@implementation ESXMLHttpRequest {
    NSURLConnection *       _urlConnection;
    NSMutableDictionary *   _requestHeaders;
    NSDictionary *          _responseHeaders;
    NSMutableData *         _receivedData;
    NSString *              _method;
    NSString *              _urlString;
    BOOL                    _async;
}

- (id)init{
    self = [super init];
    if (self) {
        _requestHeaders = [[NSMutableDictionary alloc] init];
        _readyState = Uninitialized;
    }
    return self;
}

- (void)open:(NSString *)method url:(NSString *)url async:(BOOL)async{
    _method = method;
    _urlString = url;
    _async = async;
    
    _readyState = Open;
    _onreadystatechange(self);
}

- (void)abort{
    [_urlConnection cancel];
    _receivedData = nil;
}

- (NSDictionary *)getAllResponseHeaders{
    return _responseHeaders;
}

- (void)setRequestHeader:(NSString *)header value:(NSString *)value{
    [_requestHeaders setValue:value forKey:header];
}

- (NSString *)getResponseHeader:(NSString *)field{
    return [_requestHeaders valueForKey:field];
}

- (NSString *)send:(NSString *)body{
    _readyState = Send;
    _onreadystatechange(self);
    
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0f];
    [request setHTTPMethod:_method];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Type"];
    for (NSString *field in [_requestHeaders allKeys]) {
        NSString *value = [_requestHeaders valueForKey:field];
        [request setValue:value forHTTPHeaderField:field];
    }
    
    if (_async) {
        _receivedData = [[NSMutableData alloc] init];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];
        
    } else {
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        [self didReceiveResponse:response];
        [self didFinishReceiveData:responseData];
        return _responseText;
    }
    return nil;
}

- (void)didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
    _status = [urlResponse statusCode];
    _statusText = [NSHTTPURLResponse localizedStringForStatusCode:_status];
    _responseHeaders = [urlResponse allHeaderFields];
    
    _readyState = Receiving;
    _onreadystatechange(self);
}

- (void)didFinishReceiveData:(NSData *)data{
    _responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *contentType = [_responseHeaders valueForKey:@"Content-Type"];
    NSArray *xmlTypes = @[@"application/xml", @"text/html", @"text/xml"];
    if ([xmlTypes containsObject:contentType]) {
        _responseXML = [[ESXMLDocument alloc] initWithXMLString:_responseText baseURL:_urlString];
    }
    
    _readyState = Loaded;
    _onreadystatechange(self);
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self didFinishReceiveData:_receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
@end
