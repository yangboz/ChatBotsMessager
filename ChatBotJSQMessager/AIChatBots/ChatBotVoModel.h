//
//  ChatBotVo.h
//  ChatBotsMessager
//
//  Created by zhou Yangbo on 13-3-19.
//  Copyright (c) 2013年 GODPAPER. All rights reserved.
//

#import "JSONModel.h"

@interface ChatBotVoModel:JSONModel

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
@property(nonatomic) NSString *Image;
@property(nonatomic) NSNumber *Id;
@property(nonatomic) NSString *Name;
@property(nonatomic) NSNumber *Development;
@property(nonatomic) NSString *AI;
@property(nonatomic) NSString *Updated;
@property(nonatomic) NSString *Bio;
@property(nonatomic) NSString *Entity;
@property(nonatomic) NSString *Personality;
@property(nonatomic) NSString *Temperament;
@property(nonatomic) NSString *Basis;
@property(nonatomic) NSString *From;
@property(nonatomic) NSString *Country;
@property(nonatomic) NSString *Gender;
@property(nonatomic) NSString *Created;
@property(nonatomic) NSString *Interests;
@property(nonatomic) NSString *Rating;

@end
