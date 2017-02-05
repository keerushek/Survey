//
//  SurveyView.h
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakeSurveyDelegate<NSObject>

- (void) clickTakeSurveyButton;

@end

@interface SurveyView : UIView
@property (weak, nonatomic) id<TakeSurveyDelegate> takeSurveyDelegate;
-(void)renderViewSurveyTitle:(NSString *)surveyTitle withDescription:(NSString *)description andPic:(NSString *)imageURL;
@end
