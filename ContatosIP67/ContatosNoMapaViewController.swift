//
//  ContatosNoMapaViewController.swift
//  ContatosIP67
//
//  Created by ios7126 on 1/20/18.
//  Copyright © 2018 Caelum. All rights reserved.
//

import UIKit
import MapKit

class ContatosNoMapaViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapa: MKMapView!
    let locationManager = CLLocationManager()
    var contatos: [Contato] = Array()
    let dao:ContatoDao = ContatoDao.sharedInstance()
    
    override func viewWillAppear(_ animated: Bool) {
        self.contatos = dao.listaTodos()
        self.mapa.addAnnotations(self.contatos)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapa.removeAnnotations(self.contatos)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contatos no Mapa"
        
        self.mapa.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
        
        // Do any additional setup after loading the view.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier:String = "pino"
        
        var pino:MKPinAnnotationView
        
        if let reusablePin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            pino = reusablePin
        }else{
            pino = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if let contato = annotation as? Contato {
            
            pino.pinTintColor = UIColor.red
            pino.canShowCallout = true
            
            let frame = CGRect(x: 0.0, y:0.0, width: 32.0, height: 32.0)
            let imagemContato = UIImageView(frame: frame)
            
            imagemContato.image = contato.foto
            
            pino.leftCalloutAccessoryView = imagemContato
        }
        
        return pino
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        
        
        //recupere o pino que foi seleionado
        let pinoTo200m = view.annotation
        
        //exibe anotacao
        mapView.showAnnotations([pinoTo200m!], animated: true)
        
        //zoom para 200m
        mapView.selectAnnotation(pinoTo200m!, animated: true)
        
        
//        //SOLUCAO ALTERNATIVA
//        //opcionalmente, define os limites do 200m
//        let span = MKCoordinateSpanMake(1, 1)
//        
//        //Ou utilize o 200m corente e cnetraliz o mapa
//        //let span = mapView.region.span
//        
//        //agora mova o mapa
//        let region = MKCoordinateRegion(center: pinoTo200m!.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
