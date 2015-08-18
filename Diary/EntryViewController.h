//
//  NewEntryViewController.h
//  Diary
//
//  Created by Alex Valladares on 14/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry;

@interface EntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)doneWhenPressed:(id)sender;
- (IBAction)cancelWhenPressed:(id)sender;
- (void) dismissSelf;


@property (strong, nonatomic) DiaryEntry *entry;

@end
