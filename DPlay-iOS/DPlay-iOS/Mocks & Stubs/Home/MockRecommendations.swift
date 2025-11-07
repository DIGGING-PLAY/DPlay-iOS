//
//  MockRecommendations.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

enum MockRecommendations {
    
    static let today: [Recommendation] = [
        Recommendation(
            id: 1,
            userName: "윤서얌",
            songTitle: "내일에서 온 티켓",
            artist: "한로로",
            comment: "진짜 나오자마자 들었는데 이 노래가 최고! 출근곡, 퇴근곡, 노동곡 다 되는 짱곡!",
            likeCount: 53,
            isScrapped: false
        ),
        Recommendation(
            id: 2,
            userName: "지우",
            songTitle: "밤양갱",
            artist: "비비",
            comment: "새벽 감성 충만할 때 듣기 좋아요 🌙",
            likeCount: 27,
            isScrapped: true
        ),
        Recommendation(
            id: 3,
            userName: "현아",
            songTitle: "오르트구름",
            artist: "윤하",
            comment: "오늘도 하늘 위로 🌤️",
            likeCount: 91,
            isScrapped: false
        ),
        Recommendation(
            id: 4,
            userName: "정욱",
            songTitle: "Still Life",
            artist: "BIGBANG",
            comment: "가을엔 이 노래죠 🍂",
            likeCount: 77,
            isScrapped: false
        )
    ]
}

