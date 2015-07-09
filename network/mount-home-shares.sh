#!/bin/sh --login

source $HOME/.private

storage=/Volumes/storage
backup=/Volumes/backup
backup_disk=$storage/$USER/backups/$(hostname).sparsebundle

mount_storage() {
  mkdir $storage
  /sbin/mount_smbfs -o soft $HOME_NETWORK_STORAGE $storage
}

if ! [[ -d $storage ]]; then
  mount_storage
else
  mount | grep $storage | grep "mounted by $USER" > /dev/null
  if [[ $? == 1 ]]; then
    rm -fd $storage
    mount_storage
  fi
fi

if [[ -d $storage ]]; then
  if ! [[ -d $backup ]]; then
    if [[ -d $backup_disk ]]; then
      open $backup_disk
    fi
  fi
fi
