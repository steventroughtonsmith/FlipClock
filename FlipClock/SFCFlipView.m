//
//  SFCFlipView.m
//  FlipClock
//
//  Created by Steven Troughton-Smith on 23/04/2012.
//  Copyright (c) 2012 High Caffeine Content. All rights reserved.
//

/*
 
 This is a really quick implementation of a flip clock. There are
 a thousand better ways to do this. Few are documented online tho
 so I thought this might be a decent starting point or helpful for
 prototyping
 
 License: BSD (or whatever)
 
 */

#import "SFCFlipView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SFCFlipView

@synthesize topLeft;
@synthesize bottomLeft;
@synthesize topRight;
@synthesize bottomRight;
@synthesize topLeftBeneath;
@synthesize topRightBeneath;
@synthesize bottomLeftBeneath;
@synthesize bottomRightBeneath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self _commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

-(UILabel *)createLabel
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	
	label.backgroundColor = nil;
	label.opaque = NO;
	label.font = [UIFont boldSystemFontOfSize:84];
	label.textAlignment = UITextAlignmentCenter;
	label.text = @"0";
	label.textColor = [UIColor darkGrayColor];
	label.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	label.shadowOffset = CGSizeMake(0, -1);
	label.tag = CARD_TAG;
	
	return label;
}

-(UIView *)segment:(BOOL)top
{
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(STARTX,STARTY+ CARDHEIGHT/2, CARDWIDTH, CARDHEIGHT/2)];
	v.clipsToBounds = YES;

	UIImage *img = [UIImage imageNamed:@"Segment.png"];
	
	if (top) // I'm flipping the image here for the top; same happens with the gloss later
	{
		UIGraphicsBeginImageContext(img.size);
		
		CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
		
		[img drawAtPoint:CGPointMake(0.0, -img.size.height)];
		
		UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		v.backgroundColor = [UIColor colorWithPatternImage:newImg];
		
	}
	else
	{
		v.backgroundColor = [UIColor colorWithPatternImage:img];
		
	}
	
	
	UILabel *label = [self createLabel];
	
	if (top)
	{
		label.frame = CGRectOffset(v.bounds, 0, +CARDHEIGHT/4);
	}
	else
	{
		label.frame = CGRectOffset(v.bounds, 0, -CARDHEIGHT/4);
	}
	
	[v addSubview:label];
	
	UIImageView *glossView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SegmentGloss.png"]];
	
	if (top)
	{
		glossView.layer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0);
	}
	
	[v addSubview:glossView];

	return v;
}

-(void)_commonInit
{
	self.text = @"00";
	self.backgroundColor = [UIColor whiteColor];
	
	/*
	 
		Really simplistic here; I create 8 segments, one for each
		half a card. I have front and back layers.
	 
	 */
	
	{
		UIView *v = [self segment:NO];
		v.frame = CGRectMake(STARTX,STARTY+CARDHEIGHT/2, CARDWIDTH, CARDHEIGHT/2);
		
		self.bottomLeft = v;
		[self addSubview:v];
	}
	{
		UIView *v = [self segment:YES];
		v.frame = CGRectMake(STARTX, STARTY, CARDWIDTH, CARDHEIGHT/2);
		
		self.topLeft = v;
		
		[self addSubview:v];
	}
	
	{
		UIView *v = [self segment:NO];
		v.frame = CGRectMake(STARTX+TWEEN+CARDWIDTH,STARTY+ CARDHEIGHT/2, CARDWIDTH, CARDHEIGHT/2);
		
		self.bottomRight = v;
		[self addSubview:v];
	}
	
	{
		UIView *v = [self segment:YES];
		v.frame = CGRectMake(STARTX+TWEEN+CARDWIDTH, STARTY, CARDWIDTH, CARDHEIGHT/2);
		
		self.topRight = v;
		[self addSubview:v];
	}
	
	/* Beneath - the ones that show underneath the animation */
	
	{
		UIView *v = [self segment:YES];
		v.frame = CGRectMake(STARTX, STARTY, CARDWIDTH, CARDHEIGHT/2);
		
		self.topLeftBeneath = v;
		[self insertSubview:v atIndex:0];
		
		
	}
	{
		UIView *v = [self segment:YES];
		v.frame = CGRectMake(STARTX+TWEEN+CARDWIDTH, STARTY, CARDWIDTH, CARDHEIGHT/2);
		
		self.topRightBeneath = v;
		[self insertSubview:v atIndex:0];
	}
	
	
	{
		UIView *v = [self segment:NO];
		v.frame = CGRectMake(STARTX,STARTY+ CARDHEIGHT/2, CARDWIDTH, CARDHEIGHT/2);
		
		self.bottomLeftBeneath = v;
		[self insertSubview:v atIndex:0];
		
	}
	
	{
		UIView *v = [self segment:NO];
		v.frame = CGRectMake(STARTX+TWEEN+CARDWIDTH,STARTY+ CARDHEIGHT/2, CARDWIDTH, CARDHEIGHT/2);
		self.bottomRightBeneath = v;
		
		[self insertSubview:v atIndex:0];
	}
	
	{
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SegmentStack.png"]];
		iv.layer.anchorPoint = CGPointMake(0, 0);
		iv.layer.position = CGPointMake(STARTX, STARTY-20);
		[self insertSubview:iv atIndex:0];
	}
	
	{
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SegmentStack.png"]];
		iv.layer.anchorPoint = CGPointMake(0, 0);
		iv.layer.position = CGPointMake(STARTX+TWEEN+CARDWIDTH, STARTY-20);
		[self insertSubview:iv atIndex:0];
		
	}
	
	/* Gotta set up the layers so they rotate around the center of each card, instead of the center of each half */
	
	self.topLeft.layer.position = CGPointMake(self.topLeft.layer.position.x-CARDWIDTH/2, self.topLeft.layer.position.y+CARDHEIGHT/4);
	self.topRight.layer.position = CGPointMake(self.topRight.layer.position.x-CARDWIDTH/2, self.topRight.layer.position.y+CARDHEIGHT/4);
	
	self.topLeft.layer.anchorPoint = CGPointMake(0, 1.0);
	self.topRight.layer.anchorPoint = CGPointMake(0, 1.0);
	
	self.bottomLeft.layer.position = CGPointMake(self.bottomLeft.layer.position.x-CARDWIDTH/2, self.bottomLeft.layer.position.y-CARDHEIGHT/4);
	self.bottomRight.layer.position = CGPointMake(self.bottomRight.layer.position.x-CARDWIDTH/2, self.bottomRight.layer.position.y-CARDHEIGHT/4);
	
	self.bottomLeft.layer.anchorPoint = CGPointMake(0, 0.0);
	self.bottomRight.layer.anchorPoint = CGPointMake(0, 0.0);
	
	/* Turn on 3D perspective */
	
	CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -420.0;
    [self.layer setSublayerTransform:sublayerTransform];
}


