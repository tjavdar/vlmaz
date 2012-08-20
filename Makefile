#
# 2010-06-01: Simplify + move to tex4ht and hyperref
#
CV  = cv
PUB = publications
#  MAI = vlmaz@water.mai.liu.se
MAI = vlmaz@sky.mai.liu.se
RSYNC = rsync -e ssh --rsync-path='bin_local/rsync' -auv --delete
RSYNC = rsync -e ssh --rsync-path='/usr/bin/rsync' --exclude .git -auv --delete
LATEX_EXT = 4ct 4tc aux dvi idv lg log tmp xref
LATEX_GARBAGE = $(patsubst %,*.%,$(LATEX_EXT))

# The implicit rulez:

%.pdf : %.tex
	cd ./$(dir $<) &&  pdflatex $(notdir $<)
%.html : %.tex
	cd ./$(dir $<) &&  htlatex $(notdir $<)

# End of implicit rules

default:
	@echo "New since 2010-06-01: Fresh versions of pulications.tex and cv.tex"
	@echo "are to be dumped in the corresponding publications and cv subdirectories "
	@echo "Specify one of:"
	@echo "    make pub (to make the publications-dir)"
	@echo "    make cv  (to make the cv-dir)"
	@echo "    make www (to publish)"

help:  default

cv:  $(CV)/$(CV).pdf $(CV)/$(CV).html 

pub: $(PUB)/$(PUB).pdf $(PUB)/$(PUB).html 

clean:
	rm -f .log *.bak $(LATEX_GARBAGE)
	find . -name \*~ -exec rm -f {} \;

distclean: clean
	$(MAKE) -C $(CV) -f ../Makefile clean
	$(MAKE) -C $(PUB) -f ../Makefile clean

www: distclean cv
	find . -type d -exec chmod a+rx {} \;
	find . -type f -exec chmod a+r {} \;
	$(RSYNC) ../public_html  $(MAI):


