//
//  MockQuestionPosts.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

enum MockQuestionPosts {
    static let sample = QuestionPostsDataDTO(
        questionId: 1,
        date: "12월 30일",
        title: "아침에 기분 좋게 시작할 때 듣는 노래는?",
        hasPosted: true,
        locked: false,
        visibleLimit: 3,
        totalCount: 12,
        nextCursor: nil,
        items: [
            QuestionPostsItemDTO(
                postId: 1,
                isEditorPick: true,
                isScrapped: false,
                content: "한로로노래임",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1703196825",
                    songTitle: "사랑하게 될 거야",
                    coverImg: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/c2/ef/87/c2ef8779-f3bb-5a1c-ef6f-c27185e62446/8809936067307.jpg/512x512bb.jpg",
                    artistName: "한로로"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 2,
                isEditorPick: true,
                isScrapped: false,
                content: "아이유 최고",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1726888402",
                    songTitle: "Love wins all",
                    coverImg: "https://i.namu.wiki/i/3tZAlvVSSiXFk_hj5s6UD_qLfMS7MMBwM8o93FumB2nojn-6mm25Ovoihnj48IzYI3bSZY_EWKA_jB0foDThVQ.webp",
                    artistName: "아이유"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 3,
                isEditorPick: true,
                isScrapped: false,
                content: "저쪽 집에 불이 났다고 해서 구경하러 갔죠 그런데 보고 오니 우리 집에 불이 난거예요 보자마자 눈물이 났어요",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1726888434",
                    songTitle: "ㅈㅣㅂ",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/206447/20644751.jpg",
                    artistName: "한로로"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 4,
                isEditorPick: false,
                isScrapped: false,
                content: "앙앙! 멘헤라 견과 수돗물",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "개와 수돗물",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40905/4090599.jpg",
                    artistName: "쏜애플"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 5,
                isEditorPick: false,
                isScrapped: false,
                content: "핑크색 좋아하세요?저는 ...좋아...하...",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "PINKTOP",
                    coverImg: "https://postfiles.pstatic.net/MjAyMTA1MjdfMjA4/MDAxNjIyMTE3NDA3NDUz.O95ruz0Ij8uRVe8bSOQ6_-W2sYIVVUYJJSUiKVnZDrIg.rku_esoSmtHYPswzDYXu-vnRFdqwlOiEeqCrc6x-fSYg.JPEG.ekek9812/IMG_0814.jpg?type=w773",
                    artistName: "The Volunteers"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 6,
                isEditorPick: false,
                isScrapped: false,
                content: "플랑크톤의 집게리아 레시피 훔치기",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "플랑크톤",
                    coverImg: "https://image.bugsm.co.kr/album/images/200/3563/356344.jpg?version=20240702024304",
                    artistName: "쏜애플"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 7,
                isEditorPick: false,
                isScrapped: false,
                content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "Ling Ling",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                    artistName: "검정치마"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 8,
                isEditorPick: false,
                isScrapped: false,
                content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "Ling Ling",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                    artistName: "검정치마"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 9,
                isEditorPick: false,
                isScrapped: false,
                content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "Ling Ling",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                    artistName: "검정치마"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 10,
                isEditorPick: false,
                isScrapped: false,
                content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "Ling Ling",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                    artistName: "검정치마"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 11,
                isEditorPick: false,
                isScrapped: false,
                content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "Ling Ling",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                    artistName: "검정치마"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            ),
            QuestionPostsItemDTO(
                postId: 12,
                isEditorPick: false,
                isScrapped: false,
                content: "링링~ 너는 정말 바보야~ 나 만큼 너를 사랑해주는",
                track: QuestionPostsTrackDTO(
                    trackId: "apple:1742310021",
                    songTitle: "Ling Ling",
                    coverImg: "https://image.bugsm.co.kr/album/images/500/40796/4079641.jpg",
                    artistName: "검정치마"
                ),
                user: QuestionPostsUserDTO(
                    userId: 0,
                    nickname: "",
                    profileImg: "",
                    isAdmin: false
                ),
                like: QuestionPostsLikeDTO(
                    isLiked: false,
                    count: 0
                )
            )
        ]
    )
}
