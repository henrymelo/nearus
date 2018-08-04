//
//  ContatoDao.swift
//  ContatosIP67
//  Created by ios7289 on 1/6/18.
//  Copyright © 2018 Caelum. All rights reserved.
//

import UIKit

///class ContatoDao: NSObject { ///usava esta linha quando nao estava persistindo os dados
class ContatoDao: CoreDataUtil {
    
    static private var defaultDAO: ContatoDao!
    var contatos: Array<Contato>! // O ! forca inicializacao
    
    func buscaPosicaoDoContato(_ contato:Contato) -> Int {
        return contatos.index(of: contato)!
    }
    
    func inserirDadosIniciais(){
        let configuracoes = UserDefaults.standard
        
        let dadosInseridos = configuracoes.bool(forKey: "dados_inseridos")
        
        if !dadosInseridos {
            
            let caelumSP = NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
            
            caelumSP.nome = "Caelum SP"
            caelumSP.endereco = "São Paulo, sp, Rua Vergueiro, 3185"
            caelumSP.telefone = "01155712751"
            caelumSP.site = "http://caelum.com.br"
            caelumSP.latitude = -23.5883034
            caelumSP.longitude = -46.632369
            
            self.saveContext()
            
            configuracoes.set(true, forKey: "dados_inseridos")
            
            configuracoes.synchronize()
            
        }
    }
    
    func novoContato() -> Contato{
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
    }
    
    func adiciona(_ contato:Contato){
        contatos.append(contato)
    }
    
    static func sharedInstance() -> ContatoDao{
        if defaultDAO == nil {
            defaultDAO = ContatoDao()
        }
        return defaultDAO
    }
    
    override private init(){
        //contatos = Array() // usado quando nao havia persistencia
        
        super.init()
        
        self.inserirDadosIniciais()
        
        // PATH do Sqlite:
        // /Users/ios7126/Library/Developer/CoreSimulator/Devices/6FE03E96-2124-4CAD-84AE-7EFA184E18BF/data/Containers/Data/Application/6C5934BD-6A9A-47BC-9147-90ABAFB46FF2
        // ...Library/Application Support/ContatosIP67.sqlite
        print("Caminho do BD: \(NSHomeDirectory())")
        
        self.carregaContatos()
    }
    
    func listaTodos() -> [Contato] {
        return contatos
    }
    
    func buscaContatoNaPosicao(_ posicao:Int) -> Contato {
        return contatos[posicao]
    }
    
    func remove(_ posicao:Int) {
        persistentContainer.viewContext.delete(contatos[posicao])
        contatos.remove(at: posicao)
        ContatoDao.sharedInstance().saveContext()
    }
    
    func carregaContatos(){
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        busca.sortDescriptors = [orderPorNome]
        
        do {
            self.contatos = try self.persistentContainer.viewContext.fetch(busca)
        }catch let error as NSError {
            print("Fetch falhou: \(error.localizedDescription)")
        }
    }
}
