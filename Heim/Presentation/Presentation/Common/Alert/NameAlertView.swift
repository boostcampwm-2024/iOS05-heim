//
//  NameAlertView.swift
//  Presentation
//
//  Created by 한상진 on 11/25/24.
//

import UIKit

import SnapKit

final class NameAlertView: AlertView {
  // MARK: - Properties
  private let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "새로운 이름"
    textField.textAlignment = .center
    return textField
  }()
  
  private let singleLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  // MARK: - Initializer
  override init(
    title: String,
    leftButtonTitle: String,
    rightbuttonTitle: String
  ) {
    super.init(title: title, leftButtonTitle: leftButtonTitle, rightbuttonTitle: rightbuttonTitle)

    setupViews()
    setupLayoutconstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupCompleteButtonAction(_ completion: @escaping (String) -> Void) {
    let action = UIAction { [weak self] _ in
      completion(self?.nameTextField.text ?? "")
    }
    
    rightbutton?.addAction(action, for: .touchUpInside)
  }
}

// MARK: - Private Extenion
private extension NameAlertView {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let defaultRadius: CGFloat = 16
    static let singleLineViewHeight: CGFloat = 1
  }
  
  func setupViews() {
    titleLabel.textAlignment = .center
    labelContainerView.addSubview(nameTextField)
    labelContainerView.addSubview(singleLineView)
  }
  
  func setupLayoutconstraints() {
    nameTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.defaultPadding * 2)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding)
    }
    
    singleLineView.snp.makeConstraints {
      $0.height.equalTo(LayoutConstants.singleLineViewHeight)
      $0.leading.trailing.equalTo(nameTextField)
      $0.top.equalTo(nameTextField.snp.bottom)
      $0.bottom.equalToSuperview().offset(-LayoutConstants.defaultPadding * 2)
    }
  }
}