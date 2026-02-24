

# iOS Code Convention (DPlay)

이 문서는 DPlay iOS 팀의 최소 코드 컨벤션입니다.  
목표는 "완벽함"이 아니라 "일관성"입니다.

---

# 1. 기본 원칙

## 1.1 Swift 스타일

- Swift API Design Guidelines를 따른다.
- 의미가 명확한 네이밍을 사용한다.
- 축약어는 최소화한다.
- force unwrap(!)은 사용하지 않는다.
- try! 사용 금지.
- 암시적 옵셔널(Implicitly Unwrapped Optional) 사용 금지.

---

## 1.2 코드 가독성

- guard + early return을 우선 사용한다.
- 중첩 depth는 3단계를 넘지 않도록 한다.
- MARK 주석으로 영역을 구분한다.

```swift
// MARK: - Properties
// MARK: - Lifecycle
// MARK: - Binding
// MARK: - Actions
````

* 한 파일은 500줄을 넘지 않도록 권장한다.

---

# 2. 아키텍처 원칙

DPlay는 Clean Architecture 기반으로 개발한다.

```
Presentation
  ├─ View
  ├─ ViewModel
Domain
  ├─ UseCase
  ├─ Entity
Data
  ├─ Repository
  ├─ Network
```

## 2.1 책임 분리

* ViewController는 UI 책임만 가진다.
* ViewModel은 상태 관리와 이벤트 처리만 담당한다.
* 비즈니스 로직은 UseCase에 위치한다.
* 네트워크 로직은 Repository에서만 처리한다.

---

## 2.2 의존성

* 상위 계층이 하위 계층을 직접 참조하지 않는다.
* Repository는 Protocol 기반 DI를 사용한다.
* 싱글톤 사용은 최소화한다.

---

# 3. 메모리 관리

* 클로저 내부에서는 기본적으로 [weak self]를 사용한다.
* strong self가 필요한 경우 이유를 명확히 한다.
* NotificationCenter 등록 시 반드시 제거한다.
* delegate는 weak으로 선언한다.

---

# 4. 동시성 규칙

## 4.1 async/await 우선

* 새로운 비동기 로직은 async/await을 우선 사용한다.
* Task 내부에서 UI 업데이트 시 @MainActor를 명시한다.

## 4.2 취소 처리

* 네트워크 요청은 취소 가능해야 한다.
* TaskGroup 사용 시 cancelAll 여부를 고려한다.

## 4.3 Combine 혼용

* Combine과 async/await 혼용 시 책임을 명확히 분리한다.
* ViewModel 내부에서만 Combine 사용을 권장한다.

---

# 5. 네트워크 & 토큰 관리

* Authorization 헤더는 Interceptor에서만 처리한다.
* Token Refresh는 단일 흐름으로 제어한다.
* 네트워크 에러는 공통 에러 타입으로 변환한다.
* API 호출 시 실패 케이스를 반드시 고려한다.

---

# 6. PR 규칙

* 기능 PR에는 버전 변경을 포함하지 않는다.
* 버전 변경은 Release 브랜치에서만 수행한다.
* PR 제목은 팀 컨벤션을 따른다.
* 불필요한 리팩토링은 별도 PR로 분리한다.

---

# 7. 우리가 지향하는 코드

* 읽기 쉬운 코드
* 테스트 가능한 코드
* 확장 가능한 코드
* 예측 가능한 상태 흐름

완벽한 코드보다 "일관된 코드"를 목표로 한다.
