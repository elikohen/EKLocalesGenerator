Localization Utils
==================
Utility set to help on language localisation of Android and iOS apps.

* **localizable-generator:** Will generate strings.xml files for Android and all Localizable.strings for iOS from a Google Drive Spreadsheet data.
* **spreadsheet-generator:** [Only on standalone] Will populate a Google Drive Spreadsheet reading from Android strings.xml or iOS Localizable.strings files.


Fastlane usage
--------------
There's a built in integration to fastlane inside the repo. I assume you're already working with it, otherwise I encourage to to take a look at their [Fastlane Documentation](https://docs.fastlane.tools/)

Once you have fastlane setup, you just need to import our fastlane file (so that the action ek_locales action is imported)

Add the following import just after `fastlane version x.x.x` on your fastfile:

```
fastlane_version "2.32.1"

import_from_git(url: 'git@github.com:elikohen/EKLocalesGenerator.git', path: 'fastlane/Fastfile')
```

So now you're ready to use the ek_locales action. It contains the following parameters:

- *spreadsheet_name*: Name of spreadsheet. I.E. if spreadsheet is '[Localizables] myProject', you mustf set 'myProject'                           
- *localizables_dir*: Directory of .lproj files on iOS and res directory on android                      
- *google\_client\_id*: [Optional] If you want to use your own google apps account with google drive this is the Google apps client id 
- *google\_client\_secret*: [Optional] If you want to use your own google apps account with google drive this is the Google apps client secret of the oauth key
- *repository_path*: [optional] Path to the repository if it's located on a subfolder. Usefull if you're using c.i. and it checkouts a specific branch to a temporary folder-
- *mark_unused*: [Optional] Mark all the unused strings in spreadsheet

examples:

```
ek_locales(
	spreadsheet_name: 'myProject',
	localizables_dir: 'myProject/i18n/'
)
```
```
ek_locales(
	google_client_id: 'someid-somehash.apps.googleusercontent.com',
	google_client_secret: 'someHexa64Secret'',
	spreadsheet_name: 'myProject',
	localizables_dir: 'myProject/i18n/',
	repository_path: 'some/temporal/subdir/',
	mark_unused: true
)
```



Standalone Installation
-----------------------
Ruby >= 1.9.3 is required. If you require installing it and don't know how to do it, try with [RVM](https://rvm.io/rvm/install/).

In order to use the scripts, all the required gems must be installed, so type this on the root folder:

	bundle install

It will install all dependencies.

If bundle command is not installed please follow this link: http://bundler.io/

localizable-generator Usage
---------------------------

Those are the generator parameters, you can show all them by typing -h

    localizable-generator (c) 2013 EKGDev <elikohen@gmail.com>
        --client-id                  google Client id
    -l, --client-secret              google Client secret
    -s example-spreadsheet,          Spreadsheet containing the localization info
        --spreadsheet
    -i /the_path/Localizables/,      Path to the iOS localization directory
        --output-ios
    -a /the_path/res/,               Path to the resource directory of an Android project
        --output-android
    -j /the_path/strings/,           Path to the JSON localization directory
        --output-json
    -k, --[no-]keep-keys             Whether to maintain original keys or not
    -c, --[no-]check-unused          Whether to check unused keys on project
    -m, --[no-]check-unused-mark     If checking keys -> mark them on spreadsheet prepending [u]
    -h, --help                       Show this message
    -v, --version                    Print version

It might sound weird or difficult but I'll explain them

- **Client**, this is created going thru https://console.developers.google.com, follow the instructions to create a Client ID for native application, download the JSON and enter the download path here. After creating a project go to *APIs & auth* then *Credentials*, click on *Create new Client ID*, select *Installed Application* and then you can download the json. There you can find the client_id and secret required by the script
- **Spreadsheet name** is part of the spreadsheet name without the [Localizables] token. For instance if the spreadsheet is called *[Localizables] Ztory* you can type just *Ztory* on this parameter.
- **iOS, Android and JSON paths:** It must be at least one of this parameters. In case of iOS it should point to the folder where are the Localizables.strings, on android it should point to the .../res folder.
- **check-unused** It shows a list of all keys that are not used on the project (it can provide false positives if you concatenate strings to access them).
- **check-unused-mark** when checking unused if this parameter is provided, the script will prepend [u] to each unused key on the google spreadsheet so that in the next generation it won't be generated.
- *trick:* If you want one of the keys (spreadsheet row) just for one of the platforms, just type [i], [a] or [j] as a prefix for the key.

An example will show everything better. 

This will generate just iOS localisables of a "radares" app.

	localizable-generator -u some_path_to.json -s radares -i /Users/mrm/Documents/workspace/Radares-iOS/Radares/Resources/Localizables

And this will generate both iOS and Android

	localizable-generator -u some_path_to.json -s radares -i /Users/mrm/Documents/workspace/Radares-iOS/Radares/Resources/Localizables -a /Users/mrm/Documents/workspace/Radares-Android/res


Google Drive spreadseet
----------------------------------

Take this spreadsheet as an example <https://docs.google.com/spreadsheet/ccc?key=0AiB94r-ubs9sdHBQYTBOcEJ2TV9KeG5qT2lWSWhOOXc&usp=sharing>

* A column will **always** contain the locale key *in a readable way* (with spaces, no slashes, underscores, etc). The script will camel case keys on iOS and use underscores on android.

* The **[key]** token on column A indicates start of localizables, so all the next columns to the right will have (in the same row than the [key] token) the language indicator. If you want to set one language as default, just append **\*** to the language.

* The **[COMMENT]** token (always in the A column) indicates a comment, to use as separator in localizable files. It is recommended to translate also the comment for each column so that the generated file will be even more readable.

* By default any translation you write will be generated for all platforms.
	* If you want to restrict one key just for android prepend **[a]** to the key.
	* To restrict just for iOS prepend **[i]** to the key.
* The **[END]** token is required at the end of the column A to indicate that there are no more keys to generate.

It is important to maintain the Spreadsheet file with colors (on important rows, columns, comments) so that it becomes more readable. You can use any style modifier you want as it won't affect the generation.


Common issues
----------------------------------
### Cannot install nokogiri gem
In their [home page](www.nokogiri.org) you can find an excellent [tutorial](http://www.nokogiri.org/tutorials/installing_nokogiri.html#install_with_included_libraries__recommended_). In my case I had a problem with conflicting libxml2 libraries because of homebrew usage. The solution they propose of unlinking `xz` and linking it again worked perfectly:

	brew unlink xz
	sudo gem install nokogiri
	brew link xz


### Open ssl issue
Some of you are having a ssl issue related with OPENSSLv3 and rvm. This is related of ruby using a the wrong system certificates. If you fall into that please reinstall your current ruby version using the following command:

`rvm reinstall [yourversion] --disable-binary`

Helper Script
----------------------------------
This is a helper script to place on your root project folder that downloads localizable script and executes it. Just change the line that starts with *./localizable-generator* with your own values.

    #!/bin/bash
    dir="$HOME/.ekscripts/locales-generator"
    projectDir=`pwd`
    if [ -d "$dir" -a ! -h "$dir" ]
    then
      echo "$dir found, updating script"
      cd "$dir"
      git pull > /dev/null
      echo "Updated. NOTE: if some gems are missing go to $dir and type 'bundle update'"
    else
      echo "Error: $dir not found, creating it and cloning script"
      mkdir -p "$dir"
      git clone "https://github.com/elikohen/EKLocalesGenerator.git" "$dir" > /dev/null
      cd "$dir"
      bundle install
    fi
      
    cd "$dir"
    ./localizable-generator -u "$projectDir/client_secret_localizables.json" -s Project_name -a "$projectDir/path_that_contains_res_folder/" $@
    cd "$projectDir"


- - -

I hope this will help you in your projects. If you have any doubt just open an Issue and ask for it.


Note: Thanks to [Christian Ronningen](https://github.com/ChristianRonningen) for the support!
