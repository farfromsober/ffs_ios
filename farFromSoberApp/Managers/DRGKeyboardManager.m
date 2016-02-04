//
//  DRGKeyboardManager.m
//  DRGKeyboardManager
//
//  Created by David Regatos on 15/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGKeyboardManager.h"

@interface DRGKeyboardManager ()

@property (nonatomic, readwrite) UIView *containerView;
@property (nonatomic, strong) NSNotificationCenter *nc;

@end

@implementation DRGKeyboardManager

#pragma mark - Init

+ (instancetype)managerForViewController:(UIViewController *)aViewController {
    return [[self alloc] initForViewController:aViewController];
}

- (instancetype)initForViewController:(UIViewController *)aViewController {
    if (self = [super init]) {
        _containerView = aViewController.view;
    }
    return self;
}

#pragma mark - Notification

- (void)beginObservingKeyboard:(NSNotificationCenter *)nc {
    
    self.nc = nc;
    
    [self.nc addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [self.nc addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    [self.nc addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [self.nc addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)endObservingKeyboard {
    
    [self.nc removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [self.nc removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self.nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [self.nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    self.nc = nil;
}

- (void)keyboardWasShown:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(keyboardManagerDidShowKeyboard:)]) {
        [self.delegate keyboardManagerDidShowKeyboard:self];
    }
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
    
    if ([self.delegate respondsToSelector:@selector(keyboardManagerWillShowKeyboard:)]) {
        [self.delegate keyboardManagerWillShowKeyboard:self];
    }

    if (self.containerView) {
        // get new size for the view
        CGRect newFrame = [self newFrameForKeyboardInfo:notification.userInfo];
        // animate the change
        double duration = [self keyboardAnimationDuration:notification.userInfo];
        [self resizeViewFrame:newFrame  withAnimationDuration:duration];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    if ([self.delegate respondsToSelector:@selector(keyboardManagerWillHideKeyboard:)]) {
        [self.delegate keyboardManagerWillHideKeyboard:self];
    }

    if (self.containerView) {
        // get new size for the view
        CGRect newFrame = [self newFrameForKeyboardInfo:notification.userInfo];
        // animate the change
        double duration = [self keyboardAnimationDuration:notification.userInfo];
        [self resizeViewFrame:newFrame  withAnimationDuration:duration];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(keyboardManagerDidHideKeyboard:)]) {
        [self.delegate keyboardManagerDidHideKeyboard:self];
    }
}

#pragma mark - Helpers

- (CGRect)newFrameForKeyboardInfo:(NSDictionary *)kbInfo {
    CGPoint kbOrigin = [[kbInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    CGRect newFrame = CGRectMake(0, 0, self.containerView.frame.size.width, kbOrigin.y);
    
    return newFrame;
}

#pragma mark - Animation

- (double)keyboardAnimationDuration:(NSDictionary *)kbInfo {
    return [[kbInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)resizeViewFrame:(CGRect)newFrame withAnimationDuration:(double)duration {
    [self.containerView setNeedsLayout];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.containerView.frame = newFrame;
                         [self.containerView layoutIfNeeded];
                     }];
}

@end
