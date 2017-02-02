//
//  CommandQueue.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommandQueue.h"

static CommandQueue *sharedCommandQueue = nil;

@interface CommandQueue()
@property (nonatomic, strong) NSTimer *loadCommandsTimer;
@end

@implementation CommandQueue

{
    NSString *_commandPath;
}

+ (instancetype)sharedCommandQueueInstance
{
    if (sharedCommandQueue == nil)
        sharedCommandQueue = [[CommandQueue alloc] init];
    
    return sharedCommandQueue;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _commandPath = nil;
        self.name = @"com.survey.commandqueue";
        self.maxConcurrentOperationCount = COMMANDQUEUE_MAX_OPERATIONS;
        [self registerForNotificaitons];
        if ([AFNetworkReachabilityManager sharedManager].reachable)
        {
            //Timer to add archived operations that arent present in the CommandQueue
            self.loadCommandsTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                                      target:self
                                                                    selector:@selector(loadStoredCommands)
                                                                    userInfo:nil
                                                                     repeats:YES];
            
            [self loadStoredCommands];
        }
    }
    return self;
}
- (void)dealloc
{
    [self unregisterForNotifications];
}
//Load Operations into the NSOperationQueue in CommandQueue
- (void)loadStoredCommands
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        return;
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self commandPath]];
    NSString *commandPath;
    
    //enumerating through each of the .archive files and loading those commands into the NSOperationQueue
    while ((commandPath = [enumerator nextObject]))
    {
        NSString *fileName = [[self commandPath] stringByAppendingPathComponent:commandPath];
        
        //If the command is already loaded in the NSOperationQueue then skip it
        BOOL duplicateCommand = NO;
        for(CommandBase *op in self.operations)
        {
            if([op.commandPath isEqualToString:fileName])
            {
                duplicateCommand = YES;
                break;
            }
        }
        if(duplicateCommand)
            continue;
        
        //Converting each of the commands into their base class i.e. CommandBase
        CommandBase *command = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        if (command != nil)
        {
            
            [self setOperationPriority:command];
            command.commandPath = fileName;
            [self addOperation:command];
        }
        else
        {
            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
        }
    }
}

//Setting the priority of the commandQueue Operation
-(void)setOperationPriority:(CommandBase *)operation
{
    if(operation.commandPriority == COMMANDQUEUE_PRIORITY_HIGH)
    {
        operation.queuePriority = NSOperationQueuePriorityHigh;
    }
    else if(operation.commandPriority == COMMANDQUEUE_PRIORITY_LOW)
    {
        operation.queuePriority = NSOperationQueuePriorityLow;
    }
}

- (NSString *)commandPath
{
    if (_commandPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"commandQueue"];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        }
        _commandPath = path;
    }
    return _commandPath;
}

//Method to add operation to command queue
- (BOOL)addClassToCommandQueue:(CommandBase *)classToAdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:COMMAND_QUEUE_FILE_DATE_FORMATTER];
    
    NSString *filename = [NSString stringWithFormat:@"%@%@%@",[dateFormatter stringFromDate:classToAdd.commandDate], NSStringFromClass([classToAdd class]), COMMAND_FILE_EXTENSION];
    NSString *archiveToPath = [[self commandPath] stringByAppendingPathComponent:filename];
    
    BOOL bReturn = [NSKeyedArchiver archiveRootObject:classToAdd toFile:archiveToPath];
    [self setOperationPriority:classToAdd];
    if (bReturn)
    {
        classToAdd.commandPath = archiveToPath;
        [self addOperation:classToAdd];
    }
    return bReturn;
}

//Method to remove operation from command queue
- (void)removeClassFromCommandQueue:(CommandBase *)classToRemove
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:COMMAND_QUEUE_FILE_DATE_FORMATTER];
    
    NSString *filename = [NSString stringWithFormat:@"%@%@%@",[dateFormatter stringFromDate:classToRemove.commandDate], NSStringFromClass([classToRemove class]), COMMAND_FILE_EXTENSION];
    NSString *archivePath = [[self commandPath] stringByAppendingPathComponent:filename];
    BOOL directory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath isDirectory:&directory])
    {
        [[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
    }
    [classToRemove cancel];
}
#pragma mark - Notifications
- (void)registerForNotificaitons
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkConnectionChanged:) name:kNotifyNetworkAvailabilityChanged object:nil];
}
- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//Invalidate the timer when there is no Network
- (void)networkConnectionChanged:(NSNotification *)notification
{
    if ([AFNetworkReachabilityManager sharedManager].reachable)
    {
        if(self.loadCommandsTimer == nil)
        {
            //Timer to add archived operations that arent present in the CommandQueue
            self.loadCommandsTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                                      target:self
                                                                    selector:@selector(loadStoredCommands)
                                                                    userInfo:nil
                                                                     repeats:YES];
            
            [self loadStoredCommands];
        }
    }
    else
    {
        if(self.loadCommandsTimer != nil)
            [self.loadCommandsTimer invalidate];
        self.loadCommandsTimer = nil;
        [self cancelAllOperations];
    }
}
@end
