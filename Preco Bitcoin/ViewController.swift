//
//  ViewController.swift
//  Preco Bitcoin
//
//  Created by Marcelo Salvador on 28/10/17.
//  Copyright © 2017 Hibejix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var precoBitcoin: UILabel!
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitcoin();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.recuperarPrecoBitcoin();
    }

    func formatarPrecoBitcoin(preco: NSNumber) -> String {
        let numberFormat = NumberFormatter();
        numberFormat.numberStyle = .decimal;
        numberFormat.locale = Locale(identifier: "pt_BR");
        
        if let precoFinal = numberFormat.string(from: preco) {
            return precoFinal;
        }
        
        return "0,00";
    }
    
    func recuperarPrecoBitcoin() {
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal);
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if(erro == nil) {
                    if let dadosRetorno = dados {
                        do {
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any] {
                                if let brl = objetoJson["BRL"] as? [String: Any] {
                                    if let preco = brl["buy"] as? Double {
                                        let precoFormatado = self.formatarPrecoBitcoin(preco: NSNumber(value: preco));
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitcoin.text = "R$ " + precoFormatado;
                                            self.botaoAtualizar.setTitle("Atualizar", for: .normal);
                                        })
                                    }
                                }
                            }
                        } catch {
                            print("Erro ao formatar o retorno");
                        }
                    }
                } else {
                    print("Erro ao fazer consulta de preços!");
                }
            }
            tarefa.resume();
        }
    }
}

