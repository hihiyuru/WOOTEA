//
//  Alert.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/11.
//

import Foundation
import UIKit

func showAlert(on viewController: UIViewController, title: String, message: String, buttonTitle: String, buttonHandler: ((UIAlertAction) -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}
