//
//  NLLocationEnvironment.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

struct NLLocationEnvironment: NLTagEnvironment {

    var tagScheme: NLTagScheme {
        return .locationTypes
    }

    var tags: [NLTag] {
        return [.toLocation, .fromLocation]
    }

    var options: NLTagger.Options {
        return .omitWhitespace
    }

    var models: [URL]? {
        let modelURL = Bundle.main.url(forResource: "LocationTagger", withExtension: "mlmodelc")

        guard let url = modelURL else {
            return nil
        }

        return [url]
    }
}
