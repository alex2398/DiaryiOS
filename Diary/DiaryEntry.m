//
//  DiaryEntry.m
//  Diary
//
//  Created by Alex Valladares on 14/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "DiaryEntry.h"


@implementation DiaryEntry

@dynamic date;
@dynamic body;
@dynamic image;
@dynamic mood;
@dynamic location;

// Guardamos la fecha actual en el campo SectionName
- (NSString*) sectionName {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM yyy"];
    
    return [formatter stringFromDate:date];
    
}
@end
