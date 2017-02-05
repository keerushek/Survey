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
#import "TakeSurveyViewController.h"
#import "NavBubblesView.h"

#define SURVEYS_VALUE       @"SURVEYS"
#define REFRESH_IMAGE_VALUE @"refresh"
#define ANIMATION_DUR 0.3


@interface SurveyViewController () <TakeSurveyDelegate, NavBubbleDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *surveyList;
@property (nonatomic, strong) UIView *fetchingLoadIndicator;
@property (nonatomic) int surveyIndex;
@property (nonatomic, strong) NavBubblesView *navBubble;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithRed:22.0/255.0 green:31.0/255.0 blue:63.0/255.0 alpha:1.0]];
    
    [self createHeaderView];
    self.surveyIndex = 0;
    
    self.surveyList = [Survey getAllSurveys];
    if(self.surveyList == nil || self.surveyList.count <=0)
    {
        [self refreshSurveyList];
        
    }
    else
    {
        [self createListOfSurveyViews];
        
        [self createBubbleNav];
    }
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}
//Create Header view
-(void)createHeaderView{
    
    UIButton *refreshSurveyButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.navigationController.navigationBar.frame.size.width * 0.12, self.navigationController.navigationBar.frame.size.height)];
    [refreshSurveyButton setImage:[UIImage imageNamed:REFRESH_IMAGE_VALUE] forState:UIControlStateNormal];
    refreshSurveyButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [refreshSurveyButton addTarget:self action:@selector(refreshSurveyList) forControlEvents:UIControlEventTouchDown];

    
    UILabel *surveyTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.navigationController.navigationItem.titleView.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    surveyTitle.text = SURVEYS_VALUE;
    surveyTitle.textAlignment = NSTextAlignmentCenter;
    surveyTitle.textColor = [UIColor whiteColor];
    surveyTitle.font = [UIFont fontWithName:FONT_NAME size:23.0];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshSurveyButton];

    self.navigationItem.titleView = surveyTitle;
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    

}
//Create List of Survey Views
-(void)createListOfSurveyViews{
    
    for(int i=self.surveyIndex+1;i>=self.surveyIndex-1;i--)
    {
        SurveyView *surveyView;
        if(i==self.surveyIndex-1)
        {
            surveyView = [[SurveyView alloc] initWithFrame:CGRectMake(0.0, -(self.view.frame.size.height - 60), self.view.frame.size.width, self.view.frame.size.height - 60.0)];
        }
        else if(i==self.surveyIndex)
        {
            surveyView = [[SurveyView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.view.frame.size.width, self.view.frame.size.height - 60.0)];
        }
        else if(i==self.surveyIndex+1)
        {
            surveyView = [[SurveyView alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height), self.view.frame.size.width, self.view.frame.size.height - 60.0)];
        }
        surveyView.tag=SURVEY_TAG+i;
        surveyView.takeSurveyDelegate=self;
        [self.view addSubview:surveyView];
        
        [self.view sendSubviewToBack:surveyView];
        
        //Up and Down Swipe gestures to navagate from one mailbyte to other
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [surveyView addGestureRecognizer:swipeDown];
        
        
        UISwipeGestureRecognizer *swipeUP = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [swipeUP setDirection:UISwipeGestureRecognizerDirectionUp];
        [surveyView addGestureRecognizer:swipeUP];
        
        
        // Rendering Survey view
        Survey *surveyObj;
        if(i==self.surveyIndex-1 && self.surveyIndex!=0)
        {
            surveyObj = (Survey *)[self.surveyList objectAtIndex:self.surveyIndex-1];
        }
        if(i==self.surveyIndex)
        {
            surveyObj = (Survey *)[self.surveyList objectAtIndex:self.surveyIndex];
        }
        if(i==self.surveyIndex+1 && self.surveyIndex!=self.surveyList.count-1)
        {
            surveyObj = (Survey *)[self.surveyList objectAtIndex:self.surveyIndex+1];
        }
        
        if(surveyObj!=nil)
        {
            [surveyView renderViewSurveyTitle:surveyObj.surveyName withDescription:surveyObj.surveyDescription andPic:surveyObj.surveyImageUrl];
            
        }
        
    }
}
//Remove the views on refresh
-(void)removeAllSurveyViews
{
    for(int i=99;i<SURVEY_TAG + self.surveyList.count;i++)
    {
        UIView *removeView  = [self.view viewWithTag:i];
        if(removeView != nil)
        {
            [removeView removeFromSuperview];
        }
    }
}
//Add Bubble Nav
-(void)createBubbleNav{
    
    float navBubblesHeight;
    if(self.surveyList.count > 10)
        navBubblesHeight = BUBBLE_HEIGHT*10;
    else
        navBubblesHeight = BUBBLE_HEIGHT*self.surveyList.count;
    
    self.navBubble = [[NavBubblesView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-BUBBLE_HEIGHT, self.navigationController.navigationBar.frame.size.height + BUBBLE_HEIGHT, BUBBLE_HEIGHT, navBubblesHeight) andNumberOfBubbles:(int)self.surveyList.count andSelectedBubble:self.surveyIndex];
    
    
    self.navBubble.navBubbleDelegate = self;
    
    self.navBubble.center = CGPointMake(self.navBubble.center.x, self.view.frame.size.height/2.0);
    
    self.navBubble.contentSize = CGSizeMake(self.navBubble.frame.size.width, BUBBLE_HEIGHT*self.surveyList.count);
    
    [self.view addSubview:self.navBubble];
}

