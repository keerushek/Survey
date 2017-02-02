//
//  AppCommon.h
//  Survey
//
//  Created by Keerthi Shekar G on 31/01/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#ifndef AppCommon_h
#define AppCommon_h

#define SERVER_URL_ENDPOINT             @"https://nimbl3-survey-api.herokuapp.com/"

//Notification Identifiers
#define kNotifyChangeMainViewController                     @"NotifyChangeMainViewController"

#define kNotifyNetworkAvailabilityChanged                   @"NotifyNetworkAvailabilityChanged"


//CommandQueuePriorities
#define COMMANDQUEUE_PRIORITY_LOW       0
#define COMMANDQUEUE_PRIORITY_MED       1
#define COMMANDQUEUE_PRIORITY_HIGH      2
#define COMMAND_QUEUE_FILE_DATE_FORMATTER                  @"yyyy-MM-dd_HH_mm_ss_SSS"
#define COMMAND_FILE_EXTENSION          @".archive"
#define COMMANDQUEUE_MAX_OPERATIONS     10
#define COMMANDQUEUE_RETRY_COUNT        2

// Typedefs
typedef void (^CompletionBlockNoParams)();
typedef void (^CompletionBlockParam)(id param);
typedef void (^ErrorBlockParam)(id param);

#endif /* AppCommon_h */
