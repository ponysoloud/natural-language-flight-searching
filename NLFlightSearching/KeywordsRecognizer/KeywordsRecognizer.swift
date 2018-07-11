//
//  KeywordsRecognizer.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

class KeywordsRecognizer {

    private var taggers: [NLKeywordsExtractable] = []

    func addTagger<Tagger: NLCustomTagger>(_ tagger: Tagger) {
        taggers.append(tagger)
    }

    func keywords(in text: String) -> KeywordsRecognizingResult {
        var keywords: [NLTag: [String]] = [:]

        taggers.forEach {
            let taggerKeywords = $0.keywords(in: text)

            keywords.merge(taggerKeywords) { current, new in
                current + new
            }
        }

        return KeywordsRecognizingResult(naturalText: text, keywords: keywords)
    }
}
