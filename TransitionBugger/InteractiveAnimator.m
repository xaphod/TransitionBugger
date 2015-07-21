//
//  InteractiveAnimator.m
//  TransitionBugger
//
//  Created by Tim Carr on 7/16/15.
//  Copyright (c) 2015 Tim Carr. All rights reserved.
//

#import "InteractiveAnimator.h"

@implementation InteractiveAnimator

- (instancetype)init {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if( self = [super init] )
        return self;
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning Protocol

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (void)animationEnded:(BOOL)transitionCompleted {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Reset to our default state
    self.transitionContext = nil;
}



#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}


#pragma mark - UIViewControllerInteractiveTransitioning Methods

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    NSArray *debugSubviews = [transitionContext containerView].subviews;
    
    if (self.isPush) {
        // The order of these matters – determines the view hierarchy order.
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
    }
    else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
    }
    
    toViewController.view.frame = endFrame;
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Presenting goes from 0...1 and dismissing goes from 1...0
    CGRect frame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]) * (1.0f - percentComplete), 0);
    
    if (self.isPush) {
        toViewController.view.frame = frame;
    } else {
        fromViewController.view.frame = frame;
    }
}

- (void)finishInteractiveTransition {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPush) {
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [UIView animateWithDuration:0.5f animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            NSLog(@"%s - completeTransition:YES", __PRETTY_FUNCTION__);
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else {
        CGRect endFrame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[self.transitionContext containerView] bounds]), 0);
        
        [UIView animateWithDuration:0.5f animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            NSLog(@"%s - completeTransition:YES", __PRETTY_FUNCTION__);
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    
}

- (void)cancelInteractiveTransition {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPush) {
        CGRect endFrame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]), 0);
        
        [UIView animateWithDuration:0.5f animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            NSLog(@"%s - completeTransition:NO", __PRETTY_FUNCTION__);
            [transitionContext completeTransition:NO];
        }];
    } else {
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [UIView animateWithDuration:0.5f animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            NSLog(@"%s - completeTransition:NO", __PRETTY_FUNCTION__);
            [transitionContext completeTransition:NO];
        }];
    }
}



@end
