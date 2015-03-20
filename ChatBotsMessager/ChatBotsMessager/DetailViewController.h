//
//  DetailViewController.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-17.
//  Copyright (c) 2013年 Godpaper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBotVo.h"
#import "FaceViewController.h"
#import "Reachability.h"
#import "StringUtil.h"
#import "CMPopTipView.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString                   *_titleString;
	NSMutableString            *_messageString;
	NSString                   *_phraseString;
	NSMutableArray		       *_chatArray;
	
	UITableView                *_chatTableView;
	UITextField                *_messageTextField;
	BOOL                       _isFromNewSMS;
	FaceViewController      *_phraseViewController;
	NSDate                     *_lastTime;
    CMPopTipView *_phraseInfoView;
}
@property (strong, nonatomic) ChatBotVo *detailItem;
//
@property (nonatomic, retain) IBOutlet FaceViewController   *phraseViewController;
@property (nonatomic, retain) IBOutlet UITableView            *chatTableView;
@property (nonatomic, retain) IBOutlet UITextField            *messageTextField;
@property (nonatomic, retain) IBOutlet UIButton            *phraseButton;
@property (nonatomic, retain) IBOutlet UIButton            *sendButton;
//
@property (nonatomic, retain) NSString               *phraseString;
@property (nonatomic, retain) NSString               *titleString;
@property (nonatomic, retain) NSMutableString        *messageString;
@property (nonatomic, retain) NSMutableArray		 *chatArray;
@property (nonatomic, retain) NSDate                 *lastTime;

//
-(IBAction)onSendMessageClick:(id)sender;
-(IBAction)showPhraseInfo:(id)sender;
@end
