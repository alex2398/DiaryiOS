//
//  EntryCell.h
//  Diary
//
//  Created by Alex Valladares on 18/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiaryEntry;
@interface EntryCell : UITableViewCell




+ (CGFloat) heightForEntry:(DiaryEntry*) entry;

- (void) configureCellForEntry:(DiaryEntry*) entry;



@end
