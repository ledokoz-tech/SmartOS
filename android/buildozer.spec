[app]

# (str) Title of your application
title = SmartOS

# (str) Package name
package.name = smartos

# (str) Package domain (needed for android/ios packaging)
package.domain = com.ledokoz.smartos

# (str) Source code where the main.py live
source.dir = engine

# (list) Source files to include
source.include_exts = py,png,jpg,kv,atlas

# (list) List of inclusions using pattern matching
source.include_patterns = homeassistant/**/*.py,core/**/*.py

# (list) Source files to exclude
source.exclude_exts = spec

# (list) List of directory to exclude
source.exclude_dirs = tests,__pycache__,build,dist

# (str) Application versioning
version = 1.0.0

# (list) Application requirements
requirements = python3,kivy,aiohttp,zeroconf,bcrypt,pyjwt,pyopenssl,orjson,sqlalchemy,pillow

# (str) Supported orientation
orientation = portrait

# (list) Permissions
permissions = INTERNET,ACCESS_NETWORK_STATE,ACCESS_WIFI_STATE,BLUETOOTH,BLUETOOTH_ADMIN

# (bool) Fullscreen
fullscreen = 0

# (string) Presplash of the application
presplash.filename = core/branding/smartos_splash.png

# (string) Icon of the application
icon.filename = core/branding/smartos_icon.png

# (int) Target Android API
android.target_api = 31

# (int) Minimum API
android.minapi = 21

# (str) Android NDK version
android.ndk = 25b

# (str) Android entry point
android.entrypoint = org.kivy.android.PythonActivity

# (list) Android services
android.services = org.kivy.android.PythonService

# (str) launchMode
android.manifest.launch_mode = singleTop

# (bool) Private storage
android.private_storage = True

# (bool) If True, then skip trying to update the Android sdk
android.skip_update = True

# (str) Android SDK directory (use pre-installed SDK)
android.sdk_path = /usr/local/lib/android/sdk

# (str) Android NDK directory (if empty, it will be automatically downloaded.)
android.ndk_path =

# (str) Android SDK license acceptance (for CI)
android.accept_sdk_license = True
