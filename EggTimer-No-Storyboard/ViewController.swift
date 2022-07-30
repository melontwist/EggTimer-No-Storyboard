//
//  ViewController.swift
//  EggTimer-No-Storyboard
//
//  Created by Vianney Marcellin on 2022/06/08.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Create a player for the alarm at the end of the timer
    var player: AVAudioPlayer!
    
    //Create the views (titleView, eggStackView, timerView)
    
    //Create the view for the title
    private let titleView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    //Create the horizontal stackview for each eggView (Soft, Medium and Hard)
    lazy var eggStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            eggView(label: "Soft", imageName: "soft_egg"),
            eggView(label: "Medium", imageName: "medium_egg"),
            eggView(label: "Hard", imageName: "hard_egg")
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    //Create the view for the timer
    private let timerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    //Create the vertical stackView which contains all the views
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleView, eggStackView, timerView
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 39
        
        return stack
    }()
    
    //Create the components for each view (titleLabel, eggView, progressBar)
    
    //Create the titleLabel for the titleView
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs?"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    //Create a function to make a reusable view that you can use as an eggView
    func eggView(label: String, imageName: String) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.setTitle(label, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    //Create the progressBar for the timerView
    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.setProgress(0.0, animated: false)
        progress.progressTintColor = .systemYellow
        progress.trackTintColor = .systemGray
        progress.contentMode = .scaleToFill
        
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.80, green: 0.95, blue: 0.98, alpha: 1.00)
        
        titleView.addSubview(titleLabel)
        timerView.addSubview(progressBar)
        view.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            //stackView (titleView, eggStackView, timerView)
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            
            //titlelabel
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            
            //progressBar
            progressBar.heightAnchor.constraint(equalToConstant: 5),
            progressBar.leadingAnchor.constraint(equalTo: timerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: timerView.centerYAnchor)
        ])
    }
    //Set different types of eggs in a Dictionary [Egg's type:Duration]
    let eggTimes = ["Soft":300, "Medium":480, "Hard":720]
    
    var secondsPassed = 0
    var totalTime = 0
    var timer = Timer()
    
    //Action when an egg is pressed
    @objc func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        if let hardness = sender.currentTitle {
            titleLabel.text = hardness
            totalTime = eggTimes[hardness]!
        }
        
        progressBar.progress = 0.0
        secondsPassed = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = percentageProgress
        } else {
            timer.invalidate()
            titleLabel.text = "DONE!"
            playSound()
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}
