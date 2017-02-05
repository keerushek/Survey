//
//  NavBubblesView.m
//  Survey
//
//  Created by Keerthi Shekar G on 05/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "NavBubblesView.h"

#define EMPTY_CIRCLE_IMAGE      @"empty_circle"
#define FULL_CIRCLE_IMAGE       @"full_circle"

@interface NavBubblesView() <UIScrollViewDelegate>

@end

@implementation NavBubblesView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame andNumberOfBubbles:(int)count andSelectedBubble:(int)selected
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        for(int i=0;i<count;i++)
        {
            UIButton *navBubble = [[UIButton alloc] init];
            navBubble.frame = CGRectMake(0.0, 40.0*i, self.frame.size.width, 40.0);
            if(i != selected)
                [navBubble setImage:[UIImage imageNamed:EMPTY_CIRCLE_IMAGE] forState:UIControlStateNormal];
            else
                [navBubble setImage:[UIImage imageNamed:FULL_CIRCLE_IMAGE] forState:UIControlStateNormal];
            
            navBubble.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
            
            [navBubble addTarget:self action:@selector(navBubbleTapped:) forControlEvents:UIControlEventTouchDown];
            
            navBubble.tag = BUBBLE_TAG + i;
            [self addSubview:navBubble];
        }
    }
    return self;
}
-(void)navBubbleTapped:(UIButton *)sender
{
    if([self.navBubbleDelegate respondsToSelector:@selector(bubbleTapped:)])
        [self.navBubbleDelegate bubbleTapped:(int)sender.tag];
}
-(void)deselectBubble:(int)tag
{
    UIButton *bubbleButton = (UIButton *)[self viewWithTag:tag];
    [bubbleButton setImage:[UIImage imageNamed:EMPTY_CIRCLE_IMAGE] forState:UIControlStateNormal];
}

-(void)selectBubble:(int)tag
{
    UIButton *bubbleButton = (UIButton *)[self viewWithTag:tag];
    [bubbleButton setImage:[UIImage imageNamed:FULL_CIRCLE_IMAGE] forState:UIControlStateNormal];
}
@end
