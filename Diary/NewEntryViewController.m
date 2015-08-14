//
//  NewEntryViewController.m
//  Diary
//
//  Created by Alex Valladares on 14/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "NewEntryViewController.h"
#import "CoreDataStack.h"
#import "DiaryEntry.h"

@interface NewEntryViewController ()

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneWhenPressed:(id)sender {
    [self insertDiaryEntry];
    [self dismissSelf];
}

- (IBAction)cancelWhenPressed:(id)sender {
    [self dismissSelf];
}

- (void) dismissSelf {
    // Esto cierra la vista
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) insertDiaryEntry {
    // Obtenemos acceso al coreData
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    // Creamos la nueva entrada con el nombre de la Entity (tabla) en este caso DiaryEntry
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    // Configuramos la entrada
    entry.body = self.textField.text;
    // Hora actual en segundos desde 1970
    entry.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
    
    
    
    
}
@end
