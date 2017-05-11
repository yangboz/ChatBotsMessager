//
//  COVITASv1API.m
//  DeepDetectChatBots
//
//  Created by yangboz on 24/03/2017.
//  Copyright © 2017 ___SMARTKIT.INFO___. All rights reserved.
//1.Create an ObjectManager
//- This is our main actor
//2.Setup Mapping
//- Specify the mapping from JSON to our classes
//3.Tie Mapping to ObjectManager with a ResponseDescriptor
//-  Tell the ObjectManager to use our mapping
//4.Request JSON from the server
//- RestKit handles everything from this point on
//

#import "COVITASv1API.h"
#import <RestKit/RestKit.h>

@implementation COVITASv1API

- (id)init
{
    self = [super init];
    if (self) {
        //
        
    }
    return self;
}

#pragma interface of Snap415API

+(COVITASv1API *)sharedInstance
{
    // 1
    static COVITASv1API *_sharedInstance = nil;
    // 2
    static dispatch_once_t oncePredicate;
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[COVITASv1API alloc] init];
    });
    return _sharedInstance;
}
//GET
-(void)pfChatWithGetMessage:(MessageVoSimple*)vo
{
    //
    [AFRKNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //
    // GET a single Article from /articles/1234.json and map it into an object
    // JSON looks like {"article": {"title": "My Article", "author": "Blake", "body": "Very cool!!"}}
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MessageVoSimple class]];
    [mapping addAttributeMappingsFromArray:@[@"chatBotID",@"message",@"emotion",@"chatBotName"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    //NSURL with escape string.
    NSString *UrlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",kAPIEndpointHost,kAPI_chat_pf,vo.chatBotID,vo.message];
    NSString *encodedUrlStr = [UrlStr stringByAddingPercentEscapesUsingEncoding:
                               NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encodedUrlStr];
    
    //
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"RKMappingResult.array: %@", result.array);
        MessageVoSimple *vobj = (MessageVoSimple *)result.array.lastObject;
        NSLog(@"RKMappingResult MessageVoSimple: %@", [vobj description]);
        //Post to local notification center.
        [[NSNotificationCenter defaultCenter] postNotificationName:kNCpN_chat_with_message object:vobj];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNCpN_chat_with_message_error object:error];
    }];
    [operation start];
    }
//POST
-(void)pfChatWithPostMessage:(MessageVoSimple*)vo
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MessageVoSimple class]];
    [responseMapping addAttributeMappingsFromArray:@[@"success", @"errorMessage", @"message"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *articleDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"chatBotID", @"message"]];
    
    // For any object of class Article, serialize into an NSMutableDictionary using the given mapping and nest
    // under the 'article' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[MessageVoSimple class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kAPIEndpointHost]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:articleDescriptor];
    
    // Set MIME Type to JSONx
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    // POST to create
    [manager postObject:vo path:kAPI_chat_pf parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Mapped the MessageVoModel result: %@", result);
        
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    
}
@end
