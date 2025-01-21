//
//  ViewController.swift
//  Kinopoisk
//
//  Created by Денис Ефименков on 17.01.2025.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {

    let userTextField = UITextField()
    let stackView = UIStackView()
    let button1 = UIButton()
    let button2 = UIButton()
    var resultTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(userTextField)
        view.addSubview(stackView)
        view.addSubview(resultTextView)
        configure()
        constraintsConfigure()

//MARK: - Constraints
        func configure() {
            button1.backgroundColor = .systemBlue
            button1.setTitle("URLSession", for: .normal)
            button2.backgroundColor = .systemBlue
            button2.setTitle("Alamofire", for: .normal)
            
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.addArrangedSubview(button1)
            stackView.addArrangedSubview(button2)
            stackView.spacing = 20
            
            button1.layer.cornerRadius = 10
            button2.layer.cornerRadius = 10
            
            userTextField.layer.cornerRadius = 10
            userTextField.layer.borderWidth = 1
            
            resultTextView.layer.cornerRadius = 10
            resultTextView.layer.borderWidth = 2
            resultTextView.isEditable = false
        }
        
        func constraintsConfigure(){
            userTextField.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
                make.centerX.equalTo(view)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(40)
            }
            
            stackView.snp.makeConstraints { make in
                make.top.equalTo(userTextField.snp.bottom).offset(20)
                make.height.equalTo(70)
                make.left.right.equalToSuperview().inset(35)
            }
            
            button1.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            button2.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            
            resultTextView.snp.makeConstraints { make in
                make.top.equalTo(stackView.snp.bottom).offset(20)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
                make.left.right.equalToSuperview().inset(20)
            }
            
        }
        
// MARK: - Buttons add actions
        button1.addTarget(self, action: #selector(sendRequestButton1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(sendRequestButton2), for: .touchUpInside)
    }

// MARK: - First Button URLSession
    @objc func sendRequestButton1(){
        if (userTextField.text?.isEmpty)! {
            alert(title:"Пустой Ввод", message:"Введите запрос")
        }else{
            let userData = URL(string:Api.url + (userTextField.text!))
            var request = URLRequest(url: userData!)
                
            request.httpMethod = "GET"
            request.setValue(Api.key, forHTTPHeaderField: Api.header)
            
            let task = URLSession.shared.dataTask(with: request) {  data, response, error in
                if let error = error {
                    print(error)
                }else{
                    if let data = data , let _ = try? JSONSerialization.jsonObject(with: data, options: []){
                        _ = String(data: data, encoding: .utf8)
                        let film: Film = try! JSONDecoder().decode(Film.self, from: data)
                        DispatchQueue.main.async{
                            if (film.films?.isEmpty)!{
                                self.resultTextView.text = "Что-то пошло не так"
                            }else{
                                self.resultTextView.text = film.films?[0].description
                            }
                        }

                    }
                }
            }
                task.resume()
        }
    }
    

// MARK: - Second Button Alamofire
    func sendRequest(urlString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        if (userTextField.text?.isEmpty)! {
            alert(title:"Пустой Ввод", message:"Введите запрос")
        }else {
            guard let url = URL(string: Api.url + (userTextField.text ?? "")) else { return }
            
            var request = URLRequest(url: url)
            request.setValue(Api.key, forHTTPHeaderField: Api.header)
            
            AF.request(request).responseDecodable(of: Film.self) { response in
                completionHandler(response.data, response.response, nil)
            }
        }
    }
    @objc func sendRequestButton2(){
        sendRequest(urlString: Api.url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {return}
            let film: Film = try! JSONDecoder().decode(Film.self, from: data)
    
            DispatchQueue.main.async{
                if (film.films?.isEmpty)!{
                    self.resultTextView.text = "Что-то пошло не так"
                }else{
                    self.resultTextView.text = film.films?[0].description
                }
            }
            

        }
    }
// MARK: - Alert Message
    func alert(title:String,message:String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

