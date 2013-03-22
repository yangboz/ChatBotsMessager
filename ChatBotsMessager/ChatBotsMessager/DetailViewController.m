//
//  DetailViewController.m
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-17.
//  Copyright (c) 2013年 Godpaper. All rights reserved.
//

#import "DetailViewController.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import <CommonCrypto/CommonHMAC.h>
#import "JSONKit.h"

#define USING_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize phraseViewController,chatTableView,messageTextField;

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_masterPopoverController release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    //
    //监听键盘高度的变换 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的  
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark -
#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(textField == self.messageTextField)
	{
        //		[self moveViewUp];
	}
}

-(void) autoMovekeyBoard: (float) h{
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    NSUInteger width = screenRect.size.width;
    NSUInteger height = screenRect.size.height;
    //
    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
    //Orientation
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        width = screenRect.size.height;
        height = screenRect.size.width;
        //
        toolbar.frame = CGRectMake(0.0f, (float)(height-h-108.0), width, 44.0f);
        tableView.frame = CGRectMake(0.0f, 0.0f, width,(float)(height-h-108.0));
    }else {
        toolbar.frame = CGRectMake(0.0f, (float)(height-h-108.0), width, 44.0f);
        tableView.frame = CGRectMake(0.0f, 0.0f, width,(float)(height-h-108.0));
    }
    
    NSLog(@"width: %u", width);
    NSLog(@"height: %u", height);
    
    

    
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self autoMovekeyBoard:keyboardRect.size.width];
    }else {
        [self autoMovekeyBoard:keyboardRect.size.height];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0];
}

-(IBAction)sendMessage_Click:(id)sender
{
    if (!self.messageTextField.text.length) {
        return;//Empty message.
    }
    //$url = "http://www.personalityforge.com/api/chat/?apiKey=".$apiKey."hash=".$hash."&message=".urlencode($messageJSON);
    //Simple API example
//    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",API_DOMAIN,API_KEY,@"&chatBotId=6&message=",self.messageTextField.text,@"&externalID=abc-639184572&firstName=Tugger&lastName=Sufani&gender=m"];
    NSString *msgJsonStr = [self getMessageJsonString];
    NSString *hashStr = [self getHMAC_hash_string:msgJsonStr];
    NSString *urlEncodeStr = [self getUrlEncodeString:msgJsonStr];
    NSLog(@"msgJsonStr: %@",msgJsonStr);
    NSLog(@"hashStr: %@",hashStr);
    NSLog(@"urlEncodeStr: %@",urlEncodeStr);
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@",API_DOMAIN,API_KEY,@"&hash=",hashStr,@"&message=",urlEncodeStr ];
    NSLog(@"sendMessage_Click! url: %@",url);
    NSURL *nsUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nsUrl];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(IBAction)showPhraseInfo:(id)sender
{
    NSLog(@"showPhraseInfo!");
    //
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{ 
    // Use when fetching text data 
    NSString *responseString = [request responseString]; 
    NSLog(@"API request finished:%@",responseString);
} 

//@see:http://ceegees.in/2011/02/objectivec-sha-hmac-php/
- (NSString *)getHMAC_hash_string:(NSString *)data
{
    NSString *key = API_SECERT;
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64Encoding];
    [HMAC release];
    
    return hash;
}

-(NSString *)getMessageJsonString
{
    NSString *jsonStrResult = @"";
    //
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    [messageDict setValue:self.messageTextField.text forKey:@"message"];
    [messageDict setValue:@"6" forKey:@"chatBotID"];
    [messageDict setValue:@"1352857720" forKey:@"timestamp"];
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:@"Tugger" forKey:@"firstName"];
    [userDict setValue:@"Sufani" forKey:@"lastName"];
    [userDict setValue:@"M" forKey:@"gender"];
    [userDict setValue:@"abc-639184572" forKey:@"externalID"];
    
    NSMutableDictionary *messageFullDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:messageDict forKey:@"message"];
    [userDict setValue:userDict forKey:@"user"];
    //
    jsonStrResult = [messageFullDict JSONStringWithOptions:JKParseOptionNone error:nil];
//    NSLog(@"message json string:%@",jsonStrResult);
    [messageDict release];
    [userDict release];
    [messageFullDict release];
    //
    return jsonStrResult;
}

-(NSString *)getUrlEncodeString:(NSString *)unEscapedString
{
    return [unEscapedString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

@end
