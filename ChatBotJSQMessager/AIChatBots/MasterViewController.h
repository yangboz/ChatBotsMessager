//
//  MasterViewController.h
//  AIChatBots
//
//  Created by yangboz on 2016/12/26.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DataModel.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    NSMutableArray *_chatbots;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *chatbots;

@property (nonatomic, retain) NSMutableArray *listOfRatings;
@property (nonatomic, retain) NSMutableArray *groupedChatbots;


@end

