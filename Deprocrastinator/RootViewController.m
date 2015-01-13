//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Evan Vandenberg on 1/12/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"
#import "Task.h"

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property NSMutableArray *tasksArray;
@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;
@property NSIndexPath *deleteIndexPath;
@property Task* tasks;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [[Task alloc] init];

    self.tasksArray = [NSMutableArray new];
}

//setting the number of cells in a tableview
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasksArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    self.tasks = [self.tasksArray objectAtIndex:indexPath.row];


    myCell.textLabel.text = self.tasks.tasksName;
    myCell.textLabel.textColor = self.tasks.tasksColor;
    return myCell;
}


- (IBAction)onAddButtonPressed:(id)sender
{
    self.tasks = [[Task alloc] init];
    self.tasks.tasksName = self.taskTextField.text;
    self.tasks.tasksColor = [UIColor blackColor];

    [self.tasksArray addObject:self.tasks];
    [self.tasksTableView reloadData];
    self.taskTextField.text = nil;
    [self.taskTextField resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self.tasksTableView cellForRowAtIndexPath:indexPath];
    //cell.textLabel.textColor = [UIColor greenColor];
    self.tasks = [self.tasksArray objectAtIndex:indexPath.row];
    self.tasks.tasksColor = [UIColor greenColor];
    self.tasks = [[Task alloc] init];
    [self.tasksTableView reloadData];



}


//Initializing edit mode and changine the button title text when pressed
- (IBAction)onEditButtonPressed:(UIButton *)editButton
{
    if ([editButton.titleLabel.text  isEqual: @"Edit"])
    {
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        [editButton sizeToFit];
        self.tasksTableView.editing = YES;
    }
    else
    {
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        self.tasksTableView.editing = NO;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.tasksArray removeObjectAtIndex:self.deleteIndexPath.row];
        [self.tasksTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"%@",[NSArray arrayWithObject:self.deleteIndexPath]);
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *deleteAlert = [UIAlertView new];
    deleteAlert.delegate = self;
    deleteAlert.title = @"Are you sure you would like to delete this item?";
    [deleteAlert addButtonWithTitle:@"Cancel"];
    [deleteAlert addButtonWithTitle:@"Delete"];
    self.deleteIndexPath = indexPath;
    [deleteAlert show];
}


- (IBAction)onRightSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.tasksTableView];
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:touchPoint];
    self.tasks = [self.tasksArray objectAtIndex:indexPath.row];

    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"GoingRight");
        if(self.tasks.tasksColor == [UIColor blackColor])
        {
               self.tasks.tasksColor = [UIColor greenColor];

        }
        else if (self.tasks.tasksColor == [UIColor greenColor])
        {
            self.tasks.tasksColor = [UIColor yellowColor];
        }
        else if (self.tasks.tasksColor == [UIColor yellowColor])
        {
            self.tasks.tasksColor = [UIColor redColor];
        }
        else if (self.tasks.tasksColor == [UIColor redColor])
        {
            self.tasks.tasksColor = [UIColor blackColor];
        }
    }
    [self.tasksTableView reloadData];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *cellContentString = [self.tasksArray objectAtIndex:sourceIndexPath.row];
    [self.tasksArray removeObjectAtIndex:sourceIndexPath.row];
    [self.tasksArray insertObject:cellContentString atIndex:destinationIndexPath.row];
}


@end
