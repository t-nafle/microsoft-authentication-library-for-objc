//
//  MSALTestURLSessionDataTask.m
//  MSAL
//
//  Created by Jason Kim on 2/7/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

#import "MSALTestURLSessionDataTask.h"

@interface MSALTestURLSessionDataTask()

@property MSALTestHttpCompletionBlock completionHandler;
@property MSALTestURLSession *session;
@property NSURLRequest *request;

@end

@implementation MSALTestURLSessionDataTask

- (id)initWithRequest:(NSURLRequest *)request
              session:(MSALTestURLSession *)session
    completionHandler:(MSALTestHttpCompletionBlock)completionHandler;
{
    (void)completionHandler;
    
    self = [super init];
    if (self)
    {
        self.completionHandler = completionHandler;
        self.session = session;
        self.request = request;
    }
    return self;
}


- (void)resume
{
    MSALTestURLResponse *response = [MSALTestURLSession removeResponseForRequest:self.request];
    
    if (!response)
    {
        // This class is used in the test target only. If you're seeing this outside the test target that means you linked in the file wrong
        // take it out!
        //
        // No unit tests are allowed to hit network. This is done to ensure reliability of the test code. Tests should run quickly and
        // deterministically. If you're hitting this assert that means you need to add an expected request and response to ADTestURLConnection
        // using the ADTestRequestReponse class and add it using -[ADTestURLConnection addExpectedRequestResponse:] if you have a single
        // request/response or -[ADTestURLConnection addExpectedRequestsAndResponses:] if you have a series of network requests that you need
        // to ensure happen in the proper order.
        //
        // Example:
        //
        // MSALTestRequestResponse *response = [MSALTestRequestResponse requestURLString:@"https://requestURL"
        //                                                             responseURLString:@"https://idontknowwhatthisshouldbe.com"
        //                                                                  responseCode:400
        //                                                              httpHeaderFields:@{}
        //                                                              dictionaryAsJSON:@{@"tenant_discovery_endpoint" : @"totally valid!"}];
        //
        //  [MSALTestURLSession addResponse:response];
        
        NSString *requestURLString = self.request.URL.absoluteString;
        NSAssert(response, @"did not find a matching response for %@", requestURLString);
        
        // TODO: Logging
        // AD_LOG_ERROR_F(@"No matching response found.", NSURLErrorNotConnectedToInternet, nil, @"request url = %@", self.request.URL);
        
        [self.session dispatchIfNeed:^{
            NSError* error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:NSURLErrorNotConnectedToInternet
                                             userInfo:nil];
            
            self.completionHandler(nil, nil, error);
        }];
        
        return;
    }
    
    if (response->_error)
    {
        [self.session dispatchIfNeed:^{
            self.completionHandler(nil, nil, response->_error);
        }];
        return;
    }
    
    if (response->_expectedRequestHeaders)
    {
        BOOL failed = NO;
        for (NSString *key in response->_expectedRequestHeaders)
        {
            NSString *value = [response->_expectedRequestHeaders objectForKey:key];
            NSString *requestValue = [_request.allHTTPHeaderFields objectForKey:key];
            
            if (!requestValue)
            {
                // TODO: Add logging
                // AD_LOG_ERROR_F(@"Missing request header", AD_FAILED, nil, @"expected \"%@\" header", key);
                failed = YES;
            }
            
            if (![requestValue isEqualToString:value])
            {
                // TODO: Add logging
                // AD_LOG_ERROR_F(@"Mismatched request header", AD_FAILED, nil, @"On \"%@\" header, expected:\"%@\" actual:\"%@\"", key, value, requestValue);
                failed = YES;
            }
        }
        
        if (failed)
        {
            [self.session dispatchIfNeed:^{
                self.completionHandler(nil, nil, [NSError errorWithDomain:NSURLErrorDomain
                                                                     code:NSURLErrorNotConnectedToInternet
                                                                 userInfo:nil]);
            }];
            return;
        }
    }
    
    self.completionHandler(response->_responseData, response->_response, response->_error);
}


@end
