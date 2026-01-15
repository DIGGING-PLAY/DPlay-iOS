//
//  AudioPlayerManager.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import AVFoundation
import Combine
import UIKit

@MainActor
final class AudioPlayerManager {

    // MARK: - Singleton

    static let shared = AudioPlayerManager()

    // MARK: - Player

    private var player: AVPlayer?
    private var itemEndObserver: Any? // 음악이 끝난 이벤트를 받기 위함
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State (외부 구독)

    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var currentTrackId: String?
    @Published private(set) var currentSessionId: String?
    @Published private(set) var currentPlayId: UUID?

    private init() {
        configureAudioSession()
        observeInterruption()
        observeAppLifecycle()
    }
}

// MARK: - Audio State (오디오 상태 관리)
extension AudioPlayerManager {

    /// 미리듣기 재생
    func playPreview(
        sessionId: String,
        trackId: String,
        streamURL: URL,
        playId: UUID?
    ) {
        
        // 1. 같은 셀에서 다시 재생 버튼을 누른 경우 - 재생, 멈춤 제어
        //    - trackId + playId가 모두 같은 경우
        //    - 동일한 트랙을 여러 셀이 가질 수 있기 때문에 playId로 UI 출처를 구분
        if currentTrackId == trackId,
           currentPlayId == playId {

            if isPlaying {
                stopInternal()
            } else {
                player?.play()
                isPlaying = true
            }
            return
        }

        // 2. 다른 셀에서 재생 버튼을 누른 경우
        //    - 기존 재생 음악을 무조건 종료하고
        //    - 새 음악을 즉시 재생 (전환 재생)
        stopInternal()
        
        isPlaying = false

        let item = AVPlayerItem(url: streamURL) // URL기반 재생할 아이템을 만듬

        // 플레이어가 있으면 갈아끼우고, 없으면 만든다
        if let player {
            player.replaceCurrentItem(with: item)
        } else {
            player = AVPlayer(playerItem: item)
        }
        
        // 트랙을 재생 중인지 기록
        currentTrackId = trackId
        currentSessionId = sessionId
        currentPlayId = playId
        
        // 재생 아이템의 생명주기를 감시한다
        observeItemEnd(item)
        observeItemStatus(item)

        player?.play()
    }

    /// 일시정지
    func pause() {
        player?.pause()
        isPlaying = false
    }

    /// 재개
    func resume() {
        guard player != nil else { return }
        player?.play()
        isPlaying = true
    }

    /// 외부에서 호출하는 완전 중지
    func stop() {
        stopInternal()
    }
}

// MARK: - Internal Handling

private extension AudioPlayerManager {
    
    /// 아이템 로딩 상태 감지 (readyToPlay)
    /// 즉 재생 아이템 상태를 구독해서 상태가 readyToPlay 준비 완료면 재생 상태로 값을 변경
    /// 이건 Cell 쪽 앨범 회전과 관련 있음  isPlaying 이 값을 구독해서 회전중임
    func observeItemStatus(_ item: AVPlayerItem) {
        item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    self?.isPlaying = true

                case .failed:
                    self?.stopInternal()

                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    /// 아이템 재생 종료 감지
    /// AVPlayerItemDidPlayToEndTime로 아이템 재생이 끝난 이벤트를 발생 시킴
    func observeItemEnd(_ item: AVPlayerItem) {
        if let observer = itemEndObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        itemEndObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.stopInternal()
        }
    }
    
    /// 재생 종료의 단일 진입점
    /// 재생 실패, 재생 끝, 백그라운드 진입, 전화 수신 등 다 여기가 종착점
    func stopInternal() {
        // 이전 곡의 종료 감지 등록을 확실히 해제
        if let observer = itemEndObserver {
            NotificationCenter.default.removeObserver(observer)
            itemEndObserver = nil
        }

        cancellables.removeAll()

        player?.pause()
        player?.replaceCurrentItem(with: nil)

        isPlaying = false
        currentTrackId = nil
        currentSessionId = nil
        currentPlayId = nil
    }
}

// MARK: - Audio Session 설정 System Events 구독

private extension AudioPlayerManager {

    /// 오디오 세션 설정
    /// iOS 시스템에게 설정을 하는 것 해당 앱에 오디오 플레이어 설정 하겠다.
    /// playback 사용시 무음모드 무시, 허용시 백그라운드 재생 가능
    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true) // 해당 앱이 오디오 주도권을 가질것이다.
        } catch {
            print("❌ AudioSession 설정 실패:", error)
        }
    }

    /// 앱 라이프사이클
    /// 앱 백그라운드, 앱 프로세스 종료 직전 이벤트를 구독
    func observeAppLifecycle() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    /// 전화 / Siri / 알림 등 인터럽트 이벤트 구독
    func observeInterruption() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }
}

@objc private extension AudioPlayerManager {
    
    //MARK: - @objc Method
    
    
    @objc func appDidEnterBackground() {
        // 미리듣기는 백그라운드 재생 안함
        stopInternal()
    }

    @objc func appWillTerminate() {
        stopInternal()
    }
    
    /// 외부 방해가 시작시 음악 멈춤, 끝나면 음악 종료
    @objc func handleInterruption(notification: Notification) {
        guard
            let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }
        switch type {
        case .began:
            pause()
        case .ended:
            stopInternal()
        @unknown default:
            break
        }
    }
}

// MARK: - 초기 셋팅
extension AudioPlayerManager {

    /// 앱 최초 진입 시 오디오 세션을 미리 활성화해
    /// 첫 재생 시 발생하는 UI hang을 줄이기 위한 셋팅
    func prepareAudioSession() {
        DispatchQueue.global(qos: .utility).async {
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .default)
            
            //준비 결과는 iOS 내부에 캐시되서
            // 다음에 setActive(true) 할 땐 훨씬 빨라서 UI 멈춤 사라짐
            try? session.setActive(true)
            try? session.setActive(false)
        }
    }
}
