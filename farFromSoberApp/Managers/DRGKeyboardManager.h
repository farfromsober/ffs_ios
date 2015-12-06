//
//  DRGKeyboardManager.h
//  DRGKeyboardManager
//
//  Created by David Regatos on 15/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

/** 
 
 DESCRIPTION:
 
 This a simple manager that resizes the viewController.view
 when a keyboard appears or disappears. The change is animated
 and synchronized with keyboard's animation.
 
 DISCUSSION:
 
 The idea is to resize the viewController's container view using an animation.
 Since we are resizing the superview, this manager works perfectly with
 UITableViews, UICollectionViews and UIScrollViews (scrollable views in general).
 This is because we are not modifying the scrollview's contentView,
 only its superview (the view that contains the scrollview).
 
 IMPORTANT ISSUES:
 
 - If your viewController doesn't contain an scrollable view, then you are 
 responsible to ensure that your UI looks great after its superview was resized.
 You can use its delegate's methods to make changes in the layout, adapting
 it to the new size.
 
 - About scrollable views. After resizing their superview, these automatically
 adjust their scroll in order to make visible the active field.
 However, you can always adjust manually the view's scroll after the animation 
 was finished. Take a look at the sample project.
 
 - viewController's width view will never change.
 
 */

@import UIKit;

@class DRGKeyboardManager;

/** 
    DRGKeyboardManagerDelegate notifies four events to its delegate:
 
        1. Keyboard will be shown (optional).
        2. Keyboard was shown.
        3. Keyboard will be hidden (optional).
        4. Keyboard was hidden.
 
    NOTE: The animation happens after keyboard will be shown/hidden and
    before keyboard was shown/hidden. So, the optional methods are the 
    perfect place to prepare your VC before the animation begins (for 
    instance, hidding some elements to focus the attention on the active
    field), minewhile the mandatory ones are perfect to do something after
    the animation was finished (for instance, to scroll the view or to
    undo the changes made before the animation occurs).
 
 */
@protocol DRGKeyboardManagerDelegate <NSObject>

// after containerView was resized
- (void)keyboardManagerDidShowKeyboard:(DRGKeyboardManager *)kbManager;
- (void)keyboardManagerDidHideKeyboard:(DRGKeyboardManager *)kbManager;

@optional
// before containerView was resized
- (void)keyboardManagerWillShowKeyboard:(DRGKeyboardManager *)kbManager;
- (void)keyboardManagerWillHideKeyboard:(DRGKeyboardManager *)kbManager;

@end

@interface DRGKeyboardManager : NSObject

@property (nonatomic, weak) id<DRGKeyboardManagerDelegate> delegate;

/** The VC's view that will be resized. Set during initialization. Readonly */
@property (nonatomic, readonly) UIView *containerView;

/** Initializers. @param(aView) = VC's superview, i.e. its self.view */
+ (instancetype)managerForViewController:(UIViewController *)aViewController;
- (instancetype)initForViewController:(UIViewController *)aViewController;

/** (Un)register for UIKeyboard notifications */
- (void)beginObservingKeyboard:(NSNotificationCenter *)nc;
- (void)endObservingKeyboard;

@end
