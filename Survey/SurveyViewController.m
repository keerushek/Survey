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
#import "User+CoreDataClass.h"
#import "CommandFetchSurveyList.h"
#import "RefreshViewController.h"


@interface SurveyViewController ()
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) SurveyView *surveryView1;
@property (nonatomic, strong) NSArray *surveyList;
@property (nonatomic, strong) UIView *fetchingLoadIndicator;
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
    [self.view setBackgroundColor:[UIColor blueColor]];
//    self.navBar = [[UINavigationBar alloc] init];
    self.surveyList = [Survey getAllSurveys];
    if(self.surveyList == nil || self.surveyList.count <=0)
    {
        
        NSArray *userArray = [User getAllUserAccounts];
        //Some User Exists
        if(userArray.count > 0)
        {
            User *currentUser = (User *)userArray[0];
            if(currentUser.accessToken != nil)
            {
                [self refreshSurveyListWithAccessToken:currentUser.accessToken];
            }
            else
            {
                [self switchToRefreshAccessTokenPage];
            }
        }
        else
        {
            [self switchToRefreshAccessTokenPage];
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.navBar.frame = CGRectMake(0.0, 20.0, self.view.frame.size.width, 40.0);
    self.surveryView1.frame = CGRectMake(0.0, self.navBar.frame.origin.y + self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.navBar.frame.origin.y + self.navBar.frame.size.height));
}

-(void)refreshSurveyListWithAccessToken:(NSString *)accessToken {
    
    self.fetchingLoadIndicator = [self getActivityIndictorWithMessage:@"Fetching Survey List" andFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.fetchingLoadIndicator];
    CommandFetchSurveyList *fetchList = [[CommandFetchSurveyList alloc] initWithAccessToken:accessToken CompletionBlock:^(id param){
        //Removing activity indicator
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.fetchingLoadIndicator removeFromSuperview];
            self.fetchingLoadIndicator = nil;
            self.surveyList = [Survey getAllSurveys];
        });


    } errorBlock:^(id param){
        [self switchToRefreshAccessTokenPage];

    }];
    [[CommandQueue sharedCommandQueueInstance] addClassToCommandQueue:fetchList];
}

-(void)switchToNextSurvey{
    
}
-(void)switchToRefreshAccessTokenPage{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Access Token" message:@"Login again please" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      
                                  }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//Loading Indicator
-(UIView *)getActivityIndictorWithMessage:(NSString *)message andFrame:(CGRect)frame
{
    UIView *activityIndicatorBackgroundView = [[UIView alloc]initWithFrame:frame];//CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    activityIndicatorBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    /*View which contais activity indicator.*/
    UIView *activityIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 120)];
    activityIndicatorView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    activityIndicatorView.backgroundColor = [UIColor clearColor];
    
    
    /*Background view of activity indicator.*/
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake((activityIndicatorView.frame.size.width/2-activityIndicatorView.frame.size.height/4), (activityIndicatorView.frame.size.height/2-activityIndicatorView.frame.size.height/4), activityIndicatorView.frame.size.height/2, activityIndicatorView.frame.size.height/2)];
    backgroundView.backgroundColor=[UIColor grayColor];
    backgroundView.layer.cornerRadius=15;
    
    /*Activity indicator for view.*/
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityView startAnimating];
    
    [backgroundView addSubview:activityView];
    
    [activityIndicatorView addSubview:backgroundView];
    
    /*If message is nill then no need of allocation.*/
    if ((message != nil) && (![message isEqualToString:@""]))
    {
        /*Message label for description of web page.*/
        UILabel *messageLabel;
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, activityIndicatorView.frame.size.height/2)];
        messageLabel.center = CGPointMake(backgroundView.center.x, backgroundView.center.y+backgroundView.frame.size.height);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        [activityIndicatorView addSubview:messageLabel];
    }
    [activityIndicatorBackgroundView addSubview:activityIndicatorView];
    return activityIndicatorBackgroundView;
}
//Delegate for to show Alert view
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^) (void))completion{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyChangeMainViewController object:[RefreshViewController class]];
}


@end
