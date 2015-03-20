//
//  StringUtil.h
//  ChatBotsMessager
//
//  Created by yangboz on 14-5-18.
//  Copyright (c) 2014年 GODPAPER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface StringUtil : NSObject
{}
//@see http://stackoverflow.com/questions/476455/is-there-a-library-for-iphone-to-work-with-hmac-sha-1-encoding
+ (NSString*) HMACWithSecret:(NSString*)secret andData:(NSString *)data;
//
+ (NSString *)HMACSHA1withKey:(NSString *)secret forString:(NSString *)data;
@end
