//
//  PlaceModel.swift
//  TestDesign
//
//  Created by Ivan Chernetskiy on 02.03.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Foundation


struct PlaceModel {
    let name: String
    let description: String
    let image: String
    let coordinates: (Double, Double)
    var isSelected: Bool = false
}
