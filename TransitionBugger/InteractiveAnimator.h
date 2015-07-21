//
//  InteractiveAnimator.h
//  TransitionBugger
//
//  Created by Tim Carr on 7/16/15.
//  Copyright (c) 2015 Tim Carr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InteractiveAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, assign) bool isPush;


-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)finishInteractiveTransition;
- (void)cancelInteractiveTransition;

@end
