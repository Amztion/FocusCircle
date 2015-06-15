//
//  ItemTextInputViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "ItemTextInputViewController.h"


@interface ItemTextInputViewController ()

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *durationField;

@end

@implementation ItemTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.titleField = [[UITextField alloc]init];
    self.durationField = [[UITextField alloc]init];
    self.titleField.placeholder = @"Name";
    self.durationField.placeholder = @"Dutation";

    [self configureNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureNavigationBar{
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.title = @"添加新项目";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
}

- (void)cancelButtonTapped{
    ItemsTableViewController *sourceViewController = (ItemsTableViewController *)self.presentingViewController.presentingViewController;
    [sourceViewController setNeedUpdateData:NO];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped{
    ItemsTableViewController *sourceViewController = (ItemsTableViewController *)self.presentingViewController.presentingViewController;
    [sourceViewController setNeedUpdateData:YES];
    
    if(self.titleField.text && self.durationField.text){
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *dutation = [formatter numberFromString:self.durationField.text]; //Convert NSString to NSNumber
        [self insertDataWithTitle:self.titleField.text andDurationTime:dutation];
        
    }else{
        NSLog(@"Empty");
    }
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)insertDataWithTitle: (NSString *)titleOfItem andDurationTime: (NSNumber *)duration{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    
    ItemModel *itemModel = [NSEntityDescription insertNewObjectForEntityForName:@"ItemModel" inManagedObjectContext:self.managedObjectContext];
    
    [itemModel setValue:titleOfItem forKey:@"titleOfItem"];
    [itemModel setValue:duration forKey:@"duration"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addingTableCell" forIndexPath:indexPath];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField;
    
    if (indexPath.section == 0) {
        textField = self.titleField;
    }else{
        textField = self.durationField;
    }
    textField.frame = CGRectMake(cell.bounds.origin.x + 20, cell.bounds.origin.y + 10, cell.bounds.size.width - 20, cell.bounds.size.height - 10);

//    textFiled.translatesAutoresizingMaskIntoConstraints = YES;

        [cell.contentView addSubview:textField];

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
