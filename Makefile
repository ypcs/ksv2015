RSYNC = rsync
RSYNC_FLAGS = -avh --exclude=.sass-cache --exclude=.git --exclude=_assets --exclude=Makefile --exclude=tmp.*
REMOTE_HOST ?= uusi.keskisuomenvihreat.fi
REMOTE_DIR ?= www/wordpress/wp-content/themes/ksv2015

SASS = sass

ASSETS_DIR ?= _assets
STYLE_SOURCE ?= $(ASSETS_DIR)/style.sass
STYLE_HEADER ?= $(ASSETS_DIR)/header.css
STYLE_TARGET ?= style.css

TEMPFILE := $(shell mktemp tmp.ksv2015.XXXXXX)
#TIMESTAMP = $(shell date +%Y%m%d%H%M%S)
VERSION = $(shell git describe |cut -b2-)

all:	sync

clean:
	rm -f *.map
	rm -f *.css
	rm -rf .sass-cache
	rm -f tmp.*

build:
	$(SASS) $(STYLE_SOURCE) $(STYLE_TARGET)
	cat $(STYLE_HEADER) $(STYLE_TARGET) >$(TEMPFILE)
	mv $(TEMPFILE) $(STYLE_TARGET)
	sed -i "s,VERSION,$(VERSION),g" $(STYLE_TARGET)

sync: build
	$(RSYNC) $(RSYNC_FLAGS) . $(REMOTE_HOST):$(REMOTE_DIR)
