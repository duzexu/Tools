//
//  UITextField+Shake.h
//  UITextField+Shake
//
//  Created by Andrea Mazzini on 08/02/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//
//  给 UITextField 加上抖动效果


@interface UITextField (Shake)

/**-----------------------------------------------------------------------------
 * @name UITextField+Shake
 * -----------------------------------------------------------------------------
 */

/** Shake the UITextField
*
* Shake the text field a given number of times
*
* @param times The number of shakes
* @param delta The width of the shake
*/
- (void)shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval;

@end
