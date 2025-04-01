//
//  EditViewController.swift
//  InteractivePopGestureTest
//
//  Created by 能登 要 on 2025/04/01.
//

import UIKit

class EditViewController: UIViewController {

    var enableFeature: Bool = false
    
    @IBOutlet weak var modifiedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            modifiedSwitch.isOn = appDelegate.modifiedFlag
        }
        if( enableFeature ){
            setupBackButton()
        }
    }
    
    func setupBackButton(){
        // back button を無効化
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // 戻るボタンを作成
        let configlation: UIImage.SymbolConfiguration = .init(weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: configlation)
        
        let barItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(onBackWithConfirm(_:)))
        navigationItem.leftBarButtonItem = barItem

        // ジェスチャーをセットアップ
        setupInteractivePopGesture()
    }

    func setupInteractivePopGesture() {
        // 再登録防止
        guard (navigationController?.interactivePopGestureRecognizer?.delegate as? Self) == nil else {
            return
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(onInteractivePop(_:)))
    }
    
    @objc func onInteractivePop( _ gestureRecognizer: UIGestureRecognizer) {
        guard modifiedSwitch.isOn else {
            return
        }

        // 位置情報を確認
        let location = gestureRecognizer.location(in: view)
        if location.x < 0, (view.frame.width + location.x) > view.frame.width * 0.4 {
            gestureRecognizer.delegate = nil
            showConfirmAlert()
        }

        if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            gestureRecognizer.removeTarget(self, action: #selector(onInteractivePop(_:)))
        }
    }
    
    @objc func onBackWithConfirm(_ id: Any){
        
        
        if modifiedSwitch.isOn {
            showConfirmAlert()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showConfirmAlert(){
        let alertController = UIAlertController(title: "保存しますか?", message: "保存しないと編集内容は消えてしまいます。", preferredStyle: .alert)
        
        alertController.addAction(
            .init(title: "保存", style: .default) { [weak self] _ in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.modifiedFlag = false
                }
                self?.navigationController?.popViewController(animated: true)
            }
        )
        alertController.addAction(
            .init(title: "保存しないで戻る", style: .destructive) { [weak self] _ in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.modifiedFlag = false
                }
                self?.navigationController?.popViewController(animated: true)
            }
        )
        alertController.addAction(
            .init(title: "キャンセル", style: .cancel) { [weak self] _ in
                // ジェスチャーを再セットアップ
                self?.setupInteractivePopGesture()
            }
        )
        
        present(alertController, animated: true)
    }

    @IBAction func onChangeModifiedFlag(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.modifiedFlag = modifiedSwitch.isOn
        }
    }
}

extension EditViewController: UIGestureRecognizerDelegate {
    
}
