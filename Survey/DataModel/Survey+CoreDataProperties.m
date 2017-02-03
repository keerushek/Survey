//
//  Survey+CoreDataProperties.m
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "Survey+CoreDataProperties.h"

@implementation Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Survey"];
}

@dynamic surveyDescription;
@dynamic surveyImageUrl;
@dynamic surveyName;
@dynamic surveyId;

@end
