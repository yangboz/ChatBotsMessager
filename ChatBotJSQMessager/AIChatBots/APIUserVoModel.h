//
//  APIUserVoModel.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/28.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface APIUserVoModel : JSONModel
@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *lastName;
@property(nonatomic) NSString *gender;
@property(nonatomic) NSString *externalID;
@end
