//
//  DetailViewController.swift
//  list-nps
//
//  Created by Ascenzo on 13/04/20.
//  Copyright © 2020 mm. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Charts

class DetailViewController: BaseViewController {
  let npsViewModel = NPSViewModelDetail(locator: BaseUseCaseLocatorImpl.defaultLocator)
  @IBOutlet weak var tableView: UITableView!

  
  var locationManager: CLLocationManager?
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureBinding()
  }
}

extension DetailViewController {
  func configureUI() {
  
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
 
  }
  
  func configureBinding() {
      npsViewModel.questions.asObservable()
        .bind(to: tableView.rx.items(cellIdentifier: "GraphDetailViewCell", cellType: GraphDetailViewCell.self)) { index, item, cell in

        
             var entries = [PieChartDataEntry]()
          var colors: [UIColor] = []
          var index = 0
          for i  in item.chartData {
              let entry = PieChartDataEntry()
            entry.y = Double(i.percetnage)
            entry.label = i.text
            entries.append( entry)
            var color = UIColor.clear
            if index < self.npsViewModel.colors.value.count {
                 color = UIColor().hexStringToUIColor(hex: self.npsViewModel.colors.value[index])
            } else {
                 color = UIColor().hexStringToUIColor(hex: self.npsViewModel.colors.value[0])
            }
          
            colors.append(color)
            index += 1
          }
          
          let set = PieChartDataSet( entries: entries, label: item.text)
          set.colors = colors
          let data = PieChartData(dataSet: set)
          cell.chart.data = data
          cell.chart.noDataText = "No data available"
          cell.chart.isUserInteractionEnabled = true
          cell.chart.holeRadiusPercent = 0.2
          cell.chart.transparentCircleColor = UIColor.clear
 
      }
      .disposed(by: self.disposeBag)
  }
  
}
extension DetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300
  }
}
