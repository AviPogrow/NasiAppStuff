//
//  Config.swift
//  NasiShadchanHelper
//
//  Created by user on 4/26/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation


func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
/*
the value is 0:
the value is 1:4/5/2020 16:03:49
the value is 2:hdiamond@ilanhigh.org
the value is 3:Levi
the value is 4:Chaya Esther
the value is 5:732-330-3551
the value is 6:9/28/1993
the value is 7:Lakewood
the value is 8:New Jersey
the value is 9:08701
the value is 10:5
the value is 11:6
the value is 12:Yes
the value is 13:Learning does not need a plan
the value is 14:1-3 year learner
the value is 15:done
the value is 16:Need koveah ittim
the value is 17:Nachlas
the value is 18:Yeshivish
the value is 19:Chaya Esther is looking for a responsible boy who will take his yiddishkeit seriously. He should be intelligent and see his family as his primary responsibility . What he does and his background is less important than his middos and personality.
the value is 20:Chaya Esther is a bright, outgoing girl who has many creative  talents. She has ideas and opinions and enjoys meeting people and hearing their ideas. She is a resilient girl who handles life’s challenges with aplomb. She is a low maintenance girl who always looks beautiful and put together.  She is very flexible and ok with various backgrounds and types.
the value is 21:Turin
the value is 22:Shulamis
the value is 23:Sturin@gmail.com
the value is 24:7327255225
the value is 25:would like to/ open to- but not a deal breaker
the value is 26:Yes
the value is 27:Yes
the value is 28:Does not need professional track
the value is 29:Does not need proffesional track
the value is 30:
the value is 31:Lost her mother
the value is 32:Living with uncle/aunt
the value is 33:Yeshiva  and College/Working
the value is 34:26.6
the value for height: 5"6' imageName: ChayaEstherLevifor proTrackDoes not need proffesional trackfor planLearning does not need a plan
(lldb)
*/
