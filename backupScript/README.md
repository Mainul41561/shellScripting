# Backup Script with 5-Day Rotation

A simple and reliable Bash script to create ZIP backups of a directory and automatically rotate old backups, keeping only the **5 most recent** copies.

## ✅ Features

- Creates timestamped ZIP backups
- Automatically deletes backups older than the 5 most recent
- Validates input paths
- Creates backup directory if it doesn’t exist
- Quiet operation (suppresses `zip` output)
- Clear success/error messages

## 📁 Requirements

- Linux (tested on Ubuntu)
- `zip` utility installed

Install `zip` if not already present:
```bash
sudo apt update && sudo apt install zip
```

## Download github Repo from this link to Access code
Here is GitHub Repo link [Shellscript For Automatic Backup](https://github.com/Mainul41561/shellScripting/tree/main/backupScript).

### Now change directory to the dirctroy where Downloaded file is located
```bash
chmod 700 backup.sh
```
It will give Excute permission to this script and then run this on ur terminal
```bash
./backup.sh
```

## If you want to set this Script as corn Job and the Script will Automatically

Then run this command on ur terminal and Excute this command
```bash
crontab -e
```
And select two as option and then it will open the file in **vim** Editor . And make the changes end of the file . It will set cronjob for **At every minute**.
```bash
* * * * * <backup.sh file dirctroy> <source directory> <backup directory>
```
And then leave it typing `esc` then `:wq`

## Here is an example
![Backup in action](https://github.com/Mainul41561/shellScripting/blob/main/backupScript/images/Screenshot%20from%202025-10-27%2020-18-03.png)

## cronjob setup
![Cronjob](https://github.com/Mainul41561/shellScripting/blob/main/backupScript/images/Screenshot%20from%202025-10-27%2020-26-06.png)