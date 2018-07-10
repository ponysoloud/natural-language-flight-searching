//
//  NLTagger+Extensions.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

enum NLTaggerError: Error {
    case mlModelInvalidUrl
}

extension NLTagger {

    convenience init(environment: NLTagEnvironment) throws {
        self.init(tagSchemes: [environment.tagScheme])

        guard let models = environment.models else {
            throw NLTaggerError.mlModelInvalidUrl
        }

        let urls = try models.map {
            try NLModel(contentsOf: $0)
        }

        self.setModels(urls, forTagScheme: environment.tagScheme)
    }
}

extension NLTagScheme {

    static let locationTypes: NLTagScheme = NLTagScheme("Location")

    static let dateTypes: NLTagScheme = NLTagScheme("Date")
}

extension NLTag {

    static let fromLocation: NLTag = NLTag("FROM_LOCATION")

    static let toLocation: NLTag = NLTag("TO_LOCATION")

    static let numberAndWordDate: NLTag = NLTag("DATE")
}
