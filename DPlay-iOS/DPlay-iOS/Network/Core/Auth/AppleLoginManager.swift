//
//  AppleLoginManager.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/8/26.
//

import AuthenticationServices

final class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleLoginManager()
    
    private override init() {}
        
    var loginSuccess: ((String?) -> Void)?
    var loginFailure: ((Error) -> Void)?
    var loadAuthorizationCode: ((String?) -> Void)?
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleLoginManager {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userIdentityToken = appleIDCredential.identityToken ?? Data()
        let userIdentityTokenString = String(data: userIdentityToken, encoding: .utf8)
        
        loginSuccess?(userIdentityTokenString)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginFailure?(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { fatalError("No window is available") }
        return window
    }
}
