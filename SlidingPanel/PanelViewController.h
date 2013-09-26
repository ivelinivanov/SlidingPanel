//
//  PanelViewController.h
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanelViewControllerDelegate <NSObject>

- (void)panelDidMoveTo:(CGFloat)xCoordinate;
- (void)panelDidSnapToLocation:(CGFloat)location;

@end

@interface PanelViewController : UIViewController

@property (weak, nonatomic) id<PanelViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *panelButton;
@property (weak, nonatomic) IBOutlet UIView *contentPanel;

@end
