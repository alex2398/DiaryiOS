//
//  NewEntryViewController.m
//  Diary
//
//  Created by Alex Valladares on 14/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "EntryViewController.h"
#import "CoreDataStack.h"
#import "DiaryEntry.h"
#import "EntryCell.h"
#import "EntryListTableViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.entry != nil) {
        self.textField.text = self.entry.body;
    }
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
    // Al pulsar en done, si la entrada ya existe, la actualizamos
    // Si no, la creamos nueva
    if (self.entry != nil) {
        [self updateDiaryEntry];
    } else {
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}

- (IBAction)cancelWhenPressed:(id)sender {
    [self dismissSelf];
}

- (void) dismissSelf {
    // Esto cierra la vista
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Insertar entrada
- (void) insertDiaryEntry {
    // Obtenemos acceso al coreData
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    // Creamos la nueva entrada con el nombre de la Entity (tabla) en este caso DiaryEntry
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    // Configuramos la entrada
    entry.body = self.textField.text;
    // Hora actual en segundos desde 1970
    entry.date = [[NSDate date] timeIntervalSince1970];
    // Salvamos los datos
    [coreDataStack saveContext];
    
}

// Actualizar entrada
- (void) updateDiaryEntry {
    self.entry.body = self.textField.text;
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
    
}
@end
