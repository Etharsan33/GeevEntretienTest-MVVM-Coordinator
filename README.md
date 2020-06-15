
# Projet avec une architecture MVVM + Coordinator

### Application builder sur Xcode 11.4, Swift 5

## Arborescence

-> | Extensions = Contient toutes les extensions UIKit, Foundation, MapKit pour pouvoir étendre les classes Swift et qu'ils soivent réutilisable
<br>
-> | Common = Contient des fichiers qui sont communs à l'application (Color, Localizable, Constants...)
<br>
-> | Manager = Singleton pour gérer la partie network, resources et user Location
<br>
-> | Protocols  = Tous les procolols
<br>
-> | Helper = Tous les Helper
<br>
-> | Models = Tous les models de l'application lié aux données du serveur
<br>
-> | Core = Le noyau de l'application (ViewController, Views, ViewModel, Worker, Coordinator)
<br>
-> | Resources = Localizable strings, Assets, LauchScreen
<br>

## Explication Architecture

Exemple Donations (Liste des donations) :

J'ai découpé cette partie avec l'architecture MVVM + Coordinator.

DonationsCoordinator (Coordinator) = Il permet d'instancier le controller avec le viewModel et de gérer les redirections pour aller vers le détail d'un don <br>
DonationsWorker = Une structure qui permet d'appeler le serveur avec les bons paramètres <br>
DonationsViewModel = Appel le serveur et transforme les données reçu en donnée présentation pour le controller et ses views <br>
DonationsViewController = Afficher les données du ViewModel et gère l'interface avec RxSwift <br>
