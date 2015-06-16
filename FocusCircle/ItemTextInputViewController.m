//
//  ItemTextInputViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "ItemTextInputViewController.h"

typedef enum timePicker{
    hours = 0,
    minutes,
    second
}TimeComponent;

@interface ItemTextInputViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate>

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *durationField;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPickerView;

@property (nonatomic) NSNumber *hours;
@property (nonatomic) NSNumber *minutes;
@property (nonatomic) NSNumber *seconds;


@end

@implementation ItemTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    

    [self configureNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure NavigationController

-(void)configureNavigationBar{
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.title = @"添加新项目";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
}

#pragma mark - Configure UIPickerView

-(void)configurePickerView{
    self.durationPickerView.showsSelectionIndicator = YES;
    [self setDefaultValue:0 inComponent:hours];
    [self setDefaultValue:0 inComponent:minutes];
    [self setDefaultValue:0 inComponent:second];
}

-(void)setDefaultValue: (NSInteger)value inComponent:(TimeComponent)component{
    [self.durationPickerView selectRow:value inComponent:component animated:YES];
    [self pickerView:self.durationPickerView didSelectRow:value inComponent:component];
}


-(NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 24;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 60;
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(NSString *)pickerView:(nonnull UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%ld 小时", row];
            break;
        case 1:
            return [NSString stringWithFormat:@"%ld 分钟", row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%ld 秒", row];
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)pickerView:(nonnull UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(void)pickerView:(nonnull UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            self.hours = [NSNumber numberWithInteger:row];
            break;
        case 1:
            self.minutes = [NSNumber numberWithInteger:row];
            break;
        case 2:
            self.seconds = [NSNumber numberWithInteger:row];
            break;
            
        default:
            break;
    }
}


#pragma mark - Button Action

- (void)cancelButtonTapped{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped{
    
    NSTimeInterval secondsDuration = self.hours.doubleValue * 60 * 60 + self.minutes.doubleValue * 60 + self.seconds.doubleValue;
    
    UITabBarController *tab = (UITabBarController*)self.navigationController.presentingViewController;
    
    UINavigationController *nav = tab.viewControllers[0];
    
    ItemsTableViewController *sourceViewController = (ItemsTableViewController *)nav.topViewController;
    [sourceViewController setNeedUpdateData:YES];
    
    
    if((![self.titleTextField.text isEqualToString:@""]) && (secondsDuration != 0)){
        
        NSNumber *dutation = [NSNumber numberWithDouble:secondsDuration]; //Convert NSTimeInterval to NSNumber
        
        [self insertDataWithTitle:self.titleTextField.text andDurationTime:dutation];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{

        UIAlertController *emptyAlert = [UIAlertController alertControllerWithTitle:@"输入为空" message:@"请输入有效值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [emptyAlert addAction:cancelAlert];
        [self presentViewController:emptyAlert animated:YES completion:nil];
        
    }
    
    
}

#pragma mark - Interact with Database

-(void)insertDataWithTitle: (NSString *)titleOfItem andDurationTime: (NSNumber *)duration{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    
    ItemModel *itemModel = [NSEntityDescription insertNewObjectForEntityForName:@"ItemModel" inManagedObjectContext:self.managedObjectContext];
    
    NSNumber *createdDate = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
    
    [itemModel setValue:titleOfItem forKey:@"titleOfItem"];
    [itemModel setValue:duration forKey:@"duration"];
    [itemModel setValue:createdDate forKey:@"createdDate"];
    
}



@end
