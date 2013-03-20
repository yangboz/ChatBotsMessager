//
//  MessageVO.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-20.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageVO : NSObject
{}

@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSNumber *chatBotID;
@property(nonatomic,retain) NSNumber *timestamp;

@end
