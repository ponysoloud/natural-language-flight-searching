//
//  DialogTextAttributes.swift
//  NLFlightSearchingExample
//
//  Created by Александр Пономарев on 11.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class DialogTextViewAttributes {

    private(set) var attributes: [NSAttributedString.Key: Any] = {
        let font = UIFont.systemFont(ofSize: 20, weight: .light)
        return [.font: font]
    }()

    var left: DialogTextViewAttributes {
        let style = NSMutableParagraphStyle()
        style.alignment = .left

        attributes.merge([.paragraphStyle: style]) { $1 }

        return self
    }

    var right: DialogTextViewAttributes {
        let style = NSMutableParagraphStyle()
        style.alignment = .right

        attributes.merge([.paragraphStyle: style]) { $1 }

        return self
    }

    var bleached: DialogTextViewAttributes {
        let color = UIColor.white.withAlphaComponent(0.4)

        attributes.merge([.foregroundColor: color]) { $1 }

        return self
    }

    var bright: DialogTextViewAttributes {
        let color = UIColor.white

        attributes.merge([.foregroundColor: color]) { $1 }

        return self
    }
}
