//
//  Constants.h
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/26/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#ifndef SlidingPanel_Constants_h
#define SlidingPanel_Constants_h

typedef NS_ENUM(NSUInteger, PanelGuide)
{
    PGPanelFullyShown = 0,
    PGPanelShownSecondStage,
    PGPanelShownFirstStage,
    PGPanelHidden
};

extern CGFloat const kEndSlideOffset;

#endif
