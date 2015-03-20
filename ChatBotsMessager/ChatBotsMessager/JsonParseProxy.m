//
//  JsonParseProxy.m
//  MasterDetailer
//
//  Created by zhou Yangbo on 13-2-21.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import "JsonParseProxy.h"
#import "JSONKit.h"
#import "AllChatBotsVO.h"
#import "ChatBotsModel.h"
#import "AppDelegate.h"

@implementation JsonParseProxy

-(void)parseJsonFile:(NSString *)path
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"json"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];
    //
    [self parseJsonRawData:fileData];
}
-(void)parseJsonUrl:(NSString *)uri
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
    NSURLResponse *response;
    NSError *error;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //
    [self parseJsonRawData:jsonData];
}

-(void) parseJsonRawData:(NSData *)rawData
{
    NSDictionary *jsonKitData = [rawData objectFromJSONData];
    NSEnumerator *enumerator = [jsonKitData keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
    {
        NSLog(@"%@", [jsonKitData objectForKey: key]);
    }
    // Pretend like you've called a REST service here and it returns a string.
    // We'll just create a string from the sample json constant at the top
    // of this file.
    NSString *jsonKitStr = [jsonKitData JSONString];
    //    NSLog(@"string from JSONKit: \n%@", jsonKitStr);
    // 1) Create a dictionary, from the result string,
    // using JSONKit's NSString category; objectFromJSONString.
    NSDictionary* dict = [jsonKitStr objectFromJSONString];
    
    // 2) Dump the dictionary to the debug console.
    NSLog(@"Dictionary => %@\n", dict); 
    
    // 3) Now, let's create a Person object from the dictionary.
    AllChatBotsVO* allChatBotsVO = [[AllChatBotsVO alloc] initWithDictionary:dict];
    
    // 4) Dump the contents of the person object
    // to the debug console.
    NSLog(@"AllChatBotsVO => %@\n", allChatBotsVO);
    NSLog(@"AllChatBotsVO.chatbots: %@\n", [allChatBotsVO chatbots]);
    NSLog(@"AllChatBotsVO.chatbots[0]: %@\n", [[allChatBotsVO chatbots] objectAtIndex:0]);
    
    // 5) Model store
    [ChatBotsModel setAllChatBots:allChatBotsVO];
    
    // 6) Set delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray: 
                              [[ChatBotsModel getAllChatBots] chatbots] ];
    //
    [appDelegate setMasterControllerData:mArray];
    [mArray release];
}
@end
