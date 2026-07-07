//
//  AuthRepository.swift
//  CleanArch
//
//  Created by Dilshad Haidari on 11/01/26.
//

import Foundation

class AuthRepoImpl: ProductRepository {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getProductList() async throws -> [Product] {
        do {
             let products : [ProductDTO]  = try await networkClient.execute("products")
            let productList = products.map { dto in
                dto.toEntity()
            }
            return productList
        } catch {
            throw error
        }
    }

}
