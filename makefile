all: doc test

doc: doc/manual.six

doc/manual.six: createautodoc.g makedoc.g maketest.g ListOfDocFiles.g \
		PackageInfo.g \
		doc/LessGenerators.bib doc/*.xml doc/*.css \
		gap/*.gd gap/*.gi examples/*.g examples/doc/*.g
		gap createautodoc.g
	        gap makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gap maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/LessGenerators.tar.gz --exclude ".DS_Store" --exclude "*~" LessGenerators/doc/*.* LessGenerators/doc/clean LessGenerators/gap/*.{gi,gd} LessGenerators/{PackageInfo.g,README,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g,ListOfDocFiles.g,createautodoc.g} LessGenerators/examples/*.g)

WEBPOS=public_html
WEBPOS_FINAL=~/Sites/homalg-project/LessGenerators

towww: archive
	echo '<?xml version="1.0" encoding="UTF-8"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.LessGenerators
	cp doc/manual.pdf ${WEBPOS}/LessGenerators.pdf
	cp doc/*.{css,html} ${WEBPOS}
	rm -f ${WEBPOS}/*.tar.gz
	mv ../tar/LessGenerators.tar.gz ${WEBPOS}/LessGenerators-`cat VERSION`.tar.gz
	rm -f ${WEBPOS_FINAL}/*.tar.gz
	cp ${WEBPOS}/* ${WEBPOS_FINAL}
	ln -s LessGenerators-`cat VERSION`.tar.gz ${WEBPOS_FINAL}/LessGenerators.tar.gz

