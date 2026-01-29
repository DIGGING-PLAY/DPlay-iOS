//
//  AppleLoginManager.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/8/26.
//

import AuthenticationServices

enum AppleLoginType {
    case initialLogin
    case getAuthorizationCode
}

final class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleLoginManager()
    
    private override init() {}
    
    var loginType: AppleLoginType?
    
    var loginSuccess: ((String?) -> Void)?
    var loginFailure: ((Error) -> Void)?
    var loadAuthorizationCode: ((String?) -> Void)?
    
    /// Apple 최초 로그인 (또는 일반 로그인) 요청
    func appleLogin() {
        loginType = .initialLogin
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        // requestedOperation 기본값(.operationLogin)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// Apple 회원 탈퇴(연결 해제)용 Authorization Code 요청
    /// Apple ID와 앱 간 연결 해제(회원 탈퇴)를 위한 authorizationCode 발급 -> 서버에서 Apple Revoke API 호출에 사용
    func getAuthorizationCode() {
        loginType = .getAuthorizationCode
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogout
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleLoginManager {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        switch loginType {
        case .initialLogin:
            let userIdentityToken = appleIDCredential.identityToken ?? Data()
            let userIdentityTokenString = String(data: userIdentityToken, encoding: .utf8)
            
            loginSuccess?(userIdentityTokenString)
        case .getAuthorizationCode:
            let authorizationCode = appleIDCredential.authorizationCode ?? Data()
            let authorizationCodeString = String(data: authorizationCode, encoding: .utf8)
            
            loadAuthorizationCode?(authorizationCodeString)
        default:
            break
        }
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
