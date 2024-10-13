# **Anivise**
## anime.visualise
### *Your one-stop for exploring & discovering your favourite anime shows/movies* 
<img src=https://github.com/user-attachments/assets/3b9541da-d4fa-47d9-b6a3-90fe4e8dd82f width="200" height="200">



### Technology Stack:
![Static Badge](https://img.shields.io/badge/Swift-orange?style=for-the-badge&logo=Swift&logoColor=FFFFFF) ![Static Badge](https://img.shields.io/badge/SwiftUI-blue?style=for-the-badge&logo=Swift&logoColor=FFFFFF) 
![Static Badge](https://img.shields.io/badge/Firebase-red?style=for-the-badge&logo=Firebase&logoColor=FFFFFF) ![Static Badge](https://img.shields.io/badge/iOS-black?style=for-the-badge&logo=iOS&logoColor=FFFFFF)
![Static Badge](https://img.shields.io/badge/macOS-black?style=for-the-badge&logo=macOS&logoColor=FFFFFF)

- Swift/SwiftUI
- Google Firebase

### Prerequisites (for development/testing purposes):
- Google Firebase (Firebase Auth & Firebase Firestore) - Add link to project dependencies if missing: 
```
https://github.com/firebase/firebase-ios-sdk.git
```
- Sign in with Google iOS module  - Add link to project dependencies if missing:
```
https://github.com/google/GoogleSignIn-iOS.git
```
- `GoogleService-Info.plist`: required to test Firebase functions, place it in project's root folder. (in Anivise folder) 
<br>(Note for Advanced iOS Development course: This file will be attached in Canvas Assignment .zip submission. Not available in Github repo for security reasons.)

### What is Anivise?
### *Anivise - anime.visualise*

Embark on the world of anime tailored to your tastes with Anivise. Swipe through personalised recommendations, discover new genres, and save your favourites to watch later. Set your preferences, dive into detailed anime info, and sync across devices with seamless cloud support. Whether you're a seasoned Otaku or just getting into anime, Anivise transforms your experience in search of your next binge-worthy anime!

### Main Features
- Discover: Explore a world of anime tailored to your preferences! 
<br> Adding genres to your pallete to let the great taste flows through your entertainment needs!
- Track: Keep track of your favourite Anime shows and movies. 
<br> Viewing your saved items at one location couldn't be any easier.
- Recommend: Receive recommendations based on your taste! 
<br> Craving for more of your favourites? Fear not, they are right at your fingertips!


### App Screenshots!

![IMG_9574](https://github.com/user-attachments/assets/bbe3e624-2f25-4b01-8448-52708addcd6e)
![IMG_9573](https://github.com/user-attachments/assets/526e54f6-5fd8-4c43-b49d-c03115259727)
![IMG_9572](https://github.com/user-attachments/assets/149cfa69-dea1-4b5f-a0bd-00c689ffef47)
![IMG_9575](https://github.com/user-attachments/assets/6576e060-5f90-4bdc-96da-5e69e5a1d774) 
![IMG_9578](https://github.com/user-attachments/assets/ea71f43b-b043-4ddc-aea8-3fe030044364)


## For Advanced iOS Assignment Reference Only
### Error handling:
- Genre Selection:
<br> Issue: User selected genres, but some might not be saved properly
<br> Solution: Adding debug print-to-console messages that checks which genres user saved to favourites and cross-compare with the output. 
- Signing in/Authentication:
<br> Issue(s): User may mistype email, password or attempt to login multiple times quickly -> failed login attempts
<br> Solution: Provide alert message with detailed errors of which type of sign in errors it was (e.g.:mistyped email, passwords, blank fields, brute forcing).
- Cloud Syncing:
<br> Issue: User has not favourited any genres (selecting "skip for now") during Onboarding flow & syncing to cloud when signed in. Blank genre -> empty record in Firestore -> could cause genreList corruption.
<br> Solution: Provide alert message that user has not favourited a genre for cloud saving. 

### Instructions:
- Complete the onboarding process & select genres
- Save changes for genre selection view & browse through Home. Tap into each anime to show detailed info.
- Visit the Discover page to look for more Anime. Tap into each anime to show detailed info.
- Sign in through the "Preferences" tab using either Sign in with Google (requires `GoogleService-Info.plist` file and Google account) or using the following credentials if not working:
```
 email: janedoe@quang.au
 pass: JaneDoe1
```
- Backup and restore genres through the available options after Login.