-(void)flipToShowString:(NSString *)string
{
	NSString *firstDigit = [string substringToIndex:1];
	NSString *secondDigit = [string substringFromIndex:1];
	
	NSString *oldFirstDigit = [self.text substringToIndex:1];
	NSString *oldSecondDigit = [self.text substringFromIndex:1];
	
	
	((UILabel *)[self.topLeftBeneath viewWithTag:CARD_TAG]).text = firstDigit;
	((UILabel *)[self.topRightBeneath viewWithTag:CARD_TAG]).text = secondDigit;
	
	
	((UILabel *)[self.bottomLeftBeneath viewWithTag:CARD_TAG]).text = oldFirstDigit;
	((UILabel *)[self.bottomRightBeneath viewWithTag:CARD_TAG]).text = oldSecondDigit;
	
	[UIView animateWithDuration:ANIMATION_LENGTH animations:^{
		
		self.topRight.layer.transform = CATransform3DMakeRotation(M_PI_2, -1.0, 0.0, 0.0);
		self.topLeft.layer.transform = CATransform3DMakeRotation(M_PI_2, -1.0, 0.0, 0.0);
		
	} completion:^(BOOL finished) {
		((UILabel *)[self.topLeft viewWithTag:CARD_TAG]).text = firstDigit;
		((UILabel *)[self.topRight viewWithTag:CARD_TAG]).text = secondDigit;
		
		((UILabel *)[self.bottomLeft viewWithTag:CARD_TAG]).text = firstDigit;
		((UILabel *)[self.bottomRight viewWithTag:CARD_TAG]).text = secondDigit;
		
		self.topRight.layer.transform = CATransform3DIdentity;
		self.topLeft.layer.transform = CATransform3DIdentity;
		
		self.bottomRight.layer.transform = CATransform3DMakeRotation(M_PI_2, 1.0, 0.0, 0.0);
		self.bottomLeft.layer.transform = CATransform3DMakeRotation(M_PI_2, 1.0, 0.0, 0.0);
		
		[UIView animateWithDuration:ANIMATION_LENGTH animations:^{
			self.bottomRight.layer.transform = CATransform3DIdentity;
			self.bottomLeft.layer.transform = CATransform3DIdentity;
		} completion:^(BOOL finished) {
			
		}];
	}];
	
	self.text = string;
}

-(IBAction)testFlip:(id)sender
{
	/* Pick a random number, flip to it. 01-99 format */
	
	[self flipToShowString:[NSString stringWithFormat:@"%02i",arc4random()%99]];
}

@end
