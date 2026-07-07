//
//  Product.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 07/07/26.
//


import Foundation

typealias ProductsResponse = [ProductDTO]

struct ProductDTO: Codable, Sendable {
    let id: Int
    let title: String
    let slug: String
    let price: Int
    let description: String
    let category: CategoryDTO
    let images: [String]
    let creationAt: String
    let updatedAt: String
    
    
}

struct CategoryDTO: Codable {
    let id: Int
    let name: String
    let slug: String
    let image: String
    let creationAt: String
    let updatedAt: String
    
    func toEntity() -> Category {
        return Category(id: id,
                        name: name,
                        slug: slug,
                        image: image
        )
    }
}

extension ProductDTO {
    func toEntity() -> Product {
        return Product(
            id: id,
            title: title,
            slug: slug,
            price: price,
            description: description,
            category: category.toEntity(),
            images: images
        )
    }
}
