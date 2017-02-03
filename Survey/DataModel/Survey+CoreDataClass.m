//
//  Survey+CoreDataClass.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Survey+CoreDataClass.h"

@implementation Survey

+ (NSString *)modelName
{
    return @"Survey";
}

+ (Survey *)getSurveyWithId:(NSString *)surveyId
{
    return [self getSurveyWithId:surveyId withManagedObjectContext:[self context]];
}
+ (Survey *)getSurveyWithId:(NSString *)surveyId withManagedObjectContext:(NSManagedObjectContext *)moc
{
    if((surveyId == nil) || (moc == nil))
        return  nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(surveyId == %@)", surveyId];
    
    return (Survey *)[self fetchManagedObjectWithPredicate:predicate withSortDescriptors:nil andContext:moc includePropertyValues:YES];
}

+ (NSArray *)getAllSurveys
{
    return [self getAllSurveysWithManagedObjectContext:[self context]];
}
+ (NSArray *)getAllSurveysWithManagedObjectContext:(NSManagedObjectContext *)moc
{
    //Looking for all care cases.
    if(moc == nil)
        return  nil;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"surveyId" ascending:NO];
    
    NSArray *fetchResults = [self fetchManagedObjectsWithPredicate:nil withSortDescriptors:@[sort] andContext:moc includePropertyValues:YES];
    if (fetchResults.count > 0) {
        return fetchResults;
    }
    return [NSArray array];
    
}
@end
