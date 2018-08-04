//
//  FormularioContatoViewControllerDelegateController.swift
//  ContatosIP67
//
//  Created by ios7126 on 1/13/18.
//  Copyright © 2018 Caelum. All rights reserved.
//

import Foundation

protocol FormularioContatoViewControllerDelegate {

    func contatoAtualizado(_ contato:Contato)
    func contatoAdicionado(_ contato:Contato)
 
}
