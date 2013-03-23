//
//  ResponseVO.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-20.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "MessageVO.h"

@interface ResponseVO : Jastor
{}

@property(nonatomic,retain) NSNumber *success;
//@property(nonatomic,retain) NSString *errorType;
@property(nonatomic,retain) NSString *errorMessage;
@property(nonatomic,retain) MessageVO *message;

@end
