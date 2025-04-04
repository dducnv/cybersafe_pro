setup(){
    appVersion=$1
    flutter clean
    flutter pub get
    dart '/Users/ducnv/Documents/Projects/Persional/Flutter/cybersafe_pro/build_script/setup.dart' $appVersion
}

setup $1