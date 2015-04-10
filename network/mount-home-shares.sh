#!/bin/sh

source $HOME/.private

storage=/Volumes/storage
backup=/Volumes/backup
backup_disk=$storage/$USER/backups/$(hostname).sparsebundle

if ! [[ -d $storage ]]; then
  mkdir $storage
  /sbin/mount_smbfs -o soft $HOME_NETWORK_STORAGE $storage
fi

if [[ -d $storage ]]; then
  if ! [[ -d $backup ]]; then
    if [[ -d $backup_disk ]]; then
      open $backup_disk
    fi
  fi
fi

