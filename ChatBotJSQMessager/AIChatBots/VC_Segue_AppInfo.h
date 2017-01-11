//
//  VC_Segue_AppInfo.h
//  ChatBotsMessager
//
//  Created by yangboz on 13-11-5.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_Segue_AppInfo : UITableViewController
{}
- (IBAction)dissmiss:(id)sender;
@property(nonatomic,strong) IBOutlet UITextView *appInfoTxtView;
@end
