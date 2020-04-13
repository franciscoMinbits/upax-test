//
//  ViewController.swift
//  list-nps
//
//  Created by Ascenzo on 06/04/20.
//  Copyright © 2020 mm. All rights reserved.
//

import UIKit
import Photos

class ViewController: BaseViewController {
  private let npsViewModel = NPSViewModel(locator: BaseUseCaseLocatorImpl.defaultLocator)
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var imageContainer: UIView!
  @IBOutlet weak var imageTaked: UIImageView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var sendButton: UIButton!
  lazy var dataImage: Data? = nil
  
  var selectedItem = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureBinding()
  }
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? DetailViewController {
      viewController.npsViewModel.colors.accept(self.npsViewModel.npsData.value?.colors ?? [])
      viewController.npsViewModel.questions.accept(self.npsViewModel.npsData.value?.questions ?? [])
      
    }
  }
  func configureUI() {
    self.title = "TEST"
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  func configureBinding() {
    npsViewModel.isLoading
      .asObservable()
      .bind { isLoading in
        if isLoading{
          CustomViews.sharedInstance.showLoading()
        } else {
          CustomViews.sharedInstance.dismissLoading()
        }
        
    }.disposed(by: disposeBag)
    
    
    npsViewModel.errorMessage
      .asObservable()
      .bind { errorMessage in
        if let errorMessage = errorMessage{
          let alert = UIAlertController(title: "Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
        
    }.disposed(by: disposeBag)
    
    
    npsViewModel.items.bind(to: tableView.rx.items){(tv, row, item) -> UITableViewCell in
      switch row {
      case 0:
        let cell = tv.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: IndexPath.init(row: row, section: 0)) as! InputTableViewCell
        cell.nameTextField.rx
          .controlEvent(.editingChanged)
          .subscribe(onNext: { (text) in
            if let value = cell.nameTextField.text {
              let pattern = "[^A-Za-z]+"
              let result = value.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
              cell.nameTextField.text = result
              self.npsViewModel.username.accept(result)
            }
          })
          .disposed(by: self.disposeBag)
    
        cell.selectionStyle = .none
        return cell
      case 1:
        let cell = tv.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: IndexPath.init(row: row, section: 0)) as! PhotoTableViewCell
        cell.photonButton.rx.tap
          .bind {
            self.takePhoto()
        }
        .disposed(by: self.disposeBag)
        cell.selectionStyle = .none
        return cell
      default:
        let cell = tv.dequeueReusableCell(withIdentifier: "GraphTableViewCell", for: IndexPath.init(row: row, section: 0)) as! GraphTableViewCell
        cell.selectionStyle = .none
        return cell
      }
      
    }.disposed(by: disposeBag)
    
    closeButton.rx.tap
      .bind {
        self.imageTaked.image = nil
        self.imageContainer.isHidden = true
    }
    .disposed(by: self.disposeBag)
    sendButton.rx.tap
      .bind {
        self.npsViewModel.uploadMedia(data: self.dataImage)
    }
    .disposed(by: self.disposeBag)
    
    npsViewModel.colorValue
      .asObservable()
      .bind { colorValue in
        if let colorValue = colorValue, colorValue.count > 0{
          self.view.backgroundColor = UIColor().hexStringToUIColor(hex: colorValue)
        }
        
    }.disposed(by: disposeBag)
    
    tableView
      .rx
      .itemSelected
      .subscribe(onNext:{ indexPath in
        self.performSegue(withIdentifier: "showDetail", sender: nil)
      }).disposed(by: disposeBag)
  }
  
  func accessMedia() {
    let status = PHPhotoLibrary.authorizationStatus()
    if status == PHAuthorizationStatus.authorized {
      takePhoto()
    } else if status == PHAuthorizationStatus.denied {
      
    } else if status == PHAuthorizationStatus.notDetermined {
      PHPhotoLibrary.requestAuthorization({ newStatus in
        if newStatus == PHAuthorizationStatus.authorized {
          self.takePhoto()
        } else {}
      })
    } else if status == PHAuthorizationStatus.restricted {
    }
  }
  func takePhoto() {
    let optionMenu = UIAlertController(title: nil, message: "Choose one option", preferredStyle: .actionSheet)
    let camaraAction = UIAlertAction(title: "Show Photo", style: .default) { (_: UIAlertAction) in
      self.imageContainer.isHidden = false
      if let data = self.dataImage {
        self.imageTaked.image = UIImage(data: data)
      }
    }
    
    let carreteAction = UIAlertAction(title: "Gallery", style: .default) { (_: UIAlertAction) in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
        let mCarrete = UIImagePickerController()
        mCarrete.delegate = self
        mCarrete.sourceType = UIImagePickerController.SourceType.photoLibrary
        mCarrete.allowsEditing = false
        self.present(mCarrete, animated: true, completion: nil)
      }
    }
    
    let cancelacionAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
      print("Action Cancel")
    }
    
    optionMenu.addAction(camaraAction)
    optionMenu.addAction(carreteAction)
    optionMenu.addAction(cancelacionAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let pickedImage  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
      picker.dismiss(animated: false, completion: {
        self.imageContainer.isHidden = false
        self.imageTaked.image = pickedImage
        
        if let _mImage =  pickedImage.jpegData(compressionQuality: 1.0) as Data? {
          self.dataImage = _mImage
        }
      })
      
    }
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
}
