

import Foundation

class Variables {
    class var sharedVariables : Variables {
        struct Static {
            static let instance : Variables = Variables()
        }
        return Static.instance
    }
    
    var arrList : [NasiGirlsList] = []
    var isFromSignUp:Bool = false
    var arrayForResearchList = [String]()
}
