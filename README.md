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

## Step 1: How to set up Apple Developer App-Specific Password:

1: Create an Apple Developer app-specific password with following the link below.
https://support.apple.com/en-us/HT204397

2: Open "Terminal.app" and run command below
xcrun altool --store-password-in-keychain-item Apple_dev_acc -u 'AppleDev@account.com' -p AppSpecificPassword

Explained: Add  your Apple Developer ID e-mail account behind " -u " and add Apple Developer app-specific password being " -p "

## Step 2:
1: Download the scripts
2: Open Munki.Notarize.zsh in your text editor TextEdit, Atom etc
3: Go to Line number 21 and change "Name/Company (ID)" to match your Apple Developer ID info and save the file

Tip: You can find you Apple Devoloper ID Name and ID number in Keychain just search for Installer and Application.
You should then see "Apple Developer ID Application: Name/Company (ID)" and "Apple Developer ID Installer: Name/Company (ID)"

## Step 3: How to set up Munki and copy scripts to correct folder

1: Open terminal --> cd "To the folder you want munki to be in"
Tip: If you get some type of warning or access problem you could try to use this folder for munki building "/Users/Shared/"

2: Type in terminal: git clone https://github.com/munki/munki.git

3: Copy the scripts to the "munki/code/tools" folder that was created in the step abow

4: In terminal type "cd /Path/To/munki/Folder" where the git repo folder is located

## Step 4: Building a specific munki version (Recommended way)
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

### Tips

Tip 1: If you want to create a munki.pkg installer with Custom Client Settings you can modify the Munki.Notarize.zsh and just switch the " # " in front of the commands below
Example below will create a munki.pkg without custom client settings.
 
#Without client settings for munki
sudo $MUNKIROOT/code/tools/make_munki_mpkg.sh -i "$BUNDLE_ID" -S "$DevApp" -s "$DevInst" -o "$OUTPUTDIR"

#With client settings for munki
#sudo $MUNKIROOT/code/tools/make_munki_mpkg.sh -i "$BUNDLE_ID" -S "$DevApp" -s "$DevInst" -c "$MUNKIROOT/code/tools/MunkiClientSettings.plist" -o "$OUTPUTDIR"

 Tip 2: If you get “You must first sign the relevant contracts online. (1048)” error
 Go to Apple.developer.com and sign in with the account you are trying to notarize the app with and agree to the updated license agreement.
