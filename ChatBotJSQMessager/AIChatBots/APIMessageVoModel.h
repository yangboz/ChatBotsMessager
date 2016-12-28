//
//  APIMessageVoModel.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/28.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface APIMessageVoModel : JSONModel

@property(nonatomic) NSString *message;
@property(nonatomic) NSNumber *chatBotID;
@property(nonatomic) NSNumber *timestamp;

@end
