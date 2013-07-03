Localization Utils
==================

Utilidades para ayudar a la localización lingüística de nuestras aplicaciones.

* localizable-generator: se utiliza para crear los archivos strings.xml de Android o Localizable.strings de iOS a partir de una hoja de cálculo de Google Drive.

Instalación
-----------

Es necesario tener ruby 1.9.3 como mínimo instalado. Si no sabes cómo instalarlo, prueba usando [RVM](https://rvm.io/rvm/install/).

Para poder usar este script tienes que ejecutar primero en el directorio:

	bundle install

Esto te instalará las dependencias necesarias.

Uso del localizable-generator
-----------------------------

Se ejecuta pasando una serie de parámetros por línea de comandos. Os pego:

    localizable-generator (c) 2013 Eli Kohen <elikohen@gmail.com>
    -u your.user@gmail.com,          Your Google Drive user
        --username
    -p, --password your_password     Your Google Drive password
    -s example-spreadsheet,          Spreadsheet containing the localization info
        --spreadsheet
    -i /the_path/Localizables/,      Path to the iOS localization directory
        --output-ios
    -a /the_path/res/,               Path to the resource directory of an Android project
        --output-android
    -j /the_path/strings/,           Path to the JSON localization directory
        --output-json
    -h, --help                       Show this message
    -v, --version                    Print version

Que igual os parece chungo, pero si lo explico seguro que no :)

- El username y el password son los de vuestra cuenta de mmip. Una vez hayáis metido los valores, se guardan en local y no hace falta introducirlos más. Si no los introducís la primera vez, la aplicación os lo solicitará.
- El campo spreadsheet es una parte del nombre de la hoja de cálculo, sin el [Localizables]. Por ejemplo, en el caso de radares, la hoja de cálculo se llama "[Localizables] Radares: AvisaMe" y aquí bastaría con poner "radares" o "avisame".
- Las rutas de iOS, Android y JSON: debe haber por lo menos una. En el caso de iOS marcamos el directorio raíz donde están los localizables, normalmente lo ponemos en /Classes/Resources/Localizables. En el caso de Android tenemos que poner el directorio /res del proyecto. En el caso de JSON, marcamos un directorio base del que creará el programa un /strings/localizable.json con todos los datos.
- Si queréis que un localizable sólo esté en una plataforma, poned al principio de la key [a] para Android, [i] para iOS o [j] para JSON, solo en el caso de que se exporte para más de una plataforma.

Lo veréis más sencillo con un ejemplo. 

Esto generaría sólo los de iOS de radares.

	localizable-generator -u pepe@mmip.es -p pepepepe -s radares -i /Users/mrm/Documents/workspace/Radares-iOS/Radares/Resources/Localizables

Y esto generaría los de iOS y Android.

	localizable-generator -u pepe@mmip.es -p pepepepe -s radares -i /Users/mrm/Documents/workspace/Radares-iOS/Radares/Resources/Localizables -a /Users/mrm/Documents/workspace/Radares-Android/res


La hoja de cálculo en Google Drive
----------------------------------

Repito lo de antes, podéis ver un ejemplo en: https://docs.google.com/spreadsheet/ccc?key=0AjxU4FKmsSr8dDBUa0dNYThxMnVrbWY5Rzd4SWpKTVE

* Siempre *la columna A va a contener la clave del localizable, sin ningún tipo de guión bajo*. Simplemente el nombre con sus espacios y tal, muy legible.
* Siempre *la primera fila que marque el comienzo del localizable en sí va a tener [key] en la columna A, y los códigos de país en las siguientes columnas*, marcando el idioma que vayáis a poner debajo. Es importante comentar que *en el caso de que un idioma sea el que queramos por defecto en Android deberemos marcarlo con un asterisco*, por ejemplo poniendo "es*" en vez de "es".
* Para marcar un comentario habrá que poner *[COMMENT]* como clave. Es conveniente repetir en todos los idiomas el texto del comentario (incluso se puede traducir si se quiere).
* Por defecto, todo lo que pongáis va a ser para todas las plataformas.
* Para indicar que un texto es solo para Android, poned al principio de su key el tag __[a]__ en minúscula. 
* Para indicar que un texto es solo para iOS, poned al principio de su key el tag __[i]__ en minúscula. 
* El *final* del archivo localizable se marcará con el *tag [END] en la columna A*.

Es importante que mantengáis un Google Docs con colorines muy claros, y podéis usar todos los modificadores de estilo que queráis (negrita, cursiva, etc), porque no afecta a la generación.
Sobre todo si se lo pasáis a un cliente, hay que tenerlo todo muy aseado.

Es *recomendable que si esto lo va a tocar un cliente se bloqueen ciertas columnas y filas básicas*: La columna A entera y la fila que contenga [key] y los idiomas, para evitar _client disasters_.

- - -

Espero que las aplicaciones os sean de utilidad. Para cualquier consulta: elikohen@gmail.com
