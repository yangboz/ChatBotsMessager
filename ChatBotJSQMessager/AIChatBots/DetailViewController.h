//
//  DetailViewController.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/26.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import "ChatBotVoModel.h"


@interface DetailViewController : UIViewController

@property (strong, nonatomic) ChatBotVoModel *detailItem;

@end

