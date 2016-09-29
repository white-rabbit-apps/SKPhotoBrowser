//
//  SKCustomToolbar.swift
//  Pods
//
//  Created by Michael Bina on 9/29/16.
//
//

import Foundation

// helpers which often used
private let bundle = Bundle(for: SKPhotoBrowser.self)

class SKCustomToolbar: UIToolbar {
    var toolCounterLabel: UILabel!
    var toolCounterButton: UIBarButtonItem!
    var toolCommentButton: UIBarButtonItem!
    
    fileprivate weak var browser: SKPhotoBrowser?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser) {
        self.init(frame: frame)
        self.browser = browser
        
        setupApperance()
        setupCounterLabel()
        setupCommentButton()
        setupToolbar()
    }
    
    func updateToolbar(_ currentPageIndex: Int) {
        guard let browser = browser else { return }
        
        if browser.numberOfPhotos > 1 {
            toolCounterLabel.text = "\(currentPageIndex + 1) / \(browser.numberOfPhotos)"
        } else {
            toolCounterLabel.text = nil
        }
    }
}

private extension SKCustomToolbar {
    func setupApperance() {
        backgroundColor = UIColor.clear
        clipsToBounds = true
        isTranslucent = true
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        // toolbar
        if !SKPhotoBrowserOptions.displayCustomToolbar {
            isHidden = true
        }
    }
    
    func setupToolbar() {
        guard let browser = browser else { return }
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        
        if SKPhotoBrowserOptions.displayCounterLabel {
            items.append(flexSpace)
            items.append(toolCounterButton)
            items.append(flexSpace)
        } else {
            items.append(flexSpace)
        }
        
        setItems(items, animated: false)
    }
    
    func setupCommentButton() {
        let commentBtn = SKCommentButton(frame: frame)
        commentBtn.addTarget(browser, action: #selector(SKPhotoBrowser.gotoNextPage), for: .touchUpInside)
        toolCommentButton = UIBarButtonItem(customView: commentBtn)
    }
    
    func setupCounterLabel() {
        toolCounterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 95, height: 40))
        toolCounterLabel.textAlignment = .center
        toolCounterLabel.backgroundColor = UIColor.clear
        toolCounterLabel.font  = UIFont(name: "Helvetica", size: 16.0)
        toolCounterLabel.textColor = UIColor.white
        toolCounterLabel.shadowColor = UIColor.black
        toolCounterLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        toolCounterButton = UIBarButtonItem(customView: toolCounterLabel)
    }
    
}

class SKCommentButton: SKToolbarButton {
    let imageName = "btn_common_forward_wh"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        if let image = SKPhotoBrowserOptions.customCommentButtonImage {
            super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            setupWithImage(image)
        } else {
            super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            setup(imageName)
        }
    }
}
