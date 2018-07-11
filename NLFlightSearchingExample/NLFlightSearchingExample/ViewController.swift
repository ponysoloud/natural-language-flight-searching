//
//  ViewController.swift
//  NLFlightSearchingExample
//
//  Created by Александр Пономарев on 04.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit
import NLFlightSearching

enum RecorderingStatus {
    case recordering
    case ready
    case inaccesible
}

class ViewController: UIViewController, NLFlightSearchingDelegate {

    @IBOutlet var spokenTextView: DialogTextView!
    @IBOutlet var recordButton: UIButton!

    var flightSearching: NLFlightSearching?

    var recorderingStatus: RecorderingStatus = .inaccesible {
        didSet {
            switch recorderingStatus {
            case .inaccesible:
                recordButton.isEnabled = false
            default:
                recordButton.isEnabled = true
            }
        }
    }

    private var savedText: NSMutableAttributedString = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()

        //recordButton.isEnabled = false

        flightSearching = try! NLFlightSearching(locale: Locale(identifier: "ru-RU"))
        flightSearching!.delegate = self

        switch flightSearching!.state {
        case .ready, .requiresAuthorization:
            recorderingStatus = .ready
        case .recording:
            recorderingStatus = .recordering
        case .inaccessible:
            recorderingStatus = .inaccesible
        }

        self.spokenTextView.addMachine(phrase: "Здравствуйте. Нажмите на кнопку, чтобы начать поиск рейсов голосом")
    }

    /*
     "Record" button tap
     */
    @IBAction func recordTapped(_ sender: Any) {
        print("touch")

        switch recorderingStatus {
        case .ready:
            do {
                recordButton.setTitle("Stop", for: .normal)
                savedText = self.spokenTextView.getMutableString()
                try flightSearching?.beginSpeechRecordering()
            } catch {
                self.spokenTextView.addMachine(phrase: "Кажется возникла проблема с записью речи")
            }
        case .recordering:
            flightSearching?.stopSpeechRecordering()
            recordButton.setTitle("Speak", for: .normal)
        default:
            return
        }
    }

    func flightSearching(_ flightSearching: NLFlightSearching, speechHandlerStatusDidChangeTo status: SpeechHandlerStatus) {

        switch status {
        case .ready, .requiresAuthorization:
            recorderingStatus = .ready
        case .recording:
            recorderingStatus = .recordering
        case .inaccessible:
            recorderingStatus = .inaccesible
        }
    }

    func flightSearching(_ flightSearching: NLFlightSearching, speechRecognized text: String) {
        self.spokenTextView.reset(with: savedText)
        self.spokenTextView.addUser(phrase: text)
    }

    func flightSearchingDidEndRecognizing(_ flightSearching: NLFlightSearching, speechRecognized text: String, extractedKeywords: [NLFlightSearchingTag : [String]]) {

        print("Recognized \(text)")

        extractedKeywords.forEach { tag, keywords in
            if let word = keywords.first {
                self.spokenTextView.addMachine(phrase: "\(tag) \(word)")
            } else {
                self.spokenTextView.addMachine(phrase: "\(tag) -")
            }
        }
    }
}

