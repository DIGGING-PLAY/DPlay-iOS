//
//  ProfileSettingViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

final class ProfileSettingViewModel {
    
    //MARK: - Properties
    
    private(set) var currentText: String = ""
    var onValidationStateChanged: ((NicknameValidationState) -> Void)?
}

extension ProfileSettingViewModel {
    
    //MARK: - Method
    
    func updateNicknameInputState(_ text: String) {
        currentText = text
        
        guard !text.isEmpty else {
            onValidationStateChanged?(.empty)
            return
        }
        
        do {
           let _ = try Nickname(text)
            onValidationStateChanged?(.normal)
        } catch let error as NicknameError {
            onValidationStateChanged?(.invalid(error))
        } catch {
            assertionFailure("Unhandled error: \(error)")
        }
    }
    
    func validateNicknameDuplicate(_ text: String) {
        // UseCase를 통해 닉네임 중복 검증 로직 호출 (추후 연결)
        
        if text == "중복" {
            onValidationStateChanged?(.invalid(.duplicate))
        } else {
            onValidationStateChanged?(.valid)
        }
    }
}
