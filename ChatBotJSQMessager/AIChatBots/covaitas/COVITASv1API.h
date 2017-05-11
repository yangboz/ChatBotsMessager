//
//  COVITASv1API.h
//  DeepDetectChatBots
//
//  Created by yangboz on 24/03/2017.
//  Copyright © 2017 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageVoModel.h"
#import "COVITASv1Model.h"
#import "MessageVoSimple.h"
//@see: http://stackoverflow.com/questions/5643514/how-to-define-an-nsstring-for-global-use
//#define DEV @"dev_aliyun"
#ifdef DEV
#define kAPIEndpointHost @"http://118.190.3.169:8085/covitas/tas"
#else//LOCAL
#define kAPIEndpointHost @"http://192.168.0.11:8085/covitas/tas"
#endif
#define kAPI_chat_pf (@"pf")//pf/{chatBotID}/{message}

//Notification Center post names;
#define kNCpN_chat_with_message @"pfChatWithMessage"
#define kNCpN_chat_with_message_error @"pfChatWithMessageError"

//Default value.
#define kAPI_default_chatbot_id 6
#define kAPI_default_chatbot_ex_id @"abc-639184572"
#define kAPI_default_chatbot_fname @"Tugger"
#define kAPI_default_chatbot_lname @"Sufani"
#define kAPI_default_chatbot_gender @"m"

@interface COVITASv1API : NSObject
+(COVITASv1API *)sharedInstance;
//@see:https://www.personalityforge.com/chatbot-api-docs.php
-(void)pfChatWithGetMessage:(MessageVoSimple*)vo;
-(void)pfChatWithPostMessage:(MessageVoSimple*)vo;
@end
