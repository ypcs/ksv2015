build:
	sass style.sass style.css.tmp
	cat _theme.sass style.css.tmp >style.css
	rm -f style.css.tmp

sync: build
	rsync --exclude=.sass-cache --exclude=.git -avh . keskisuomenvihreat.fi:/var/www/keskisuomenvihreat.fi/www/wordpress/wp-content/themes/ksv2015
