//
//  NLDateEnvironment.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

struct NLDateEnvironment: NLTagEnvironment {

    var tagScheme: NLTagScheme {
        return .dateTypes
    }

    var tags: [NLTag] {
        return [.numberAndWordDate]
    }

    var options: NLTagger.Options {
        return .omitWhitespace
    }

    var models: [URL]? {
        guard
            let bundle = Bundle(identifier: "com.baseteam.NLFlightSearching"),
            let url = bundle.url(forResource: "FlightsTagger", withExtension: "mlmodelc") else {
                return nil
        }

        return [url]
    }
}
