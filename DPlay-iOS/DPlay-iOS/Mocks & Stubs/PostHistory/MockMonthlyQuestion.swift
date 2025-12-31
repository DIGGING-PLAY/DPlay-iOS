//
//  MockMonthlyQuestion.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/31/25.
//

import Foundation

enum MockMonthlyQuestion {
    static let questionsSample = MonthlyQuestionsResponseDTO(
        success: true,
        code: 2000,
        message: "요청이 성공했습니다.",
        data: MonthlyQuestionsDataDTO(
            questions: [
                MonthlyQuestionDTO(day: "1일",  questionId: 1,  title: "여행 갈 때 플레이리스트에 꼭 넣는 노래는?"),
                MonthlyQuestionDTO(day: "2일",  questionId: 2,  title: "겨울이 오면 꼭 들어야하는 노래"),
                MonthlyQuestionDTO(day: "3일",  questionId: 3,  title: "비 오는 날 들으면 더 좋은 노래는?"),
                MonthlyQuestionDTO(day: "4일",  questionId: 4,  title: "아침에 기분 좋게 시작할 때 듣는 노래는?"),
                MonthlyQuestionDTO(day: "5일",  questionId: 5,  title: "공부/집중할 때 반복 재생하는 노래는?"),
                MonthlyQuestionDTO(day: "6일",  questionId: 6,  title: "드라이브할 때 가장 잘 어울리는 노래는?"),
                MonthlyQuestionDTO(day: "7일",  questionId: 7,  title: "첫 소절만 들어도 추억이 떠오르는 노래는?"),
                MonthlyQuestionDTO(day: "8일",  questionId: 8,  title: "가사가 너무 좋아서 저장해 둔 노래는?"),
                MonthlyQuestionDTO(day: "9일",  questionId: 9,  title: "요즘 가장 많이 듣는 노래는?"),
                MonthlyQuestionDTO(day: "10일", questionId: 10, title: "운동할 때 텐션 올려주는 노래는?"),
                MonthlyQuestionDTO(day: "11일", questionId: 11, title: "퇴근/하교 길에 위로가 되는 노래는?"),
                MonthlyQuestionDTO(day: "12일", questionId: 12, title: "혼자 산책할 때 듣기 좋은 노래는?"),
                MonthlyQuestionDTO(day: "13일", questionId: 13, title: "밤에 들으면 더 감성 터지는 노래는?"),
                MonthlyQuestionDTO(day: "14일", questionId: 14, title: "노래방에서 자신 있는 애창곡은?"),
                MonthlyQuestionDTO(day: "15일", questionId: 15, title: "친구에게 꼭 추천하고 싶은 노래는?"),
                MonthlyQuestionDTO(day: "16일", questionId: 16, title: "처음 듣자마자 플레이리스트에 넣은 노래는?"),
                MonthlyQuestionDTO(day: "17일", questionId: 17, title: "가수/밴드 한 팀만 고른다면 누구의 노래?"),
                MonthlyQuestionDTO(day: "18일", questionId: 18, title: "노래 제목이 지금 내 기분 같은 곡은?"),
                MonthlyQuestionDTO(day: "19일", questionId: 19, title: "일할 때(또는 과제할 때) 배경으로 틀어두는 노래는?"),
                MonthlyQuestionDTO(day: "20일", questionId: 20, title: "다시 돌아가고 싶은 시절을 떠올리게 하는 노래는?"),
                MonthlyQuestionDTO(day: "21일", questionId: 21, title: "힘들 때 들으면 ‘괜찮아’지는 노래는?"),
                MonthlyQuestionDTO(day: "22일", questionId: 22, title: "가사 한 줄로 위로받은 적 있는 노래는?"),
                MonthlyQuestionDTO(day: "23일", questionId: 23, title: "여름 밤에 듣기 좋은 노래는?"),
                MonthlyQuestionDTO(day: "24일", questionId: 24, title: "가을 감성에 딱 맞는 노래는?"),
                MonthlyQuestionDTO(day: "25일", questionId: 25, title: "눈 오는 날 창밖 보면서 듣고 싶은 노래는?"),
                MonthlyQuestionDTO(day: "26일", questionId: 26, title: "해 질 무렵(노을)과 어울리는 노래는?"),
                MonthlyQuestionDTO(day: "27일", questionId: 27, title: "라이브로 꼭 한 번 들어보고 싶은 노래는?"),
                MonthlyQuestionDTO(day: "28일", questionId: 28, title: "인트로가 미쳤다고 생각하는 노래는?"),
                MonthlyQuestionDTO(day: "29일", questionId: 29, title: "이별 후에 들으면 위험한(?) 노래는?"),
                MonthlyQuestionDTO(day: "30일", questionId: 30, title: "올해의 나를 대표하는 노래 한 곡은?")
            ]
        )
    )
}
