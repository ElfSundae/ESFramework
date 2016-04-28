//
//  ESRefreshControlDefaultContentView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESRefreshControlDefaultContentView.h"
#import "ESDefines.h"

@interface ESRefreshControlDefaultContentView ()
@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;

@end

@implementation ESRefreshControlDefaultContentView

- (instancetype)init
{
        return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                _shapeLayer = [[CAShapeLayer alloc] init];
                _shapeLayer.frame = CGRectZero;
                _shapeLayer.fillColor = nil;
                _shapeLayer.strokeColor = [UIColorWithRGB(99., 109., 125.) CGColor];
                _shapeLayer.strokeEnd = 0;
                _shapeLayer.contentsScale = [UIScreen mainScreen].scale;
                _shapeLayer.lineWidth = 2;
                _shapeLayer.lineCap = kCALineCapRound;
                [self.layer addSublayer:_shapeLayer];

                _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [_activityIndicatorView sizeToFit];
                [self addSubview:_activityIndicatorView];
                self.backgroundColor = [UIColor clearColor];
                
        }
        return self;
}

- (UILabel *)textLabel
{
//        if (!_textLabel) {
//                _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//                _textLabel.backgroundColor = [UIColor clearColor];
//                _textLabel.textAlignment = NSTextAlignmentCenter;
//                _textLabel.numberOfLines = 0;
//                _textLabel.font = [UIFont systemFontOfSize:14.0];
//                _textLabel.textColor = UIColorWithRGB(99., 109., 125.);
//                [self addSubview:_textLabel];
//        }
        return _textLabel;
}

- (void)setFrame:(CGRect)frame
{
        [super setFrame:frame];
        if (frame.size.width > 0 && frame.size.height > 0) {
                CGRect activityFrame = self.activityIndicatorView.frame;
                activityFrame.origin.x = floorf((frame.size.width - activityFrame.size.width) / 2.);
                activityFrame.origin.y = 15.;
                self.activityIndicatorView.frame = activityFrame;
                
                self.shapeLayer.frame = activityFrame;
                //https://developer.apple.com/library/ios/documentation/2ddrawing/conceptual/drawingprintingios/BezierPaths/BezierPaths.html#//apple_ref/doc/uid/TP40010156-CH11-SW5
                
                UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(floorf(activityFrame.size.width / 2.), floorf(activityFrame.size.height / 2.))
                                                                          radius:floorf(activityFrame.size.width / 2.)
                                                                      startAngle:ESDegreesToRadians(-45)
                                                                        endAngle:ESDegreesToRadians(315)
                                                                       clockwise:YES];
                self.shapeLayer.path = bezierPath.CGPath;
        }
        
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
        //TODO: textLabel
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESRefreshControlContentViewDelegate

- (CGFloat)refreshControlContentViewHeight:(ESRefreshControl *)refreshControl
{
        return 50.;
}

- (void)refreshControl:(ESRefreshControl *)refreshControl stateChanged:(ESRefreshControlState)state from:(ESRefreshControlState)fromState
{
        if (ESRefreshControlStateRefreshing == state) {
                self.shapeLayer.hidden = YES;
                [self.activityIndicatorView startAnimating];
        } else {
                self.shapeLayer.hidden = NO;
                if (ESRefreshControlStateNormal == state) {
                        self.shapeLayer.strokeEnd = 0;
                }
                [self.activityIndicatorView stopAnimating];
        }
}

- (void)refreshControl:(ESRefreshControl *)refreshControl pullProgressChanged:(CGFloat)pullProgress
{
        CGFloat progress = pullProgress;
#if 1 //Fix: 还没有拉到圆圈的底部时圆圈已经画了大部分了
        if (progress < 0.8) {
                progress = (progress * self.frame.size.height - self.shapeLayer.frame.origin.y) / self.frame.size.height;
        }
        progress = fmax(0., (fmin(progress, 1.)));
#endif
        //NSLog(@"%f %f %f-%f", pullProgress, progress, self.shapeLayer.strokeStart, self.shapeLayer.strokeEnd);
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        self.shapeLayer.strokeEnd = progress;
        [CATransaction commit];
}
@end
