RSYNC = rsync
RSYNC_FLAGS = -avh --exclude=.sass-cache --exclude=.git --exclude=*.sass --exclude=*.map
REMOTE_HOST ?= keskisuomenvihreat.fi
REMOTE_DIR ?= /var/www/keskisuomenvihreat.fi/www/wordpress/wp-content/themes/ksv2015

SASS = sass

STYLE_SOURCE ?= style.sass
STYLE_HEADER ?= _theme.sass
STYLE_TARGET ?= style.css

TEMPFILE = $(shell mktemp)

build:
	$(SASS) $(STYLE_SOURCE) $(TEMPFILE)
	cat $(STYLE_HEADER) $(TEMPFILE) >$(STYLE_TARGET)
	rm -f $(TEMPFILE)

sync: build
	$(RSYNC) $(RSYNC_FLAGS) . $(REMOTE_HOST):$(REMOTE_DIR)
