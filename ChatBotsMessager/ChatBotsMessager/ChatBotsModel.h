//
//  ChatBotsModel.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-19.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllChatBotsVO.h"
#import "ChatBotVo.h"

@interface ChatBotsModel : NSObject
{}

+(ChatBotsModel *)sharedInstance;

//AllChatBotsVo
+(AllChatBotsVO *)getAllChatBots;
+(void)setAllChatBots:(AllChatBotsVO *)value;
//Current selected chat bot
+(ChatBotVo *)getSelectedChatBot;
+(void)setSelectedChatBot:(ChatBotVo *)value;
@end
