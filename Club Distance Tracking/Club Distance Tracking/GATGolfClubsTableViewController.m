//
//  GATGolfClubsTableViewController.m
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import "GATGolfClubsTableViewController.h"

@interface GATGolfClubsTableViewController ()

@end

@implementation GATGolfClubsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _globalsArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }else{
        _globalsArray = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_globalsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_globalsArray[indexPath.row] objectForKey:@"Club"];
    
    NSNumber *total = [_globalsArray[indexPath.row] objectForKey:@"Total"];
    NSNumber *count = [_globalsArray[indexPath.row] objectForKey:@"Count"];
    double average;
    if ([count doubleValue] == 0) {
        average = 0;
    }else{
        average = [total doubleValue] / [count doubleValue];
    }
    
    
    //formatting string to show only two decimal places
    NSNumberFormatter *doubleValueWithMaxTwoDecimalPlaces = [[NSNumberFormatter alloc] init];
    [doubleValueWithMaxTwoDecimalPlaces setNumberStyle:NSNumberFormatterDecimalStyle];
    [doubleValueWithMaxTwoDecimalPlaces setMaximumFractionDigits:2];
    
    cell.detailTextLabel.text = [doubleValueWithMaxTwoDecimalPlaces stringFromNumber:[NSNumber numberWithDouble:average]];
    
    return cell;
}


//code to save plist file if application is put into background
- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Clubs" ofType:@"plist"];
    [_globalsArray writeToFile:filePath atomically:YES];
}


- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Clubs.plist"];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = segue.destinationViewController;
    SEL selector = NSSelectorFromString(@"setChosenIndex:");
    if ([destination respondsToSelector:selector]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSNumber *tmp =[[NSNumber alloc] initWithInteger:indexPath.row];
        [destination setValue:tmp forKey:@"chosenIndex"];
    }
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSMutableDictionary *club = [[NSMutableDictionary alloc] init];
        [club setValue:[[alertView textFieldAtIndex:0] text] forKey:@"Club"];
        [club setValue:0 forKey:@"Total"];
        [club setValue:0 forKey:@"Count"];
        [_globalsArray addObject:club];
        NSString *filePath = [self dataFilePath];
        [_globalsArray writeToFile:filePath atomically:YES];
        [self.tableView reloadData];
        
    }
    
    
}


- (IBAction)addClub:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Club" message:@"Enter Club You Would Like to Add" delegate:self cancelButtonTitle:@"Add" otherButtonTitles:@"Cancel",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
@end
