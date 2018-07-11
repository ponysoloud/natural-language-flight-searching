//
//  SpeechRecognizer.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 06.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import Speech

class SpeechRecognizer {

    private let recognizer: SFSpeechRecognizer
    private let audioEngine: AVAudioEngine

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    var isAvailable: Bool {
        return recognizer.isAvailable
    }

    init(recognizer: SFSpeechRecognizer, audioEngine: AVAudioEngine) {
        self.recognizer = recognizer
        self.audioEngine = audioEngine
    }

    /**
     Begin speech recordering and recognizing it
    */
    func beginRecordering(_ handler: @escaping (_ isFinal: Bool,_ result: String) -> Void) throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechRecognizerError.sfSpeechAudioBufferRecognitionRequestCreationFailed
        }
        recognitionRequest.shouldReportPartialResults = true

        try setupAudioSession()

        let inputNode = audioEngine.inputNode
        var recorderedSpeech: String = ""

        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) {
            [weak self]
            result, error in

            guard let strongSelf = self else {
                return
            }

            var isFinal = false

            if let result = result {
                recorderedSpeech = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                strongSelf.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                strongSelf.recognitionRequest = nil
                strongSelf.recognitionTask = nil
            }

            handler(isFinal, recorderedSpeech)
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                                self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    /**
     Stop speech recordering
     */
    func stopRecordering() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }

    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()

        try audioSession.setCategory(AVAudioSession.Category.record,
                                     mode: AVAudioSession.Mode.measurement,
                                     options: .defaultToSpeaker)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
}

enum SpeechRecognizerError: Error {
    case sfSpeechAudioBufferRecognitionRequestCreationFailed
}
