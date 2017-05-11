//
//  StringUtil.m
//  ChatBotsMessager
//
//  Created by yangboz on 14-5-18.
//  Copyright (c) 2014年 GODPAPER. All rights reserved.
//

#import "StringUtil.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>


@implementation StringUtil
//
+ (NSString*) HMACWithSecret:(NSString*)secret andData:(NSString *)data
{
    //return @"NSString";
    //
    NSLog(@"HMAC with Secret: %@,andData:%@",secret,data);
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    //char       *key = (char *)malloc([secret length]);
    //strcpy(key, [secret UTF8String]);
    const char       *str = [data UTF8String];
    //char *str = (char *)malloc([data length]);
    //strcpy(str, [data UTF8String]);
    unsigned char    mac[CC_SHA256_DIGEST_LENGTH];
    char             hexmac[CC_SHA256_DIGEST_LENGTH];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgSHA256, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    //    if(0!=hexmac[0])
    //    {
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    //    }else
    //    {
    //        NSLog(@"HEXMAC zero exception!!!");
    //        return nil;
    //    }
    
    NSLog(@"hexmac sizeof = %lu",sizeof(hexmac));
    //NSData *hexmacData = [NSData dataWithBytes:hexmac length:sizeof(hexmac)];
    //NSLog(@"hexmacData = %@",hexmacData);
    NSString *resultStr = @"";
    //    resultStr = [NSString stringWithUTF8String:hexmac];
    resultStr = [resultStr stringByAppendingString:[NSString stringWithUTF8String:hexmac]];
    //NSString *resultStr = [[NSString alloc] initWithBytes:[hexmacData bytes] length:sizeof(hexmacData) encoding:NSUTF8StringEncoding];
    //
    //    free(key);
    //    free(str);
    return resultStr;
}
//@see http://stackoverflow.com/questions/476455/is-there-a-library-for-iphone-to-work-with-hmac-sha-1-encoding
+ (NSString *)HMACSHA1withKey:(NSString *)secret forString:(NSString *)data;
{
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    
    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
    
    return HMAC;
}

+ (NSString *)HMACSHA256withKey:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

@end
