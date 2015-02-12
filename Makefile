RSYNC = rsync
RSYNC_FLAGS = -avh --exclude=.sass-cache --exclude=.git --exclude=_assets --exclude=*.map
REMOTE_HOST ?= keskisuomenvihreat.fi
REMOTE_DIR ?= /var/www/keskisuomenvihreat.fi/www/wordpress/wp-content/themes/ksv2015

SASS = sass

ASSETS_DIR ?= _assets
STYLE_SOURCE ?= $(ASSETS_DIR)/style.sass
STYLE_HEADER ?= $(ASSETS_DIR)/header.css
STYLE_TARGET ?= style.css

TEMPFILE = $(shell mktemp)

clean:
	rm -f *.map
	rm -f *.css
	rm -rf .sass-cache

build:
	$(SASS) $(STYLE_SOURCE) $(TEMPFILE)
	cat $(STYLE_HEADER) $(TEMPFILE) >$(STYLE_TARGET)
	rm -f $(TEMPFILE)

sync: build
	$(RSYNC) $(RSYNC_FLAGS) . $(REMOTE_HOST):$(REMOTE_DIR)
