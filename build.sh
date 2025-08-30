appDataFolderPath="/Users/$USER/Documents/AppBuildLog"

fvm flutter clean
fvm flutter pub get
fvm flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --obfuscate --split-debug-info=$appDataFolderPath
