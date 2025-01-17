//
//  GeneralError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum GeneralError: Error {
  case environmentError
  
  public var description: String {
    switch self {
    case .environmentError:
      return "환경변수 불러오기 실패"
    }
  }
}
