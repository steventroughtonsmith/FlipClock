//
//  SFCFlipView.h
//  FlipClock
//
//  Created by Steven Troughton-Smith on 23/04/2012.
//  Copyright (c) 2012 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CARDWIDTH 100
#define CARDHEIGHT 140

#define CARD_TAG 0x1337

#define STARTX 50
#define STARTY	30
#define TWEEN 5

#define ANIMATION_LENGTH 5.0

@interface SFCFlipView : UIView

@property (nonatomic, strong) UIView *topLeft;
@property (nonatomic, strong) UIView *bottomLeft;
@property (nonatomic, strong) UIView *topRight;
@property (nonatomic, strong) UIView *bottomRight;


@property (nonatomic, strong) UIView *topLeftBeneath;
@property (nonatomic, strong) UIView *topRightBeneath;
@property (nonatomic, strong) UIView *bottomLeftBeneath;
@property (nonatomic, strong) UIView *bottomRightBeneath;

@property (nonatomic, strong) NSString *text;

-(IBAction)testFlip:(id)sender;
-(void)flipToShowString:(NSString *)string;

@end
