//
//  SFCircluarSlider.h
//  SFCircluarSliderDemo
//
//  Created by Jone on 18/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFCircularSlider : UIControl

@property (nonatomic, assign) CGFloat value; ///< Default 0.0
@property (nonatomic, assign) CGFloat minimumValue; ///< default 0.0.
@property (nonatomic, assign) CGFloat maximumValue; ///< default 1.0.

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat thumbRadius;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nullable, nonatomic, strong) UIColor *minimumTrackTintColor UI_APPEARANCE_SELECTOR;
@property (nullable, nonatomic, strong) UIColor *maximumTrackTintColor UI_APPEARANCE_SELECTOR;
@property (nullable, nonatomic, strong) UIColor *thumbTintColor UI_APPEARANCE_SELECTOR;
@property (nullable, nonatomic, strong) UIColor *circularColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
