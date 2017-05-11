//
//  MessageVoSimple.h
//  AIChatBots
//
//  Created by yangboz on 11/05/2017.
//  Copyright © 2017 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageVoSimple : NSObject
@property(nonatomic) NSString *message;
@property(nonatomic) NSNumber *chatBotID;
@property(nonatomic) NSString *emotion;
@property(nonatomic) NSString *chatBotName;
@end
