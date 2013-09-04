//
//  URLRequest.h
//  jsonController
//
//  Created by gegger on 9/2/13.
//  Copyright (c) 2013 Illion IT Group. All rights reserved.
//

#import <Foundation/Foundation.h>
enum completionType {
    usingBlockOnCompletion = 0,
    usingDelegateOnCompletion = 1,
    usingNoCallbackFunctions = 2
};

@protocol URLRequestDelegate
@optional -(void)requestFinished:(id)request withResult:(NSMutableDictionary *)result;
@optional -(void)requestFailed:(id)request withError:(NSError *)error;
@optional -(void)requestShouldStart:(id)request;
@end

@interface URLRequest : NSObject
{
    void (^completion)(URLRequest* request, NSMutableDictionary* result, NSError* error);
    id  delegate;
    NSData *rawData;
    int httpStatusCode;
}
@property (nonatomic, assign) id  delegate;
@property (nonatomic, readonly) NSData *rawData;
@property (readonly) int httpStatusCode;

- (id)initWithRequest:(NSURLRequest*)_request;
- (void)startWithCompletion:(void (^)(URLRequest* request, NSMutableDictionary* result, NSError* error))_completion;
- (void)startWithDelegate:(id)adelegate;
- (void)startWithNoCallback;

//url string requests
+(NSURLRequest *)getData;
@end