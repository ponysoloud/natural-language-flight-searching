//
//  NLFlightSearching.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 10.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

public enum FlightKeywordsTag {
    case toLocation
    case fromLocation
    case date
}

public class NLFlightSearching {

    public var keywords: [FlightKeywordsTag: [String]] = [:]

    private let speechManager: SpeechHandler
    private let keywordsManager: KeywordsRecognizer

    public init() {
        self.speechManager = try! SpeechHandler(locale: Locale(identifier: "ru-RU"))

        self.keywordsManager = KeywordsRecognizer()
        self.keywordsManager.locationTagger = try! NLLocationTagger(environment: NLLocationEnvironment())
    }

    public func beginSpeechRecordering() throws {
        try speechManager.recordSpeech()
    }

    public func stopSpeechRecordering() {
        speechManager.stopSpeech()
    }
}
