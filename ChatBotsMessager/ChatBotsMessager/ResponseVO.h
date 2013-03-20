//
//  ResponseVO.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-20.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseVO : NSObject
{}

@property(nonatomic,retain) NSNumber *success;
@property(nonatomic,retain) NSString *errorType;
@property(nonatomic,retain) NSString *errorMessage;
@property(nonatomic,retain) NSString *chatBotName;
@property(nonatomic,retain) NSNumber *chatBotID;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *emotion;

@end
