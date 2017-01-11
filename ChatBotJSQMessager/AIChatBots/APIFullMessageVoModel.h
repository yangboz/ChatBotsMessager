//
//  APIFullMessageVoModel.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/28.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "APIUserVoModel.h"
#import "APIMessageVoModel.h"

@protocol APIUserVoModel
@end
@protocol APIMessageVoModel
@end

@interface APIFullMessageVoModel : JSONModel

@property(nonatomic) APIMessageVoModel *message;
@property(nonatomic) APIUserVoModel *user;

@end
