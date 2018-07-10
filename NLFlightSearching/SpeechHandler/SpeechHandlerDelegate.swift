//
//  SpeechHandlerDelegate.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 06.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import Speech

protocol SpeechHandlerDelegate: class {

    func speechHandler(_ speechHandler: SpeechHandler, accessibilityStatusDidChangeTo accessibility: SpeechHandlerStatus)

    func speechHandler(_ speechHandler: SpeechHandler, recognized text: String)

    func speechHandlerDidEndRecognizing(_ speechHandler: SpeechHandler, final text: String)
}
