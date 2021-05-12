#!/bin/zsh
# encoding: utf-8

# Made by Lux
# https://github.com/lifeunexpected

# Scripts are based on code by:
# https://groups.google.com/forum/#!topic/munki-dev/FADUXPWJeds - Michal Moravec
# https://github.com/rednoah/notarize-app/blob/master/notarize-app - rednoah
# https://github.com/munki/munki/tree/master/code/tools - Greg Neagle
# https://stackoverflow.com/a/57083245 - Perry

# 1: Copy script to Munki folder
# 2: In terminal "cd FolderWheremunki" git repo is located
# 3: run script
# 4 Enter Password when asked for it

# Tip: if you get “You must first sign the relevant contracts online. (1048)” error
# Go to Apple.developer.com and sign in with the account you are trying to notarize the app with and agree to the updated license agreement.

# Defaults do NOT Change!
MUNKIROOT="."
# Convert to absolute path.
MUNKIROOT=$(cd "$MUNKIROOT"; pwd)
OUTPUTDIR="$(pwd)"

# Update munki to latest version
# Disable with # before the command if you dont want it to update
git pull

# Rename existing munkitools files
Old_PKG=$( ls munkitools-[0-9]* )
if [[ -f $Old_PKG ]]; then
    mv $Old_PKG Unkown-$Old_PKG
    echo "Renamed $Old_PKG to Unkown-$Old_PKG to let the script run properly later on"
fi

# Python notarization part of the sript

$MUNKIROOT/code/tools/build_python_framework.sh

#get current python version used in Munki build so that it doesn't have to be hardcoded
PYTHON_FRAMEWORK_VERSION=$(ls Python.framework/Versions | grep -v "Current")

find $MUNKIROOT/Python.framework/Versions/$PYTHON_FRAMEWORK_VERSION/lib/ -type f -perm -u=x -exec codesign --force --deep --verbose -s "$DevApp" {} \;
find $MUNKIROOT/Python.framework/Versions/$PYTHON_FRAMEWORK_VERSION/bin/ -type f -perm -u=x -exec codesign --force --deep --verbose -s "$DevApp" {} \;

find $MUNKIROOT/Python.framework/Versions/$PYTHON_FRAMEWORK_VERSION/lib/ -type f -name "*dylib" -exec codesign --force --deep --verbose -s "$DevApp" {} \;
find $MUNKIROOT/Python.framework/Versions/$PYTHON_FRAMEWORK_VERSION/lib/ -type f -name "*so" -exec codesign --force --deep --verbose -s "$DevApp" {} \;

/usr/libexec/PlistBuddy -c "Add :com.apple.security.cs.allow-unsigned-executable-memory bool true" $MUNKIROOT/entitlements.plist

codesign --force --options runtime --entitlements $MUNKIROOT/entitlements.plist --deep --verbose -s "$DevApp" $MUNKIROOT/Python.framework/Versions/$PYTHON_FRAMEWORK_VERSION/Resources/Python.app/

codesign --force --options runtime --entitlements $MUNKIROOT/entitlements.plist --deep --verbose -s "$DevApp" $MUNKIROOT/Python.framework/Versions/$PYTHON_FRAMEWORK_VERSION/bin/"python$PYTHON_FRAMEWORK_VERSION"
codesign --force --deep --verbose -s  "$DevApp" $MUNKIROOT/Python.framework

# Creating munkitools.pkg
# Change for if you want a package that includes the client settings for the installation

# Without client settings for munki
sudo $MUNKIROOT/code/tools/make_munki_mpkg.sh -i "$BUNDLE_ID" -S "$DevApp" -s "$DevInst" -o "$OUTPUTDIR"

#With client settings for munki
#sudo $MUNKIROOT/code/tools/make_munki_mpkg.sh -i "$BUNDLE_ID" -S "$DevApp" -s "$DevInst" -c "$MUNKIROOT/code/tools/MunkiClientSettings.plist" -o "$OUTPUTDIR"

# Get filename for munkitools file that was created above
BUNDLE_PKG=$( ls munkitools-[0-9]* )

# prepare munkitools for notarization and signing
LocalUser=$(whoami)
sudo chown $LocalUser $BUNDLE_PKG

# Notarizing and signing munkitools.pkg

# create temporary files
NOTARIZE_APP_LOG=$(mktemp -t notarize-app)
NOTARIZE_INFO_LOG=$(mktemp -t notarize-info)

# delete temporary files on exit
function finish {
	rm "$NOTARIZE_APP_LOG" "$NOTARIZE_INFO_LOG"
}
trap finish EXIT

# submit app for notarization
if xcrun altool --notarize-app --primary-bundle-id "$BUNDLE_ID" --password @keychain:Apple_dev_acc -f "$BUNDLE_PKG" > "$NOTARIZE_APP_LOG" 2>&1; then
	cat "$NOTARIZE_APP_LOG"
	RequestUUID=$(awk -F ' = ' '/RequestUUID/ {print $2}' "$NOTARIZE_APP_LOG")

	# check status periodically
	while sleep 60 && date; do
  echo "Waiting on Apple to approve the notarization so it can be stapled. This can take a few minutes or more. Script auto checks every 60 sec"

		# check notarization status
		if xcrun altool --notarization-info "$RequestUUID" --password @keychain:Apple_dev_acc > "$NOTARIZE_INFO_LOG" 2>&1; then
			cat "$NOTARIZE_INFO_LOG"

			# once notarization is complete, run stapler and exit
			if ! grep -q "Status: in progress" "$NOTARIZE_INFO_LOG"; then
				#wait for package to be successfully notarized before renaming; if notarization fails the file will still be renamed accordingly
				if grep -q "Status Message: Package Approved" "$NOTARIZE_INFO_LOG"; then
					xcrun stapler staple "$BUNDLE_PKG"
					mv $BUNDLE_PKG Notarized-$BUNDLE_PKG
					# Renames the $BUNDLE_PKG file too Notarized-$BUNDLE_PKG so the script can run again without any problems
					echo "Renamed $BUNDLE_PKG to Notarized-$BUNDLE_PKG to let you know it was notarized"
					echo "You can check if its notarized properly with Taccy - https://eclecticlight.co/taccy-signet-precize-alifix-utiutility-alisma/"
					exit $?
				else
					echo "Notarization Unsuccessful; $BUNDLE_PKG is still available as a signed package"
					exit 1

				fi
			fi
		else
			cat "$NOTARIZE_INFO_LOG" 1>&2
			exit 1
		fi
	done
else
	cat "$NOTARIZE_APP_LOG" 1>&2
	exit 1
fi
