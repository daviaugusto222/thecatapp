//
//  ViewController.swift
//  thecatapp
//
//  Created by Admin on 21/09/22.
//

import UIKit

//Enum criado para capturar diferentes tipos de erros que podem acontecer.
enum KittyError: Error {
    case invalidURL
    case requestError
    case decodedError
    case invalidData
}

class ViewController: UIViewController {
    
    //Imagem do storyboard
    @IBOutlet weak var gatinho: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Faz a primeira requisição a API assim que o app abre. Se verdadeiro envia o objeto kitty para handleSuccess se não mostra o alerta de erro.
        //Não estamos mostrando erros diferentes mas isso seria otimo para sabermos onde ele está. Como você faria isso?
        makeRequest { [weak self] result in
            switch result {
            case .success(let kitty):
                self?.handleSuccess(kitty)
            case .failure:
                self?.showAlert()
            }
        }
        
    }
    
    //Função executada toda vez que clicamos no button da navigation.
    @IBAction func reloadKitty(_ sender: Any) {
        
        //Faz a primeira requisição a API assim que o app abre. Se verdadeiro envia o objeto kitty para handleSuccess se não mostra o alerta de erro.
        //Não estamos mostrando erros diferentes mas isso seria otimo para sabermos onde ele está. Como você faria isso?
        //Esse é o mesmo código que usamos antes, como poderiamos fazer isso sem duplicação de código?
        makeRequest { [weak self] result in
            switch result {
            case .success(let kitty):
                self?.handleSuccess(kitty)
            case .failure:
                self?.showAlert()
            }
        }
        
    }
    
    //Função que faz a requisição a API de forma assincrona. Quando a recebemos os dados da API e fazemos a conversão de JSON para Kitty enviamos esse resultado para a clusure (completion). Dessa forma o app não fica travado enquando esperamos.
    func makeRequest(completion: @escaping (Result<Kitty, KittyError>) -> Void ) {
        
        //Criando uma URL baseada em uma string. Caso não consiga criar, retorna com erro para a completion
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: url) { data,_,error in
            //Deixando a execução de forma assincrona
            DispatchQueue.main.async {
                //Verificando se a requisição gerou algum erro, se não continuamos
                guard error == nil else {
                    return completion(.failure(.requestError))
                }
                
                //Verificamos se recebemos algum dado, se sim verificamos se conseguimos converter. Se sim continuamos e enviamos para a completion o kitty.
                // Essa API retorno um objeto ({}) dentro de um Array ([]). [{parametros aqui}]. Então quando convertemos o JSON para dado temo um array com os objetos que queremos dentro. Então temos que fazer a conversão para [Kitty].self. E depois pegar o primeiro elemento (e unico nesse caso) para enviar pelo completion.
                
                if let data = data {
                    guard let kitty = try? JSONDecoder().decode([Kitty].self, from: data) else {
                        return completion(.failure(.decodedError))
                    }
                    completion(.success(kitty.first!))
                } else {
                    completion(.failure(.invalidData))
                }
                
            }
        }.resume()
    }
    
    
    //Função responsável por mostrar o alerta caso algum erro aconteça
    func showAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Algo de errado não está certo com a requisição!",
            preferredStyle: .alert)
        
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    //Função responsável por transformar uma url de uma imagem e um data e depois atribuir isso a uma imagem. Depois adicionamos isso a nossa UIImage.
    func handleSuccess(_ kitty: Kitty) {
        
        guard let urlImage = URL(string: kitty.url) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: urlImage), let imageKitty = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.gatinho.image = imageKitty
            }
        }
        
    }
    
    
}

