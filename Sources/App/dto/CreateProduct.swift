//
//  File.swift
//  
//
//  Created by Bartosz Krawiec on 07/01/2022.
//

import Vapor
import Foundation



struct CreateProduct: Content {
    let title: String
    let description: String
    let image: String
    let quantity: Int
    let kategoria_id: UUID
}
