//
//  AllChatBotsVO.m
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-19.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import "AllChatBotsVO.h"
#import "ChatBotVo.h"

@implementation AllChatBotsVO

@synthesize chatbots;

+(Class)chatbots_class
{
    return [ChatBotVo class];
}

@end
