//
//  SpeechHandler.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 06.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import Speech

enum SpeechHandlerStatus {
    case requiresAuthorization
    case ready
    case recording
    case inaccessible
}

class SpeechHandler {

    weak var delegate: SpeechHandlerDelegate?

    private let recognizer: SpeechRecognizer
    private(set) var accessibilityStatus: SpeechHandlerStatus = .inaccessible {
        didSet {
            delegate?.speechHandler(self, accessibilityStatusDidChangeTo: accessibilityStatus)
        }
    }

    init(locale: Locale = Locale.current) throws {
        guard let speechRecognizer = SFSpeechRecognizer(locale: locale) else {
            throw SpeechRecognizerError.unsupportedLocale
        }
        self.recognizer = SpeechRecognizer(recognizer: speechRecognizer,
                                           audioEngine: AVAudioEngine())
        setAccessibilityStatus()
    }

    func recordSpeech() throws {
        switch accessibilityStatus {
        case .requiresAuthorization:
            requestAuthorization()
        case .ready:
            accessibilityStatus = .recording

            try recognizer.beginRecordering {
                [weak self]
                isFinal, text in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.delegate?.speechHandler(strongSelf, recognized: text)

                if isFinal {
                    strongSelf.accessibilityStatus = .ready
                    strongSelf.delegate?.speechHandlerDidEndRecognizing(strongSelf, final: text)
                }
            }
        default:
            return
        }
    }

    func stopSpeech() {
        switch accessibilityStatus {
        case .recording:
            recognizer.stopRecordering()
            accessibilityStatus = .ready
        default:
            return
        }
    }

    private func requestAuthorization() {
        guard accessibilityStatus == .requiresAuthorization else {
            return
        }

        SFSpeechRecognizer.requestAuthorization {
            [weak self]
            status in

            OperationQueue.main.addOperation {
                guard let strongSelf = self else {
                    return
                }

                strongSelf.setAccessibilityStatus()
            }
        }
    }

    private func setAccessibilityStatus() {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            if accessibilityStatus != .recording {
                accessibilityStatus = .ready
            }
        default:
            accessibilityStatus = .requiresAuthorization
        }
    }
}

