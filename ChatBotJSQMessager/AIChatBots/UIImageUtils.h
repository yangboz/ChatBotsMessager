//
//  UIImageUtils.h
//  DeepDetectChatBots
//
//  Created by yangboz on 30/01/2017.
//  Copyright © 2017 ___SMARTKIT.INFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageUtils : NSObject
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*) grayishImage: (UIImage*) inputImage;
@end
