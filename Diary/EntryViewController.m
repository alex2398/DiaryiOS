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
#import <CoreLocation/CoreLocation.h>

@interface EntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (assign, nonatomic) enum DiaryEntryMood *pickedMood;
@property (strong, nonatomic) UIImage *pickedImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *location;


/*
- (IBAction)doneWhenPressed:(id)sender;
- (IBAction)cancelWhenPressed:(id)sender;
- (void) dismissSelf;
*/

@end

@implementation EntryViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Le damos el foco al textView para que aparezca el teclado
    self.textView.becomeFirstResponder;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date;
    
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedMood = DiaryEntryMoodGood;
        date = [NSDate date];
        [self loadLocation];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE MMM d, yyyy"];
    self.dateLabel.text = [formatter stringFromDate:date ];
    
    // El accesory view aparece encima del teclado al
    // pulsar sobre el textfield al escribir
    // Para ello hemos creado una vista con los 3 botones
    // del humor
    self.textView.inputAccessoryView = self.accesoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setPickedMood:(enum DiaryEntryMood)pickedMood {
    _pickedMood = &pickedMood;
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case DiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;

    }
}


// Insertar entrada
- (void) insertDiaryEntry {
    // Obtenemos acceso al coreData
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    // Creamos la nueva entrada con el nombre de la Entity (tabla) en este caso DiaryEntry
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    // Configuramos la entrada
    entry.body = self.textView.text;
    // Hora actual en segundos desde 1970
    entry.date = [[NSDate date] timeIntervalSince1970];
    // Insertamos el humor
    entry.mood = self.pickedMood;
    // Imagen
    entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    // Ubicacion
    entry.location = self.location;
    // Salvamos los datos
    [coreDataStack saveContext];
    
}

// Actualizar entrada
- (void) updateDiaryEntry {
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
    self.entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //Cogemos la imagen
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    // Cerramos el cuadro de diálogo
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Cerramos el cuadro de diálogo
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Método para preguntar si seleccionamos la camara
// o la galería
- (void) promptForSource {
    // Con actionSheet hacemos aparecer un cuadro de dialogo con opciones para realizar por el usuario
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    [actionSheet showInView:self.view];
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        //Es el botón de cámara
        if (buttonIndex != [actionSheet firstOtherButtonIndex]) {
            [self promptForCamera];
            // Es el botón de galería
        } else {
            [self promptForPhotoRoll];
        }
    }
}

// Método para seleccionar de la galería
- (void) promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion: nil];
}
// Método para seleccionar de la cámara
- (void) promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion: nil];
}

// Establecemos la imagen seleccionada en el botón
- (void) setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (pickedImage != nil) {
        [self.imageButton setImage:self.pickedImage forState:UIControlStateNormal];
    } else {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    }
}

// Localización

- (void) loadLocation {
    self.locationManager  = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000;
    
    
    
    [self.locationManager startUpdatingLocation];
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
        
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    }];

}
#pragma mark - Botones de accion

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

- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodGood;
}
- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodAverage;

}

- (IBAction)imageButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}



@end
