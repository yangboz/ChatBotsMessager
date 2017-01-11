//
//  ResponseVoModel.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/28.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "MessageVoModel.h"

@protocol MessageVoModel
@end

@interface ResponseVoModel : JSONModel

@property(nonatomic) NSNumber *success;
//@property(nonatomic,retain) NSString *errorType;
@property(nonatomic) NSString *errorMessage;
@property(nonatomic) MessageVoModel *message;

@end
