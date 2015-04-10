#!/bin/sh

storage=/Volumes/storage
backup=/Volumes/backup
backup_disk=$storage/$USER/backups/$(hostname).sparsebundle

if ! [[ -d $backup ]]; then
  if [[ -d $backup_disk ]]; then
    open $backup_disk
  fi
fi