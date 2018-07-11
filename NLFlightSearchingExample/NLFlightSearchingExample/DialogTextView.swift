//
//  DialogTextView.swift
//  NLFlightSearchingExample
//
//  Created by Александр Пономарев on 11.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

/*
 Custom UITextView for easy adding User and Machine phrases according
 to the attributed string styles
 */
class DialogTextView: UITextView {

    /*
     Reset textView data with given text: NSMutableAttributedString,
     that can be got from getMutableString() function
     */
    func reset(with text: NSMutableAttributedString) {
        attributedText = text
    }

    /*
     Get current textView data as NSMutableAttributedString
     */
    func getMutableString() -> NSMutableAttributedString {
        return attributedText.mutableCopy() as! NSMutableAttributedString
    }

    /*
     Bleach all current textView data
     */
    func bleachPrevious() {
        let mutable = getMutableString()
        let range = NSRange(0..<mutable.length)
        mutable.addAttributes(DialogTextViewAttributes().left.bleached.attributes, range: range)

        attributedText = mutable
    }

    /*
     Add machine phrase to the textView
     */
    func addMachine(phrase: String) {
        var string = "\n"
        string.append(phrase)
        string.append("\n")

        let attrString = NSMutableAttributedString(string: string, attributes: DialogTextViewAttributes().left.bright.attributes)

        let temp = NSMutableAttributedString()
        temp.append(attributedText)
        temp.append(attrString)

        attributedText = temp

        scrollToBottom()
    }


    /*
     Add user phrase to the textView
     */
    func addUser(phrase: String) {
        bleachPrevious()

        var string = "\n\""
        string.append(phrase)
        string.append("\"\n")

        let attrString = NSMutableAttributedString(string: string, attributes: DialogTextViewAttributes().right.bright.attributes)

        let temp = NSMutableAttributedString()
        temp.append(attributedText)
        temp.append(attrString)

        attributedText = temp

        scrollToBottom()
    }


    /*
     Scroll view to bottom
     */
    func scrollToBottom() {
        let range = NSMakeRange(text.count - 1, 0)
        scrollRangeToVisible(range)
    }
}
