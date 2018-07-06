//
//  KeywordsSearcher.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

class KeywordsSearcher {

    var locationTagger: NLLocationTagger?
    var dateTagger: NLDateTagger?

    func keywords(in text: String) -> KeywordsSearchResult {
        let locations = locationTagger?.keywords(in: text)
        //let dates = dateTagger?.keywords(in: text)

        let toLocations: [String]? = locations?[NLTag.toLocation]
        let fromLocations: [String]? = locations?[NLTag.fromLocation]

        //let numAndWordDates: [Date]? = dates?[NLTag.numberAndWordDate]

        return KeywordsSearchResult(naturalText: text, toLocation: toLocations, fromLocation: fromLocations, date: nil)
    }
}
