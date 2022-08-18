# Different scripts for macOS

## Munki Notarization scripts
###### lets you do the following:
- Updates munki folder before updating so you get the latest version
- Re-names previous munkitools-versions files to unkown-munkitools-version.pkg so the script later in the script runs correct.
Renaming is done since its unkown if the older files in munki folder are notarized or note.
- Signes the the custom python.pkg for munkitools to make it work with notarization later on in the script.
- Uploads the finished packaged munkitools-version.pkg to Apple to get it approver for notarization.
When and if Apple approves it for notarization it gets automaticly stapled and signed so it completes the notarization process.
- Re-names the finished munkitools-version.pkg too Notarized-munkitools-version.pkg so it's easy to see it has been notarized.
You can then run the script again if you want too.

## Update regarding Apple Altool
Apple´s Altool software that the original script uses to notarize the app will be deprecated fall 2023 and the new tool is Notarytool.
Because of this the script has been updated and the guide below has been updated also.
Step 1 in the guide below has been updated to guide you thrue how to set a NotaryTool keychain profile.
This new keychain profile will be used to notarize the app.

## Step 1: What you will need to notarize and sign software
- Apple Developer account
- Apple Developer ID Application Certificate in keychain
- Apple Developer ID Installer Certificate in keychain
- Apple Developer App-Specific Password
- Xcode installed on your Mac or at least Xcode Command Line Tools

## Step 2: How to set up Apple Developer App-Specific Password:

1: Create an Apple Developer app-specific password using the guide in the link below.
https://support.apple.com/en-us/HT204397

Step 2 below has been updated to use the new notarytool not altool that was originally used
2: Open "Terminal.app" and run command below
xcrun notarytool store-credentials --apple-id "name@example.com" --team-id "ABCD123456"

More detailed:
When you enter the Command you will be asked to type in a Profile Name then the App-specific password you created in the step abow it
will then validate what you typed in and if it was correct you will get "Success. Credentials validated. Credentials saved to Keychain."

What happens when you run the command abow:
This process stores your credentials securely in the Keychain. You reference these credentials later using a profile name.

Profile name:
notary-example.com
Password for name@example.com:
Validating your credentials...
Success. Credentials validated.
Credentials saved to Keychain.
To use them, specify `--keychain-profile "notary-example.com"`


Command explained:
Store-Credentials = the name that will be used later in the script
Add your Apple Developer ID e-mail account behind " --apple-id " and add your Apple Team ID " --team-id "

Tip: You can find you Apple Devoloper Team ID number in Keychain just search for Installer and Application.

You should then see "Apple Developer ID Application: Name/Company (Team ID)" and "Apple Developer ID Installer: Name/Company (Team ID)"

## Step 3:
1: Download the scripts

2: Open Munki.Notarize.zsh in your text editor TextEdit, Atom etc

3: Go to "Change what is needed below this line" and change "Name/Company (ID)" to match your Apple Developer ID info and save the file

Tip: You can find you Apple Devoloper ID Name and ID number in Keychain just search for Installer and Application.

You should then see "Apple Developer ID Application: Name/Company (ID)" and "Apple Developer ID Installer: Name/Company (ID)"

## Step 4: How to set up Munki and copy scripts to correct folder

1: Open terminal --> cd "To the folder you want munki to be in"
Tip: If you get some type of warning or access problem you could try to use this folder for munki building "/Users/Shared/"

2: Type in terminal: git clone https://github.com/munki/munki.git

3: Copy the scripts to the "munki/code/tools" folder that was created in the step abow

4: In terminal type "cd /Path/To/munki/Folder" where the git repo folder is located

Tip: You might need to open Terminal and run chmod +x on the files below to make them able to run.
- Munki.Notarize.Specific.Git.Version.zsh
- Munki.Notarize.zsh
- MunkiClientSettings.plist

## Step 5: Building a specific munki version (Recommended way)
More detailed information is here: https://github.com/munki/munki/wiki/Building-Munki-packages

2: In terminal type "cd /Path/To/munki/Folder" too where the git repo folder is located that you made in the steps above

3: Type "git tag" in Terminal and press the "Enter" key until you find the build version you want to make.

OR

You can look for the git tag for the specific version you want on the website below like showed in the picture
https://github.com/munki/munki/releases/

<a href="https://ibb.co/FBxWmPM"><img src="https://i.ibb.co/FBxWmPM/GitTag.png" alt="GitTag" border="0"></a>

4: Run "Munki.Notarize.Specific.Git.Version.zsh -b VersionNumber" to build the specific version you want

5: Enter your users account password when asked for it.

6: If everything goes correct a notarized packaged file will be built to munki/munki-git folder


###### Building latest version running only Munki.Notarize.zsh (Not really recommended but it works, so you should use the method in step 4)
Tip: Since munki can get different commits its recommended to build the specific munki version you want but you can run Munki.Notarize.zsh if you want.

1: Copy Munki.Notarize.Specific.Git.Version.zsh, Munki.Notarize.zsh and MunkiClientSettings.plist to munki/code/tools/ folder

2: In terminal type "cd munki" to where the git repo folder is located

4: Drag Munki.Notarize.zsh script into the terminal window and run it

6: Enter your computer Password when asked for it.

## macOS Catalina error message that sometimes happens with different munki builds:
Problem: You might experience the following error when running this script or when you are running code/tools/make_munki_mpkg.sh

The domain/default pair of (/Users/eric/Desktop/munki/code/client/munkilib/version, CFBundleShortVersionString) does not exist
/Users/eric/Desktop/munki/code/client/munkilib/version is missing!
Perhaps /Users/eric/Desktop/munki does not contain the munki source?

https://github.com/munki/munki/issues/978

The problem seems to be happen with some munki builds but not everyone.

Partial fix: Try macOS Mojave 10.14.6 and Xcode 11.3.1 this the latest version that supports Mojave it should now work without any problems.
Somebody have manged to make it work on macOS Catalina if they put the munki files in /Users/Shared folders.
You could probably run older versions of Xcode but havent tried.

## Tips

Tip 1: If you get “You must first sign the relevant contracts online. (1048)” error
Go to Apple.developer.com and sign in with the account you are trying to notarize the app with and agree to the updated license agreement.

## Known problems
Updated 29 September 2021

Munki v5.5.0 & v5.5.1 on Apple M1 problems
There is a known problem with packaging Munki v5.5.0 and v5.5.1 caused by PyobjC that triggers problems for Xattr during the build process.
There is also a problem with Xcode 12.5 and 12.5.1

If you want to notarize or build Munki v5.5.0 & v5.5.1 its recommended to use the following:
CPU: Intel
OS: macOS 11.4 maybe 11.5 and 11.6 will work but i havent tried.
Xcode: 12.4 (12.3 might work) 12.5 and 12.5.1 DONT work, Not tested on Xcode 13 yet
https://github.com/lifeunexpected/Scripts/issues/5
https://github.com/munki/munki/issues/1100#issuecomment-900119943