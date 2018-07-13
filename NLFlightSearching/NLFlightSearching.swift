//
//  NLFlightSearching.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 10.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

public enum NLFlightSearchingError: Error {
    case unsupportedLocale
    case speechHandlerInternalError
    case keywordsRecognizerInternalError
}

public enum NLFlightSearchingTag: Int, CaseIterable {
    case to = 0
    case from
    case when

    var nlTag: NLTag {
        switch self {
        case .to:
            return .toLocation
        case .from:
            return .fromLocation
        case .when:
            return .numberAndWordDate
        }
    }
}

public protocol NLFlightSearchingDelegate: class {

    func flightSearching(_ flightSearching: NLFlightSearching, speechHandlerStatusDidChangeTo status: SpeechHandlerStatus)

    func flightSearching(_ flightSearching: NLFlightSearching, speechRecognized text: String)

    func flightSearchingDidEndRecognizing(_ flightSearching: NLFlightSearching, speechRecognized text: String, extractedKeywords: [NLFlightSearchingTag:[String]])
}

public class NLFlightSearching: SpeechHandlerDelegate {

    public weak var delegate: NLFlightSearchingDelegate?

    public var keywords: [NLFlightSearchingTag: [String]] = [:]

    public var state: SpeechHandlerStatus {
        return speechManager.accessibilityStatus
    }

    private let speechManager: SpeechHandler
    private let keywordsManager: KeywordsRecognizer

    public init(locale: Locale = Locale.current) throws {
        do {
            self.speechManager = try SpeechHandler(locale: locale)

            self.keywordsManager = KeywordsRecognizer()

            let locationTagger = try NLLocationTagger(environment: NLLocationEnvironment())
            let dateTagger = try NLDateTagger(environment: NLDateEnvironment())
            self.keywordsManager.addTagger(locationTagger)
            self.keywordsManager.addTagger(dateTagger)

        } catch SpeechHandlerError.unsupportedLocale {
            throw NLFlightSearchingError.unsupportedLocale
        } catch SpeechHandlerError.speechRecorderingInternalError {
            throw NLFlightSearchingError.speechHandlerInternalError
        } catch {
            throw NLFlightSearchingError.keywordsRecognizerInternalError
        }

        self.speechManager.delegate = self
    }

    public func beginSpeechRecordering() throws {
        try speechManager.recordSpeech()

        self.keywords.removeAll()
    }

    public func stopSpeechRecordering() {
        speechManager.stopSpeech()
    }

    func speechHandler(_ speechHandler: SpeechHandler, accessibilityStatusDidChangeTo accessibility: SpeechHandlerStatus) {
        delegate?.flightSearching(self, speechHandlerStatusDidChangeTo: accessibility)
    }

    func speechHandler(_ speechHandler: SpeechHandler, recognized text: String) {
        delegate?.flightSearching(self, speechRecognized: text)
    }

    func speechHandlerDidEndRecognizing(_ speechHandler: SpeechHandler, final text: String) {
        let keywordsObject = keywordsManager.keywords(in: text)
        let keywords = keywordsObject.keywords

        var result: [NLFlightSearchingTag: [String]] = [:]

        NLFlightSearchingTag.allCases.forEach { tag in
            if let tagKeywords = keywords[tag.nlTag] {
                result[tag] = tagKeywords
            }
        }

        self.keywords = result

        delegate?.flightSearchingDidEndRecognizing(self, speechRecognized: text, extractedKeywords: result)
    }
}
