# Different scripts for macOS

## MunkiPythonNotarizeAndSign
###### lets you do the following:
- Updates munki folder before updating so you get the latest version
- Re-names previous munkitools-versions files to unkown-munkitools-version.pkg so the script later in the script runs correct.
Renaming is done since its unkown if the older files in munki folder are notarized or note.
- Signes the the custom python.pkg for munkitools to make it work with notarization later on in the script.
- Uploads the finished packaged munkitools-version.pkg to Apple to get it approver for notarization.
When and if Apple has approved it for notarization it gets automaticly stapled and signed so it completes the notarization process.
- Re-names the finished munkitools-version.pkg too Notarized-munkitools-version.pkg so it's easy to see it has been notarized. 
You can then run the script again if you want too.

###### How to use:

1: Add your Apple developer account e-mail
AppleAcc="DeveloperAppleAcc@Apple.com"

2: Create an Apple Developer app-specific password with following the link below and add it to the script
https://support.apple.com/en-us/HT204397
AppleAccPwd="Apple Developer Account app-specific password"

3: Open terminal --> cd "To the folder you want munki to be in"

4: Type in terminal: git clone https://github.com/munki/munki.git

5: Copy script to "munki/code/tools" folder

6: In terminal type "cd munki" where the git repo folder is located

7: drag the script into the terminal window and run it

8: Enter your computer Password when asked for it.

###### macOS Catalina error message that sometimes show:
Problem: You might experience the following error when running this script or when you are running code/tools/make_munki_mpkg.sh

The domain/default pair of (/Users/eric/Desktop/munki/code/client/munkilib/version, CFBundleShortVersionString) does not exist
/Users/eric/Desktop/munki/code/client/munkilib/version is missing!
Perhaps /Users/eric/Desktop/munki does not contain the munki source?

https://github.com/munki/munki/issues/978

The problem seems to be happen with some munki builds but not everyone.

Partial fix: If you run macOS Mojave 10.14.6 and Xcode 11.3.1 this the latest version that supports Mojave it should now work without any problems.
You can probably run older versions also but havent tried those. 
