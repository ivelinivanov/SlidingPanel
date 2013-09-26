//
//  ViewController.h
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelViewController.h"
#import "Constants.h"

@protocol SlidingPanelDelegate <NSObject>

- (void)panelDidSnapToGuide:(PanelGuide)guide;
- (void)panelWillSnapToGuide:(PanelGuide)guide;

@end

@interface SlidingPanelViewController : UIViewController <PanelViewControllerDelegate>

@property (weak, nonatomic) id<SlidingPanelDelegate> delegate;

@end
