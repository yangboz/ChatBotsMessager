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
#import "MBProgressHUD.h"
#import "Base64.h"
#import "ResponseVO.h"

#define USING_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize phraseViewController,chatTableView,messageTextField;

MBProgressHUD *hud;

- (void)dealloc
{
    [_detailItem release];
    [_masterPopoverController release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
//    NSLog(@"Detail item value:%@",newDetailItem);
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
        //TODO:configureView
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
    
//    NSLog(@"width: %u", width);
//    NSLog(@"height: %u", height);
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
    //
    NSString *hashStr = [self HMACWithSecret:API_SECERT andData:msgJsonStr];
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
// 
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
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
    NSLog(@"API request response str:%@",responseString);
    //
    NSScanner *scanner = [NSScanner scannerWithString:responseString];
    //
    NSString *text = nil;
    //Find the last pair of { }.
    while ([scanner isAtEnd] == NO) {
        // find start of tag
        [scanner scanUpToString:@"{" intoString:NULL] ; 
        // find end of tag
        [scanner scanUpToString:@"}" intoString:&text] ;
        // appending tags(}})
        text = [text stringByAppendingString:@"}"];
    } // while //
    NSLog(@"Scanned text:%@",text);
    // Pretend like you've called a REST service here and it returns a string.
    // We'll just create a string from the sample json constant at the top
    // of this file.
    NSString *jsonKitStr = [text JSONString];
    NSLog(@"string from JSONKit: \n%@", jsonKitStr);
    // 1) Create a dictionary, from the result string,
    // using JSONKit's NSString category; objectFromJSONString.
    NSDictionary* dict = [jsonKitStr objectFromJSONString];
    
    // 2) Dump the dictionary to the debug console.
    NSLog(@"Dictionary => %@\n", dict); 
    
    // 3) Now, let's create a Person object from the dictionary.
    ResponseVO* responseVO = [[ResponseVO alloc] initWithDictionary:dict];
    // 4) Dump the contents of the person object
    // to the debug console.
    NSLog(@"responseVO => %@\n", responseVO);
    NSLog(@"responseVO.chatBotName: %@\n", [responseVO chatBotName]);
    NSLog(@"responseVO.chatBotID: %@\n", [responseVO chatBotID]);
    NSLog(@"responseVO.message: %@\n", [responseVO message]);
    NSLog(@"responseVO.emotion: %@\n", [responseVO emotion]);
    //
    [hud hide:YES];
} 

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"API request error:%@",error);
    //
    [hud hide:YES];
}

-(NSString *)getMessageJsonString
{
    NSString *jsonStrResult = @"";
//    NSTimeInterval interval64Bit = (63522762851317000/1000000)-62135596800;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval64Bit];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int dateInt = (long long int)time; 
//    NSLog(@"date %lld",dateInt);
    int chatBotId = [_detailItem.Id intValue];
    NSLog(@"chatBotID:%d",chatBotId);
    if(0 == chatBotId)
    {
        chatBotId = 6;//Default chatbot id;
    }
    //
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    [messageDict setValue:self.messageTextField.text forKey:@"message"];
    [messageDict setValue:[NSNumber numberWithInt:chatBotId] forKey:@"chatBotID"];
    [messageDict setValue:[NSNumber numberWithInt:dateInt] forKey:@"timestamp"];
    NSLog(@"messageDict:%@",messageDict);
//    NSLog(@"messageDict json str:%@",[messageDict JSONString]);
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:@"Tugger" forKey:@"firstName"];
    [userDict setValue:@"Sufani" forKey:@"lastName"];
    [userDict setValue:@"m" forKey:@"gender"];
    [userDict setValue:@"abc-639184572" forKey:@"externalID"];
    NSLog(@"userDict:%@",userDict);
//    NSLog(@"userDict json str:%@",[userDict JSONString]);
    
    NSMutableDictionary *messageFullDict = [[NSMutableDictionary alloc] init];
    [messageFullDict setValue:messageDict forKey:@"message"];
    [messageFullDict setValue:userDict forKey:@"user"];
    NSLog(@"messageFullDict:%@",messageFullDict);
    //Json writer
    jsonStrResult = [messageFullDict JSONString];
    NSLog(@"messageFullDict json str:%@",[messageFullDict JSONString]);
    //
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

- (NSString*) HMACWithSecret:(NSString*)secret andData:(NSString *)data
{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [data UTF8String];
    unsigned char    mac[CC_SHA256_DIGEST_LENGTH];
    char             hexmac[CC_SHA256_DIGEST_LENGTH];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgSHA256, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}


@end
