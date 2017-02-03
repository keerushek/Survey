//
//  CommandFetchSurveyList.h
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommandBase.h"

@interface CommandFetchSurveyList : CommandBase
-(id)initWithAccessToken:(NSString *)accessToken;
-(id)initWithAccessToken:(NSString *)accessToken CompletionBlock:(CompletionBlockParam)completeBlock errorBlock:(ErrorBlockParam)errorBlock;
@end
