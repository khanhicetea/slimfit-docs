all: build save
serve:
	hugo serve --theme=hugo-material-docs --buildDrafts
build:
	git pull
	hugo --theme=hugo-material-docs -d docs
save:
	git add -A
	git commit -m "Updated `date +'%y.%m.%d %H:%M:%S'`"
	git push origin
