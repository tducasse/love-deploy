# love-deploy
## What this project does
This repo contains a single Makefile, which tries to provide a few useful targets to build and deploy a LOVE project (to [itch.io](https://itch.io/)). This currently works on Windows, used from WSL.

## Prerequisites
- a standard version of Make for your system
- if you plan on deploying to itch.io, [butler](https://itch.io/docs/butler/) - run `butler login` before you use the Makefile
- LOVE and at least one LOVE project 😀
- if you plan on bundling for web, a compatible version of `Node.js`, since we use [love.js](https://github.com/Davidobot/love.js).

## Setup
First, let's do a little bit of setup:
- put the Makefile in your root LOVE project folder
```sh
# projects folder for love projects
- myLoveProjets
# a LOVE project here
    - helloWorld
    - ...
```
- for each project you're working on, create a folder and put the relevant files inside this folder
- create a Makefile (empty for now) in each one of your "project folders"

Now let's give make actual data:
In the "root Makefile", you'll see that there's a variable called `love`; this is where you tell make where your LOVE install folder is (where the `love.exe` and the required `.dll` are).
```Makefile
# just an example
love = /mnt/c/Program\ Files/LOVE
```
In your "project Makefile" (the one that's empty in your project folder), add the two following variables:
```Makefile
# this is the your project name, it will be used in `name.exe` and `name.love`
name = MY_PROJECT
# this is your username and the name of your project on itch.io
itchio = USERNAME/TEST-GAME
# use this to pass options to love.js. More info here: https://github.com/Davidobot/love.js#options
# this is compatibility mode for example:
web_options = -c
```
⚠ itch.io tends to convert the name of the project when there's underscores in it, replacing them with hyphens, so make sure you use the one that's shown in the URL and not the actual project name

⚠ also, make sure you created the project on itch.io before you deploy to it, because butler doesn't create it for you

ℹ I'd recommend setting the size of your HTML embed on itch.io to 780x680 to get nice looking margins 😀. Or just set the game to start in fullscreen instead of embedding it on the page!

⚠ If you build a web version and push it to itchio, make sure you either use the compatibility mode (`web_options = -c`), or activate the experimental SharedArrayBuffer support: https://itch.io/t/2025776/experimental-sharedarraybuffer-support.

Note that you can also provide your own `index.html` by putting it in your project folder.

## How to run
In the root LOVE folder, run
```sh
make TARGET project=FOLDER
```
to run the operation `TARGET` on the project `FOLDER_NAME`.

### List of useful targets
- **play**: runs the project
- **all**: builds `web` and `windows`
- **web**: builds `web`
- **windows**: builds `windows`
- **deploy**: exports and deploys `web` and `windows`
- **deploy_windows**: exports and deploys `windows`
- **deploy_web**: exports and deploys `web`
- **clean**: removes the exports for both `web` and `windows`
- **clean_web**: removes the exports for `web`
- **clean_windows**: removes the exports for `windows`
 
Or just have a read through the Makefile! 😉

Feel free to modify it however you want, and let me know if you come up with something cool, I'll be happy to integrate it to this project!

### Sample run
Given the following folder structure:
```
ROOT_FOLDER/
 |_ Makefile
 |_ hello/
    |_ index.html (optional)
    |_ main.lua
    |_ Makefile
```
```Makefile
# hello/Makefile
name = my_project
itchio = tducasse/test-deploy
```
```sh
make deploy project=hello && make clean project=hello
```
![image](https://user-images.githubusercontent.com/11507599/125232090-466d6d80-e31f-11eb-9c39-3296db8b0b14.png)
