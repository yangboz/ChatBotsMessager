//
//  MessageVoModel.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/27.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface MessageVoModel:JSONModel
@property(nonatomic) NSString *message;
@property(nonatomic) NSNumber *chatBotID;
@property(nonatomic) NSString *chatBotName;
@property(nonatomic) NSString *emotion;
@end
