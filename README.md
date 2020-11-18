# rsync-increamental-backup

Below is a simple bash script that uses rsync command, with option "--backup" and "--backup-dir" to backup data. 
In this way, only the old files will be copied to the "--backup-dir". Comparing the backup apps using  hard links, it can drastically reduce the number of links 
if you have alot of files in the folder to backup.

With this method, I can first do a full backup to ${DSTDIR} folder using rsync, and after that I can use this script to do increaental backup more 
frequently(like daily, etc.). The ${DSTDIR} folder always has the most recent data backuped.

The script is coded on Centos 7, rsync  version 3.1.2.

> #!/bin/bash -x
> 
> lock=/tmp/rsync-backup-local.lock
>
>  \# Check the lock file. Only alow one instance till finished.
> if [ -f $lock ]; then
>
>      echo "Backup is already running, please try again later!"
>
>    exit
>
> fi
>
> \# Create the lockfile
>
>touch $lock
>
>if [ $? -ne 0 ]; then
>
>  echo " can not make lock file: $lock"
>
> exit
>
>fi
>
> \# directory to backup
>
>SRCDIR=/home/feng
>
> \# directory for backup
>
>DSTDIR=/data/backup_home
>
> \# excludes files/folders for backup
>
>EXCLUDES=/home/feng/rsync_exclude.txt
>
> \# remote backup server if any.
>
>SERVER=
>
>
> \# folders for saving the older files/folders.
>
>BACKUPDIR=`date +%Y-%m-%d_%H-%M-%S`
>
> \# options for rsync command...
>
>OPTS=" --log-file=${DSTDIR}/rsync-$BACKUPDIR.log --force --ignore-errors --delete-excluded --exclude-from=$EXCLUDES --delete --backup --backup-dir=${DSTDIR}/$BACKUPDIR --relative -a"
>
>
> \# do the backup
>
>rsync $OPTS $SRCDIR ${SERVER}${DSTDIR}
>
>rm $lock
>

---------------------------------------

The exlcude file may look like:

>cat rsync_exclude.txt
>
>.[a-z]*/
>
>
>oldhome/
>
>*.o
>
>tmp/
>
>temp/
>
>*mp3
>
>*mp4
>
>*avi
>
>*~
>
>*nobackup*
>
>core.*
>
>tutorials/
>
>foo

