# Creating Additional Application Launchers for ui_menu

If the `ui_app_launchers` configuration option is enabled, then the startup script will automatically load any valid application launchers found in `project_eris/etc/project_eris/SUP/launchers` and display them as a game title on the stock Sony ui_menu interface. The following guide explains how to correctly configure your application.

### Folder Structure
project_eris/etc/project_eris/SUP/launchers/*[application_name]*

Create a folder here to store your applications files. At a minimum this must contain an application configuration file and a script to launch your application. 

### Application Configuration File
project_eris/etc/project_eris/SUP/launchers/*[application_name]*/launcher.cfg

This file must contain the following properties. Only use characters a-z and numbers.

| Property | Required | Description |
| - | - | - |
| launcher_filename | Y | Will be assigned as the ui_menu BASENAME. Your launcher title picture must use this name for it to load correctly  |
| launcher_title | Y | Title which will be displayed in ui_menu |
| launcher_publisher | N | Publisher which will be displayed in ui_menu |
| launcher_year | N | Year which will be displayed in ui_menu |
| launcher_sort | N | If set to "no" then this application title will not be sorted in with the rest of the games, and will instead appear as the last item on the carousel |

**_Example launcher.cfg for bootmenu_launch_**
```bash
launcher_filename="bootmenu"
launcher_title="Boot Menu"
launcher_publisher="ModMyClassic"
launcher_year="2020"
launcher_sort="no"
```

### Application Execution Script
project_eris/etc/project_eris/SUP/launchers/*[application_name]*/launch.sh

This is a shell script which will automatically be executed once your application has been launched by ui_menu. It should contain the commands required to launch your application.

Prior to your application being launched the ui_menu process will be terminated. A symbolic link will be created to your applications directory at `/var/volatile/launchtmp`. You can use this from your launch.sh to easily reference your applications files.

**_Example launch.sh for generic application where files are all stored in this directory_**
```bash
#!/bin/sh
cd "/var/volatile/launchtmp"
chmod +x my_application
my_application
```

### Application Title Picture
project_eris/etc/project_eris/SUP/launchers/*[application_name]*/*[launcher_filename]*.png

This should be named the same as what you have used for `launcher_filename` in the configuration file.

A 256x256 image in PNG format is preferred.

If the file is named incorrectly, or does not exist, then the application will still appear on the carousel but with no graphic.

**_Example for bootmenu_launch_**

bootmenu.png