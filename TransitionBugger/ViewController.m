//
//  ViewController.m
//  TransitionBugger
//
//  Created by Tim Carr on 7/16/15.
//  Copyright (c) 2015 Tim Carr. All rights reserved.
//

#import "ViewController.h"
#import "InteractiveAnimator.h"
#import "NavigationControllerDelegate.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) NavigationControllerDelegate *myNavDel;

@end

@implementation ViewController



#pragma mark - Normal VC Stuff

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myNavDel = ((AppDelegate*)[UIApplication sharedApplication].delegate).navDel;
    self.navigationController.delegate = self.myNavDel;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s, userInteractionEnabled: %d", __PRETTY_FUNCTION__, self.view.userInteractionEnabled);
    [super viewDidAppear:animated];
    
    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self.view addGestureRecognizer:gr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panned:(UIPanGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            bool isPush = !self.myNavDel.myAnimator.isPush;
            self.myNavDel.myAnimator = [[InteractiveAnimator alloc] init];
            if (isPush) {
                self.myNavDel.myAnimator.isPush = true;
                NSLog(@"PUSH START");
                [self.navigationController pushViewController:[self getTargetVC] animated:YES];
            } else {
                self.myNavDel.myAnimator.isPush = false;
                NSLog(@"POP START");
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self.myNavDel.myAnimator updateInteractiveTransition:[self completionProgress:gestureRecognizer]];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"UIGestureRecognizerStateEnded");
            if ([self completionProgress:gestureRecognizer] >= 0.5) {
                [self.myNavDel.myAnimator finishInteractiveTransition];
            } else {
                [self.myNavDel.myAnimator cancelInteractiveTransition];
            }
//            self.myNavDel.myAnimator = nil;
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateCancelled/Failed");
            [self.myNavDel.myAnimator cancelInteractiveTransition];
//            self.myNavDel.myAnimator = nil;
            break;

        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
            
        default:
            NSAssert(false, @"da fick?");
            [self.myNavDel.myAnimator cancelInteractiveTransition];
//            self.myNavDel.myAnimator = nil;
            break;
    }
}

- (UIViewController*)getTargetVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"targetVC"];
    if( self.myNavDel.myAnimator.isPush )
        vc.view.backgroundColor = [UIColor blueColor];
    else
        vc.view.backgroundColor = [UIColor greenColor];
    return vc;
}

- (CGFloat)completionProgress:(UIPanGestureRecognizer *)gestureRecognizer {
 
    NSAssert(self.myNavDel.myAnimator, @"ERROR");
    CGFloat sign = UINavigationControllerOperationPush == self.myNavDel.myAnimator.isPush ? 1 : -1;
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    
    CGFloat completion = sign * translation.x / self.view.frame.size.width;
    
    NSLog(@"completion: %2f", completion);
    
    return MIN(1.0, completion);
}

- (IBAction)buttonPressed:(id)sender {
    NSLog(@"*** BUTTON PRESSED ***");
    [[[UIAlertView alloc] initWithTitle:@"Touch Received" message:@"Button pressed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


@end
