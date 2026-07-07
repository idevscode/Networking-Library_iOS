//
//  UseCaseFactory.swift
//  Networking-Library_iOS
//
//  Created by Dilshad Haidari on 07/07/26.
//

import Foundation

public actor UseCaseFactory {
    
    private let networkClient: NetworkClient
    
    public init(){
        self.networkClient = NetworkExecutor()
    }
    
    public func makeProductListUseCase() -> ProductListUseCase {
        let repository = AuthRepoImpl(networkClient: networkClient)
        return ProductListUseCase(userRepository: repository)
    }
    
}
