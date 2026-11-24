#!/bin/bash
# K-4 Perancangan Sistem Berkas dan Penyimpanan (ext4, XFS, Btrfs, RAID 1)
# Nama: Muhammad Fadlan Ibadurohman | NIM: 250660121045

sudo mkdir -p /var/tmp/storage-lab /mnt/{ext4_elearning,xfs_media,btrfs_nilai}
sudo truncate -s 512M /var/tmp/storage-lab/disk{1,2,3,4}.img
sudo losetup /dev/loop10 /var/tmp/storage-lab/disk1.img
sudo losetup /dev/loop11 /var/tmp/storage-lab/disk2.img
sudo losetup /dev/loop12 /var/tmp/storage-lab/disk3.img
sudo losetup /dev/loop13 /var/tmp/storage-lab/disk4.img

# Buat RAID 1 dan Format File System
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/loop10 /dev/loop11 --run
sudo mkfs.ext4 -F -L ELEARNING_EXT4 /dev/loop12
sudo mkfs.xfs -f -L MEDIA_XFS /dev/loop13
sudo mkfs.btrfs -f -L NILAI_BTRFS /dev/md0

# Mount dan Uji Snapshot Btrfs
sudo mount /dev/loop12 /mnt/ext4_elearning
sudo mount /dev/loop13 /mnt/xfs_media
sudo mount /dev/md0 /mnt/btrfs_nilai
sudo btrfs subvolume create /mnt/btrfs_nilai/data_aktif
echo 'NIM:250660121045 | Nilai_SO: A' | sudo tee /mnt/btrfs_nilai/data_aktif/nilai_uas.csv
sudo btrfs subvolume snapshot -r /mnt/btrfs_nilai/data_aktif /mnt/btrfs_nilai/snap_uas_v1
sudo rm /mnt/btrfs_nilai/data_aktif/nilai_uas.csv
cat /mnt/btrfs_nilai/snap_uas_v1/nilai_uas.csv
sudo mdadm /dev/md0 --fail /dev/loop11
