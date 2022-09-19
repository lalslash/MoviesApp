//
//  ViewController.swift
//  peliculasAPI
//
//  Created by user223791 on 9/9/22.
//

import UIKit

class MainMovies: UIViewController {
    
    var GenerosLista : [Genres] = []
    var PeliculasLista : [Results] = []
    var PeliculaAEnviar : Results?
    
    let amarilloColection = UIColor.init(named: "amarilloSelected")
    let normalCollectionColor = UIColor.init(named: "fondoColor")
    
    
    @IBOutlet weak var labelForKids: UILabel!
    @IBOutlet weak var labelAllMovies: UILabel!
    @IBOutlet weak var labelNowShowing: UILabel!
    @IBOutlet weak var btnAllMoviesOut: UIButton!
    @IBOutlet weak var btnForKidsOut: UIButton!
    
    var labelGeneroSelected = 0
    var idGeneroSelected = 0
    
    var boolAllMovies = true
    
    static let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var labelComingSoon: UILabel!
    @IBOutlet weak var colectionViewGenerosPeliculas: UICollectionView!
    
    @IBOutlet weak var labelUpcoming: UILabel!
    @IBOutlet weak var imageUpComing: UIImageView!
    @IBOutlet weak var collectionPeliculas: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        //Paso 1, pedir permiso
        MainMovies.center.requestAuthorization(options: [.alert,.sound]) { granted, error in
        }
        
        colectionViewGenerosPeliculas.delegate = self
        colectionViewGenerosPeliculas.dataSource = self
        colectionViewGenerosPeliculas.register(UINib(nibName: GeneroCollectionVC.nibName, bundle: nil), forCellWithReuseIdentifier: GeneroCollectionVC.identificador)
        
        collectionPeliculas.delegate = self
        collectionPeliculas.dataSource = self
        collectionPeliculas.register(UINib(nibName: CollecctionViewImages.nibName, bundle: nil), forCellWithReuseIdentifier: CollecctionViewImages.identificador)
        
        loadPeliculaPortrait(stringUrl: "https://api.themoviedb.org/3/discover/movie?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&with_genres=53", int: 1)
        loadGeneros()
    }
    
    func loadPeliculaPortrait(stringUrl : String, int : Int){
        descargarJSONPeliculas(urlString: stringUrl) { JSON in
            DispatchQueue.main.async {
                descargarImagenes(pathImage: JSON.results[int].backdrop_path, imageView: self.imageUpComing)
                self.labelUpcoming.text = JSON.results[int].title
            }
        }
    }
    
    func loadGeneros(){
        descargarJSONGeneros(urlString: "https://api.themoviedb.org/3/genre/movie/list?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1") { JSON in
            self.GenerosLista = JSON.genres
            self.reloadPeliculas(intID: JSON.genres[self.idGeneroSelected].id)
        }
    }
    
    func descargarJSONGeneros(urlString : String,completion : @escaping (Generos) -> Void) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let JSON = try? JSONDecoder().decode(Generos.self, from: data){
                    completion(JSON)
                    return
                }
            }
            //completion([])
        }.resume()
    }
    
    func descargarJSONPeliculas(urlString : String,completion : @escaping (PeliculasPorGenero) -> Void) {
        
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let JSON = try? JSONDecoder().decode(PeliculasPorGenero.self, from: data){
                    completion(JSON)
                    return
                }
            }
            //completion([])
        }.resume()
    }
    
    @IBAction func btnForKids(_ sender: Any) {
        if boolAllMovies == true{
            labelForKids.textColor = UIColor(named: "amarilloSelected")
            labelAllMovies.textColor = UIColor.white
            labelComingSoon.text = "Best Rated Kids Movie"
            labelNowShowing.text = "Movies For Kids"
            loadPeliculaPortrait(stringUrl: "https://api.themoviedb.org/3/discover/movie?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&with_genres=16", int: 6)
                DispatchQueue.main.async {
                    self.colectionViewGenerosPeliculas.isHidden = true
                    self.reloadPeliculas(intID: 16)
                }
        }
        boolAllMovies = false
    }
    
    @IBAction func btnAllMovies(_ sender: Any) {
        if boolAllMovies == false{
            labelForKids.textColor = UIColor.white
            labelAllMovies.textColor = UIColor(named: "amarilloSelected")
            labelComingSoon.text = "Coming Soon"
            labelNowShowing.text = "Now Showing"
            self.colectionViewGenerosPeliculas.isHidden = false
            idGeneroSelected = 0
            labelGeneroSelected = 0
            loadPeliculaPortrait(stringUrl: "https://api.themoviedb.org/3/discover/movie?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&with_genres=53", int: 0)
            loadGeneros()
        }
        boolAllMovies = true
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
}

extension MainMovies: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPeliculas {
            return (PeliculasLista.count == 0) ? 0 : PeliculasLista.count
        }else{
            return (GenerosLista.count == 0) ? 0 : GenerosLista.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionPeliculas {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollecctionViewImages.identificador, for: indexPath) as? CollecctionViewImages
            
            if PeliculasLista.count != 0 {
                descargarImagenes(pathImage: PeliculasLista[indexPath.row].backdrop_path, imageView: cell!.imageView)
            }
            
            cell?.labelMinEdad.text = (PeliculasLista[indexPath.row].adult) ? "+18" : "+13"
            cell?.labelNombrePelicula.text = PeliculasLista[indexPath.row].title
            cell?.labelGeneroPelicula.text = GenerosLista[labelGeneroSelected].name
            
            
            return cell!
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneroCollectionVC.identificador, for: indexPath) as? GeneroCollectionVC
            if GenerosLista.count != 0 {
            cell?.labelGeneros.text = GenerosLista[indexPath.row].name
            if indexPath.row == labelGeneroSelected {
                cell?.labelGeneros.backgroundColor = amarilloColection
                idGeneroSelected = GenerosLista[indexPath.row].id
                print("IdSelected\(idGeneroSelected)")
                print("Genero selected \(GenerosLista[indexPath.row].name)")
            }else{
                cell?.labelGeneros.backgroundColor = normalCollectionColor
            }
        }
        return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionPeliculas {
            PeliculaAEnviar = PeliculasLista[indexPath.row]
            performSegue(withIdentifier: "MainToDescription", sender: self)
        }else{
        labelGeneroSelected = indexPath.row
        reloadPeliculas(intID: GenerosLista[indexPath.row].id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor.gray
 
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        if let target = segue.destination as? PeliculaDescripcionVC, let peliculaAEnviar = PeliculaAEnviar {
            target.peliculaARecibir = peliculaAEnviar
            target.generoARecibir = GenerosLista[labelGeneroSelected].name
        }
    }
    
    func reloadPeliculas(intID: Int){
        self.descargarJSONPeliculas(urlString : "https://api.themoviedb.org/3/discover/movie?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&with_genres=\(intID)") { JSON in
            self.PeliculasLista = JSON.results
            print("Peliculas: \(JSON.results.count)")
            print("Peliculas JSON Lista: \(self.PeliculasLista[0])")
            
            DispatchQueue.main.async {
                self.collectionPeliculas.scrollsToTop = true
                self.collectionPeliculas.reloadData()
                
            }
        }
        DispatchQueue.main.async {
            self.colectionViewGenerosPeliculas.reloadData()
        }
    }
    
    
}

extension MainMovies: UICollectionViewDelegateFlowLayout {
    
}

extension MainMovies: UICollectionViewDelegate {
    
    
}
