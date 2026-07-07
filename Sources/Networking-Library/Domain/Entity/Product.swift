
//
//  Untitled.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 07/07/26.
//

import Foundation

public struct Product {
    public let id: Int
    public let title: String
    public let slug: String
    public let price: Int
    public let description: String
    public let category: Category
    public let images: [String]
}

public struct Category {
    public let id: Int
    public let name: String
    public let slug: String
    public let image: String
}
