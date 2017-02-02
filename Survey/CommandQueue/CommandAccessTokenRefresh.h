//
//  CommandAccessTokenRefresh.h
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommandBase.h"

@interface CommandAccessTokenRefresh : CommandBase
-(id)initWithData:(NSDictionary *)loginDictionary andloginType:(NSString *)loginType;
-(id)initWithData:(NSDictionary *)loginDictionary andloginType:(NSString *)loginType CompletionBlock:(CompletionBlockParam)completeBlock errorBlock:(ErrorBlockParam)errorBlock;
@end
