//
//  Constant.swift
//  NasiShadchanHelper
//
//  Created by user on 5/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation
import UIKit

class Constant {
    
    //The type of pick list. One of:
    struct CategoryTypeName {
        static let kPredicateString1 = "FTL"
        static let kPredicateString2 = "FTL+PTL+FTC"
        static let kPredicateString3 = "FTL+PTL"
        static let kCategoryString0 = "FTC"
        static let kCategoryString1 = "PTL+FTC"
        static let kCategoryString3 = "PTL"
    }
    
    struct ValidationMessages {
        //MARK: Alert Titles
        public static let oopsTitle = "Oops...!"
        public static let sorryTitle = "Sorry...!"
        public static let successTitle = "Successful...!"
        
        public static let msgDocumentUrlEmpty = "Document url is empty"
        
        //MARK: Alerts
        public static let msgEmailEmpty = "Please enter your Email"
        public static let msgSentPassword = "Password recovery link sent on your email"
        public static let msgEmailInvalid = "Please enter a valid registered email"
        
        public static let msgNotesEmpty = "Please enter a note"
    }
    
    struct AppFont {
        static let fontRegular = "GillSans"
        static let fontLight = "GillSans-Light"
        static let fontBold = "GillSans-Bold"
        static let fontSemibold = "GillSans-Semibold"
    }
    
    struct AppFontHelper {
        static func defaultRegularFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: AppFont.fontRegular, size: size)!
        }
        static func defaultBoldFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: AppFont.fontBold, size: size)!
        }
        static func defaultSemiboldFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: AppFont.fontSemibold, size: size)!
        }
        static func defaultLightFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: AppFont.fontLight, size: size)!
        }
    }
    
    struct AppRootFlow {
        static let kEnterApp = "enterApp"
        static let kAuthVc  = "AuthNavViewController"
    }
    
    struct AppColor {
        static let colorAppTheme = UIColor.withHex(hex: "36A0A0", alpha: 1.0)
        static let colorGrey = UIColor.withHex(hex: "3C3C43", alpha: 1.0)
    }
    
    struct EventNotifications {
        static let notifRemoveFromFav = Notification.Name("RemoveFromFav")
    }
}

