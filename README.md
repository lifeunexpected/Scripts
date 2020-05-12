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
1: Open terminal --> cd "To the top folder you want munki to be in"

2: Type in terminal: git clone https://github.com/munki/munki.git

3: Copy script to "munki/code/tools" folder

4: In terminal type "cd munki" where the git repo folder is located

5: drag the script into the terminal window and run it

6: Enter Password when asked for it
