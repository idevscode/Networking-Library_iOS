//
//  UserUseCase.swift
//  CleanArchitectureExampleCode
//
//  Created by Dilshad Haidari on 16/12/25.
//


public struct ProductListUseCase {
    
    let userRepository: ProductRepository
    
    init(userRepository: ProductRepository){
        self.userRepository = userRepository
    }
    
    public func execute() async throws -> [Product] {
        return try await self.userRepository.getProductList()
    }
}

