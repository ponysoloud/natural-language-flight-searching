//
//  NLLocationTagger.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

struct NLLocationTagger: NLCustomTagger {

    let tagger: NLTagger
    let environment: NLLocationEnvironment

    init(environment: NLLocationEnvironment) throws {
        self.environment = environment
        self.tagger = try NLTagger(environment: environment)
    }

    func keywords(in text: String) -> [NLTag: [String]] {
        var keywords: [NLTag: [String]] = [:]

        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                             unit: .word,
                             scheme: environment.tagScheme,
                             options: environment.options) { (tag, range) -> Bool in

                                if let t = tag, environment.tags.contains(t) {
                                    let keyword = String(text[range])

                                    if keywords.keys.contains(t) {
                                        keywords[t]!.append(keyword)
                                    } else {
                                        keywords[t] = [keyword]
                                    }
                                }

                                return true
        }

        return keywords
    }
}
