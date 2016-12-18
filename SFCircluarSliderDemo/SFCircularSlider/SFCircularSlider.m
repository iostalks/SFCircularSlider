//
//  SFCircluarSlider.m
//  SFCircluarSliderDemo
//
//  Created by Jone on 18/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import "SFCircularSlider.h"

#define SQR(x)       ((x)*(x))

#define kSelfWidth  CGRectGetWidth(self.frame)
#define kSelfHeight CGRectGetHeight(self.frame)

static CGFloat const kCircleDegree360 = 360;
static CGFloat const kCircleDegreeMin = 140;
static CGFloat const kCircleDegreeMax = 40;

@interface SFCircularSlider ()
@property (nonatomic, assign) CGFloat angle;
@end

@implementation SFCircularSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 &&
        frame.size.height == 0) {
        frame.size = (CGSize){300, 300};
    }
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initialzation];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self initialzation];
    return self;
}

- (void)initialzation {
    _thumbRadius = 14;
    _borderWidth = 16;
    _radius = (kSelfWidth - _borderWidth - _thumbRadius - 4) / 2;

    _angle = kCircleDegree360 - kCircleDegreeMin;
    _value = 0.5;
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    
    _thumbTintColor = [UIColor whiteColor];
    _minimumTrackTintColor = [UIColor greenColor];
    _maximumTrackTintColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _circularColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark -

- (void)setMinimumValue:(CGFloat)minimumValue {
    if (minimumValue > _maximumValue) minimumValue = _maximumValue;
    if (minimumValue > _value) _value = minimumValue;
    _minimumValue = minimumValue;
    
    _angle = [self angleFromValue:_value];
    [self setNeedsDisplay];
}


- (void)setMaximumValue:(CGFloat)maximumValue {
    if (maximumValue < _minimumValue) maximumValue = _minimumValue;
    if (maximumValue < _value) _value = maximumValue;
    _maximumValue = maximumValue;
    
    _angle = [self angleFromValue:_value];
    [self setNeedsDisplay];
}

- (void)setValue:(CGFloat)value {
    _value = value;
    _angle = [self angleFromValue:value];

    [self setNeedsDisplay];
}

- (CGFloat)angleFromValue:(CGFloat)value {
    CGFloat percentage = value / (_maximumValue - _minimumValue);
    CGFloat originAngle = percentage * (kCircleDegree360 - (kCircleDegreeMin  - kCircleDegreeMax));
    CGFloat rawAngle;
    if (originAngle <= kCircleDegree360 - kCircleDegreeMin) {
        rawAngle = kCircleDegreeMin + originAngle;
    } else {
        rawAngle = originAngle - (kCircleDegree360 - kCircleDegreeMin);
    }
    return kCircleDegree360 - rawAngle;
}

#pragma mark -

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /// Underlay circle
    [self drawTheUnderlayCircle:context];

    /// filled arc
    [self drawTheFilledArc:context];

    /// Unfilled arc
    [self drawTheUnfilledArc:context];
    
    /// Thumb
    [self drawTheThum:context];
}

