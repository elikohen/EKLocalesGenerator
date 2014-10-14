Localization Utils
==================
Utility set to help on language localisation of Android and iOS apps.

* **localizable-generator:** Will generate strings.xml files for Android and all Localizable.strings for iOS from a Google Drive Spreadsheet data.
* **spreadsheet-generator:** Will populate a Google Drive Spreadsheet reading from Android strings.xml or iOS Localizable.strings files.

Installation
------------
Ruby >= 1.9.3 is required. If you require installing it and don't know how to do it, try with [RVM](https://rvm.io/rvm/install/).

In order to use the scripts, all the required gems must be installed, so type this on the root folder:

	bundle install

It will install all dependencies.

localizable-generator Usage
---------------------------

Those are the generator parameters, you can show all them by typing -h

    localizable-generator (c) 2013 EKGDev <elikohen@gmail.com>
    -u, --username your.user@gmail.com		Your Google Drive user
    -p, --password your_password     Your Google Drive password
    -s example-spreadsheet,          Spreadsheet containing the localization info
        --spreadsheet
    -i /the_path/Localizables/,      Path to the iOS localization directory
        --output-ios
    -a /the_path/res/,               Path to the resource directory of an Android project
        --output-android
    -j /the_path/strings/,           Path to the JSON localization directory
        --output-json
    -c, --[no-]check-unused          Whether to check unused keys on project
    -m, --[no-]check-unused-mark     If checking keys -> mark them on spreadsheet prepending [u]
    -h, --help                       Show this message
    -v, --version                    Print version

It might sound weird or difficult but I'll explain them

- **Username and password** are the ones you use for gmail (maybe if you're using 2factor authentication it won't work...). Those values are required just for the first time, and get stored locally so that the next times the script reuses them.
- **Spreadsheet name** is part of the spreadsheet name without the [Localizables] token. For instance if the spreadsheet is called *[Localizables] Ztory* you can type just *Ztory* on this parameter.
- **iOS, Android and JSON paths:** It must be at least one of this parameters. In case of iOS it should point to the folder where are the Localizables.strings, on android it should point to the .../res folder.
- **check-unused** It shows a list of all keys that are not used on the project (it can provide false positives if you concatenate strings to access them).
- **check-unused-mark** when checking unused if this parameter is provided, the script will prepend [u] to each unused key on the google spreadsheet so that in the next generation it won't be generated.
- *trick:* If you want one of the keys (spreadsheet row) just for one of the platforms, just type [i], [a] or [j] as a prefix for the key.

An example will show everything better. 

This will generate just iOS localisables of a "radares" app.

	localizable-generator -u pepe@gmail.com -p pepepepe -s radares -i /Users/mrm/Documents/workspace/Radares-iOS/Radares/Resources/Localizables

And this will generate both iOS and Android

	localizable-generator -u pepe@gmail.com -p pepepepe -s radares -i /Users/mrm/Documents/workspace/Radares-iOS/Radares/Resources/Localizables -a /Users/mrm/Documents/workspace/Radares-Android/res


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

- - -

I hope this will help you in your projects. If you have any doubt just open an Issue and ask for it. 
