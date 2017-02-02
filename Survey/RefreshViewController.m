//
//  RefreshViewController.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "RefreshViewController.h"

#define FONT_NAME     @"HelveticaNeue-Light"
#define BG_IMAGE    @"background"

#define EMAIL_ADDRESS_VALUE     @"Email Id"
#define PASSWORD_VALUE          @"Password"

@interface RefreshViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *emailIdLabel,*passwordLabel;
@property (nonatomic, strong) UITextField *emailIdTF,*passwordTF;
@property (nonatomic, strong) UIView *loginView;
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
    [self.loginButton setTitle:@"Refresh Access Token" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [self.loginButton addTarget:self action:@selector(refreshAccessToken) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.loginButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    
    self.loginView.frame = CGRectMake(0.0, self.view.frame.size.height * 0.4, self.view.frame.size.width, self.view.frame.size.height/8.0);
    
    self.emailIdLabel.frame = CGRectMake(0.0, 0.0, self.loginView.frame.size.width/2.5, self.loginView.frame.size.height/2.0);
    
    self.passwordLabel.frame = CGRectMake(0.0, self.emailIdLabel.frame.origin.y + self.emailIdLabel.frame.size.height, self.loginView.frame.size.width/2.5, self.loginView.frame.size.height/2.0);
    
    self.emailIdTF.frame = CGRectMake(self.emailIdLabel.frame.origin.x + self.emailIdLabel.frame.size.width,self.emailIdLabel.frame.origin.y, self.loginView.frame.size.width - self.emailIdLabel.frame.size.width, self.emailIdLabel.frame.size.height);
    
    self.passwordTF.frame = CGRectMake(self.passwordLabel.frame.origin.x + self.passwordLabel.frame.size.width,self.passwordLabel.frame.origin.y, self.loginView.frame.size.width - self.passwordLabel.frame.size.width, self.passwordLabel.frame.size.height);
    
    self.loginButton.frame = CGRectMake(0.0, self.loginView.frame.origin.y + self.loginView.frame.size.height + self.view.frame.size.height/10.0, self.view.frame.size.width/2.0, self.view.frame.size.height/10.0);
    
    self.loginButton.center = CGPointMake(self.view.frame.size.width/2.0, self.loginButton.center.y);
}
-(void)refreshAccessToken{
    NSLog(@"Refres");
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