// Draw underlay circle
- (void)drawTheUnderlayCircle:(CGContextRef)context {
    
    CGContextSaveGState(context);
    
    CGContextAddArc(context, kSelfWidth / 2, kSelfHeight / 2, _radius, 0, M_PI * 2, 0);
    
    [_circularColor setStroke];
    
    CGContextSetLineWidth(context, _borderWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

// Draw filled arc
- (void)drawTheFilledArc:(CGContextRef)context {
    
    CGContextSaveGState(context);
    
    CGContextAddArc(context, kSelfWidth / 2, kSelfHeight / 2, _radius,
                    DegreesToRadians(kCircleDegreeMin),
                    DegreesToRadians(kCircleDegree360 - _angle), 0);
    
    [_minimumTrackTintColor setStroke];
    
    CGContextSetLineWidth(context, _borderWidth);
    CGContextSetLineCap(context, kCGLineCapRound);  //设置线起点终点形状
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

// Draw unfilled circle
- (void)drawTheUnfilledArc:(CGContextRef)context {
    
    CGContextSaveGState(context);
    
    CGContextAddArc(context, kSelfWidth / 2, kSelfWidth / 2,
                    _radius, DegreesToRadians(kCircleDegree360 - _angle),
                    DegreesToRadians(kCircleDegreeMax), 0);
    
    [_maximumTrackTintColor setStroke];
    
    CGContextSetLineWidth(context, _borderWidth);
    CGContextSetLineCap(context, kCGLineCapRound);  //设置线起点终点形状
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

// Draw Thumb
- (void)drawTheThum:(CGContextRef)context {
    
    CGContextSaveGState(context);
    
    CGPoint handleCenter = [self thumbCenterFromAngle:_angle radius:_radius];
    
    [_thumbTintColor set];
    
    CGSize shadowOffset = CGSizeMake(0, 0);
    CGFloat colorValues[] = {0, 0, 1/2, .6};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
    CGColorRef color = CGColorCreate (colorSpace, colorValues);
    CGContextSetShadowWithColor(context, shadowOffset, 3, color);
    
    CGContextFillEllipseInRect(context, CGRectMake(handleCenter.x - _thumbRadius,
                                                   handleCenter.y - _thumbRadius,
                                                   _thumbRadius * 2, _thumbRadius * 2));
    
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(context);
}

#pragma mark - Control Action

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint lastPoint = [touch locationInView:self];
    
    if (![self trackHandle:lastPoint]) {
        return NO;
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    CGPoint lastPoint = [touch locationInView:self];
    
    if (![self moveThumbHandle:lastPoint]) return NO;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    
}

#pragma mark - Control Method

// Thumb center point
- (CGPoint)thumbCenterFromAngle:(NSInteger)angleInt radius:(CGFloat)radius {
    
    CGPoint centerPoint = CGPointMake(kSelfWidth / 2, kSelfHeight/ 2);
    
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(DegreesToRadians(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(DegreesToRadians(-angleInt)));
    
    return result;
}

// Track scope
- (BOOL)trackHandle:(CGPoint)beginPoint {

    CGPoint centerPoint = CGPointMake(kSelfWidth / 2, kSelfHeight / 2);
    CGFloat distanceToCenter = sqrt(SQR(beginPoint.x - centerPoint.x) + SQR(beginPoint.y - centerPoint.y));
    
    if (fabs(distanceToCenter - _radius) > 30) return NO;
    
    return YES;
}

// Move thumb handle
- (BOOL)moveThumbHandle:(CGPoint)lastPoint {

    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    CGFloat currentAngle = AngleFromNorth(centerPoint, lastPoint);
//    NSLog(@"currentAngle = %f", currentAngle); // 140 -> 360 -> 40

    if (currentAngle < kCircleDegreeMin &&
        currentAngle > kCircleDegreeMax) return NO;
    
    int angleInt = roundl(currentAngle);
    CGFloat tolerance = 15;
    int oldAngle = kCircleDegree360 - _angle;
    int scope = fabs(currentAngle - oldAngle);
    
    if (scope > tolerance && (kCircleDegree360 - scope) > tolerance) return NO;

    CGFloat rawValue = angleInt >= kCircleDegreeMin ? angleInt : (kCircleDegree360 + (angleInt)); // 140 - 400
    CGFloat progress = (rawValue - kCircleDegreeMin) / (kCircleDegree360 - kCircleDegreeMin + kCircleDegreeMax);
    _value = MIN(MAX(0.0, progress), 1.0) * (_maximumValue - _minimumValue);
//    NSLog(@"rawValue = %f, progress = %f", rawValue, progress);
    
    _angle = kCircleDegree360 - currentAngle;
//    NSLog(@"Angle: %f", _angle); // 220->0 ~ 360->320
    
    [self setNeedsDisplay]; // Redraw
    
    return YES;
}

#pragma mark - Help Methods

static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

static inline CGFloat AngleFromNorth(CGPoint p1, CGPoint p2) {
    CGPoint v = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y, v.x);
    result = RadiansToDegrees(radians);
    return (result < 0  ? result + 360 : result);
}

@end
