//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Evan Vandenberg on 1/12/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property NSMutableArray *tasksArray;
@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;
@property NSIndexPath *deleteIndexPath;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

        myCell.textLabel.text = [self.tasksArray objectAtIndex:indexPath.row];
        return myCell;
}


- (IBAction)onAddButtonPressed:(id)sender
{

    [self.tasksArray addObject:self.taskTextField.text];
    [self.tasksTableView reloadData];
    self.taskTextField.text = nil;
    [self.taskTextField resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tasksTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
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
    UITableViewCell *swipedCell = [self.tasksTableView cellForRowAtIndexPath:indexPath];

    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"GoingRight");
        if(swipedCell.textLabel.textColor == [UIColor blackColor])
        {
               swipedCell.textLabel.textColor = [UIColor greenColor];

        }
        else if (swipedCell.textLabel.textColor == [UIColor greenColor])
        {
            swipedCell.textLabel.textColor = [UIColor yellowColor];
        }
        else if (swipedCell.textLabel.textColor == [UIColor yellowColor])
        {
            swipedCell.textLabel.textColor = [UIColor redColor];
        }
        else if (swipedCell.textLabel.textColor == [UIColor redColor])
        {
            swipedCell.textLabel.textColor = [UIColor blackColor];
        }
    }

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
