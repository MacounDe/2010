Macoun 2010 - Cocos2d mit Komponenten

Source Code wird "as is" zur Verfügung gestellt. Ohne support.

Gocos = Game Object Component System

Gocos enthält noch Bugs, ist unvollständig und ungetestet.
Es sollte dementsprechend nicht als Grundlage für Projekte dienen,
sondern nur zu Lernzwecken. Als Basis dient derzeit noch die
veraltete cocos2d v0.99.5 beta 1 Version. Außerdem habe ich etliche
Dateien gelöscht, um die Größe des downloads zu reduzieren.

cocos2d-project ist das Projekt, gocos die Komponenten Library.
Im gocos Ordner ist ein docs.zip mit Doxy docs und ein doxyfile, 
um die Docs ggfs. selber zu generieren.

Ich arbeite derzeit an einem Projekt das das Komponentensystem
erstmalig im realen Einsatz prüft. Dieses überarbeitete und erprobte
Komponentensystem werde ich später veröffentlichen, entweder als 
Open Source in meinem Github repository:

https://github.com/GamingHorror

Oder als Teil eines kommerziellen Produkts auf meiner Webseite:

http://www.learn-cocos2d.com

Oder beides. :)

Hängt einfach von der Trennung ab, im Moment tendiere ich zu:
- Komponentensystem Gocos kostenlos & open source
- Starterkits auf Basis von Gocos kommerziell


Mein cocos2d-project is jetzt übrigens auch auf Github:
https://github.com/GamingHorror/cocos2d-project


Wenn ich Gocos veröffentliche, wird es ein überarbeitetes cocos2d-project
nutzen und komplett mit cocos2d-iphone und gocos sowie wax (Lua für iOS)
gemeinsam zum Download stehen. Dann wird das eine "all-in-one" Lösung,
und es Bedarf keiner separaten downloads mehr.

Es hat sich nämlich gezeigt das durch Änderungen an Cocos2D, und
zukünftig auch wax, Probleme entstehen die ich nicht kenne, weil ich
noch mit alten Versionen arbeite. Als kompletten Download umgehe ich
dieses Problem, und kann sagen "damit funktionierts". Wer dann doch
cocos2d-iphone oder wax updaten will, kann das immer noch tun, hat aber
entsprechend keine Funktionsgarantie. Evtl. bugfixes und 
Kompatibilitätsupdates nehme ich auf github natürlich gerne entgegen.
