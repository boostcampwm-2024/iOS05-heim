//
//  DiaryDetailViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Combine
import Core
import Domain
import Foundation

final class DiaryDetailViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchDiary
    case deleteDiary
  }
  
  struct State: Equatable {
    var calendarDate: String = ""
    var description: String = ""
    var content: String = ""
    var isDeleted: Bool = false
  }
  
  @Published var state: State
  private let useCase: DiaryUseCase
  // TODO: 이름 가져오는 기능 추가
  private let userName: String = "성근"
  let diary: Diary
  
  // MARK: - Initializer
  init(
    useCase: DiaryUseCase,
    diary: Diary
  ) {
    state = State()
    self.useCase = useCase
    self.diary = diary
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .fetchDiary:
      setupInitialState()
    case .deleteDiary:
      Task {
        await handleDeleteDiary()
        state.isDeleted = true
      }
    }
  }
}

// MARK: - Private Extenion
private extension DiaryDetailViewModel {
  func handleDeleteDiary() async {
    do {
      try await useCase.deleteDiary(calendarDate: diary.calendarDate)
    } catch {
      // TODO: Error Handling
    }
  }
  
  func setupInitialState() {
    state.calendarDate = "\(diary.calendarDate.year)년 \(diary.calendarDate.month)월 \(diary.calendarDate.day)일"
    state.description = diary.emotion.diaryDetailDescription(with: userName)
    state.content = diary.summary.text
  }
}
