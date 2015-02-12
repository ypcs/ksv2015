RSYNC = rsync
RSYNC_FLAGS = -avh --exclude=.sass-cache --exclude=.git --exclude=_assets --exclude=*.map --exclude=Makefile --exclude=tmp.*
REMOTE_HOST ?= keskisuomenvihreat.fi
REMOTE_DIR ?= /var/www/keskisuomenvihreat.fi/www/wordpress/wp-content/themes/ksv2015

SASS = sass

ASSETS_DIR ?= _assets
STYLE_SOURCE ?= $(ASSETS_DIR)/style.sass
STYLE_HEADER ?= $(ASSETS_DIR)/header.css
STYLE_TARGET ?= style.css

TEMPFILE := $(shell mktemp tmp.ksv2015.XXXXXX)
TIMESTAMP = $(shell date +%Y%m%d%H%M%S)

all:	sync

clean:
	rm -f *.map
	rm -f *.css
	rm -rf .sass-cache
	rm -f tmp.*

build:
	echo "Converting SASS styles, using '$(TEMPFILE)' as tempfile..."
	$(SASS) $(STYLE_SOURCE) $(TEMPFILE)
	cat $(STYLE_HEADER) $(TEMPFILE) >$(STYLE_TARGET)
	rm -f $(TEMPFILE) $(TEMPFILE).map
	sed -i "s,DD,$(TIMESTAMP),g" $(STYLE_TARGET)

sync: build
	$(RSYNC) $(RSYNC_FLAGS) . $(REMOTE_HOST):$(REMOTE_DIR)
