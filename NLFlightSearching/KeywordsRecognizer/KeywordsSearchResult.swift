//
//  KeywordsSearchResult.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

struct KeywordsRecognizingResult {

    let naturalText: String

    let keywords: [NLTag: [String]]
    
}
