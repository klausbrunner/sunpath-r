# Makefile for sunpath-r project

# Default target
all: sunpath.md carpet.md solar_maps.md solar_asia_animated.md 

# Pattern rules
%.md: %.Rmd
	Rscript -e "knitr::knit('$<')"

%.html: %.Rmd
	Rscript -e "rmarkdown::render('$<', output_format = 'html_document')"

# Clean generated files
clean:
	rm -f sunpath.md carpet.md solar_maps.md solar_asia_animated.md 
	rm -f *.html
	rm -rf *_files/ figure/
	rm -f *.webp
	rm -f /tmp/sunpositions.csv /tmp/asia_*.parquet /tmp/europe_*.csv 
	rm -f /tmp/seasonal_dates.txt /tmp/times.txt 

# Format R code in Rmd
format:
	Rscript -e "styler::style_dir('.', filetype = 'Rmd')"

# Help target
help:
	@echo "Available targets:"
	@echo "  all       - Build all markdown files"
	@echo "  format    - Format R code in Rmd files"
	@echo "  clean     - Remove generated files"
	@echo "  help      - Show this help"

.PHONY: all clean help format
