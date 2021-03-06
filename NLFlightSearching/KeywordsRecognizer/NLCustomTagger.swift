//
//  NLCustomTagger.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

protocol NLCustomTagger: NLKeywordsExtractable {

    associatedtype EnvironmentType: NLTagEnvironment

    init(environment: EnvironmentType) throws
}

protocol NLKeywordsExtractable {

    func keywords(in text: String) -> [NLTag: [String]]
}
