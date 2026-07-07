//
//  UserRepository.swift
//  CleanArchitectureExampleCode
//
//  Created by Dilshad Haidari on 16/12/25.
//



protocol ProductRepository {
    func getProductList() async throws -> [Product]
}



