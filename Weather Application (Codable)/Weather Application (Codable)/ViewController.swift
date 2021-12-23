//
//  ViewController.swift
//  Weather Application (Codable)
//
//  Created by admin on 20/12/2021.
//

//https://api.openweathermap.org/data/2.5/onecall?lat=24.774265&lon=46.738586&exclude=alerts&appid=a289ac6dfb995ed665c3559082f2c52b

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var minmax: UILabel!
    
    var hourlyList: [Current]? = []
    var current: Current? = nil
    var weather: Weather? = nil
    var dailyList: [Daily]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hourlyCollectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: "HourlyCell")
        dailyCollectionView.register(DailyCollectionViewCell.nib(), forCellWithReuseIdentifier: "DailyCell")
        
        let hourlyLayout = UICollectionViewFlowLayout()
        let dailyLayout = UICollectionViewFlowLayout()
        
        hourlyLayout.itemSize = CGSize(width: 70, height: 100)
        hourlyLayout.scrollDirection = .horizontal
        hourlyCollectionView.collectionViewLayout = hourlyLayout
        
        dailyLayout.itemSize = CGSize(width: dailyCollectionView.frame.size.width, height: dailyCollectionView.frame.size.height/7)
        dailyLayout.scrollDirection = .vertical
        dailyCollectionView.collectionViewLayout = dailyLayout
        
        getData()
        
        hourlyCollectionView.dataSource = self
        dailyCollectionView.dataSource = self
    }
    
//https://api.openweathermap.org/data/2.5/onecall?lat=24.774265&lon=46.738586&exclude=alerts&appid=a289ac6dfb995ed665c3559082f2c52b
    
    func getData(){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=25.8759&lon=45.3731&appid=f2763f64328617a339894577e9107052"
        ) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, _, error in
            
            if let myData = data, error == nil{
                do{
                    let decoder = JSONDecoder()
                    
                    let jsonResult = try decoder.decode(Data.self, from: myData)
                    
                    self.current = jsonResult.current
                    self.weather = self.current?.weather[0]
                    self.dailyList = jsonResult.daily
                    
                    guard let cur = self.current, let weath = self.weather else { return }
                    
                    
                    self.hourlyList = jsonResult.hourly
                    
                    for i in jsonResult.hourly{
                        if self.hourlyList?.count == 24{
                            break
                        }
                        self.hourlyList?.append(i)
                    }
                    
                    DispatchQueue.main.async {
                        self.mainLbl.text = weath.weatherDescription.rawValue
                        self.cityLbl.text = jsonResult.timezone
                        self.degreeLbl.text = "\(String(format: "%.2f", self.convertToC(degree: cur.temp)))°"
                        self.minmax.text = "Pressure:\(cur.pressure)   Humidity:\(cur.humidity)"
                        self.dailyCollectionView.reloadData()
                        self.hourlyCollectionView.reloadData()
                    }
                }catch{
                    print(error)
                }
                
            }
            
        })
        task.resume()
    }
    
    func convertToC(degree: Double) -> Double{
        return degree - 273.15
    }
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyCollectionView{
            return dailyList?.count ?? 0
        }
        return hourlyList?.count ?? 0
    }
    
    func timeFormatter(Time seconds: Int) -> String{
        let  formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let date = Date(timeIntervalSince1970: Double(seconds))
        
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
            
            var img: UIImage? = nil
            
            let time = hourlyList![indexPath.row]
            
            
            switch(time.weather[0].main.rawValue){
            case "Clouds": do {
                if time.dt > self.current?.sunrise ?? 0 && time.dt < self.current?.sunset ?? 0{
                    img = UIImage(systemName: "cloud.sun.fill")
                }
                else{
                    img = UIImage(systemName: "cloud.moon.fill")
                }
            }
            case "Clear": do {
                if time.dt > self.current?.sunrise ?? 0 && time.dt < self.current?.sunset ?? 0{
                    img = UIImage(systemName: "sun.max.fill")
                }
                else{
                    img = UIImage(systemName: "moon.stars.fill")
                }
            }
            case "Rain":  do {
                if time.dt > self.current?.sunrise ?? 0 && time.dt < self.current?.sunset ?? 0{
                    img = UIImage(systemName: "cloud.sun.rain.fill")
                }
                else{
                    img = UIImage(systemName: "cloud.moon.rain.fill")
                }
            }
            default: img = UIImage(systemName: "sun.min")
            }
            
            print(time.dt*1000)
            
            cell.configure(h: "\(timeFormatter(Time: time.dt * 1000))", image: img!, d: "\(String(format: "%.2f", convertToC(degree: time.temp)))")
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCollectionViewCell
            
            guard let item = dailyList?[indexPath.row] else { return cell }
            
            var img: UIImage? = nil
            
            switch(item.weather[0].main.rawValue){
            case "Clouds": do {
                if item.dt > self.current?.sunrise ?? 0 && item.dt < self.current?.sunset ?? 0{
                    img = UIImage(systemName: "cloud.sun.fill")
                }
                else{
                    img = UIImage(systemName: "cloud.moon.fill")
                }
            }
            case "Clear": do {
                if item.dt > self.current?.sunrise ?? 0 && item.dt < self.current?.sunset ?? 0{
                    img = UIImage(systemName: "sun.max.fill")
                }
                else{
                    img = UIImage(systemName: "moon.stars.fill")
                }
            }
            case "Rain":  do {
                if item.dt > self.current?.sunrise ?? 0 && item.dt < self.current?.sunset ?? 0{
                    img = UIImage(systemName: "cloud.sun.rain.fill")
                }
                else{
                    img = UIImage(systemName: "cloud.moon.rain.fill")
                }
            }
            default: img = UIImage(systemName: "sun.min")
            }
            
            let day = item.dt * 1000
            print("day: \(day)")
            
            let date = Date(timeIntervalSince1970: Double(day))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            let dayInWeek = dateFormatter.string(from: date)
            
            cell.configure(day: dayInWeek, image: img!, min: "\(String(format: "%.2f", convertToC(degree: item.temp.min)))", max: "\(String(format: "%.2f", convertToC(degree: item.temp.max)))")
            
            return cell
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dailyCollectionView{
            return CGSize(width: dailyCollectionView.frame.size.width, height: dailyCollectionView.frame.size.height/7)
        }
        return CGSize(width: 100, height: 120)
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
