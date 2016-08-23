./build_ios/libtodoapp.xcodeproj: libtodoapp.gyp ./deps/djinni/support-lib/support_lib.gyp todolist.djinni
	sh ./run_djinni.sh
	deps/gyp/gyp --depth=. -f xcode -DOS=ios --generator-output ./build_ios -Ideps/djinni/common.gypi ./libtodoapp.gyp

ios: ./build_ios/libtodoapp.xcodeproj
	xcodebuild -workspace ios_project/TodoApp.xcworkspace \
		-scheme TodoApp \
		-configuration 'Debug' \
		-sdk iphonesimulator

GypAndroid.mk: libtodoapp.gyp ./deps/djinni/support-lib/support_lib.gyp todolist.djinni
	sh ./run_djinni.sh
	ANDROID_BUILD_TOP=$(shell dirname `which ndk-build`) deps/gyp/gyp --depth=. -f android -DOS=android -Ideps/djinni/common.gypi ./libtodoapp.gyp --root-target=libtodoapp_jni

android: GypAndroid.mk
	cd android_project/TodoApp/ && ./gradlew app:assembleDebug
	@echo "Apks produced at:"
	@python deps/djinni/example/glob.py ./ '*.apk'

sqlite: ./build_ios/libtodoapp.xcodeproj

clean:
	rm -rf ./build_ios ./generated-src .*~ src/.*~
