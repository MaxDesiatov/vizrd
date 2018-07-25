//
//  Document.swift
//  vizrd
//
//  Created by Max Desiatov on 25/07/2018.
//  Copyright © 2018 Max Desiatov. All rights reserved.
//

import Cocoa
import CSV
import Charts

final class Document: NSDocument {
  lazy var dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()

  var url: URL?
  var reader: CSVReader?

  override class var autosavesInPlace: Bool {
    return true
  }

  override func makeWindowControllers() {
    // Returns the Storyboard that contains your Document window.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
    let viewController = windowController.contentViewController as! ViewController
    viewController.document = self
    self.addWindowController(windowController)
  }

  override func data(ofType typeName: String) throws -> Data {
    // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }

  override func read(from url: URL, ofType typeName: String) throws {
    self.url = url
  }

  func readData() throws -> LineChartData {
    guard let url = url else {
      return LineChartData()
    }

    guard let stream = InputStream(url: url) else {
      throw NSError(domain: NSOSStatusErrorDomain, code: ioErr)
    }

    let reader = try CSVReader(stream: stream)
    self.reader = reader

    let data = LineChartData()
    var entries = [ChartDataEntry]()

    for row in reader {
      guard let date = dateFormatter.date(from: row[0]),
      let y = Double(row[1]) else {
        continue
      }

      entries.append(ChartDataEntry(x: date.timeIntervalSinceReferenceDate,
                                    y: y))
    }

    let ds = LineChartDataSet(values: entries.sorted {
      $0.x < $1.x
    }, label: "Unique Hits")
    ds.valueFont = .systemFont(ofSize: dataSetSize)
    ds.colors = [.blue]
    data.addDataSet(ds)

    return data
  }
}

