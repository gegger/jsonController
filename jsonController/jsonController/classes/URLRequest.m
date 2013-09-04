//
//  URLRequest.m
//  jsonController
//
//  Created by gegger on 9/2/13.
//  Copyright (c) 2013 Illion IT Group. All rights reserved.
//

#import "URLRequest.h"

@interface URLRequest(){
    NSURLRequest *request;
    NSURLConnection *connection;
    int completionType;
    NSMutableData *webData;
}
@end

@implementation URLRequest
@synthesize delegate = _delegate;
@synthesize rawData;
@synthesize httpStatusCode;

- (id)initWithRequest:(NSURLRequest*)_request
{
    self = [super init];
    if (self != nil)
    {
        request = _request;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark Public functions
///////////////////////////////////////////////////////////////////////////
- (void)startWithCompletion:(void (^)(URLRequest* request, NSMutableDictionary* result, NSError* error))_completion
{
    delegate=nil;
    completionType=usingBlockOnCompletion;
    completion = [_completion copy];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
#if ! __has_feature(objc_arc)
        webData = [[NSMutableData data] retain];
        result = [[NSMutableDictionary alloc] init];

#else
        webData = [[NSMutableData alloc] init];
#endif
        
    }
    else
    {
        completion(self, nil, [NSError errorWithDomain:@"Failed connect." code:1 userInfo:nil]);
    }
}

-(void)startWithDelegate:(id)adelegate
{
    completionType=usingDelegateOnCompletion;
    delegate = adelegate;
    [delegate requestShouldStart:request];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        webData = [[NSMutableData alloc] init];
    }
    else
    {
        [delegate requestFailed:self withError:nil];
    }
}

- (void)startWithNoCallback
{
    delegate=nil;
    completionType=usingNoCallbackFunctions;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        webData = [[NSMutableData alloc] init];
    }
    else
    {
        NSLog(@"connection error");
    }
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    if (webData != nil)
        [webData release];
    if (connection != nil)
        [connection release];
    [super dealloc];
}
#endif

///////////////////////////////////////////////////////////////////////////
#pragma mark Private functions
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
#pragma mark NSURLConnection delegate
///////////////////////////////////////////////////////////////////////////
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    rawData = [webData copy];
    NSString *resultString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];

    NSError *error;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if(resultString.length > 0) {
        
        NSData *jsonData = [NSData dataWithBytes:[resultString UTF8String] length:[resultString length]];
        id parsedJson = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if(parsedJson || [parsedJson isKindOfClass:[NSArray class]]) {
            result = [[NSMutableDictionary alloc] initWithObjectsAndKeys:parsedJson,@"data", nil];
        }
        else {
            NSLog(@"%s:%@",__PRETTY_FUNCTION__, @"Answer is not JSON compilant.");
            result = [[NSMutableDictionary alloc] init];
            error = [NSError errorWithDomain:@"Answer is not JSON compilant." code:10 userInfo:nil];
        }
    }
    else {
        NSLog(@"%s:%@",__PRETTY_FUNCTION__, @"Empty answer.");
        result = [[NSMutableDictionary alloc] init];
        error = [NSError errorWithDomain:@"Empty answer" code:11 userInfo:nil];
    }
    
    //callback functions
    if (completionType==usingBlockOnCompletion){
        //run completion block
        if(!error){
            completion(self, result, nil);
        }
        else {
            completion(self, result, error);
        }
    }
    else if(completionType==usingDelegateOnCompletion){
        //call delegate
        if(!error){
            [delegate requestFinished:self withResult:result];
        }
        else {
            [delegate requestFailed:self withError:error];
        }
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    httpStatusCode = [httpResponse statusCode];
    [webData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (completionType==usingBlockOnCompletion){
        //run completion block
        completion(self, nil, error);
    }
    else
    if (completionType==usingDelegateOnCompletion){
        //call requestFailed delegate
        [delegate requestFailed:self withError:error];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark Public request methods
///////////////////////////////////////////////////////////////////////////
+(NSURLRequest *)getData{
    NSURL *urlString = [NSURL URLWithString:@"http://query.yahooapis.com/v1/public/yql?q=select%20item%20from%20weather.forecast%20where%20location%3D%2248907%22&format=json"];
    return [NSURLRequest requestWithURL:urlString];
}



@end
