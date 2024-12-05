//
//  MockGenerativeEmotionPromptUseCase.swift
//  Presentation
//
//  Created by 박성근 on 12/6/24.
//

import Foundation
import Domain
@testable import Presentation

final class MockGenerativeEmotionPromptUseCase: GenerativeEmotionPromptUseCase {
  var generateCallCount = 0
  var mockReply = "Test Reply"
  var shouldThrowError = false
  
  enum MockError: Error {
    case testError
  }
  
  func generate(_ input: String) async throws -> String? {
    generateCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockReply
  }
}