//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "DemoMessagesViewController.h"
#import "JSQMessagesViewAccessoryButtonDelegate.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import <ASIHttpRequest.h>
#import "StringUtil.h"
#import "Constants.h"
#import "ResponseVoModel.h"
#import "APIMessageVoModel.h"
#import "APIUserVoModel.h"
#import "APIFullMessageVoModel.h"
#import "NSString+Emoji.h"
#import "DataModel.h"
#import "ChatBotVoModel.h"

#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface DemoMessagesViewController () <JSQMessagesViewAccessoryButtonDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DemoMessagesViewController
@synthesize masterPopoverController = _masterPopoverController;
MBProgressHUD *hud;

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    ChatBotVoModel *selected = [[DataModel sharedInstance] getSelectedChatBot];
    barButtonItem.title = selected.Name;
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark - API request

#pragma mark - Responding to API request
-(void)sendMessageToAPI:(NSString *)content
{
    NSString *msgJsonStr = [self getMessageJsonString:content];
    NSLog(@"msgJsonStr:%@",msgJsonStr);
    //
    //    NSString *hashStr = [self HMACWithSecret:API_SECERT andData:msgJsonStr];
    //NSString *hashStr = [StringUtil HMACWithSecret:API_SECERT andData:msgJsonStr];
    NSString *hashStr = [StringUtil HMACSHA1withKey:API_SECERT forString:msgJsonStr];
    if(nil == hashStr) return;
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
//    NSDictionary* dict = [text objectFromJSONString];
    
    // 2) Dump the dictionary to the debug console.
//    NSLog(@"Dictionary => %@\n", dict);
    
    // 3) Now, let's create a Person object from the dictionary.
    NSError *error;
    ResponseVoModel *responseVO = [[ResponseVoModel alloc] initWithString:text error:&error];
    // 4) Dump the contents of the person object
    // to the debug console.
//    NSString *message = responseVO.message.message;
    NSLog(@"responseVO => %@\n", responseVO);
    NSLog(@"responseVO.message.chatBotName: %@\n", [[responseVO message] chatBotName]);
    NSLog(@"responseVO.message.chatBotID: %@\n", [[responseVO message] chatBotID]);
    NSLog(@"responseVO.message.message: %@\n", [[responseVO message] message]);
    NSLog(@"responseVO.message.emotion: %@\n", [[responseVO message] emotion]);
    //
    [hud hideAnimated:YES];
    //go to receive message
    [self receiveMessageFromAPI:responseVO];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"API request error:%@",error);
    //
    [hud hideAnimated:YES];
}

-(NSString *)getMessageJsonString:(NSString *)content
{
    //    NSTimeInterval interval64Bit = (63522762851317000/1000000)-62135596800;
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval64Bit];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int dateInt = (long long int)time;
    //    NSLog(@"date %lld",dateInt);
    int chatBotId = [self.detailItem.Id intValue];
    NSLog(@"chatBotID:%d",chatBotId);
    if(0 == chatBotId)
    {
        chatBotId = 6;//Default chatbot id;
    }
    //
//    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
//    [messageDict setValue:content forKey:@"message"];
//    [messageDict setValue:[NSNumber numberWithInt:chatBotId] forKey:@"chatBotID"];
//    [messageDict setValue:[NSNumber numberWithInt:dateInt] forKey:@"timestamp"];
//    NSLog(@"messageDict:%@",messageDict);
    //
    APIMessageVoModel *messageModel = [APIMessageVoModel new];
    messageModel.message = content;
    messageModel.chatBotID = [NSNumber numberWithInt:chatBotId];
    messageModel.timestamp = [NSNumber numberWithInt:dateInt];
     NSLog(@"messageModel json:%@",messageModel.toJSONString);
    //    NSLog(@"messageDict json str:%@",[messageDict JSONString]);
    
//    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
//    [userDict setValue:@"Tugger" forKey:@"firstName"];
//    [userDict setValue:@"Sufani" forKey:@"lastName"];
//    [userDict setValue:@"m" forKey:@"gender"];
//    [userDict setValue:@"abc-639184572" forKey:@"externalID"];
//    NSLog(@"userDict:%@",userDict);
    APIUserVoModel *userModel = [APIUserVoModel new];
    userModel.firstName = @"Tugger";
    userModel.lastName = @"Sufani";
    userModel.gender = @"m";
    userModel.externalID = @"abc-639184572";
        NSLog(@"userModel json str:%@",userModel.toJSONString);
    
//    NSMutableDictionary *messageFullDict = [[NSMutableDictionary alloc] init];
//    [messageFullDict setValue:messageDict forKey:@"message"];
//    [messageFullDict setValue:userDict forKey:@"user"];
//    NSLog(@"messageFullDict:%@",messageFullDict);
    APIFullMessageVoModel *messageFullModel = [APIFullMessageVoModel new];
    messageFullModel.message = messageModel;
    messageFullModel.user = userModel;
    //Json writer
    NSLog(@"messageFullDict json:%@",messageFullModel.toJSONString);
    //
    return messageFullModel.toJSONString;
}

