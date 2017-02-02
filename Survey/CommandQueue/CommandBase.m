//
//  CommandBase.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommandBase.h"

#define COMMAND_DATE            @"commandDate"
#define COMMAND_PRIORITY        @"commandPriority"
#define COMMAND_RETRY_COUNT     @"commandRetryCount"

@implementation CommandBase

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _commandDate = [aDecoder decodeObjectForKey:COMMAND_DATE];
        _commandPriority = [((NSNumber *)[aDecoder decodeObjectForKey:COMMAND_PRIORITY]) intValue] ;
        _commandQueueRetryCount = [aDecoder decodeIntForKey:COMMAND_RETRY_COUNT];
        _commandPath = nil;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _commandDate = [NSDate date];
        _commandPriority = COMMANDQUEUE_PRIORITY_MED;
        _commandQueueRetryCount = COMMANDQUEUE_RETRY_COUNT;
        _commandPath = nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_commandDate forKey:COMMAND_DATE];
    [aCoder encodeObject:[NSNumber numberWithInt:_commandPriority] forKey:COMMAND_PRIORITY];
    [aCoder encodeInt:_commandQueueRetryCount forKey:COMMAND_RETRY_COUNT];
}

- (void)cleanup
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.commandPath error:&error];
    if (error != nil) {
        NSLog(@"Error = %@",error.description);
    }
}
//Check if errorBlock needs to executed or errormessage to be shown
-(void)errorBlockCheck:(NSError *)error
{
    if(self.errorBlock != nil)
    {
        self.errorBlock(error);
    }
}

//Method to update the commandQueue retry count
- (int)decrementRetryCountInFileWithPath:(NSString*)path
{
    CommandBase *data= [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    int count = data.commandQueueRetryCount -1;
    data.commandQueueRetryCount= count;
    [NSKeyedArchiver archiveRootObject:data toFile:self.commandPath];
    return count;
}
@end
