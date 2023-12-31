//
//  DepictionLabelView.swift
//  Sileo
//
//  Created by CoolStar on 7/6/19.
//  Copyright © 2019 CoolStar. All rights reserved.
//

import UIKit

class DepictionLabelView: DepictionBaseView {
    private let label: UILabel
    private var useDefaultColor: Bool = false
    private var margins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    required init?(dictionary: [String: Any], viewController: UIViewController, tintColor: UIColor, isActionable: Bool) {
        guard let text = dictionary["text"] as? String else {
            return nil
        }

        label = UILabel(frame: .zero)
        super.init(dictionary: dictionary, viewController: viewController, tintColor: tintColor, isActionable: isActionable)

        if let rawMargins = dictionary["margins"] as? String {
            margins = NSCoder.uiEdgeInsets(for: rawMargins)
        }

        if margins.left == 0 {
            margins.left = 16
        }
        if margins.right == 0 {
            margins.right = 16
        }

        let useMargins = (dictionary["useMargins"] as? Bool) ?? true
        let usePadding = (dictionary["usePadding"] as? Bool) ?? true

        if !useMargins {
            margins = .zero
        } else if !usePadding {
            margins.top = 0
            margins.bottom = 0
        }

        var fontWeight = "normal"
        if let rawFontWeight = dictionary["fontWeight"] as? String {
            fontWeight = rawFontWeight.lowercased()
        }

        let fontSize = (dictionary["fontSize"] as? CGFloat) ?? 14.0

        var textColor = UIColor.sileoLabel
        useDefaultColor = true
        if let rawTextColor = dictionary["textColor"] as? String,
           let color = UIColor(css: rawTextColor)
        {
            textColor = color
            useDefaultColor = false
        }

        let weight = fontWeightParse(str: fontWeight)

        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.text = text

        let alignment = (dictionary["alignment"] as? Int) ?? 0
        switch alignment {
        case 1:
            label.textAlignment = .center
        case 2:
            label.textAlignment = .right
        default:
            label.textAlignment = .left
        }
        addSubview(label)
    }

    func fontWeightParse(str: String) -> UIFont.Weight {
        var weight = UIFont.Weight.regular
        switch str {
        case "black":
            weight = .black
        case "bold":
            weight = .bold
        case "heavy":
            weight = .heavy
        case "light":
            weight = .light
        case "medium":
            weight = .medium
        case "semibold":
            weight = .semibold
        case "thin":
            weight = .thin
        case "ultralight":
            weight = .ultraLight
        default:
            weight = .regular
        }
        return weight
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func updateSileoColors() {
        layoutSubviews()
    }

    override func depictionHeight(width _: CGFloat) -> CGFloat {
        20 + margins.top + margins.bottom
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if useDefaultColor {
            if isActionable {
                if isHighlighted {
                    var tintHue: CGFloat = 0
                    var tintSat: CGFloat = 0
                    var tintBrightness: CGFloat = 0
                    tintColor.getHue(&tintHue, saturation: &tintSat, brightness: &tintBrightness, alpha: nil)

                    tintBrightness *= 0.75
                    label.textColor = UIColor(hue: tintHue, saturation: tintSat, brightness: tintBrightness, alpha: 1)
                } else {
                    label.textColor = tintColor
                }
            } else {
                label.textColor = .sileoLabel
            }
        }

        label.frame = CGRect(x: margins.left,
                             y: margins.top,
                             width: bounds.width - (margins.left + margins.right),
                             height: bounds.height - (margins.top + margins.bottom))
    }

    override var isHighlighted: Bool {
        didSet {
            layoutSubviews()
        }
    }
}