-(NSString *)getUrlEncodeString:(NSString *)unEscapedString
{
    return [unEscapedString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

-(void)receiveMessageFromAPI:(ResponseVoModel *)response
{
    
    /**
     *  Show the typing indicator to be shown
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:YES];
    
    /**
     *  Copy last sent message, this will be the new "received" message
     */
    JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
    
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                          displayName:kJSQDemoAvatarDisplayNameJobs
                                                 text:@"First received!"];
    }
    
    /**
     *  Allow typing indicator to show
     */
//        NSMutableArray *userIds = [[self.demoData.users allKeys] mutableCopy];
//        [userIds removeObject:self.senderId];
//        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
        
        JSQMessage *newMessage = nil;
        id<JSQMessageMediaData> newMediaData = nil;
        id newMediaAttachmentCopy = nil;
        //Always text message with emoji
    NSString *emotionalMessage = [[NSString stringWithFormat:@":%@:%@",response.message.emotion,response.message.message] stringByReplacingEmojiCheatCodesWithUnicode];
            newMessage = [JSQMessage messageWithSenderId:response.message.chatBotID.stringValue
                                             displayName:response.message.chatBotName
                                                    text:emotionalMessage];
//        }
    
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        
        [self.demoData.messages addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
        
        
//        if (newMessage.isMediaMessage) {
//            /**
//             *  Simulate "downloading" media
//             */
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                /**
//                 *  Media is "finished downloading", re-display visible cells
//                 *
//                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
//                 *
//                 *  Reload the specific item, or simply call `reloadData`
//                 */
//                
//                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
//                    [self.collectionView reloadData];
//                }
//                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
//                        [self.collectionView reloadData];
//                    }];
//                }
//                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
//                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
//                    [self.collectionView reloadData];
//                }
//                else if ([newMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
//                    ((JSQAudioMediaItem *)newMediaData).audioData = newMediaAttachmentCopy;
//                    [self.collectionView reloadData];
//                }
//                else {
//                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//                }
//                
//            });
//        }
}


#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.yahoo.com"];
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
    
//    self.title = self.detailItem.Name;
    ChatBotVoModel *curChatBot = [[DataModel sharedInstance] getSelectedChatBot];
    self.title = curChatBot.Name;

    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    self.inputToolbar.contentView.leftBarButtonItem.enabled = NO;
    
    /**
     *  Load up our fake data for the demo
     */
    self.demoData = [[DemoModelData alloc] init];
    
    self.detailItem = [[DataModel sharedInstance] getSelectedChatBot];
    /**
     *  Set up message accessory button delegate and configuration
     */
//    self.collectionView.accessoryDelegate = self;

    /**
     *  You can set custom avatar sizes
     */
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(40, 40);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
//    if (![NSUserDefaults incomingAvatarSetting]) {
//        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//    }
//    
//    if (![NSUserDefaults outgoingAvatarSetting]) {
//        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
//    }
    
    self.showLoadEarlierMessagesHeader = NO;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(receiveMessagePressed:)];

    /**
     *  Register custom menu actions for cells.
     */
//    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];

	
    /**
     *  OPT-IN: allow cells to be deleted
     */
//    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];

    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */

    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];
}



#pragma mark - Custom menu actions for cells

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    /**
     *  Display custom menu actions for cells.
     */
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    [super didReceiveMenuWillShowNotification:notification];
}



#pragma mark - Testing

- (void)pushMainViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:nc.topViewController animated:YES];
}


#pragma mark - Actions

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissJSQDemoViewController:self];
}




#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */

    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.demoData.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    //
    [self sendMessageToAPI:message.text];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Media messages", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Send photo", nil), NSLocalizedString(@"Send location", nil), NSLocalizedString(@"Send video", nil), NSLocalizedString(@"Send video thumbnail", nil), NSLocalizedString(@"Send audio", nil), nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self.demoData addPhotoMediaMessage];
            break;
            
        case 1:
        {
            __weak UICollectionView *weakView = self.collectionView;
            
            [self.demoData addLocationMediaMessageCompletion:^{
                [weakView reloadData];
            }];
        }
            break;
            
        case 2:
            [self.demoData addVideoMediaMessage];
            break;
            
        case 3:
            [self.demoData addVideoMediaMessageWithThumbnail];
            break;
            
        case 4:
            [self.demoData addAudioMediaMessage];
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}



#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return kJSQDemoAvatarIdSquires;
}

- (NSString *)senderDisplayName {
    return kJSQDemoAvatarDisplayNameSquires;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.demoData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    JSQMessagesAvatarImage *chatBotImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:self.detailItem.Image] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    return chatBotImage;
    
    if ([message.senderId isEqualToString:self.senderId]) {
        if (![NSUserDefaults outgoingAvatarSetting]) {
            return nil;
        }
    }
    else {
        if (![NSUserDefaults incomingAvatarSetting]) {
            return nil;
        }
    }
    
    
    return [self.demoData.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }

//    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
    
    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return ([message isMediaMessage] && [NSUserDefaults accessoryButtonForMediaMessages]);
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }

    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }

    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);

    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.demoData.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}

@end
