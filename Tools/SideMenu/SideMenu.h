//
//  SideMenu.h
//  SideMenuDemo
//
//  Created by Balram on 29/05/14.
//  Copyright (c) 2014 Balram Tiwari. All rights reserved.
//
//  侧边栏模糊菜单

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@class SideMenu;

@protocol SideMenuDelegate <NSObject>

@optional
-(void)SideMenu:(SideMenu *)menu didSelectItemAtIndex:(NSInteger)index;
-(void)SideMenu:(SideMenu *)menu selectedItemTitle:(NSString *)title;

@end

@interface UIView (bt_screenshot)
- (UIImage *)screenshot;

@end

@interface UIImage (bt_blurrEffect)
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
@end

@interface SideMenu : UIView<UITableViewDelegate, UITableViewDataSource> {
    @private
    UITableView *menuTable;
    CGFloat xAxis, yAxis,height, width;
    NSArray *titleArray;
    NSArray *imageArray;
    NSArray *itemsArray;
    BOOL isOpen;
    UITapGestureRecognizer *gesture;
    UISwipeGestureRecognizer *leftSwipe, *rightSwipe;
    UIImage *blurredImage;
    UIImageView *backGroundImage;
    UIImage *screenShotImage;
    UIImageView *screenShotView;
    
}

@property (nonatomic, retain) MenuItem *selectedItem;
@property(nonatomic, weak) id <SideMenuDelegate> delegate;

-(instancetype) initWithItem:(NSArray *)items addToViewController:(id)sender;
-(instancetype) initWithItemTitles:(NSArray *)itemsTitle addToViewController:(id)sender;
-(instancetype) initWithItemTitles:(NSArray *)itemsTitle andItemImages:(NSArray *)itemsImage addToViewController:(UIViewController *)sender;

-(void)show;
-(void)hide;
-(void)toggleMenu;
@end
