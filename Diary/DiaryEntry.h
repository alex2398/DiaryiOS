//
//  DiaryEntry.h
//  Diary
//
//  Created by Alex Valladares on 14/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// Propiedad para el humor
// Un NS_ENUM son una serie de constantes que asignamos a un nombre
// en este caso del tipo int16. De este modo se pueden usar en el código
// en lugar de números directamente

NS_ENUM(int16_t, DiaryEntryMood) {
    DiaryEntryMoodGood = 0,
    DiaryEntryMoodAverage = 1,
    DiaryEntryMoodBad = 2
};

@interface DiaryEntry : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * image;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@property (nonatomic, readonly) NSString * sectionName;

@end
