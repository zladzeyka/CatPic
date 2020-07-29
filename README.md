# Received task
Create an app that displays random cat pictures and offers the possibility to favour/un-favour a picture.

Requirements:

To display the cat images you should use the http://thecatapi.com/ it offers a lot of cat pictures and you can favour them to your liking. However for doing other things than just requesting random pictures you need an api key. Usually you can request one instantly. ( For favour picture don't use api )

* Query images from http://thecatapi.com/
* Display them in a collection view
* Let the user favour them
* Create an additional screen that lists all your favorite cat images
* Cache the favoured images on the device

You may design the UI as you like or just stick to the platform's guidelines.

#  How to build and run application

The application was developed on latest XCode version - 11.6 (11E708).
Used pods  : 
pod 'Alamofire', '~> 5.0.0-rc.3'
pod 'AlamofireImage','~> 4.0.0-beta.6'

#  Short description of solution

MVVM was chosen as an architectural pattern

CatPicturesController and SavedPicturesViewController play view roles and don't interact with model directly but through viewModels.
CatPicturesViewModel and SavedPicturesViewModel are responsible for business logic : retrieving data from CoreData , serverside, caching images ,and also for creating mini viewModels .
CatCellViewModel, SavedCellViewModel are responsible for  cell business logic like favourite state handling.

DynamicValue - binds values from our ViewModel to our View, keeps a dictionary of observers and their closure, that we want to execute when updated our Model.

Helpers :
ApiHelper - wrapper for Api interaction
CoreDataHelper - helper class for core data manipulation
ImageCacheHelper - helper class for caching realisation , uses in-memory and on-device caching mechanism.
