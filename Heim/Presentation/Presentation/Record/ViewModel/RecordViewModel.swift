//
//  RecordViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Combine
import Core
import Domain
import Foundation

final class RecordViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case startRecording
    case stopRecording
    case refresh
    case moveToNext
  }
  
  struct State: Equatable {
    var isRecording: Bool = false
    var canMoveToNext: Bool = false
    var timeText: String = "00:00"
    var isPaused: Bool = false  // 일시정지 상태 확인
  }
  
  @Published var state: State
  private var recordManager: RecordManager
  private var timer: Timer?
  
  // MARK: - Initializer
  init() {
    self.state = State()
    // TODO: 주입 방식 수정 고민
    self.recordManager = RecordManager(
      recognizedText: "",
      minuteAndSeconds: 0
    )
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .startRecording:
      handleStartRecording()
    case .stopRecording:
      handleStopRecording()
    case .refresh:
      handleRefresh()
    case .moveToNext:
      handleMoveToNext()
    }
  }
  
  func setup() async {
    await recordManager.setupSpeech()
    // TODO: Handle authorization status
  }
}

// MARK: - Private Extenion
private extension RecordViewModel {
  func handleStartRecording() {
    recordManager.startRecording()
    state.isRecording = true
    state.canMoveToNext = false
    startTimeObservation()
  }
  
  func handleStopRecording() {
    recordManager.stopRecording()
//    print(recordManager.recognizedText)
    state.isRecording = false
    state.canMoveToNext = true
    state.isPaused = true
    stopTimeObservation()
  }
  
  func handleRefresh() {
    recordManager.resetAll()
    stopTimeObservation()
    state = State()
  }
  
  func handleMoveToNext() {
    recordManager.resetAll()
    // TODO: 다음 화면과 연결
  }
  
  func startTimeObservation() {
    stopTimeObservation() // 기존 타이머가 있다면 제거
    
    if !state.isPaused {
      state.timeText = "00:00"
    }
    state.isPaused = false
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      let minutes = self.recordManager.minuteAndSeconds / 60
      let seconds = self.recordManager.minuteAndSeconds % 60
      let timeText = String(format: "%02d:%02d", minutes, seconds)
      self.state.timeText = String(format: "%02d:%02d", minutes, seconds)
    }
  }
  
  func stopTimeObservation() {
    timer?.invalidate()
    timer = nil
  }
}
