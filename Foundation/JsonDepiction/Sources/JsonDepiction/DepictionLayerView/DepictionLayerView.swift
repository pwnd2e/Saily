//
//  DepictionLayerView.swift
//  Sileo
//
//  Created by CoolStar on 8/29/20.
//  Copyright © 2020 CoolStar. All rights reserved.
//

import UIKit

class DepictionLayerView: DepictionBaseView {
    private var views: [DepictionBaseView] = []

    required init?(dictionary: [String: Any], viewController: UIViewController, tintColor: UIColor, isActionable: Bool) {
        guard let rawViews = dictionary["views"] as? [[String: Any]] else {
            return nil
        }

        super.init(dictionary: dictionary, viewController: viewController, tintColor: tintColor, isActionable: isActionable)

        for rawView in rawViews {
            if let depictView = DepictionBaseView.view(dictionary: rawView,
                                                       viewController: viewController,
                                                       tintColor: tintColor,
                                                       isActionable: isActionable)
            {
                views.append(depictView)
                addSubview(depictView)
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func depictionHeight(width: CGFloat) -> CGFloat {
        var maxHeight = CGFloat(0)
        for view in views {
            let height = view.depictionHeight(width: width)
            maxHeight = (height > maxHeight) ? height : maxHeight
        }
        return maxHeight
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for view in views {
            let width = bounds.width
            let height = view.depictionHeight(width: width)
            view.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isActionable {
                for view in views {
                    view.isHighlighted = isHighlighted
                }
            }
        }
    }
}
