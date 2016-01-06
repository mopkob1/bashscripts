# synccom.sh
backup or recovery configs from list of paths to any path

    You have to prepare file with name "list" whith pathes to backup.
    You can use absolute (/etc/apache/) or relative (../../test/) paths.
    
    Two rules about list file:
		1) All strings in list-gile start without first "/": /etc/apache/ ----> etc/apache/
		2) Last "/" - means all dir. If you put line whithout that mean one file.

    Before using you have to change 2 variables in synccom.sh:
		1) FROM = "path to add before each line in list file 
		2) TO = "path, where you want to place your backup"

When you use this script together with GIT you can backup your server configs.
