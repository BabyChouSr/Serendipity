//
//  StatsViewController.swift
//  Serendipity
//
//  Created by Kevin Pradjinata on 1/30/21.
//



import UIKit
import Charts
import Firebase

class StatsViewController: UIViewController {
    
    
    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet weak var pieChartBackground: UIView!
    @IBOutlet weak var lineGraphBackground: UIView!
    
    
    let db = Firestore.firestore()
    var moodCount = [String: Int]()
    var moodGraph = [Int: Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadMoodGraph()
        loadMoodCount()
        pieChartBackground.layer.cornerRadius = 40
        lineGraphBackground.layer.cornerRadius = 40
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        
    }
    
    func moodValue(emotion: String) -> Double{
        var moodVal = 0.0
        switch emotion {
        case "🥳":
            moodVal = 1.0
        case "🙂":
            moodVal = 0.8
        case "😐":
            moodVal = 0.6
        case "☹️":
            moodVal = 0.4
        case "😫":
            moodVal = 0.2
        default:
            moodVal = 0.6
        }
        
        return moodVal
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      // TO-DO: customize the chart here
        var dataEntries: [ChartDataEntry] = []
          for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
          }
          // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
          pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
          // 3. Set ChartData
          let pieChartData = PieChartData(dataSet: pieChartDataSet)
          let format = NumberFormatter()
          format.numberStyle = .none
          let formatter = DefaultValueFormatter(formatter: format)
          pieChartData.setValueFormatter(formatter)
          // 4. Assign it to the chart’s data
          pieChartView.data = pieChartData
          pieChartView.backgroundColor = UIColor.clear
        
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    

    func customizeLineChart(dataPoints: [Double], values: [Double]) {
      // TO-DO: customize the chart here
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: dataPoints[i], y: values[i])
          dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        
        lineChartDataSet.circleRadius = 0.0
        lineChartDataSet.lineWidth = 5.0
        lineChartDataSet.valueTextColor = UIColor.clear

        // ADD - Feature Different Color for each line
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.backgroundColor = UIColor.clear
    }
    
    
    

    
    func loadMoodCount() {
        
        db.collection("logs").document("a@k.com").collection("entries")
            .addSnapshotListener { (querySnapshot, error) in
            
//            self.moodLogs = []
                self.moodCount = [String: Int]()
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let activities = data["activity"] as? [String]{
                            for activity in activities{
                                if self.moodCount[activity] != nil {
                                    self.moodCount[activity]! += 1
                                } else{
                                    self.moodCount[activity] = 1
                                }
                            }
                        }
                    }
                    self.customizeChart(dataPoints: Array(self.moodCount.keys), values: Array(self.moodCount.values).map{ Double($0) })
                }
            }
        }
    }
    
    func loadMoodGraph() {
        print("Babu!")
        db.collection("logs").document("a@k.com").collection("entries")
            .order(by: "order", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            
//            self.moodLogs = []
                self.moodGraph = [Int: Double]()
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let date = data["date"] as? String, let userEmo = data["userDetected"] as? String, let day = data["order"] as? Int{
                            
                            self.moodGraph[day] = self.moodValue(emotion: userEmo)
                        }
                    }
                    self.customizeLineChart(dataPoints: Array(self.moodGraph.keys).map{ Double($0) }, values: Array(self.moodGraph.values))
                }
            }
        }
    }
    
}
    
    
    

