#!/bin/bash -x
  
lock=/tmp/rsync-backup-local.lock
# Check the lock file. Only alow one instance till finished.
if [ -f $lock ]; then
   echo "Backup is already running, please try again later!"
   exit
fi
# Create the lockfile
touch $lock
if [ $? -ne 0 ]; then
  echo " can not make lock file: $lock"
  exit
fi

# directory to backup
SRCDIR=/home/feng

# directory for backup
DSTDIR=/data/feng/backup

# excludes files/folders for backup
EXCLUDES=$HOME/rsync_exclude.txt

# remote backup server if any.
SERVER=


# folders for saving the older files/folders.
BACKUPDIR=$`date +%Y-%m-%d_%H-%M-%S`

# options for rsync command...
OPTS=" --log-file=${DSTDIR}/rsync-$BACKUPDIR.log --force --ignore-errors --delete-excluded --exclude-from=$EXCLUDES --delete --backup --backup-dir=${DSTDIR}/$BACKUPDIR --relative -a"

# do the backup
rsync $OPTS $SRCDIR ${SERVER}${DSTDIR}
rm $lock
