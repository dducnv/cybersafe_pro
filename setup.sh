setup(){
    appVersion=$1
    fvm flutter clean
    fvm flutter pub get
    dart build_script/setup.dart $appVersion
}

setup $1