//
//  ComplicationController.swift
//  MyWeight
//
//  Created by Bruno Koga on 11/01/2018.
//  Copyright © 2018 Diogo Tridapalli. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource  {
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler(.forward)
        
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        handler(nil)
    }
}
