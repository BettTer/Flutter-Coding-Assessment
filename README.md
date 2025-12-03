# Flutter-Coding-Assessment
The project aims to demonstrate the seamless integration of Flutter and Web technologies, native state management, and full-stack development capabilities.

## Setup
### 1.Launch Angular Web Service
```
cd webpage
npm install
// * To ensure the Android emulator or physical device can access it, bind to 0.0.0.0
npx ng serve --host 0.0.0.0
```
The service will run at http://localhost:4200

### 2. Run Flutter Client (Mobile App)
```
cd flutter_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## WebView Networking Notes
The application includes logic to automatically identify the running platform to ensure the WebView correctly loads the local Angular service:
- Android Simulator: http://10.0.2.2:4200
- Else: Change the URL in lib/screens/dashboard_screen.dart to your computer's LAN IP 

### Permissions Configuration:
- iOS: Info.plst -> NSAppTransportSecurity
- Else: AndroidManifest.xml -> usesCleartextTraffic

## Goals Completed & Features
### Flutter:
- Basic: All completed by using Riverpod State Management.
- Bonus: 
    - Message Persistence: Uses Hive to store historical messages. Also have "Clear History" feature.
    - Image Support: Integrated system photo album picker; Sandbox Storage Strategy and UI Interaction

### Angular Dashboard:
- Basic: All completed.

### Assumptions:
- The Web Dashboard does not require a backend API; data is Mock generated in the frontend memory.

- Images are only stored on the local device and do not involve cloud uploads.

## Screenshots
<table>
  <tr>
    <td align="center">
      <img src="Screenshots/IMG_2975.png" width="100%" />
      <br />
      <b>Chat Page</b>
    </td>
    <td align="center">
      <img src="Screenshots/IMG_2976.png" width="100%" />
      <br />
      <b>Clear History</b>
    </td>
  </tr>
</table>

<table>
  <tr>
    </td>
      <td align="center">
      <img src="Screenshots/IMG_2974.png" width="100%" />
      <br />
      <b>Tickets</b>
    </td>
    <td align="center">
      <img src="Screenshots/IMG_2973.png" width="100%" />
      <br />
      <b>Editor</b>
    </td>
    <td align="center">
      <img src="Screenshots/IMG_2972.png" width="100%" />
      <br />
      <b>Logs</b>
  </tr>
</table>