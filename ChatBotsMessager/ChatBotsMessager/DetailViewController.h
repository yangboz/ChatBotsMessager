//
//  DetailViewController.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-17.
//  Copyright (c) 2013年 Godpaper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBotVo.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) ChatBotVo *detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
