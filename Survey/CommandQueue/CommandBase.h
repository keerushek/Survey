//
//  CommandBase.h
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandBase : NSOperation<NSCoding>
/**Date when the derived class was created so that it used as its identifier */
@property (nonatomic, strong) NSDate *commandDate;

/**Path where the class is saved in file */
@property (nonatomic, strong) NSString *commandPath;

/**LOW-MED-HIGH priority for execution */
@property (nonatomic) int commandPriority;

/**Used only for Unit Test Case */
@property (nonatomic,strong) CompletionBlockParam completeBlock;

/**Used only for Unit Test Case */
@property (nonatomic,strong) ErrorBlockParam errorBlock;

/**Method where the derived class is removed from the file*/
-(void)cleanup;

/**Returning Error Block*/
-(void)errorBlockCheck:(NSError *)error;

/**Maximum command queue operation retry count */
@property (nonatomic) int commandQueueRetryCount;

/**Update command queue retry count */
- (int)decrementRetryCountInFileWithPath:(NSString*)path;
@end
