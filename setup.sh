setup(){
    appVersion=$1
    fvm flutter clean
    fvm flutter pub get
    dart '/Users/ducnv/Documents/Projects/Persional/Flutter/cybersafe_pro/build_script/setup.dart' $appVersion
}

setup $1