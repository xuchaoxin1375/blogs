<a id="how-to-backups-and-version-control"></a>

# Backups and version control

It’s important to back up your Ubuntu installation so you can recover quickly if you experience data loss. You can create redundancy by using multiple back-up methods. Redundant data is useful if the primary back-up fails.

It is important to develop a backup plan that consists of:

- What should be backed up

- How often to back it up

- Where backups should be stored

- How to restore your backups

It is good practice to store important backup media off-site in case of a disaster. Physical backup media like removable hard drives or tape can be moved off-site manually. When it is either impossible or impractical to move media, backups can be copied over a WAN link to a server in another location.

On Ubuntu, two primary ways of backing up your system are **backup utilities** and **shell scripts**. For additional protection, you can combine backup methods.

## Backup utilities

The easiest way to create backups is to use a dedicated tool like [Bacula](https://www.bacula.org/) or [rsnapshot](https://rsnapshot.org/). These tools have easy-to-use interface or CLI to help simplify the backup management process. They have powerful features such as automation, compression, data recovery, encryption and incremental backups. Incremental backups only store changes made since the last backup which can significantly decrease storage space needs and backup time.

Bacula’s advanced features and support for additional customization make it a good choice for enterprise systems or users with complex needs. rsnapshot is ideal for individual users or small-scale organizations who want a simple and efficient solution.

| **Tool** | **Back up** | **Backup Method** | **Install and configure** |
|----|----|----|----|
| **Bacula** | Multiple systems over a network | Incremental backups | [how to install and configure Bacula](backups/install-bacula.md#install-bacula) |
| **rsnapshot** | Single system | Periodic “snapshots” of files locally or remotely with SSH | [how to install and configure rsnapshot](backups/install-rsnapshot.md#install-rsnapshot) |

## Shell scripts

Usually laying out such base concepts as the *Backup utilities* above do, forces the implementation to follow some best practices and generally is recommended. But if you are looking for full flexibility and customization, another option is to use shell scripts around the most basic tools.

Here are a few examples:

- [how to use shell scripts for backups](backups/back-up-using-shell-scripts.md#back-up-using-shell-scripts)

- [An example of archive rotation with shell scripts](backups/back-up-using-shell-scripts.md#archive-rotation-shell-script)

## Version control

- [etckeeper](backups/install-etckeeper.md#install-etckeeper) stores the contents of `/etc` in a Version Control System (VCS) repository

- [Install gitolite](backups/install-gitolite.md#install-gitolite) for a traditional source control management server for git, including multiple users and access rights management

## See also

- Sometimes backup is quite application-specific, an example of that is described in [Backup and restore OpenLDAP](openldap/backup-and-restore.md#ldap-backup-and-restore)

---

> 来源：https://ubuntu.com/server/docs/how-to/backups/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
