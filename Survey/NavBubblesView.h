//
//  NavBubblesView.h
//  Survey
//
//  Created by Keerthi Shekar G on 05/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavBubbleDelegate <NSObject>

-(void)bubbleTapped:(int)tappedBubbleTag;

@end

@interface NavBubblesView : UIScrollView
@property (weak, nonatomic) id<NavBubbleDelegate> navBubbleDelegate;
-(instancetype)initWithFrame:(CGRect)frame andNumberOfBubbles:(int)count andSelectedBubble:(int)selected;
-(void)deselectBubble:(int)tag;
-(void)selectBubble:(int)tag;
@end
