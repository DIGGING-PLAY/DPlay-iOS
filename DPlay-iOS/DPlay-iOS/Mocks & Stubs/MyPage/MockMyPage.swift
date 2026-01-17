//
//  MockMyPage.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

enum MockMyPage {
    static let profileSample = MyPageProfileResponseDTO(
        status: true,
        code: 2000,
        message: "요청이 성공했습니다.",
        data: MyPageProfileDataDTO(
            user: MyPageUserDTO(
                userId: 1,
                nickname: "조리",
                profileImg: "https://i.pinimg.com/474x/52/4d/bf/524dbf475995b70c42184c652b833c8b.jpg"
            ),
            isHost: true,
            pushOn: true,
            postTotalCount: 10
        )
    )
    
    static let registeredTracksSample = MyPageTracksResponseDTO(
        status: true,
        code: 2000,
        message: "요청이 성공했습니다.",
        data: MyPageTracksDataDTO(
            visibleLimit: 10,
            totalCount: 10,
            nextCursor: nil,
            isHost: true,
            items: [
                MyPageTrackItemDTO(
                    postId: 1,
                    track: MyPageTrackDTO(
                        trackId: "apple:1703196825",
                        songTitle: "사랑하게 될 거야",
                        coverImg: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/c2/ef/87/c2ef8779-f3bb-5a1c-ef6f-c27185e62446/8809936067307.jpg/512x512bb.jpg",
                        artistName: "한로로"
                    ),
                    content: "한로로노래임"
                ),
                MyPageTrackItemDTO(
                    postId: 2,
                    track: MyPageTrackDTO(
                        trackId: "apple:1726888402",
                        songTitle: "Love wins all",
                        coverImg: "https://i.namu.wiki/i/3tZAlvVSSiXFk_hj5s6UD_qLfMS7MMBwM8o93FumB2nojn-6mm25Ovoihnj48IzYI3bSZY_EWKA_jB0foDThVQ.webp",
                        artistName: "아이유"
                    ),
                    content: "아이유 최고"
                ),
                MyPageTrackItemDTO(
                    postId: 3,
                    track: MyPageTrackDTO(
                        trackId: "apple:1726888434",
                        songTitle: "ㅈㅣㅂ",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/206447/20644751.jpg",
                        artistName: "한로로"
                    ),
                    content: "저쪽 집에 불이 났다고 해서 구경하러 갔죠 그런데 보고 오니 우리 집에 불이 난거예요 보자마자 눈물이 났어요"
                ),
                MyPageTrackItemDTO(
                    postId: 4,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "개와 수돗물",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40905/4090599.jpg",
                        artistName: "쏜애플"
                    ),
                    content: "앙앙! 멘헤라 견과 수돗물"
                ),
                MyPageTrackItemDTO(
                    postId: 5,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "PINKTOP",
                        coverImg: "https://postfiles.pstatic.net/MjAyMTA1MjdfMjA4/MDAxNjIyMTE3NDA3NDUz.O95ruz0Ij8uRVe8bSOQ6_-W2sYIVVUYJJSUiKVnZDrIg.rku_esoSmtHYPswzDYXu-vnRFdqwlOiEeqCrc6x-fSYg.JPEG.ekek9812/IMG_0814.jpg?type=w773",
                        artistName: "The Volunteers"
                    ),
                    content: "핑크색 좋아하세요?저는 ...좋아...하..."
                ),
                MyPageTrackItemDTO(
                    postId: 6,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "플랑크톤",
                        coverImg: "https://image.bugsm.co.kr/album/images/200/3563/356344.jpg?version=20240702024304",
                        artistName: "쏜애플"
                    ),
                    content: "플랑크톤의 집게리아 레시피 훔치기"
                ),
                MyPageTrackItemDTO(
                    postId: 7,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는"
                ),
                MyPageTrackItemDTO(
                    postId: 8,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는"
                ),
                MyPageTrackItemDTO(
                    postId: 9,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는"
                ),
                MyPageTrackItemDTO(
                    postId: 10,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는"
                )
            ]
        )
    )
    
    static let archiveTracksSample = MyPageTracksResponseDTO(
        status: true,
        code: 2000,
        message: "요청이 성공했습니다.",
        data: MyPageTracksDataDTO(
            visibleLimit: 13,
            totalCount: 13,
            nextCursor: nil,
            isHost: true,
            items: [
                MyPageTrackItemDTO(
                    postId: 1,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "시간을 달리네",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/207447/20744778.jpg",
                        artistName: "한로로"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 2,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "한계",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/204200/20420099.jpg",
                        artistName: "백예린"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 3,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 4,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Summer",
                        coverImg: "https://postfiles.pstatic.net/MjAyMTA1MjdfMjA4/MDAxNjIyMTE3NDA3NDUz.O95ruz0Ij8uRVe8bSOQ6_-W2sYIVVUYJJSUiKVnZDrIg.rku_esoSmtHYPswzDYXu-vnRFdqwlOiEeqCrc6x-fSYg.JPEG.ekek9812/IMG_0814.jpg?type=w773",
                        artistName: "The Volunteers"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 5,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "플랑크톤",
                        coverImg: "https://image.bugsm.co.kr/album/images/200/3563/356344.jpg?version=20240702024304",
                        artistName: "쏜애플"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 6,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "한계",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/204200/20420099.jpg",
                        artistName: "백예린"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 7,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 8,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Summer",
                        coverImg: "https://postfiles.pstatic.net/MjAyMTA1MjdfMjA4/MDAxNjIyMTE3NDA3NDUz.O95ruz0Ij8uRVe8bSOQ6_-W2sYIVVUYJJSUiKVnZDrIg.rku_esoSmtHYPswzDYXu-vnRFdqwlOiEeqCrc6x-fSYg.JPEG.ekek9812/IMG_0814.jpg?type=w773",
                        artistName: "The Volunteers"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 9,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "플랑크톤",
                        coverImg: "https://image.bugsm.co.kr/album/images/200/3563/356344.jpg?version=20240702024304",
                        artistName: "쏜애플"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 10,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "한계",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/204200/20420099.jpg",
                        artistName: "백예린"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 11,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Ling Ling",
                        coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                        artistName: "검정치마"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 12,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "Summer",
                        coverImg: "https://postfiles.pstatic.net/MjAyMTA1MjdfMjA4/MDAxNjIyMTE3NDA3NDUz.O95ruz0Ij8uRVe8bSOQ6_-W2sYIVVUYJJSUiKVnZDrIg.rku_esoSmtHYPswzDYXu-vnRFdqwlOiEeqCrc6x-fSYg.JPEG.ekek9812/IMG_0814.jpg?type=w773",
                        artistName: "The Volunteers"
                    ),
                    content: nil
                ),
                MyPageTrackItemDTO(
                    postId: 13,
                    track: MyPageTrackDTO(
                        trackId: "apple:1742310021",
                        songTitle: "플랑크톤",
                        coverImg: "https://image.bugsm.co.kr/album/images/200/3563/356344.jpg?version=20240702024304",
                        artistName: "쏜애플"
                    ),
                    content: nil
                )
            ]
        )
    )
}
