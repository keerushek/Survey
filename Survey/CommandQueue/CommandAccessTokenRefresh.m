//
//  CommandAccessTokenRefresh.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommandAccessTokenRefresh.h"
#import "User+CoreDataClass.h"
#define COMMAND_LOGIN_DATA      @"LOGINDATA"
#define COMMAND_LOGIN_TYPE      @"LOGINTYPE"
#define REFRESH_GRANT_TYPE      @"grant_type"
#define REFRESH_LOGIN_USERNAME  @"username"
#define REFRESH_LOGIN_PASSWORD  @"password"
#define URL_OAUTH_TOKEN         @"oauth/token"

@interface CommandAccessTokenRefresh()

@property (nonatomic, strong) NSDictionary *loginDictionary, *responseDictionary;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;
@property (nonatomic, strong) NSString *loginType;

@end

@implementation CommandAccessTokenRefresh
-(id)initWithData:(NSDictionary *)loginDictionary andloginType:(NSString *)loginType{
    self = [super init];
    if (self) {
        self.loginDictionary = loginDictionary;
        self.loginType = loginType;
    }
    return self;
}
-(id)initWithData:(NSDictionary *)loginDictionary andloginType:(NSString *)loginType CompletionBlock:(CompletionBlockParam)completeBlock errorBlock:(ErrorBlockParam)errorBlock
{
    self = [super init];
    if (self) {
        self.loginDictionary = loginDictionary;
        self.loginType = loginType;
        self.completeBlock = completeBlock;
        self.errorBlock = errorBlock;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.loginDictionary = [aDecoder decodeObjectForKey:COMMAND_LOGIN_DATA];
        self.loginType = [aDecoder decodeObjectForKey:COMMAND_LOGIN_TYPE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.loginDictionary forKey:COMMAND_LOGIN_DATA];
    [aCoder encodeObject:self.loginType forKey:COMMAND_LOGIN_TYPE];
}
-(void)main
{
    
    NSError *errorParam = [self userLogin];
    if (errorParam == nil)
    {
        [self saveUserDetailsToCoreData];
        if(self.commandPath!=nil)
        {
            [self cleanup];
        }
        if (self.completeBlock != nil) {
            self.completeBlock(self.responseDictionary);
        }
    } else {
        [self errorBlockCheck:errorParam];
        
        if(self.commandPath!=nil)
        {
            [self cleanup];
        }
        
    }
    
}
-(NSError *)userLogin
{
    __block NSError *responseError = nil;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",SERVER_URL_ENDPOINT,URL_OAUTH_TOKEN];
    NSDictionary *parameters = @{REFRESH_GRANT_TYPE:self.loginType, REFRESH_LOGIN_USERNAME: [self.loginDictionary objectForKey:REFRESH_LOGIN_USERNAME], REFRESH_LOGIN_PASSWORD:[self.loginDictionary objectForKey:REFRESH_LOGIN_PASSWORD]};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    __block CFRunLoopRef currentThreadref = CFRunLoopGetCurrent();
    CFRunLoopPerformBlock(currentThreadref, kCFRunLoopCommonModes, ^{
        [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([responseObject objectForKey:@"access_token"] != nil)
            {
                NSLog(@"success!---%@",responseObject);
                self.responseDictionary = [[NSDictionary alloc] initWithDictionary:responseObject];
            }
            else
            {
                //Not expected response
                responseError = [NSError errorWithDomain:NSURLErrorDomain code:[[NSNumber numberWithInt:404] integerValue] userInfo:@{@"error":@"Unable to refresh"}];
            }
            CFRunLoopStop(currentThreadref);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
            responseError = error;
            CFRunLoopStop(currentThreadref);
        }];
    });
    CFRunLoopWakeUp(currentThreadref);
    CFRunLoopRun();
    
    return  responseError;
}
-(void)saveUserDetailsToCoreData
{
    
}
@end
