//
//  Survey+CoreDataClass.h
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Survey : CommonManagedObject

+ (Survey *)getSurveyWithId:(NSString *)surveyId;
+ (Survey *)getSurveyWithId:(NSString *)surveyId withManagedObjectContext:(NSManagedObjectContext *)moc;

+ (NSArray *)getAllSurveys;
+ (NSArray *)getAllSurveysWithManagedObjectContext:(NSManagedObjectContext *)moc;

@end

NS_ASSUME_NONNULL_END

#import "Survey+CoreDataProperties.h"
