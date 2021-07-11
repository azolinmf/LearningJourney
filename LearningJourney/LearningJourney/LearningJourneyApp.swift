//
//  LearningJourneyApp.swift
//  LearningJourney
//
//  Created by Bruno Pastre on 23/06/21.
//

import SwiftUI

@main
struct LearningJourneyApp: App {
    
    private let libraryFeature = LibraryFeature<LibraryCoordinator>()
    
    private let appContainer = DefaultDependencyContainer()
    
    init() {
        #if DEBUG
        TokenCacheService().clear()
        #endif
        print(DefaultEnvironment.baseUrl)
        
        appContainer.register(
            factory: { ApiFactory() },
            for: ApiFactoryProtocol.self)
    }
    
    
    var body: some Scene {
        WindowGroup {
            libraryFeature
                .resolve()
                .authenticationSheet(assembler: LoginAssembler())
        }
    }
}
