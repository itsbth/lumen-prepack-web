LUMEN ?= /home/itsbth/Code/github.com/sctb/lumen/bin/lumen

.PHONY: clean

out.min.js: out.js
	npx prepack $< --out $@ --compatibility browser

out.js: runtime.js reader.js compiler.js test.js 
	echo "(() => {" > out.js
	cat $^ >> out.js
	echo "})();" >> out.js

# use a modified version of runtime.l instead
# runtime-var.js: runtime.js
# 	sed -r 's/^([a-z0-9_]+) =/var \1 =/g' $< > $@

clean:
	rm -f out.min.js out.js runtime-var.js runtime.js test.js

%.js: %.l
	${LUMEN} -c $< -o $@ -t js

