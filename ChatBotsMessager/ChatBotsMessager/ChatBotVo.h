//
//  ChatBotVo.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-19.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import "Jastor.h"

@interface ChatBotVo : Jastor
{}
//"image": "prob_23958.gif",
//"id": 23958,
//"name": "prob",
//"Development": 29715,
//"AI": "•••••••••",
//"Updated": "Cold",
//"Bio": "Problem is a wood elf, she loves to help",
//"Entity": "Mythical",
//"Personality": "Helper",
//"Temperament": "Friendly",
//"Basis": "Original",
//"From": "The Grove of Sumber, Crescent Mountains",
//"Country": "Middle Earth",
//"Gender": "F",
//"Created": "February 19, 2005",
//	"Interests": "Prob is not an adult bot. PLEASE DO NOT CYBER Flora and fauna, singing, and roaming the forests are Prob's favorite things to do. She also has a fascination with campfires email her at Problem@WitchesBrew.zzn.com This is NOT an adult bot.. "
//,"Rating": "E"
@property(nonatomic,retain) NSString *Image;
@property(nonatomic,retain) NSNumber *Id;
@property(nonatomic,retain) NSString *Name;
@property(nonatomic,retain) NSNumber *Development;
@property(nonatomic,retain) NSString *AI;
@property(nonatomic,retain) NSString *Updated;
@property(nonatomic,retain) NSString *Bio;
@property(nonatomic,retain) NSString *Entity;
@property(nonatomic,retain) NSString *Personality;
@property(nonatomic,retain) NSString *Temperament;
@property(nonatomic,retain) NSString *Basis;
@property(nonatomic,retain) NSString *From;
@property(nonatomic,retain) NSString *Country;
@property(nonatomic,retain) NSString *Gender;
@property(nonatomic,retain) NSString *Created;
@property(nonatomic,retain) NSString *Interests;
@property(nonatomic,retain) NSString *Rating;

@end
