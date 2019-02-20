//
//  JsonModel.swift
//  Nuevo
//
//  Created by Buse ERKUŞ on 5.02.2019.
//  Copyright © 2019 Buse ERKUŞ. All rights reserved.
//

import Foundation
import UIKit

class JsonModel {
    
    var id : Int
    var title : String
    var image : String

    init(id : Int, title : String, image : String) {
        self.id = id
        self.title = title
        self.image = image
    }
   
}
