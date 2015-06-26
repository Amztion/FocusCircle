//
//  TimerTextInputViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "TimerTextInputViewController.h"

typedef enum timePicker{
    hours = 0,
    minutes,
    second
}TimeComponent;

@interface TimerTextInputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleOfTimerTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPickerView;

@property (nonatomic) NSNumber *hours;
@property (nonatomic) NSNumber *minutes;
@property (nonatomic) NSNumber *seconds;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

@implementation TimerTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configurePickerView];
    
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
            return [NSString stringWithFormat:@"%ld 小时", (long)row];
            break;
        case 1:
            return [NSString stringWithFormat:@"%ld 分钟", (long)row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%ld 秒", (long)row];
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
    
    NSTimeInterval durationTimeInSeconds = self.hours.doubleValue * 60 * 60 + self.minutes.doubleValue * 60 + self.seconds.doubleValue;
    
    if((![self.titleOfTimerTextField.text isEqualToString:@""]) && (durationTimeInSeconds != 0)){
        
        NSNumber *dutation = [NSNumber numberWithDouble:durationTimeInSeconds]; //Convert NSTimeInterval to NSNumber
        
        [self insertDataWithTitle:self.titleOfTimerTextField.text andDurationTime:dutation];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{

        UIAlertController *emptyAlert = [UIAlertController alertControllerWithTitle:@"输入为空" message:@"请输入有效值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [emptyAlert addAction:cancelAlert];
        [self presentViewController:emptyAlert animated:YES completion:nil];
        
    }
    
    
}

#pragma mark - Interact with Database

-(NSManagedObjectContext *)managedObjectContext{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    return _managedObjectContext;
}

-(void)insertDataWithTitle: (NSString *)titleOfTimer andDurationTime: (NSNumber *)duration{
    TimerModel *timerModel = [NSEntityDescription insertNewObjectForEntityForName:@"TimerModel" inManagedObjectContext:self.managedObjectContext];
    
    NSNumber *createdDate = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
    
    [timerModel setValue:titleOfTimer forKey:@"titleOfTimer"];
    [timerModel setValue:duration forKey:@"durationTime"];
    [timerModel setValue:createdDate forKey:@"sortValue"];
}



@end
