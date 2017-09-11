//
//  TaskCell.m
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTask:(Task *)task{
    self.urlLabel.text = task.urlString;
    self.statusLabel.text = task.readableState;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (task.taskState == TaskStateProcessed){
        if (task.resultsCount > 0){
            self.contentView.backgroundColor = [UIColor greenColor];
        }else{
            self.contentView.backgroundColor = [UIColor redColor];
        }
        
    }
}

@end
