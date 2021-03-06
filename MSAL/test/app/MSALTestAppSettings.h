//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@class MSALAuthority;

extern NSString* MSALTestAppCacheChangeNotification;

@interface MSALTestAppSettings : NSObject

#define MSAL_APP_CLIENT_ID @"clientId"
#define MSAL_APP_PROFILE @"profile"
#define MSAL_APP_REDIRECT_URI @"redirectUri"

@property (nonatomic) NSDictionary *profile;
@property (nonatomic) MSALAuthority *authority;
@property (nonatomic) MSALAccount *currentAccount;
@property (nonatomic) NSString *loginHint;
@property (nonatomic) BOOL validateAuthority;
@property (nonatomic, readonly) NSSet<NSString *> *scopes;

+ (MSALTestAppSettings*)settings;
+ (NSArray<NSString *> *)aadAuthorities;
+ (NSArray<NSString *> *)b2cAuthorities;
+ (NSArray<NSString *> *)authorityTypes;
+ (NSArray<NSString *> *)availableScopes;
+ (NSDictionary *)profiles;

- (BOOL)addScope:(NSString *)scope;
- (BOOL)removeScope:(NSString *)scope;

@end
