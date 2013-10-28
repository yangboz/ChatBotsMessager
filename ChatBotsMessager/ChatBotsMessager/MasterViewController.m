//
//  MasterViewController.m
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-17.
//  Copyright (c) 2013年 Godpaper. All rights reserved.
//

#import "MasterViewController.h"
#import "ChatBotVo.h"
#import "DetailViewController.h"
#import "ChatBotsModel.h"

#define RATINGS @"Ratings"

@interface MasterViewController () {
//    NSMutableArray *_chatbots;
    NSMutableArray *_listOfRatings;
    NSMutableArray *_groupedChatbots;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize chatbots = _chatbots;



- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ChatBots", @"ChatBots");
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}

- (void)dealloc
{
    [_detailViewController release];
    [_chatbots release];
    [_listOfRatings release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //Test code
    _groupedChatbots = [self getGroupedChatBots];
    NSLog(@"_groupedChatbots:%@",_groupedChatbots);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listOfRatings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"_chatbots.count: %d",_chatbots.count);
//    NSLog(@"chatbots.count: %d",[[[ChatBotsModel getAllChatBots] chatbots] count]);
//    return [self getChatBots].count;
    NSDictionary *dictionary = [_listOfRatings objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:RATINGS];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    NSLog(@"Current _chatbots:%@",_chatbots);
//    NSLog(@"Current chatbots:%@",[self getChatBots]);
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    // Configure the cell.
    NSDictionary *dictionary = [_listOfRatings objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:RATINGS];
    NSLog(@"indexPath.row:%d",indexPath.row);
    int rowIndex = indexPath.row;
//FIXME:    if(indexPath.row<0 || indexPath.row>3) rowIndex = 0;
    ChatBotVo *object = [array objectAtIndex:rowIndex];
    
    cell.textLabel.text = [object Name];
    cell.imageView.image = [UIImage imageNamed:[object Image]];
    cell.detailTextLabel.text = [object Bio];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return @"Teen";
    }
    if (section == 1)
    {
        return @"EveryOne";
    }
    if (section == 2)
    {
        return @"Mature";
    }
    if (section == 3)
    {
        return @"Adult";
    }
    return @"#";
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_chatbots removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        NSDate *object = [[self getChatBots] objectAtIndex:indexPath.row];
        NSDictionary *dictionary = [_listOfRatings objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:RATINGS];
        ChatBotVo *object = [array objectAtIndex:indexPath.row];
        //
        self.detailViewController.detailItem = (ChatBotVo *)object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        ChatBotVo *object = (ChatBotVo *)[[self getChatBots] objectAtIndex:indexPath.row];
        NSDictionary *dictionary = [_listOfRatings objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:RATINGS];
        ChatBotVo *object = [array objectAtIndex:indexPath.row];
        //
        [[segue destinationViewController] setDetailItem:object];
    }
}

-(NSArray *)getChatBots
{
    return [[[ChatBotsModel getAllChatBots] chatbots] retain];
}
-(NSMutableArray *)getGroupedChatBots
{
    _listOfRatings = [[NSMutableArray alloc] init];
    //Rating variables for grouping data set.
    NSMutableArray *teenRating = [[NSMutableArray alloc] init];
    NSMutableArray *matureRating = [[NSMutableArray alloc] init];
    NSMutableArray *adultRating = [[NSMutableArray alloc] init];
    NSMutableArray *everyoneRating = [[NSMutableArray alloc] init];
    //Grouping
    NSArray *listItems = [self getChatBots];
    ChatBotVo *object;
    for (int i=0; i<listItems.count; i++) {
        object = (ChatBotVo *)[listItems objectAtIndex:i];
        if ([object.Rating isEqualToString:@"E"]) {
            [everyoneRating addObject:object];
        }
        if ([object.Rating isEqualToString:@"T"]) {
            [teenRating addObject:object];
        }
        if ([object.Rating isEqualToString:@"M"]) {
            [matureRating addObject:object];
        }
        if ([object.Rating isEqualToString:@"A"]) {
            [adultRating addObject:object];
        }
    }
    //
    NSDictionary *teenRatingDict = [NSDictionary dictionaryWithObject:teenRating forKey:RATINGS];
    NSDictionary *matureRatingDict = [NSDictionary dictionaryWithObject:matureRating forKey:RATINGS];
    NSDictionary *adultRatingDict = [NSDictionary dictionaryWithObject:adultRating forKey:RATINGS];
    NSDictionary *everyoneRatingDict = [NSDictionary dictionaryWithObject:everyoneRating forKey:RATINGS];
    //Deallocate
    [listItems release];
    [object release];
    //
    [_listOfRatings addObject:teenRatingDict];
    [_listOfRatings addObject:everyoneRatingDict];
    [_listOfRatings addObject:matureRatingDict];
    [_listOfRatings addObject:adultRatingDict];
    //
    return _listOfRatings;
}

@end
