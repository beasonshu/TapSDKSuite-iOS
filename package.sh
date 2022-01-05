#!/bin/bash
export LANG="en_US.UTF-8"

DIR_ROOT=$(pwd)
DIR_PRODUCT=./Products
FRAMEWORK_FINAL=$DIR_PRODUCT/
FILE_BUILDCONFIG=$DIR_ROOT/BuildConfig.xcconfig

buildFramework(){
    framework_name=$1
    build_path=$2

    framework_product=$DIR_ROOT/$DIR_PRODUCT/$1.framework

    framework_device=$build_path/build/Release-iphoneos/$framework_name.framework
    framework_simulator=$build_path/build/Release-iphonesimulator/$framework_name.framework
    framework_universal=$build_path/Universal/$framework_name.framework
    mkdir -p $framework_universal

    temp_framework_simulator=$build_path/Temp/Simulator/$framework_name.framework
    mkdir -p $temp_framework_simulator

    cd $build_path

    xcodebuild -quiet -configuration "Release" -target $framework_name -sdk iphoneos -xcconfig $FILE_BUILDCONFIG clean build
    if [ $? -ne 0 ]; then
        echo "xcodebuild iphoneos build fail"
        exit 1
    fi
    cp -a $framework_device/ $framework_universal/

    xcodebuild -quiet -configuration "Release" -target $framework_name -sdk iphonesimulator -xcconfig $FILE_BUILDCONFIG clean build
    if [ $? -ne 0 ]; then
        echo "xcodebuild iphonesimulator build fail"
        exit 1
    fi
    cp -a $framework_simulator/ $temp_framework_simulator/
    lipo $temp_framework_simulator/$framework_name -thin x86_64 -output $temp_framework_simulator/x86_64
    lipo $temp_framework_simulator/$framework_name -thin i386 -output $temp_framework_simulator/i386

    lipo -create $temp_framework_simulator/x86_64 $temp_framework_simulator/i386 $framework_universal/$framework_name -output $build_path/Universal/$framework_name.framework/$framework_name
    cp -a $framework_universal/ $framework_product/

    rm -rf $build_path/Temp/
    rm -rf $build_path/build/
    rm -rf $build_path/Universal/
}
rm -rf $DIR_PRODUCT
mkdir -p $DIR_PRODUCT

cp -a ./TapSDKSuiteKit/TapSDKSuiteResource.bundle $DIR_PRODUCT

buildFramework "TapSDKSuiteKit" "$DIR_ROOT/TapSDKSuiteKit"