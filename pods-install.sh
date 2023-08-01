rm -rf ios/Pods ios/Podfile.lock ios/DerivedData ios/build
flutter clean
flutter pub get
cd ios/ 
pod install && pod update