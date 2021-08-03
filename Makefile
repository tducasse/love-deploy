project = project
include $(project)/Makefile

love = PATH_TO_LOVE_INSTALL_FOLDER_ON_WINDOWS 
fullname = $(project)/build/$(name)

all: web windows

web: clean_web $(fullname).love
	mkdir -p $(project)/build/web
	npx love.js $(fullname).love $(project)/build/web -t $(name) $(compat_mode)
	[ -f "$(project)/index.html" ] && cp $(project)/index.html $(project)/build/web/ || :

windows: clean_windows $(fullname).love
	mkdir -p $(project)/build/windows
	cp -r $(love)/*.dll $(project)/build/windows/
	cp -r $(love)/license.txt $(project)/build/windows/
	cat $(love)/love.exe $(fullname).love > $(project)/build/windows/$(name).exe

$(fullname).love: clean_love
	mkdir -p $(project)/build
	cd $(project) && zip -9 -r build/$(name).love . \
			-x Makefile \
			-x build/**\* \
			-x build/ \
			-x .git/**\* \
			-x .git/ \
			-x .vscode/**\* \
			-x .vscode/ \
			-x .gitignore

deploy: deploy_web deploy_windows

deploy_web: web
	cd $(project)/build/web && zip -9 -r $(name).zip .
	butler push $(project)/build/web/$(name).zip $(itchio):web

deploy_windows: windows
	cd $(project)/build/windows && zip -9 -r $(name).zip .
	butler push $(project)/build/windows/$(name).zip $(itchio):windows
	

clean: clean_web clean_windows clean_love

clean_web:
	rm -rf $(project)/build/web

clean_windows:
	rm -rf $(project)/build/windows

clean_love:
	rm -rf $(project)/build/$(name).love

.PHONY: clean web windows all
