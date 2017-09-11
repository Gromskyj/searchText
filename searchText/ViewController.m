//
//  ViewController.m
//  searchText
//
//  Created by User on 14.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "PageParser.h"
#import "TaskCell.h"

#import "PageProcessingController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, PageProcessingControllerDelegate, UITextFieldDelegate>

//CONTROLS
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *concurrencyCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlScanCountTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *generalProgressBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;


//Helpers
@property (retain, nonatomic) NetworkManager *networkManager;
@property (retain, nonatomic) PageParser *pageParser;
@property (retain, nonatomic) PageProcessingController *pageProcessingController;
//Variables

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.networkManager = [[NetworkManager alloc] init];
    self.pageParser = [[PageParser alloc] init];
    self.pageProcessingController = [[PageProcessingController alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (IBAction)sampleButtonAction:(id)sender {
    self.urlTextField.text = @"http://bigmir.net/";
    self.searchTextField.text = @"Украина";
}

- (IBAction)startButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    self.pageProcessingController.rootURL = self.urlTextField.text;
    self.pageProcessingController.maxLinksCount = [self.urlScanCountTextField.text integerValue];
    self.pageProcessingController.maxConcurrentOperationCount = [self.concurrencyCountTextField.text integerValue];
    self.pageProcessingController.delegate = self;
    
    [self.pageProcessingController clear];
    [self.tableView reloadData];
    
    [self.pageProcessingController performSearchWithText:self.searchTextField.text];
    
    self.startButton.enabled = NO;
    self.stopButton.enabled = YES;
    self.pauseButton.enabled = YES;
}

- (IBAction)pauseButtonAction:(id)sender {
    [self.pauseButton setSelected:!self.pauseButton.selected];
    [self.pageProcessingController setSuspend:self.pauseButton.selected];
}

- (IBAction)stopButtonAction:(id)sender {
    [self.pageProcessingController invalidate];
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    self.pauseButton.enabled = NO;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pageProcessingController.tasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"taskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Task *task = self.pageProcessingController.tasks[indexPath.row];
    
    [cell setTask:task];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *task = self.pageProcessingController.tasks[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: task.urlString]];
}

#pragma mark - PageProcessingController Delegate
-(void)controllerWillChangeContent:(PageProcessingController *)controller{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(PageProcessingController *)controller{
    [self.tableView endUpdates];
}

- (void)controller:(PageProcessingController *)controller didChangeTask:(Task *)task atIndex:(NSUInteger)index forType:(PageProcessingChangeType)type{
    switch (type) {
        case PageProcessingChangeTypeInsert:
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case PageProcessingChangeTypeUpdate:{
            NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:index inSection:0];
            TaskCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell){
                [cell setTask:task];
            }
            
            //Progress Update
            [self.generalProgressBar setProgress:(float)self.pageProcessingController.progressStatus.value / (float)self.pageProcessingController.progressStatus.maxValue];
            self.statusLabel.text = self.pageProcessingController.progressStatus.readableState;
        }
            break;
        default:
            break;
    }
}

- (void)controllerDidFinish:(PageProcessingController *)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Parsing finished" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    self.pauseButton.enabled = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}



@end
