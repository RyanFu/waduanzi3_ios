//
//  CDQButtonElement.m
//  waduanzi3
//
//  Created by chendong on 13-9-24.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDQButtonElement.h"
#import "CDQButtonTableViewCell.h"

@implementation CDQButtonElement


- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    CDQButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDQuickformButtonElement"];
    if (cell == nil){
        cell= [[CDQButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CDQuickformButtonElement"];
    }
    [cell applyAppearanceForElement:self];
    cell.textLabel.text = _title;
    cell.textLabel.textAlignment = self.appearance.buttonAlignment;
    cell.textLabel.font = self.appearance.labelFont;
    cell.textLabel.textColor = self.enabled ? self.appearance.actionColorEnabled : self.appearance.actionColorDisabled;
    return cell;
}

@end
