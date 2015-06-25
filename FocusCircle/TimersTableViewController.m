//
//  TimersTableViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//


#import "TimersTableViewController.h"

@interface TimersTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSMutableArray *runningTimers;

@end

@implementation TimersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelection = YES;

    [self configureNavigationBar];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    
    [self.fetchedResultController performFetch:&error];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.tableFooterView.frame.size.width, self.tableView.tableFooterView.frame.size.height)];
    self.tableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)runningTimers{
    if (_runningTimers) {
        return _runningTimers;
    }else{
        _runningTimers = [[NSMutableArray alloc]init];
        return _runningTimers;
    }
}

#pragma mark - Configure View Controller and View

- (void)configureNavigationBar{
    self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addingButtonTapped:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.title = @"Timers";
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Actions of Controls

- (void)addingButtonTapped:(id)sender{
    NavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addingNavigation"];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)settingButtonTapped:(id)sender{
    NavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingNavigation"];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (self.isEditing) {
        self.editButtonItem.title = @"完成";
    }else{
        self.editButtonItem.title = @"编辑";
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections]objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timerCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.shouldIndentWhileEditing = YES;
    
    TimerModel *timerModel =  (TimerModel *)[self.fetchedResultController objectAtIndexPath:indexPath];
    TimerController *timerController = timerModel.timerController;
    timerController.indexPath = indexPath;
    
    cell.titleOfTimerLabel.text = timerModel.titleOfTimer;
    cell.durationTimeLabel.text = [NSString stringWithSeconds:timerController.remainingTime];

    UITapGestureRecognizer *tapReconizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondToTimerButtonTapped:)];
    tapReconizer.numberOfTapsRequired = 1;
    [cell.timerButtonView addGestureRecognizer:tapReconizer];
    cell.timerButtonView.relatedTimerController = timerController;
    
    return cell;
}

-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(tableView.indexPathsForSelectedRows.count){
        if ([tableView.indexPathsForSelectedRows indexOfObject:indexPath] != NSNotFound){
            return 150;
        }else{
            return 95;
        }
    }else{
        return 95;
    }
}


#pragma mark - Editing Table View Cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerModel *timerModelToEdit = [self.fetchedResultController objectAtIndexPath:indexPath];
    TimerController *currentTimerController = timerModelToEdit.timerController;
    if (currentTimerController.currentStatus == TimerRunning) {
        return NO;
    }
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(nonnull UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.fetchedResultController.managedObjectContext deleteObject:[self.fetchedResultController objectAtIndexPath:indexPath]];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


#pragma mark - Action of Table View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editing){
    
        NavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editingNavigation"];
        TimerEditingViewController *editingViewController = (TimerEditingViewController *)nvc.topViewController;
        [editingViewController setValueForFetchedResultsController:self.fetchedResultController forTimerIndexPath:indexPath];
        
        [self presentViewController:nvc animated:YES completion:nil];
        
    }else{
        [self updateTableView:tableView];
    }

}

-(void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self updateTableView:tableView];
}

#pragma mark - Configure Core Data

-(NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TimerModel" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sortValue" ascending:NO];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultController.delegate = self;
    
    return _fetchedResultController;
}

-(NSManagedObjectContext *)managedObjectContext{
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    
    _managedObjectContext = appdelegate.managedObjectContext;
    
    return _managedObjectContext;
}

#pragma mark - Delegeate of NSFetchedResultController
-(void)controllerWillChangeContent:(nonnull NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void)controller:(nonnull NSFetchedResultsController *)controller didChangeObject:(nonnull __kindof NSManagedObject *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    
    
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
    else if(type == NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
    else if(type == NSFetchedResultsChangeUpdate){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }

}

-(void)controllerDidChangeContent:(nonnull NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}


-(void)updateTableView:(UITableView *)tableView{
    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - Gesture Recognizer

-(void)respondToTimerButtonTapped:(UITapGestureRecognizer *)sender{
    if (self.editing) {
    }else{
        TimerButton *currentTimerButtonView = (TimerButton *)sender.view;
        TimerController *timerController = (TimerController *)currentTimerButtonView.relatedTimerController;
        
        switch (timerController.currentStatus) {
            case TimerPausing:
                [self resumeTimerForTimerController:timerController];
                break;
            case TimerStopped:
                [self createTimerForTimerController:timerController];
                break;
            case TimerRunning:
                [self pauseTimerForTimerController:timerController];
                break;
            default:
                break;
        }
    }

}

#pragma mark - Timer
-(void)createTimerForTimerController: (TimerController *)timerController{

    NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownForTimer:) userInfo:timerController repeats:YES];
    
    timerController.timer = countdownTimer;
    timerController.currentStatus = TimerRunning;
    [[NSRunLoop currentRunLoop]addTimer:countdownTimer forMode:NSDefaultRunLoopMode];
    [countdownTimer fire];
}

-(void)countdownForTimer: (NSTimer *)sender{
    if (sender.valid) {
        TimerController *timerController = (TimerController *)sender.userInfo;
        if([timerController.remainingTime isEqualToNumber:[NSNumber numberWithDouble:0.0]]){
            
            [sender invalidate];
            sender = nil;
            
            timerController.currentStatus = TimerStopped;
            timerController.remainingTime = ((TimerModel *)[self.fetchedResultController objectAtIndexPath:timerController.indexPath]).durationTime;
            
            TimerTableViewCell *currentCell = (TimerTableViewCell *)[self.tableView cellForRowAtIndexPath:timerController.indexPath];
            currentCell.durationTimeLabel.text = [NSString stringWithSeconds:timerController.remainingTime];
            

        }else if(timerController.remainingTime.doubleValue > 0.0){
            NSNumber *oldNumer = timerController.remainingTime;
            timerController.remainingTime = [NSNumber numberWithDouble:oldNumer.doubleValue - 1];
            oldNumer = nil;
            
            TimerTableViewCell *currentCell = (TimerTableViewCell *)[self.tableView cellForRowAtIndexPath:timerController.indexPath];
            currentCell.durationTimeLabel.text = [NSString stringWithSeconds:timerController.remainingTime];
            
            
        }else{
            abort();
        }
    }
}

-(void)pauseTimerForTimerController: (TimerController *)timerController{
    timerController.currentStatus = TimerPausing;
    [timerController.timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimerForTimerController: (TimerController *)timerController{
    timerController.currentStatus = TimerRunning;
    [timerController.timer setFireDate:[NSDate distantPast]];
}

@end