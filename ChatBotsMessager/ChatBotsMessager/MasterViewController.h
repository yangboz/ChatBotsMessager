//
//  MasterViewController.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-17.
//  Copyright (c) 2013年 Godpaper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    NSMutableArray *_chatbots;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *chatbots;

@end
