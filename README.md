# Table of Contents
1. [Getting started](#getting-started)
2. [Structure](#structure)
3. [Tests](#tests)
4. [Design](#design)
5. [API](#api)
6. [Demonstração](#demonstração)

# Travel
An iOS concept project, developed in Swift and SwiftUI, focusing on connecting drivers to users who want a race.

# Getting started
* Check if you are using Xcode 16, with the simulator on iOS 18<br>
* Download this repository.<br>
* Open the project.<br>
* Compile and run the app.<br>

After compilation, and the app is running normally, you should see a form to enter the route information and its identification.<br>

### Note: Only bellow routes are working:
- Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031 to Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200<br>
- Av. Thomas Edison, 365 - Barra Funda, São Paulo - SP, 01140-000 to Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200<br>
- Av. Brasil, 2033 - Jardim America, São Paulo - SP, 01431-001 to Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200<br>

# Structure
* Travel uses the architecture standard <strong>Model-View-ViewModel (MVVM)</strong><br>
* The Model is responsible for handling only the data necessary for the app.<br>
* View is only responsible for displaying the current state in which the data is located.<br>
* The ViewModel is responsible for creating a bridge between the Model and the View, and processing information and actions.<br>
* Helper is a set of standard methods that assists in the execution of some process, without the need for code duplication.<br>
* The Network layer is a set of methods that are responsible for handling communication between the App and the API.<br>

# Tests
Travel has a set of unit tests, to check if the App's features are working correctly.<br>
If you want to analyze them or even run it, just go to the <strong>TravelTests</strong> folder, navigate to some subfolder marked with <strong>Test</strong> at the end, analyze it and/or run the tests.

# Design 
The App was designed to be simple, intuitive and familiar for iOS users. Therefore, the design was inspired by the standard iOS Apps, with strong use of standard system components such as Form and Apple Maps (On the screen to choose a driver.).<br>
In addition to using standard colors throughout the UI to avoid visual fatigue and difficulty in finding any component.

# API 
The app makes a request to an API in which it is responsible for calculating the travel route, confirming the trip, and obtaining the passenger's travel history with a given driver.

# Demonstração
[Clique aqui](https://youtu.be/qqgXdeo9BWw) That you will be redirected to the demonstration video of the working App, on my YouTube channel.
