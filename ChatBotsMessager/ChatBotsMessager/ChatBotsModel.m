//
//  ChatBotsModel.m
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-19.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import "ChatBotsModel.h"
#import "AllChatBotsVO.h"

@implementation ChatBotsModel
//It declares a static instance of your singleton object and initializes it to nil.

static ChatBotsModel *sharedInstance = nil;

static AllChatBotsVO *allChatBots = nil;
static ChatBotVo *selectedChatBot = nil;

//In your class factory method for the class (named something like “sharedInstance” or “sharedManager”), it generates an instance of the class but only if the static instance is nil.
+(ChatBotsModel *)sharedInstance
{	
	if (sharedInstance==nil) {
		sharedInstance = [[super allocWithZone:NULL] init];
	}
	return sharedInstance;
}
//It overrides the allocWithZone: method to ensure that another instance is not allocated if someone tries to allocate and initialize an instance of your class directly instead of using the class factory method. Instead, it just returns the shared object.
+(id)allocWithZone:(NSZone *)zone
{
	return [ [self sharedInstance] retain];
}
//It implements the base protocol methods copyWithZone:, release, retain, retainCount, and autorelease to do the appropriate things to ensure singleton status. (The last four of these methods apply to memory-managed code, not to garbage-collected code.)
-(id)copyWithZone:(NSZone *)zone
{
	return self;
}

-(id)retain
{
	return self;
}

-(NSUInteger)retainCount
{
	return NSUIntegerMax;//denotes an object that cannot be released.
}

//-(void)release
//{
//	//do nothing.
//}

//implementations
+(AllChatBotsVO *)getAllChatBots
{
	return allChatBots;
}

+(void)setAllChatBots:(AllChatBotsVO *)value
{
	allChatBots = value;
}
//
+(ChatBotVo *)getSelectedChatBot
{
    return selectedChatBot;
}
+(void)setSelectedChatBot:(ChatBotVo *)value
{
    selectedChatBot = value;
}

@end
