//
//  GATGolfClubsTableViewController.m
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import "GATGolfClubsTableViewController.h"
#import "GATAppDelegate.h"

static NSString * const kClubEntityName = @"Club";
static NSString * const kClubNameKey = @"name";
static NSString * const kClubCountKey = @"count";
static NSString * const kClubTotalKey = @"total";


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
//    NSString *filePath = [self dataFilePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        _globalsArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
//    }else{
//        _globalsArray = [[NSMutableArray alloc] init];
//    }
    
    GATAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kClubEntityName];
    NSError *error;
    _coreDataObjects = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (_coreDataObjects == nil) {
        NSLog(@"returned empty array");
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
    return [_coreDataObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_coreDataObjects[indexPath.row] valueForKey:kClubNameKey];
    
    NSNumber *total = [_coreDataObjects[indexPath.row] valueForKey:kClubTotalKey];
    NSNumber *count = [_coreDataObjects[indexPath.row] valueForKey:kClubCountKey];
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
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Clubs" ofType:@"plist"];
    //[_globalsArray writeToFile:filePath atomically:YES];
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
    SEL selector = NSSelectorFromString(@"setClubName:");
    if ([destination respondsToSelector:selector]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [destination setValue:[_coreDataObjects[indexPath.row] valueForKey:kClubNameKey] forKey:@"clubName"];
    }
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        //get application delegate to retrieve managed object context
        GATAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kClubEntityName];
        //set predicate to look for existing value in database
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K = %@)", kClubNameKey, [[alertView textFieldAtIndex:0] text]];
        [request setPredicate:pred];
        
        
        NSError *error;
        
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        //if no objects are returned then value supplied must not exist
        if ([objects count] == 0) {
            
            NSManagedObject *newClub = [NSEntityDescription insertNewObjectForEntityForName:kClubEntityName inManagedObjectContext:context];
            [newClub setValue:[[alertView textFieldAtIndex:0] text] forKey:kClubNameKey];
            [newClub setValue:0 forKey:kClubCountKey];
            [newClub setValue:0 forKey:kClubTotalKey];
            [_coreDataObjects addObject:newClub];
            [appDelegate saveContext];
            [self.tableView reloadData];
            
            
            NSLog(@"no object exists");
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Already Exists" message:[NSString stringWithFormat:@"%@ Already Exists",[[alertView textFieldAtIndex:0] text]] delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
            [alert show];
        }
    
        
    }
    
    
}


- (IBAction)addClub:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Club" message:@"Enter Club You Would Like to Add" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
@end
