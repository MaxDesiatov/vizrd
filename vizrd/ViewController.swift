//
//  ViewController.swift
//  vizrd
//
//  Created by Max Desiatov on 25/07/2018.
//  Copyright © 2018 Max Desiatov. All rights reserved.
//

import Cocoa
import Charts

let dataSetSize: CGFloat = 14

final class DateValueFormatter: IAxisValueFormatter {
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return formatter.string(from: Date(timeIntervalSinceReferenceDate: value))
  }

  let formatter: DateFormatter

  init(formatter: DateFormatter) {
    self.formatter = formatter
  }
}

final class ViewController: NSViewController {
  @IBOutlet weak var chartView: LineChartView!

  weak var document: Document? {
    didSet {
      refresh()
    }
  }

  func refresh() {
    guard let document = document else {
      chartView.clear()
      return
    }

    chartView.xAxis.valueFormatter = DateValueFormatter(formatter: document.dateFormatter)
    do {
      chartView.data = try document.readData()
    } catch {
      NSAlert(error: error).runModal()
    }

    chartView.gridBackgroundColor = .lightGray
    chartView.backgroundColor = .white

    chartView.chartDescription?.text = "Linechart Demo"
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
}

