//
//  EntryCell.m
//  Diary
//
//  Created by Alex Valladares on 18/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "EntryCell.h"
#import "DiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface EntryCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moodImage;



@end


@implementation EntryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForEntry:(DiaryEntry *)entry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(202.0, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight,CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
    
}

- (void) configureCellForEntry:(DiaryEntry*) entry {
    
    // configuramos el texto y la ubicacion
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    
    // configuramos la fecha
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [formatter stringFromDate:date];
    
    
    // configuramos la imagen principal
    if (entry.image) {
        self.mainImage.image = [UIImage imageWithData:entry.image];
    } else {
        self.mainImage.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    // configuramos el icono del humor
    if (entry.mood == DiaryEntryMoodGood) {
        self.moodImage.image = [UIImage imageNamed:@"icn_happy"];
    } else if (entry.mood == DiaryEntryMoodAverage){
        self.moodImage.image = [UIImage imageNamed:@"icn_average"];
    } else if (entry.mood == DiaryEntryMoodBad) {
        self.moodImage.image = [UIImage imageNamed:@"icn_bad"];

    }
    // Hacemos la imagen circular con cornerRadius = a la mitad del ancho de la imagen (¿?)
    self.mainImage.layer.cornerRadius = CGRectGetWidth(self.mainImage.frame) / 2.0f;
    
    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text = @"No location";
    }
}
@end
