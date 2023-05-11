//
//  login.swift
//  template-ios
//
//  Created by Hanan Asiri on 17/10/1444 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {
    //    ------------------- properties ---------------------------
    
    let alert =  Alert()
    let authService = AuthService()
    private var agreeIconClick  = false
    
    private let loginLebel : UILabel = {
        let label = UILabel()
        label.text = "login"
        label.tintColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var emailController : UIView = {
        let image = UIImage(systemName: "envelope.fill")
        let view = Utilities().inputContainerView(withImage: image! , textField: emailTextField)
        return view
    }()
    
    private lazy var passwordController : UIView = {
        
        let image = UIImage(systemName: "lock.fill")
        let view = Utilities().inputContainerView(withImage: image! , textField: passwordTextField)
        return view
    }()
    
    private let emailTextField  : UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    
    private let passwordTextField : UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("login", for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.cornerRadius = 5
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    private let alreadyHaveAccountButton : UIButton = {
        let button = Utilities().attributedButton("Dont have an account? ", " SingUp")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotLebel : UILabel = {
        let label = UILabel()
        label.text = "Forgot paasword ?"
        label.tintColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let signwithPhoneButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("sign in with phone", for: .normal)
        button.backgroundColor = .systemBackground
        button.backgroundColor = .systemGray6
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true;
        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleWithPhone), for: .touchUpInside)
        return button
    }()
    
    private let signwithGoogleButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("sign in with Google", for: .normal)
        button.backgroundColor = .systemGray6
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true;
        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleWithGoogle), for: .touchUpInside)
        return button
    }()
    
    private let signwithAppleButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("sign in with Apple", for: .normal)
        button.backgroundColor = .systemGray6
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 9
        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleWithApple), for: .touchUpInside)
        return button
    }()
    
    
    let image :UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "checkmark")
        image.tintColor = .black
        image.isHidden = true
        
        image.setDimensions(width: 24, height: 24)
        
        return image
        
    }()
    
    
    private var checkBoxRemmberMe :CircularCheckBox = {
        
        let view = CircularCheckBox()
        return view
        
    }()
    

    //  ------------------   lifcycle -----------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        checkAndAdd()
        checkBoxRemmberMe.addSubview(image)
        
    }
    
    
    
    //    selecters
    
    @objc func handleShowLogin(){
        navigationController?.pushViewController(signUpViewController(), animated: true)
    }
    
    @objc func handleWithPhone(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleWithGoogle(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleWithApple(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleLogin()  {
        
        guard let email = emailTextField.text else {return}
        
        guard let password = passwordTextField.text else{return}
        authService.LoginWithEmail(email: email, password: password) { result, error in
            if let error = error {
                print ("error \(error.localizedDescription)")
                self.alert.showAlert(with: "Login falid", message: "please inter email and password" , on: self)
                return
            }
           
            let vc = UINavigationController(rootViewController: homeViewController())
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            print("success")
        }

        }
    
    
    
    //     helpers
    
    func configureUI(){
        
        
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(loginLebel)
        loginLebel.centerX(inView: view , topAnchor: view.safeAreaLayoutGuide.topAnchor )
        loginLebel.setDimensions(width: 128, height: 128)
        
        
        let stack = UIStackView(arrangedSubviews: [emailController,
                                                   passwordController,loginButton ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top : loginLebel.bottomAnchor ,left: view.leftAnchor , right : view.rightAnchor,paddingLeft: 38 , paddingRight: 38)
        
        
        let stackView = UIStackView(arrangedSubviews: [forgotLebel ,
                                                       signwithPhoneButton ,signwithGoogleButton , signwithAppleButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
            //          stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        
        checkBoxRemmberMe = CircularCheckBox(frame: CGRect(x: 50 , y: 420, width: 18 , height: 18))
        view.addSubview(checkBoxRemmberMe)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTabCheckBox))
        checkBoxRemmberMe.addGestureRecognizer(gesture)
        
        
        let lable = UILabel (frame: CGRect(x: 76, y: 394, width: 200, height: 70))
        lable.text = "Rember me"
        lable.font = UIFont.boldSystemFont(ofSize: 13)
        lable.textColor = .systemGray2
        view.addSubview(lable)
    
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left : view.leftAnchor ,bottom: view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor , paddingLeft: 40 , paddingRight: 40)
    }
    
    //    ------------------ remmber me-------------------------------------
    @objc func didTabCheckBox(){
        
        if(agreeIconClick == false){
            image.isHidden = false
            agreeIconClick = true
            UserDefaults.standard.set("1", forKey: "remmber")
            UserDefaults.standard.set(emailTextField.text!, forKey: "email")
        }else {
            checkBoxRemmberMe.backgroundColor = .systemBackground
            image.isHidden = true
            agreeIconClick = false
            UserDefaults.standard.set("2", forKey: "remmber")
        }
    }
    
    func checkAndAdd (){
        if  UserDefaults.standard.string(forKey :  "remmber") == "1"{
            image.isHidden = false
            agreeIconClick = true
            self.emailTextField.text = UserDefaults.standard.string(forKey :  "email") ?? ""
            
        }else{
            image.isHidden = true
            agreeIconClick = false
            
        }
        
    }
    
}
