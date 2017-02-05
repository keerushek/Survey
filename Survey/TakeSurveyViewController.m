//
//  TakeSurveyViewController.m
//  Survey
//
//  Created by Keerthi Shekar G on 05/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "TakeSurveyViewController.h"

@interface TakeSurveyViewController ()

@end

@implementation TakeSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *surveyTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.navigationController.navigationItem.titleView.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    surveyTitle.text = @"TAKE THE SURVEY";
    surveyTitle.textAlignment = NSTextAlignmentCenter;
    surveyTitle.textColor = [UIColor whiteColor];
    surveyTitle.font = [UIFont fontWithName:FONT_NAME size:23.0];
    
    self.navigationItem.titleView = surveyTitle;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
