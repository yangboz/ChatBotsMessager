//
//  VC_Segue_ChatBotInfo.m
//  ChatBotsMessager
//
//  Created by yangboz on 13-11-5.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import "VC_Segue_ChatBotInfo.h"
#import "UIImageUtils.h"

@interface VC_Segue_ChatBotInfo ()

@end

@implementation VC_Segue_ChatBotInfo
ChatBotVoModel *curChatBot;
NSMutableDictionary *curChatBotProfile;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = curChatBot.Name;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"VC_Segue_ChatBotInfo view did load!");
    curChatBot = [[DataModel sharedInstance] getSelectedChatBot];
    NSLog(@"Current selected chat bot Basis:%@",curChatBot.description);
    if (curChatBot==nil) {
        return;//Empty handler.
    }
    //JSONObject to NSMutableArray.
    curChatBotProfile = [[NSMutableDictionary alloc] init];
    [curChatBotProfile setObject:curChatBot.AI forKey:@"AI"];
    [curChatBotProfile setObject:curChatBot.Basis forKey:@"Basis"];
    [curChatBotProfile setObject:curChatBot.Bio forKey:@"Bio"];
    [curChatBotProfile setObject:curChatBot.Country forKey:@"Country"];
    [curChatBotProfile setObject:curChatBot.Created forKey:@"Created"];
    //[curChatBotProfile setObject:curChatBot.Development forKey:@"Development"];
    [curChatBotProfile setObject:curChatBot.Entity forKey:@"Entity"];
    [curChatBotProfile setObject:curChatBot.From forKey:@"From"];
    [curChatBotProfile setObject:curChatBot.Gender forKey:@"Gender"];
    //[curChatBotProfile setObject:curChatBot.Id forKey:@"Id"];
    //[curChatBotProfile setObject:curChatBot.Image forKey:@"Image"];
    [curChatBotProfile setObject:curChatBot.Interests forKey:@"Interests"];
    [curChatBotProfile setObject:curChatBot.Name forKey:@"Name"];
    [curChatBotProfile setObject:curChatBot.Personality forKey:@"Personality"];
    [curChatBotProfile setObject:curChatBot.Rating forKey:@"Rating"];
    [curChatBotProfile setObject:curChatBot.Temperament forKey:@"Temperament"];
    [curChatBotProfile setObject:curChatBot.Updated forKey:@"Updated"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = curChatBot.Name;
    //UINavigation header with icon functions.
    UIImage *headerOrignalIcon =  [UIImage imageNamed:curChatBot.Image];
    UIImage *headerIcon =  [UIImageUtils imageWithImage:headerOrignalIcon scaledToSize:CGSizeMake(40, 40)];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = headerIcon;
    NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    // space between icon and title
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    
    // Title
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.navigationItem.title];
    
    // new title
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithAttributedString:icon];
    [attributedTitle appendAttributedString:space];
    [attributedTitle appendAttributedString:title];
    
    // move text up to align with image
    [attributedTitle addAttribute:NSBaselineOffsetAttributeName
                            value:@(10.0)
                            range:NSMakeRange(1, attributedTitle.length-1)];
    
    UILabel *titleLabel = [UILabel new];
    //    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.f];
    titleLabel.attributedText = attributedTitle;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[curChatBotProfile allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSArray *allKeys = [curChatBotProfile allKeys];
    NSArray *allValues = [curChatBotProfile allValues];
    NSString *key = [allKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    NSString *value = [allValues objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = value;
    NSLog(@"index:%ld,key-value:%@-%@",(long)indexPath.row,key,value);
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)dissmiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
