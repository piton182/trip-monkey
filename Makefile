# SOURCE_OBJECTS = \
# 	package.json \
# 	chrome-extension/src/manifest-template.json \
# 	chrome-extension/src/styles.css

TARGET_OBJECTS = \
	chrome-extension/dist/manifest.json \
	chrome-extension/dist/bundle.js \
	chrome-extension/dist/dom.js \
	chrome-extension/dist/styles.css

default : ${TARGET_OBJECTS}
	@echo "Good to go!"

chrome-extension/dist :
	@mkdir chrome-extension/dist

chrome-extension/dist/styles.css : chrome-extension/src/styles.css chrome-extension/dist
	@cp chrome-extension/src/styles.css chrome-extension/dist/styles.css

chrome-extension/dist/manifest.json : chrome-extension/src/manifest-template.json chrome-extension/dist chrome-extension/dist/bundle.js chrome-extension/dist/dom.js
	@cp chrome-extension/src/manifest-template.json chrome-extension/dist/manifest.json
	@sed 's/???content-script-files???/"bundle.js", "dom.js"/g' chrome-extension/dist/manifest.json > chrome-extension/dist/manifest.json.tmp ; mv chrome-extension/dist/manifest.json.tmp chrome-extension/dist/manifest.json
	@sed 's/???styles-files???/"styles.css"/g' chrome-extension/dist/manifest.json > chrome-extension/dist/manifest.json.tmp ; mv chrome-extension/dist/manifest.json.tmp chrome-extension/dist/manifest.json

chrome-extension/dist/dom.js :
	@cp chrome-extension/src/dom.js chrome-extension/dist/dom.js

chrome-extension/dist/bundle.js : chrome-extension/dist grammars/airports/dist/bundle.js
	@cp grammars/airports/dist/bundle.js chrome-extension/dist/bundle.js

grammars/airports/dist :
	@mkdir grammars/airports/dist

grammars/airports/dist/bundle.js : grammars/airports/dist grammars/airports/webpack.config.js grammars/airports/webpack grammars/airports/dist/main.js grammars/airports/dist/AirportsParser.js
	@cd grammars/airports ; npx webpack

grammars/airports/dist/AirportsParser.js : grammars/airports/src/Airports.g4 grammars/airports/dist
	@cd grammars/airports/src ; java -Xmx500M -cp "/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool -o ../dist -Dlanguage=JavaScript Airports.g4

grammars/airports/dist/main.js :
	@cp grammars/airports/src/main.js grammars/airports/dist/main.js

.PHONY: clean

clean : clean-chrome-extension clean-grammars-airports
	@echo "Cleaned!"

clean-chrome-extension :
	@rm -rf chrome-extension/dist

clean-grammars-airports :
	@rm -rf grammars/airports/node_modules
	@rm -rf grammars/airports/dist

grammars/airports/webpack :
	@cd grammars/airports ; npm install webpack webpack-cli --save-dev
