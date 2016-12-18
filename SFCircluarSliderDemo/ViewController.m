//
//  ViewController.m
//  SFCircluarSliderDemo
//
//  Created by Jone on 18/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import "ViewController.h"
#import "SFCircularSlider.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;
@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SFCircularSlider *circularSlider = [[SFCircularSlider alloc] init];
    circularSlider.value = 5;
    circularSlider.minimumValue = 0;
    circularSlider.maximumValue = 10;
    circularSlider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:177/255.0 blue:0/255.0 alpha:1];
    [circularSlider addTarget:self action:@selector(toucheUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [circularSlider addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circularSlider];
    circularSlider.center = self.view.center;
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.frame = (CGRect){0,0, 160, 100};
    valueLabel.font = [UIFont systemFontOfSize:95];
    valueLabel.textColor = [UIColor grayColor];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [circularSlider addSubview:valueLabel];
    valueLabel.center = (CGPoint){CGRectGetWidth(circularSlider.frame) / 2,
                                  CGRectGetHeight(circularSlider.frame) / 2};
    
    _valueLabel = valueLabel;
    _valueLabel.text = [NSString stringWithFormat:@"%02d", (int)circularSlider.value];

}

- (void)valueChangedAction:(SFCircularSlider *)sender {
    NSLog(@"valueChangedAction = %f", sender.value);
    _valueLabel.text = [NSString stringWithFormat:@"%02d", (int)sender.value];
}

- (void)toucheUpInsideAction:(SFCircularSlider *)sender {
    NSLog(@"toucheUpInsideAction value = %f", sender.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
