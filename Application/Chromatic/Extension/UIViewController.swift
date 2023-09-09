//
//  UIViewController.swift
//  Chromatic
//
//  Created by Lakr Aream on 2021/8/8.
//  Copyright © 2021 Lakr Aream. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    var topbarHeight: CGFloat {
        (
            view
                .window?
                .windowScene?
                .statusBarManager?
                .statusBarFrame
                .height ?? 0.0
        ) + (
            navigationController?
                .navigationBar
                .frame
                .height ?? 0.0
        )
    }

    func present(next: UIViewController) {
        if let navigator = navigationController,
           !(next is UIAlertController),
           !(next is UIActivityViewController)
        {
            navigator.pushViewController(next)
        } else {
            next.modalTransitionStyle = .coverVertical
            next.modalPresentationStyle = .formSheet
            present(next, animated: true, completion: nil)
        }
    }
}
