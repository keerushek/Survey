//
//  SurveyViewController.m
//  Survey
//
//  Created by Keerthi Shekar G on 31/01/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "SurveyViewController.h"
#import "SurveyView.h"
#import "Survey+CoreDataClass.h"


@interface SurveyViewController ()
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) SurveyView *surveryView1;
@end

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.navBar = [[UINavigationBar alloc] init];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.navBar.frame = CGRectMake(0.0, 20.0, self.view.frame.size.width, 40.0);
    self.surveryView1.frame = CGRectMake(0.0, self.navBar.frame.origin.y + self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.navBar.frame.origin.y + self.navBar.frame.size.height));
}

-(void)switchToNextSurvey{
    
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
