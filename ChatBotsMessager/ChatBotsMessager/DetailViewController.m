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
#import "ChatCustomCell.h"

#define USING_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

#define TOOLBAR_MARGIN 50.0
#define TOOLBAR_HEIGHT 44.0f

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

//@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;

//
@synthesize titleString = _titleString;
@synthesize chatArray = _chatArray;
@synthesize chatTableView = _chatTableView;
@synthesize messageTextField = _messageTextField;
@synthesize phraseViewController = _phraseViewController;
@synthesize messageString = _messageString;
@synthesize phraseString = _phraseString;
@synthesize lastTime = _lastTime;
@synthesize phraseButton = _phraseButton;
@synthesize sendButton = _sendButton;

MBProgressHUD *hud;

//
- (void)dealloc
{
    [_detailItem release];
    [_masterPopoverController release];
    [_lastTime release];
	[_phraseString release];
	[_messageString release];
	[_phraseViewController release];
	[_messageTextField release];
	[_chatArray release];
	[_titleString release];
	[_chatTableView release];
    [_phraseButton release];
    [_sendButton release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
//    NSLog(@"Detail item value:%@",newDetailItem);
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        //
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
        //configureView
        self.title = self.detailItem.Name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    //Variables initi
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.chatArray = tempArray;
	[tempArray release];
	
    NSMutableString *tempStr = [[NSMutableString alloc] initWithFormat:@""];
    self.messageString = tempStr;
    [tempStr release];
    
	NSDate   *tempDate = [[NSDate alloc] init];
	self.lastTime = tempDate;
	[tempDate release];
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
    //PhraseButton setting here.
    //Disabled style
    self.phraseButton.alpha = 0.5;
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachability->REACHABLE!");
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachability->UNREACHABLE!");
        //Update UI with disabled feature.
        //
        [self.view setUserInteractionEnabled:NO];
        
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
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
        //TODO:		[self moveViewUp];
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
        toolbar.frame = CGRectMake(0.0f, (float)(height-h-TOOLBAR_MARGIN), width, TOOLBAR_HEIGHT);
        tableView.frame = CGRectMake(0.0f, 0.0f, width,(float)(height-h-TOOLBAR_MARGIN));
    }else {
        toolbar.frame = CGRectMake(0.0f, (float)(height-h-TOOLBAR_MARGIN), width, TOOLBAR_HEIGHT);
        tableView.frame = CGRectMake(0.0f, 0.0f, width,(float)(height-h-TOOLBAR_MARGIN));
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
#pragma mark -
#pragma mark Responding to API request
-(IBAction)sendMessage_Click:(id)sender
{
    NSLog(@"Button pressed: %@", [sender currentTitle]);
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
    //Prepare to send message
    [self beforeBubbleView:self.messageTextField.text from:YES];
    //Text filed responder resign
    self.messageTextField.text = @"";
	[_messageTextField resignFirstResponder];
}

-(IBAction)showPhraseInfo:(id)sender
{
    NSLog(@"showPhraseInfo!");
    //TODO:display phrase info view;
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
    NSLog(@"string from JSONKit: \n%@", text);
    // 1) Create a dictionary, from the result string,
    // using JSONKit's NSString category; objectFromJSONString.
    NSDictionary* dict = [text objectFromJSONString];
    
    // 2) Dump the dictionary to the debug console.
    NSLog(@"Dictionary => %@\n", dict); 
    
    // 3) Now, let's create a Person object from the dictionary.
    ResponseVO* responseVO = [[ResponseVO alloc] initWithDictionary:dict];
    // 4) Dump the contents of the person object
    // to the debug console.
    NSString *message = [[responseVO message] message];
    NSLog(@"responseVO => %@\n", responseVO);
    NSLog(@"responseVO.message.chatBotName: %@\n", [[responseVO message] chatBotName]);
    NSLog(@"responseVO.message.chatBotID: %@\n", [[responseVO message] chatBotID]);
    NSLog(@"responseVO.message.message: %@\n", [[responseVO message] message]);
    NSLog(@"responseVO.message.emotion: %@\n", [[responseVO message] emotion]);
    //
    [hud hide:YES];
    //Prepare to send message
    [self beforeBubbleView:message from:NO];
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
    //
    NSLog(@"HMAC with Secret: %@,andData:%@",secret,data);
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
    //if(0!=hexmac[0])
    //{
        for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++ ) {
            snprintf( p, 3, "%02x", mac[ i ] );
            p += 2;
        }
    //}else
    //{
        //NSLog(@"HEXMAC zero exception!!!");
    //}
    
    NSLog(@"hexmac sizeof = %lu",sizeof(hexmac));
    NSData *hexmacData = [NSData dataWithBytes:hexmac length:sizeof(hexmac)];
    NSLog(@"hexmacData = %@",hexmacData);
    NSString *resultStr = [NSString stringWithUTF8String:hexmac];
    //NSString *resultStr = [[NSString alloc] initWithBytes:[hexmacData bytes] length:sizeof(hexmacData) encoding:NSUTF8StringEncoding];
    return resultStr;
}

/*
 生成泡泡UIView
 */
#pragma mark -
#pragma mark Table view methods
- (void)beforeBubbleView:(NSString *)message from:(BOOL)fromSelf
{
    //Timestamp
	NSDate *nowTime = [NSDate date];
	//String with capcity limit.
	NSMutableString *sendString=[NSMutableString stringWithCapacity:100];
	[sendString appendString:message];
	//准备发送
//	if ([self.chatArray lastObject] == nil) {
//		self.lastTime = nowTime;
//		[self.chatArray addObject:nowTime];
//	}
	// 发送后生成泡泡显示出来
    self.lastTime = nowTime;
    [self.chatArray addObject:nowTime];
    //Role name display.
    NSString *roleName = @"me";
    if(!fromSelf)
    {
        roleName = self.detailItem.Name;
    }
    //
    UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(roleName,nil), message] 
								   from:fromSelf];
	[self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"self", @"speaker", chatView, @"view", nil]];
    //
	[self.chatTableView reloadData];
	[self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] 
							  atScrollPosition: UITableViewScrollPositionBottom 
									  animated:YES];
}

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf {
	// build single chat bubble cell with given text
    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    returnView.backgroundColor = [UIColor clearColor];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    
    if(fromSelf){
        [headImageView setImage:[UIImage imageNamed:@"anonymous_user_32.png"]];
        returnView.frame= CGRectMake(9.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(0.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f );
        cellView.frame = CGRectMake(265.0f-bubbleImageView.frame.size.width, 0.0f,bubbleImageView.frame.size.width+50.0f, bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(bubbleImageView.frame.size.width, cellView.frame.size.height-50.0f, 50.0f, 50.0f);
    }
	else{
        [headImageView setImage:[UIImage imageNamed:_detailItem.Image]];
        returnView.frame= CGRectMake(65.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(50.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f);
		cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(0.0f, cellView.frame.size.height-50.0f, 50.0f, 50.0f);
    }
    
    
    
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:headImageView];
    [cellView addSubview:returnView];
    [bubbleImageView release];
    [returnView release];
    [headImageView release];
	return [cellView autorelease];
    
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



#pragma mark -
#pragma mark Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]) {
		return 30;
	}else {
		UIView *chatView = [[self.chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
		return chatView.frame.size.height+10;
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CommentCellIdentifier = @"CommentCell";
	ChatCustomCell *cell = (ChatCustomCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil] lastObject];
	}
	
	if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]) {
		// Set up the cell...
		NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yy-MM-dd HH:mm"];
		NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:[self.chatArray objectAtIndex:[indexPath row]]]];
		[formatter release];
        
		[cell.dateLabel setText:timeString];
		
        
	}else {
		// Set up the cell...
		NSDictionary *chatInfo = [self.chatArray objectAtIndex:[indexPath row]];
		UIView *chatView = [chatInfo objectForKey:@"view"];
		[cell.contentView addSubview:chatView];
	}
    return cell;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.messageTextField resignFirstResponder];
}

//图文混排

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                [img release];
                upX=KFacialSizeWidth+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    [la release];
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}
@end
