gyp: ./deps/gyp

./deps/gyp:
	git submodule update --init

./deps/djinni:
	git submodule update --init

djinni-output-temp/gen.stamp mx3.cidl:
	./run_djinni.sh

./build_ios/libtodoapp.xcodeproj: libtodoapp.gyp ./deps/djinni/support-lib/support_lib.gyp todoapp.djinni
	sh ./run_djinni.sh
	deps/gyp/gyp --depth=. -f xcode -DOS=ios --generator-output=./build_ios -Ideps/djinni/common.gypi ./libtodoapp.gyp

ios: ./build_ios/libtodoapp.xcodeproj
	xcodebuild -workspace ios_project/TodoApp.xcworkspace \
		-scheme TodoApp \
		-configuration 'Debug' \
		-sdk iphonesimulator

# This file needs to be manually configured per system.
example_android/local.properties:
	@echo "Android SDK and NDK not properly configured, please create a example_android/local.properties file." && false

GypAndroid.mk: deps/gyp deps/json11 mx3.gyp djinni
	ANDROID_BUILD_TOP=dirname PYTHONPATH=deps/gyp/pylib $(which ndk-build) deps/gyp/gyp --depth=. -f android -DOS=android --root-target libmx3_android -Icommon.gypi mx3.gyp

android: GypAndroid.mk example_android/local.properties
	cd example_android && ./gradlew app:assembleDebug && cd ..
