//
//  COVIASv1Model.h
//  DeepDetectChatBots
//
//  Created by yangboz on 24/03/2017.
//  Copyright © 2017 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageVoModel.h"

@interface COVITASv1Model : NSObject
+(COVITASv1Model *)sharedInstance;

@property (strong, nonatomic) MessageVoModel *messageVo;
@end
