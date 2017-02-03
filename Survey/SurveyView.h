//
//  SurveyView.h
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyView : UIView
-(instancetype)initWithSurveyTitle:(NSString *)surveyTitle withDescription:(NSString *)description andPic:(NSString *)imageURL;
@property (nonatomic, strong) UIButton *takeSurveyButton;
@end
