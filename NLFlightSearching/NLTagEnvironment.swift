//
//  NLTagEnvironment.swift
//  NLFlightSearching
//
//  Created by Александр Пономарев on 05.07.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import NaturalLanguage

protocol NLTagEnvironment {

    var tagScheme: NLTagScheme { get }

    var tags: [NLTag] { get }

    var options: NLTagger.Options { get }

    var models: [URL]? { get }
}
