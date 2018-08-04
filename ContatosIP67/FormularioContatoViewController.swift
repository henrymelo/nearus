//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios7289 on 1/6/18.
//  Copyright © 2018 Caelum. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioContatoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var nome: UITextField!
    @IBOutlet var telefone: UITextField!
    @IBOutlet var endereco: UITextField!
    @IBOutlet var site: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var latitude: UITextField!
    @IBOutlet var longitude: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var dao:ContatoDao
    var contato: Contato!
    var delegate:FormularioContatoViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        dao = ContatoDao.sharedInstance()
        
        super.init(coder: aDecoder)
    }

 
    @IBAction func buscaCoordenadas(sender: UIButton) {
        
        self.loading.startAnimating()
        sender.isEnabled = false
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(endereco.text!) { (resultado, error) in
            
            if error == nil && (resultado?.count)! > 0 {
                let placemark = resultado![0]
                let coordenada = placemark.location!.coordinate
                
                self.latitude.text = coordenada.latitude.description
                self.longitude.text = coordenada.longitude.description
                
            }
            self.loading.stopAnimating()
            sender.isEnabled = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contato != nil {
            self.nome.text = contato.nome
            self.telefone.text = contato.telefone
            self.endereco.text = contato.endereco
            self.site.text = contato.site
            self.longitude.text = contato.longitude?.description
            self.latitude.text = contato.latitude?.description
            
            if let foto = contato.foto{
                imageView.image = contato.foto
            }
            
            let botaoAlterar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizaContato))
            self.navigationItem.rightBarButtonItem = botaoAlterar
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionarFoto(sender:)))
        
        self.imageView.addGestureRecognizer(tap)
    }
    
    func selecionarFoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //camera disponivel
        } else {
            //usar biblioteca
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagemSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imagemSelecionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pegaDadosDoFormulario(){
        if contato == nil {
          //self.contato = Contato()
            self.contato = dao.novoContato()
        }
        
        /**
        //Opcional
        if self.botaoAdicionarImage.backgroundImageForState(.Normal) != nil {
            self.contato.foto = self.botaoAdicionar.backgroundImageGorState(.Normal)
        }
        */
        
        contato.foto = imageView.image
        contato.nome = nome.text!
        contato.telefone = telefone.text!
        contato.endereco = endereco.text!
        contato.site = site.text!
        
        if let latitude = Double(self.latitude.text!) {
            self.contato.latitude = latitude as NSNumber
        }
        
        if let longitude = Double(self.longitude.text!) {
            self.contato.longitude = longitude as NSNumber
        }
        
        ////dao.adiciona(contato)
        
        ////print(contato)
        
        /* LISTANDO CONTATOS
        for contato in contatos {
            print(contato)
        }
        */
        
        /*
        let nome = self.nome.text!
        let telefone = self.nome.text!
        let endereco = self.nome.text!
        let site = self.nome.text!
        print("Nome: \(nome), Telefone: \(telefone), Endereço \(endereco), Site: \(site)")
        */
        //let xdate = Date()
        //print("Botão foi clicado \(xdate)" )
    }
    
    @IBAction func criaContato(){
        self.pegaDadosDoFormulario()
        dao.adiciona(contato)
        
        self.delegate?.contatoAdicionado(contato)
        
        _=self.navigationController?.popViewController(animated: true)
    }
    
    func atualizaContato(){
        pegaDadosDoFormulario()
        
        self.delegate?.contatoAtualizado(contato)
        
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    
}

