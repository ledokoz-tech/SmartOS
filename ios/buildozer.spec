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
requirements = python3,kivy-ios,aiohttp,zeroconf,bcrypt,pyjwt,pyopenssl,orjson,sqlalchemy,pillow

# (str) Supported orientation
orientation = portrait

# (list) Permissions
ios.codesign.allowed = false

# (string) Presplash of the application
presplash.filename = core/branding/smartos_splash.png

# (string) Icon of the application
icon.filename = core/branding/smartos_icon.png

# iOS specific settings
ios.kivy_ios_url = https://github.com/kivy/kivy-ios
ios.ios_deploy_url = https://github.com/phonegap/ios-deploy

# (str) Organisational url
ios.ios_deploy.url =

# (str) deploy url
ios.ios_deploy.deploy_url =
