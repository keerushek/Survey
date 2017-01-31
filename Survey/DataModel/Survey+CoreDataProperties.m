//
//  Survey+CoreDataProperties.m
//  Survey
//
//  Created by Keerthi Shekar G on 31/01/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Survey+CoreDataProperties.h"

@implementation Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Survey"];
}

@dynamic surveyDescription;
@dynamic surveyImageUrl;
@dynamic surveyName;

@end
