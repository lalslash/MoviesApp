//
//  PeliculaDescripcionVCViewController.swift
//  peliculasAPI
//
//  Created by user223791 on 9/13/22.
//

import UIKit

class PeliculaDescripcionVC: UIViewController {
    
    @IBOutlet weak var labelGeneroPelicula: UILabel!
    @IBOutlet weak var labelTituloPelicula: UILabel!
    @IBOutlet weak var imagenPelicula: UIImageView!
    @IBOutlet weak var labelEdadPelicula: UILabel!
    @IBOutlet weak var labelDescripcionPelicula: UILabel!
    var generoARecibir : String?
    var peliculaARecibir : Results?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        labelTituloPelicula.text = peliculaARecibir?.title
        labelDescripcionPelicula.text = peliculaARecibir?.overview
        labelEdadPelicula.text = (peliculaARecibir!.adult) ? "+18" : "+13"
        labelGeneroPelicula.text = generoARecibir!
        descargarImagenes(pathImage: peliculaARecibir!.backdrop_path, imageView: imagenPelicula)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnGetTickets(_ sender: UIButton) {
        let alertTickets = UIAlertController(title: "Boletos adquiridos", message: "Has comprado los boletos", preferredStyle: .alert)
        alertTickets.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Presionado Ok")
            
            //Paso 2
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Tu funcion comenzara"
            notificationContent.body = "Tu funcion comenzara en 30 minutos"
            
            //Paso 3
            let date = Date().addingTimeInterval(10)
            let dateInFuture = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInFuture, repeats: false)
            
            let request = UNNotificationRequest(identifier: "com.prba.prba2.localNotifications", content: notificationContent, trigger: trigger)
            
            MainMovies.center.add(request) { error in
                
            }
            
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
        }))
        present(alertTickets, animated: true) {
            
        }
    }
    
}
