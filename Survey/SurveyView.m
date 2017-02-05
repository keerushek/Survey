//
//  SurveyView.m
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "SurveyView.h"
#import "ImageCache.h"

#define TAKE_SURVEY_VALUE   @"Take the Survey"
#define BG_IMAGE            @"food"

@interface SurveyView()
@property (nonatomic, strong) UILabel *surveyTitleLabel, *surveyDescLabel;
@property (nonatomic, strong) UIImageView *surveyBGImage;
@property (nonatomic, strong) UIButton *takeSurveyButton;
@end

@implementation SurveyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.surveyBGImage = [[UIImageView alloc] init];
        self.surveyBGImage.contentMode = UIViewContentModeScaleAspectFit;
        self.surveyBGImage.image = [UIImage imageNamed:BG_IMAGE];
        [self addSubview:self.surveyBGImage];
        
        
        self.surveyTitleLabel = [[UILabel alloc] init];
        self.surveyTitleLabel.font = [UIFont fontWithName:FONT_NAME size:23.0];
        self.surveyTitleLabel.textColor = [UIColor whiteColor];
        self.surveyTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.surveyTitleLabel];
        
        self.surveyDescLabel = [[UILabel alloc] init];
        self.surveyDescLabel.font = [UIFont fontWithName:FONT_NAME size:18.0];
        self.surveyDescLabel.textColor = [UIColor whiteColor];
        self.surveyDescLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.surveyDescLabel];
        
        
        
        self.takeSurveyButton = [[UIButton alloc] init];
        [self.takeSurveyButton setTitle:TAKE_SURVEY_VALUE forState:UIControlStateNormal];
        [self.takeSurveyButton setBackgroundColor:[UIColor redColor]];
        self.takeSurveyButton.layer.cornerRadius = 30;
        self.takeSurveyButton.clipsToBounds = YES;
        [self.takeSurveyButton addTarget:self action:@selector(takeSurvey) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.takeSurveyButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.surveyTitleLabel.frame = CGRectMake(0.0, self.frame.size.height *0.01, self.frame.size.width, self.frame.size.height*0.1);
    
    self.surveyDescLabel.frame = CGRectMake(0.0, self.surveyTitleLabel.frame.size.height + self.surveyTitleLabel.frame.origin.y + self.frame.size.height *0.02, self.frame.size.width, self.frame.size.height*0.1);
    
    self.surveyBGImage.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    self.takeSurveyButton.frame = CGRectMake(0.0, self.frame.size.height - self.frame.size.height*0.2, self.frame.size.width * 0.6, self.frame.size.height*0.1);
    self.takeSurveyButton.center = CGPointMake(self.frame.size.width/2.0, self.takeSurveyButton.center.y);
}

//Delegate to call when take survey is clicked
-(void)takeSurvey{
    if([self.takeSurveyDelegate respondsToSelector:@selector(clickTakeSurveyButton)])
        [self.takeSurveyDelegate clickTakeSurveyButton];
}

-(void)renderViewSurveyTitle:(NSString *)surveyTitle withDescription:(NSString *)description andPic:(NSString *)imageURL{
   
    UIImage *img = (UIImage *)[[ImageCache sharedCache]imageForURLString:imageURL];
    if(img == nil)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            if(image != nil)
            {
                [[ImageCache sharedCache]addImageToCache:image forURLString:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.surveyBGImage.image = image;
                });
            }
        });
    }
    else
    {
        self.surveyBGImage.image = img;
    }
 
    self.surveyTitleLabel.text = surveyTitle;
    
    self.surveyDescLabel.text = description;
    
    
}
@end
