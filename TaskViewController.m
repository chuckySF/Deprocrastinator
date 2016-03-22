//
//  TaskViewController.m
//  Deprocrastinator
//
//  Created by Chucky on 3/21/16.
//  Copyright © 2016 Chuck. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController () < UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UITextField *textFieldInput;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *tasks;
@property NSMutableArray *taskColors;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray new];
    [self.tasks addObjectsFromArray:@[@"A", @"B", @"C",
                                      @"D", @"E", @"F",
                                      @"G", @"H", @"I",
                                      @"J", @"K", @"L",
                                      @"M", @"N", @"O",
                                      @"P", @"Q", @"R",
                                      @"S", @"T", @"U",
                                      @"V", @"W", @"X",
                                      @"Y", @"Z"]];

    self.taskColors = [NSMutableArray new];
    [self.taskColors addObjectsFromArray:@[[UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor],
                                           [UIColor clearColor], [UIColor clearColor]
                                           ]];
    
    //add code for gesture actions
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gesture];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task cell"];
    cell.textLabel.text = [self.tasks objectAtIndex:indexPath.row];

    cell.backgroundColor = [self.taskColors objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    NSString *text = self.textFieldInput.text;
    
    [self.tasks addObject:text];
    [self.taskColors addObject:[UIColor clearColor]];
    
    [self.tableView reloadData];
    
    self.textFieldInput.text = @"";
    [self.textFieldInput resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor greenColor]];
    [self.taskColors replaceObjectAtIndex:indexPath.row withObject:[UIColor greenColor]];
    
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.tasks removeObjectAtIndex:indexPath.row];
            [self.taskColors removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }];
        
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil ];
        
        [alertController addAction:deleteButton];
        [alertController addAction:cancelButton];
        
         [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.editing) {
        self.editing = false; //sets editing state immediately to false when current state is editing
        sender.title = @"edit"; //change button back to default "edit" text
        sender.style = UIBarButtonItemStyleDone;
        [self.tableView setEditing:false animated:true];
    } else {
        self.editing = true;
        sender.title = @"done";
        sender.style = UIBarButtonItemStylePlain;
        [self.tableView setEditing:true animated:true];
    }
    
    
}
- (IBAction)swipeRight:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [sender locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        UITableViewCell *swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        
        if (swipedCell.backgroundColor == [UIColor yellowColor]) {
            [self.taskColors replaceObjectAtIndex:swipedIndexPath.row withObject:[UIColor redColor]];
        } else if (swipedCell.backgroundColor == [UIColor greenColor]) {
            [self.taskColors replaceObjectAtIndex:swipedIndexPath.row withObject:[UIColor yellowColor]];
        } else {
            [self.taskColors replaceObjectAtIndex:swipedIndexPath.row withObject:[UIColor greenColor]];
        }
        
        [self.tableView reloadData];
    }
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    NSString *task = [self.tasks objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObject:task];
    [self.tasks insertObject:task atIndex:destinationIndexPath.row];
    
}







@end
