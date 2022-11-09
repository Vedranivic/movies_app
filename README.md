# movies_app
<img align="left" width="80" height="80" src="https://user-images.githubusercontent.com/27995181/200865661-db83f426-3a00-4ea3-a379-e1aab6a051a2.png" alt="logo"> Simple IMDB-like application

<p align="center">
  <img src="https://user-images.githubusercontent.com/27995181/200864306-7da62f8f-d7b9-4967-a9bf-b5ced80fc1d6.png" width=300/>
</p>

## Features

- ✅ Fetching genres from the API to be able to associate the genre ids with the genre names
- ✅ Fetching popular movies from the API
- ✅ Caching the movies into a database(Hive)
- ✅ Implemented pagination when fetching movies
- ✅ Using the api_key as the query parameter in each request in order to successfully authorise the API requests
- ✅ When the user selects a movie, open the details page

Advanced
- ✅ Implemented the navigation bar
- ✅ Added the favourite movies feature - NOTE: the user can toggle the movie as a favourite in the
Movie list, Favourites list and in the Movie details page
- ✅ Caching the favourite movies into a database (Hive)
- ✅ Bearer token header authorization - creating a custom auth interceptor sing the dio package
- ✅ Show notification when user is offine - NOTE: showing cached movies but letting the user know he is
offline
- ✅ Added animation transition between overview and details page

Aditional
- [x] Pull to refresh

## Architecture
Architecure of the app relies on the BLoC design pattern (somewhat similar to MVVM pattern) that uses flutter's bloc and flutter_bloc packages for state management. Read more: [Bloc Architecture](https://bloclibrary.dev/#/architecture)

![arch_full](https://user-images.githubusercontent.com/27995181/200846872-98a2701d-5757-4ced-bbc4-344625e12098.png)

## Platforms
Currently tested and working on <strong>iOS</strong> primarily (iOS 15: iPhone 13 Pro, iOS 16: iPhone 14 Pro Simulator) and <strong>Android</strong> device (Android 11).
Note: Connectivity monitoring works on physical devices only.

## Screenshots and results
<div>
  <kbd>
  <img src="https://user-images.githubusercontent.com/27995181/200853073-ce5742af-d6cc-4551-997d-cf405b177268.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200852947-8981812c-60d9-4f10-9399-bd575abdc83d.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200852962-e1464880-be3d-4d5a-974c-bbc3b7a3c78e.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200853028-d1b87406-e87c-493a-bef2-26007e025cb1.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200853043-d028446b-e3df-46cc-9fea-89a769723c61.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200853047-bd68de76-ff07-4354-a7fc-e3f8a0f37a04.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200853060-424f9d21-e1d7-4934-a50d-4029aa116b47.PNG" width=300/>
  <img src="https://user-images.githubusercontent.com/27995181/200854893-0b88a152-793f-4ec5-a709-781701da182b.gif" width=300 style="width:300px"/>
 </kbd>
 </div>
