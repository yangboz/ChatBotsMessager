//
//  COVIASv1Model.m
//  DeepDetectChatBots
//
//  Created by yangboz on 24/03/2017.
//  Copyright © 2017 ___SMARTKIT.INFO___. All rights reserved.
//

#import "COVITASv1Model.h"

@implementation COVITASv1Model
@synthesize messageVo;
- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

#pragma interface of COVITASv1Model

+(COVITASv1Model *)sharedInstance
{
    // 1
    static COVITASv1Model *_sharedInstance = nil;
    // 2
    static dispatch_once_t oncePredicate;
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[COVITASv1Model alloc] init];
    });
    return _sharedInstance;
}

@end