//Refresh Survey List
-(void)refreshSurveyList {
    
    NSArray *userArray = [User getAllUserAccounts];
    if(userArray.count > 0)
    {
        User *currentUser = (User *)userArray[0];
        if(currentUser.accessToken != nil)
        {
            self.fetchingLoadIndicator = [self getActivityIndictorWithMessage:@"Fetching Survey List" andFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:self.fetchingLoadIndicator];
            
            //Clear the view list
            [self removeAllSurveyViews];
            //Clear the navBubble
            if(self.navBubble != nil)
            {
                [self.navBubble deselectBubble:self.surveyIndex + BUBBLE_TAG];
            }
            
            CommandFetchSurveyList *fetchList = [[CommandFetchSurveyList alloc] initWithAccessToken:currentUser.accessToken CompletionBlock:^(id param){
                //Removing activity indicator
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                        self.surveyIndex = 0;
                    [self.fetchingLoadIndicator removeFromSuperview];
                    self.fetchingLoadIndicator = nil;
                    self.surveyList = [Survey getAllSurveys];
                    [self createListOfSurveyViews];
                    if(self.navBubble == nil)
                        [self createBubbleNav];
                    else
                        [self.navBubble selectBubble:self.surveyIndex + BUBBLE_TAG];
                });
                
                
            } errorBlock:^(id param){
                dispatch_async(dispatch_get_main_queue(), ^{
                [self switchToRefreshAccessTokenPage];
                });
                
            }];
            [[CommandQueue sharedCommandQueueInstance] addClassToCommandQueue:fetchList];

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
//Switch to RefreshAccess
-(void)switchToRefreshAccessTokenPage{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Access Token" message:@"Login again please" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyChangeMainViewController object:[RefreshViewController class]];
                                  }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}




//Take survey delegate
-(void)clickTakeSurveyButton{
    //Navigate to new view and come back
    [self.navigationController pushViewController:[[TakeSurveyViewController alloc] init] animated:YES];
}
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
//Gesture Handling
-(void)handleGesture:(UISwipeGestureRecognizer *)recogniser
{
    
    SurveyView *currentView=(SurveyView *)[recogniser view];
    SurveyView *nextView = (SurveyView *)[self.view viewWithTag:[currentView tag] +1];
    SurveyView *previousView = (SurveyView *)[self.view viewWithTag:[currentView tag]-1];
    
    
    // On swiping change the position(center) of the mailbyte view and change their tag
    if (recogniser.direction==UISwipeGestureRecognizerDirectionUp)
    {
        if(currentView.tag-SURVEY_TAG !=self.surveyList.count-1)
        {
            CGPoint nextViewCenter = nextView.center;
            [UIView animateWithDuration:ANIMATION_DUR
                                  delay:0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 nextView.center = currentView.center;
                                 currentView.center = previousView.center;
                                 
                             }
                             completion:^(BOOL finished){
                                 previousView.tag = nextView.tag+1;
                                 previousView.center = nextViewCenter;
                                 
                                 //Update navBubble
                                 [self.navBubble deselectBubble:self.surveyIndex + BUBBLE_TAG];
                                 self.surveyIndex = (int)nextView.tag - SURVEY_TAG;
                                 [self.navBubble selectBubble:self.surveyIndex + BUBBLE_TAG];
                                 
                                 if(previousView.tag-SURVEY_TAG!=self.surveyList.count)
                                 {
                                     
                                     Survey *survey = (Survey *)[self.surveyList objectAtIndex:previousView.tag-SURVEY_TAG];
                                     [previousView renderViewSurveyTitle:survey.surveyName withDescription:survey.surveyDescription andPic:survey.surveyImageUrl];
                                     
                                     
                                     
                                     
                                 }
                             }
             ];
        }
    }
    else if (recogniser.direction==UISwipeGestureRecognizerDirectionDown )
    {
        if(currentView.tag!=SURVEY_TAG)
        {
            CGPoint previousViewCenter = previousView.center;
            [UIView animateWithDuration:ANIMATION_DUR
                                  delay:0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 previousView.center = currentView.center;
                                 currentView.center=nextView.center;
                                 
                             }
                             completion:^(BOOL finished){
                                 
                                 nextView.tag=previousView.tag-1;
                                 nextView.center=previousViewCenter;
                                 
                                 //Update navBubble
                                 [self.navBubble deselectBubble:self.surveyIndex + BUBBLE_TAG];
                                 self.surveyIndex = (int)previousView.tag - SURVEY_TAG;
                                 [self.navBubble selectBubble:self.surveyIndex + BUBBLE_TAG];
                                 
                                 if(nextView.tag>=SURVEY_TAG)
                                 {
                                     Survey *survey = (Survey *)[self.surveyList objectAtIndex:nextView.tag-SURVEY_TAG];
                                     [nextView renderViewSurveyTitle:survey.surveyName withDescription:survey.surveyDescription andPic:survey.surveyImageUrl];
                                     
                                     
                                 }
                                 
                             }
             ];
        }
        
        
    }
}
//Change Bubble Select and Deselect and change Survey
-(void)bubbleTapped:(int)tappedBubbleTag
{
    [self.navBubble deselectBubble:self.surveyIndex + BUBBLE_TAG];
 
    self.surveyIndex = tappedBubbleTag - BUBBLE_TAG;
 
    [self.navBubble selectBubble:tappedBubbleTag];
 
    [self removeAllSurveyViews];
    
    [self createListOfSurveyViews];
}
@end
