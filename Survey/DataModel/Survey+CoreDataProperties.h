//
//  Survey+CoreDataProperties.h
//  Survey
//
//  Created by Keerthi Shekar G on 31/01/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Survey+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *surveyDescription;
@property (nullable, nonatomic, copy) NSString *surveyImageUrl;
@property (nullable, nonatomic, copy) NSString *surveyName;

@end

NS_ASSUME_NONNULL_END
