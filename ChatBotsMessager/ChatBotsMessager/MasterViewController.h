//
//  MasterViewController.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-17.
//  Copyright (c) 2013年 Godpaper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBotsModel.h"
#import <iAd/iAd.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <ADBannerViewDelegate>
{
    NSMutableArray *_chatbots;
    ADBannerView *bannerView;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *chatbots;

@end
