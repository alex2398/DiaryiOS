//
//  EntryListTableViewController.m
//  Diary
//
//  Created by Alex Valladares on 18/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "EntryListTableViewController.h"
#import "CoreDataStack.h"
#import "DiaryEntry.h"
#import "EntryViewController.h"
#import "EntryCell.h"


@interface EntryListTableViewController () <NSFetchedResultsControllerDelegate>

// Creamos una propiedad privada para ejecutar el fetchRequest
// NOTA: Para declarar propiedades privadas, lo hacemos en el archivo de implementación

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation EntryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Ejecutamos la consulta para devolver los resultados
    [self.fetchedResultsController performFetch:nil];
    

}

// Creamos un método para devolver los resultados de la entry

- (NSFetchRequest*) entryListFetchRequest {
    // Devolvemos los datos de la entry en un objeto NSFetchRequest
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DiaryEntry"];
    // Ordenamos los resultados por fecha usando un NSSortDescriptor
    // Se requiere al menos un sortDescriptor o un predicate en un fetchRequest
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;

}

- (NSFetchedResultsController*) fetchedResultsController {
    // Si existe lo devolvemos, si no, creamos uno nuevo
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
        
    } else {
        // Primero accedemos al coreData
        CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
        // Segundo instanciamos el fetchRequest
        NSFetchRequest *fetchRequest = [self entryListFetchRequest];
        // Creamos el ResultController
        _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
        _fetchedResultsController.delegate = self;
        return _fetchedResultsController;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.fetchedResultsController.sections.count;
}

// Con este método establecemos el título para la sección
- (NSString *) tableView:(UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
    
}

// Establecemos el alto de cada celda
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [EntryCell heightForEntry:entry];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    // Tenemos que hacerlo así para devolver el numero de registros
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    
    // Configure the cell...
    DiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellForEntry:entry];
    
    return cell;
}

// Borrar una entrada deslizando (swipe) requiere dos métodos:

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiaryEntry *entry = [self.fetchedResultsController indexPathForObject:indexPath];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    [coreDataStack.managedObjectContext deleteObject:entry];
    [coreDataStack saveContext];
    
    
    
    
}

#pragma mark - Actualizacion controlador con animaciones

// Actualizamos la tabla cuando el content cambia, con animaciones.
// Hay que implementar todos los siguiente métodos
// (sin animaciones sería solo [self.tableView reloadData] en DidChangeContent);

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

// Este método se llama cuando un elemento es insertado, borrado o movido
- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
}

// Igual pero para las secciones (si borramos un último elemento de una seccion también hay que borrar la sección
// e igual si añadimos un nuevo elemento

- (void) controller:(NSFetchedResultsController *) controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

    }
}
- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"edit"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        EntryViewController *entryViewController = (EntryViewController *) navigationController.topViewController;
        entryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        

    }
}




    @end