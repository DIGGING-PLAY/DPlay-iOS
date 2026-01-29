//
//  MockHomeFeed.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

//
//  MockHomeFeed.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/16/25.
//

import Foundation

enum MockHomeFeed {

    static let sample = HomeFeedResponseDTO(
        status: true,
        code: 2000,
        message: "요청이 성공했습니다.",
        data: HomeFeedDataDTO(
            questionId: 12345,
            title: "출근길에 꼭 듣는 노래는?",
            date: "2025-10-19",
            hasPosted: false,
            locked: true,
            totalCount: 257,
            items: [

                HomeFeedPostDTO(
                    postId: 111,
                    isScrapped: true,
                    content: "진짜 나오자마자 들었는데 이 노래가 최고 출근곡, 퇴근곡, 노동곡 다 되는 짱제로!",
                    badge: .editor,
                    track: HomeFeedTrackDTO(
                        trackId: "apple:1726888402",
                        songTitle: "Song Title",
                        coverImg: "https://picsum.photos/300/300",
                        artistName: "Artist1, Artist2"
                    ),
                    user: UserDTO(
                        userId: 222,
                        nickname: "윤서암",
                        profileImg: "https://picsum.photos/100"
                    ),
                    like: LikeDTO(
                        isLiked: false,
                        count: 24
                    )
                ),

                HomeFeedPostDTO(
                    postId: 133,
                    isScrapped: true,
                    content: "그냥 좋아요 이 노래 1",
                    badge: .best,
                    track: HomeFeedTrackDTO(
                        trackId: "apple:1726888402",
                        songTitle: "Song Title",
                        coverImg: "https://picsum.photos/300/300",
                        artistName: "Artist1, Artist2"
                    ),
                    user: UserDTO(
                        userId: 223,
                        nickname: "정정욱",
                        profileImg: "https://picsum.photos/100"
                    ),
                    like: LikeDTO(
                        isLiked: false,
                        count: 1224
                    )
                ),

                HomeFeedPostDTO(
                    postId: 121,
                    isScrapped: true,
                    content: "그냥 좋아요 이 노래 2",
                    badge: .new,
                    track: HomeFeedTrackDTO(
                        trackId: "apple:1726888402",
                        songTitle: "Song Title",
                        coverImg: "https://picsum.photos/300/300",
                        artistName: "Artist1, Artist2"
                    ),
                    user: UserDTO(
                        userId: 224,
                        nickname: "윤서암",
                        profileImg: "https://picsum.photos/100"
                    ),
                    like: LikeDTO(
                        isLiked: false,
                        count: 24
                    )
                ),

                HomeFeedPostDTO(
                    postId: 311,
                    isScrapped: true,
                    content: "배지 없는 케이스 (null)",
                    badge: nil,   // ⭐️ 서버에서 null 내려오는 경우
                    track: HomeFeedTrackDTO(
                        trackId: "apple:1726888402",
                        songTitle: "Song Title",
                        coverImg: "https://picsum.photos/300/300",
                        artistName: "Artist1, Artist2"
                    ),
                    user: UserDTO(
                        userId: 225,
                        nickname: "윤서암",
                        profileImg: "https://picsum.photos/100"
                    ),
                    like: LikeDTO(
                        isLiked: false,
                        count: 24
                    )
                )
            ]
        )
    )
}
