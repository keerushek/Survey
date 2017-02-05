//
//  RefreshViewController.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "RefreshViewController.h"
#import "CommandAccessTokenRefresh.h"
#import "SurveyViewController.h"

#define BG_IMAGE    @"background"

#define EMAIL_ADDRESS_VALUE     @"Email Id"
#define PASSWORD_VALUE          @"Password"
#define REFRESH_LOGIN_USERNAME  @"username"
#define REFRESH_LOGIN_PASSWORD  @"password"
#define REFRESH_ACCESS_TOKEN    @"Refresh Access Token"

@interface RefreshViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *emailIdLabel,*passwordLabel;
@property (nonatomic, strong) UITextField *emailIdTF,*passwordTF;
@property (nonatomic, strong) UIView *loginView, *fetchingLoadIndicator;
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation RefreshViewController

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
    self.navigationController.navigationBarHidden = YES;
}
-(void)loadView{
    [super loadView];
    
    //Background Image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_IMAGE]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    
    self.loginView = [[UIView alloc] init];
    self.loginView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    [self.view addSubview:self.loginView];
    
    self.emailIdLabel = [[UILabel alloc] init];
    self.emailIdLabel.text = EMAIL_ADDRESS_VALUE;
    self.emailIdLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
    self.emailIdLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginView addSubview:self.emailIdLabel];
    
    self.emailIdTF = [[UITextField alloc] init];
    self.emailIdTF.placeholder = EMAIL_ADDRESS_VALUE;
    [self.loginView addSubview:self.emailIdTF];
    
    self.passwordLabel = [[UILabel alloc] init];
    self.passwordLabel.text = PASSWORD_VALUE;
    self.passwordLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
    self.passwordLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginView addSubview:self.passwordLabel];
    
    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.placeholder = PASSWORD_VALUE;
    self.passwordTF.secureTextEntry = YES;
    [self.loginView addSubview:self.passwordTF];
    
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:REFRESH_ACCESS_TOKEN forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font =[UIFont fontWithName:FONT_NAME size:18.0];
    self.loginButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    [self.loginButton addTarget:self action:@selector(refreshAccessToken) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.loginButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    
    self.loginView.frame = CGRectMake(0.0, self.view.frame.size.height * 0.2, self.view.frame.size.width, self.view.frame.size.height/8.0);
    
    self.emailIdLabel.frame = CGRectMake(0.0, 0.0, self.loginView.frame.size.width/2.5, self.loginView.frame.size.height/2.0);
    
    self.passwordLabel.frame = CGRectMake(0.0, self.emailIdLabel.frame.origin.y + self.emailIdLabel.frame.size.height, self.loginView.frame.size.width/2.5, self.loginView.frame.size.height/2.0);
    
    self.emailIdTF.frame = CGRectMake(self.emailIdLabel.frame.origin.x + self.emailIdLabel.frame.size.width,self.emailIdLabel.frame.origin.y, self.loginView.frame.size.width - self.emailIdLabel.frame.size.width, self.emailIdLabel.frame.size.height);
    
    self.passwordTF.frame = CGRectMake(self.passwordLabel.frame.origin.x + self.passwordLabel.frame.size.width,self.passwordLabel.frame.origin.y, self.loginView.frame.size.width - self.passwordLabel.frame.size.width, self.passwordLabel.frame.size.height);
    
    self.loginButton.frame = CGRectMake(0.0, self.loginView.frame.origin.y + self.loginView.frame.size.height + self.view.frame.size.height/10.0, self.view.frame.size.width/2.0, self.view.frame.size.height/10.0);
    
    self.loginButton.center = CGPointMake(self.view.frame.size.width/2.0, self.loginButton.center.y);
}
//Call to refresh Access Token and Navigate to survey page
-(void)refreshAccessToken{
    
    NSDictionary *refreshDict = @{REFRESH_LOGIN_USERNAME:self.emailIdTF.text,REFRESH_LOGIN_PASSWORD:self.passwordTF.text};
    
    
    
    //EMail Validation
    if(![self IsValidEmail:self.emailIdTF.text])
    {
        [self addAlertViewWithTitle:@"Invalid emailId" message:@"Provide correct EmailId" cancelButtonTitle:@""];
    }
    else if([self.passwordTF.text length] == 0)
    {
        [self addAlertViewWithTitle:@"Please enter password" message:@"Provide correct password" cancelButtonTitle:@""];
    }
    else
    {
        self.fetchingLoadIndicator = [self getActivityIndictorWithMessage:@"Refreshing Access Token" andFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.fetchingLoadIndicator];
        
        __block CFRunLoopRef currentThreadref = CFRunLoopGetCurrent();
        CFRunLoopPerformBlock(currentThreadref, kCFRunLoopCommonModes, ^{
            CommandAccessTokenRefresh *refresh = [[CommandAccessTokenRefresh alloc] initWithData:refreshDict andloginType:REFRESH_LOGIN_PASSWORD CompletionBlock:^(id completeParam){
                
                //Removing activity indicator
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.fetchingLoadIndicator removeFromSuperview];
                    self.fetchingLoadIndicator = nil;
                    //Navigate to survey page
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyChangeMainViewController object:[SurveyViewController class]];
                });
                CFRunLoopStop(currentThreadref);
            } errorBlock:^(id param){
                
                //Showing Error Message
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.fetchingLoadIndicator removeFromSuperview];
                    self.fetchingLoadIndicator = nil;
                    
                    self.emailIdTF.text = @"";
                    self.passwordTF.text = @"";
                    [self addAlertViewWithTitle:@"Invalid emailId/password" message:@"Retry with correct combination" cancelButtonTitle:@""];
                });
                CFRunLoopStop(currentThreadref);
            }];
            [[CommandQueue sharedCommandQueueInstance] addClassToCommandQueue:refresh];
        });
        CFRunLoopWakeUp(currentThreadref);
        CFRunLoopRun();

    }
    
    
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
//Method to show Alert view
-(void)addAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    if([cancelButtonTitle length]>0)
    {
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancel];
    }
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//Email Validation
-(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
