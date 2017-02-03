//
//  CommandFetchSurveyList.m
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommandFetchSurveyList.h"
#import "Survey+CoreDataClass.h"

#define ACCESS_TOKEN_KEY        @"ACCESS_TOKEN_KEY"
#define SURVEY_URL              @"surveys.json"
#define SURVEY_ID_KEY           @"id"
#define SURVEY_TITLE_KEY        @"title"
#define SURVEY_DESCRIPTION_KEY  @"description"
#define SURVEY_IMAGE_KEY        @"cover_image_url"



@interface CommandFetchSurveyList()
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSArray *responseArray;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;
@end

@implementation CommandFetchSurveyList
-(id)initWithAccessToken:(NSString *)accessToken
{
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
    }
    return self;
}
-(id)initWithAccessToken:(NSString *)accessToken CompletionBlock:(CompletionBlockParam)completeBlock errorBlock:(ErrorBlockParam)errorBlock
{
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
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
        self.accessToken = [aDecoder decodeObjectForKey:ACCESS_TOKEN_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.accessToken forKey:ACCESS_TOKEN_KEY];
}
-(void)main
{
    
    NSError *errorParam = [self fetchSurveyList];
    if (errorParam == nil)
    {
        [self saveSurveyDataToCoreData];
        if(self.commandPath!=nil)
        {
            [self cleanup];
        }
        if (self.completeBlock != nil) {
            self.completeBlock(nil);
        }
    } else {
        [self errorBlockCheck:errorParam];
        
        if(self.commandPath!=nil)
        {
            [self cleanup];
        }
        
    }
    
}

-(NSError *)fetchSurveyList
{
    __block NSError *responseError = nil;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",SERVER_URL_ENDPOINT,SURVEY_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.accessToken] forHTTPHeaderField:@"Authorization"];
    
    
    __block CFRunLoopRef currentThreadref = CFRunLoopGetCurrent();
    CFRunLoopPerformBlock(currentThreadref, kCFRunLoopCommonModes, ^{
        [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            self.responseArray = [[NSArray alloc] initWithArray:(NSArray *)responseObject];
            CFRunLoopStop(currentThreadref);
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
            NSLog(@"%@",error);
            responseError = error;
            CFRunLoopStop(currentThreadref);
        }];
    });
    CFRunLoopWakeUp(currentThreadref);
    CFRunLoopRun();
    
    return  responseError;
    
}
-(void)saveSurveyDataToCoreData
{
    self.privateContext = [Survey privateContext];
    
    for(NSDictionary *surveyDict in self.responseArray)
    {
        if(surveyDict != nil)
        {
            Survey *surveyObj = [Survey getSurveyWithId:[surveyDict objectForKey:SURVEY_ID_KEY] withManagedObjectContext:self.privateContext];
            if(surveyObj == nil)
            {
                surveyObj = [Survey addNewInContext:self.privateContext];
                
            }
            
            surveyObj.surveyId = [surveyDict objectForKey:SURVEY_ID_KEY];
            
            surveyObj.surveyName = [surveyDict objectForKey:SURVEY_TITLE_KEY];
            
            surveyObj.surveyDescription = [surveyDict objectForKey:SURVEY_DESCRIPTION_KEY];
            
            surveyObj.surveyImageUrl = [surveyDict objectForKey:SURVEY_IMAGE_KEY];
            
            if([Survey saveInContext:self.privateContext])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Survey save];
                });
            }
            
        }
    }
    
}
@end
