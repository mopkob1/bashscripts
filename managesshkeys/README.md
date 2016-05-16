# getkeys.sh
Get all files of "/root/.ssh" path  from the list of hosts wrote in "list"

    Put list of hosts or hostnames into a "list" and execute getkeys.sh
    Get files from "<host|hostname>:/root/.ssh/" in local directory "./<host|hostname>/"
    
# compilekeys.sh
Compile all "authorized_keys"-files from all local directories listed in "list"

    Put list of hosts or hostnames into a "list" and execute getkeys.sh
    See result in "allinall"-file. File contain uniq-records

# addkeys.sh
Update all "authorized_keys"-files in all  local directories listed in "list"

    Edit "list" and execute addkeys.sh

# setkeys.sh
Get all files from "./\<host\|hostname>\/" path to "\<host\|hostname\>:\/root\/.ssh\/" listed in "list"

    Edit "list" and execute addkeys.sh

You can comment any line in "list" or "allinall". Simple put "#" in start or end of line.
