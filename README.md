# Daily Weather App

Daily Weather App built with Flutter. It provides current weather information, including temperature, humidity, wind speed, and more. The app uses geolocation and weather APIs to deliver real-time data with a clean and intuitive UI.

## Features
- **Current Weather Information**: Displays the current temperature, humidity, wind speed, and weather conditions for the current city.
- **Dark Mode**: Seamless transition between light and dark mode for better user experience.
- **Multiple Languages**: Supports English, German, and Italian for a multilingual experience.
- **High Customization**:
  - Temperature display can be in Celsius or Fahrenheit.
  - Time can be displayed in either 12-hour or 24-hour format.
  - Wind speed can be shown in meters per second (m/s), kilometers per hour (km/h), or miles per hour (mph).
- **SVG Icons**: Weather conditions are represented with clear and modern SVG icons for a visually appealing interface.
- **User Settings Persistence**: User preferences (such as language, temperature units, and time format) are stored for data persistence, ensuring that settings are retained across app sessions.

## Screenshots
| <img src="https://github.com/user-attachments/assets/2e3be931-0616-463e-b515-7e85dd6a1421" height="500" width="300" alt="screenshot1"> | <img src="https://github.com/user-attachments/assets/042cb832-f172-4b0a-9e86-7d47567f1931" height="500" width="300" alt="screenshot2"> |
|-------------------------------------------------|--------------------------------------------------|
| <img src="https://github.com/user-attachments/assets/44075e95-be67-48b0-a610-9fd97d19f95a" height="500" width="300" alt="screenshot3"> | <img src="https://github.com/user-attachments/assets/7335c9fa-ac61-4cdc-8f31-d2d80f111624" height="500" width="300" alt="screenshot4"> |
| <img src="https://github.com/user-attachments/assets/ef56139d-5301-4dae-aed7-fa5916e15844" height="500" width="300" alt="screenshot5"> | <img src="https://github.com/user-attachments/assets/37298d21-69fb-4fa7-bc4c-8914851d45a9" height="500" width="300" alt="screenshot6"> |

## Installation

Follow these steps to set up the project locally:

1. **Clone this repository**:
    ```bash
    git clone https://github.com/AmrQ34327/Daily-Weather-App.git
    ```

2. **Navigate to the project directory**:
    ```bash
    cd To-Do-List-App
    ```

3. **Install the necessary dependencies**:
    ```bash
    flutter pub get
    ```

4. **Run the app**:
    ```bash
    flutter run
    ```




## How it works

The app retrieves weather data from the **OpenWeather API**, providing real-time information about the current temperature, humidity, wind speed, and weather conditions. This data is displayed based on the user's current location.

To determine the user's location, the app uses location services to obtain the latitude and longitude. These coordinates are then passed to the **OpenCage Geocoding API** to retrieve the user's current city name in different languages, enhancing the overall user experience.

The app seamlessly combines these two powerful APIs to provide weather information and localization, creating a highly personalized and user-friendly experience.

## License

All rights reserved. No part of this code may be reproduced, modified, or distributed without permission.

