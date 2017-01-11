//
//  DataModel.m
//  TGCameraViewController
//
//  Created by yangboz on 2016/12/1.
//  Copyright © 2016年 Tudo Gostoso Internet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
//@see http://stackoverflow.com/questions/7568935/how-do-i-implement-an-objective-c-singleton-that-is-compatible-with-arc
@implementation DataModel

//It declares a static instance of your singleton object and initializes it to nil.
static DataModel *sharedInstance = nil;
static AllChatBotsModel *allChatBots=nil;
static ChatBotVoModel *selectedChatBot = nil;



//In your class factory method for the class (named something like “sharedInstance” or “sharedManager”), it generates an instance of the class but only if the static instance is nil.
+ (instancetype)sharedInstance
{
    static DataModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataModel alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

//implementations
#pragma mark allChatBots
-(void)setAllChatBots:(AllChatBotsModel *)value{
    allChatBots = value;
}
-(AllChatBotsModel *)getAllChatBots{
    return allChatBots;
}
//
-(ChatBotVoModel *)getSelectedChatBot
{
    return selectedChatBot;
}
-(void)setSelectedChatBot:(ChatBotVoModel *)value
{
    selectedChatBot = value;
}

@end
