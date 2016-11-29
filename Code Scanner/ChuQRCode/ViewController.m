//
//  ViewController.m
//  ChuQRCode
//
//  Created by Xes.Sky.Macbook on 2016/10/16.
//  Copyright © 2016年 Xes.Sky.Macbook. All rights reserved.
//

#import "ViewController.h"
#import "QRViewController.h"


@interface ViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, copy) NSArray * typeArray;        // data source
@property (nonatomic, copy) NSArray * capacityArray;    // data source
@property (nonatomic, weak) NSArray * currentArray;     // It's pointer
@property (nonatomic, assign) CGPoint showPoint;        // point.
@property (nonatomic, assign) CGPoint hiddenPoint;      // point.


@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.typeArray = @[@"Type:1",@"Type:2",@"Type:3"];
    self.capacityArray = @[@"3ml",@"5ml",@"10ml"];
    self.currentArray = self.typeArray; //Default array.
    
    
    [self.textView setEditable:NO];
    //Create UIBarButtonItem Object.
    UIBarButtonItem * rightBarBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                     target:self
                                                                                     action:@selector(pushQRViewController:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    
    CGSize pickerSize = CGSizeMake(self.view.frame.size.width, 272.f);
    //Set the point.
    self.hiddenPoint = CGPointMake(0,self.view.frame.size.height);
    self.showPoint = CGPointMake(0,self.view.frame.size.height - pickerSize.height);
    
    //Create UIPickerView Object.
    self.pickerView = [[UIPickerView alloc]initWithFrame:(CGRect){self.hiddenPoint,pickerSize}];
    self.pickerView.delegate = self;                        //Set the delegate.
    self.pickerView.dataSource = self;                      //Set the dataSource.
    self.pickerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.pickerView];
    
    self.rightTextField.delegate = self;
    self.leftTextField.delegate = self;
    
    
}

#pragma mark ----------------- UITextFieldDelegate ---------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //Add animation.
    [UIView animateWithDuration:0.27f animations:^{
        CGRect newRect = self.pickerView.frame;
        if (self.pickerView.frame.origin.y == self.hiddenPoint.y) {
            newRect.origin = self.showPoint;
        }else{
            newRect.origin = self.hiddenPoint;
        }
        self.pickerView.frame = newRect;
    }];
    
    if (textField == self.rightTextField) {
        self.currentArray = self.typeArray;
    }else{
        self.currentArray = self.capacityArray;
    }
    //Reload data.
    [self.pickerView reloadAllComponents];
    return NO;
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currentArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.currentArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.currentArray == self.typeArray) {
        self.rightTextField.text = [self.typeArray objectAtIndex:row];
    }else{
         self.leftTextField.text = [self.capacityArray objectAtIndex:row];
    }
}

- (void)pushQRViewController: (id)btn {
    //Create QRViewController and set the callback.
    QRViewController * qrVc = [[QRViewController alloc]initWithCallback:^(NSString * result) {
        if (self.textView) {
            self.textView.text = result;
        }
    }];
    [self.navigationController pushViewController:qrVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
