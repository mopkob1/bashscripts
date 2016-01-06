# synccom.sh
backup or recovery configs from list of paths to current path

    You have to prepare file with name "list" whith pathes to backup.
    You can use absolute (/etc/apache/) or relative (../../test/) paths.
    
    Two rules:
		All strings in list-gile start without first "/": /etc/apache/ ----> etc/apache/
		Last "/" - means all dir. If you put line whithout that mean one file.

When you use this script together with GIT you can backup your server configs.
