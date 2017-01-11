//
//  AllChatBots.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/26.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//
#import "JSONModel.h"
#import "ChatBotVoModel.h"

@protocol ChatBotVoModel
@end

@interface AllChatBotsModel:JSONModel
@property(nonatomic) NSArray <ChatBotVoModel> *chatbots;
@end
