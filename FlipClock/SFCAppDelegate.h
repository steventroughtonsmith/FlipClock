//
//  SFCAppDelegate.h
//  FlipClock
//
//  Created by Steven Troughton-Smith on 23/04/2012.
//  Copyright (c) 2012 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFCViewController;

@interface SFCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SFCViewController *viewController;

@end
