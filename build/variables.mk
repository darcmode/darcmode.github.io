# Directory structure
BLOG_SRC = ./blog
DIST_PATH = ./dist
BLOG_DIST	= ./dist/blog
PROFILE_DIST = ./dist/profile
PROFILE_PREFIX = 'dist/profile'
PROFILE_REMOTE = 'gh-profile'
PROFILE_REMOTE_URL = 'https://github.com/$(GH_USER)/$(GH_USER).git'

# Pandoc arguments macros
PANDOC_DATA_DIR	= --data-dir=./pandoc

PANDOC_HTML_FOOTER = --include-after-body=./pandoc/templates/footer.html

PANDOC_HTML_THANKS_AND_COOKIE = --include-in-header=./pandoc/templates/fortune.html \
	--include-after-body=./pandoc/templates/thanks.html

PANDOC_HTML_BLOG = $(PANDOC_DATA_DIR) --toc --section-divs \
	--lua-filter=./pandoc/filters/permalinks.lua \
	--lua-filter=./pandoc/filters/org-include-numberlines.lua \
	--lua-filter=./pandoc/filters/enhance-metadata.lua \
	$(PANDOC_HTML_THANKS_AND_COOKIE) \
	$(PANDOC_HTML_FOOTER) \
	--highlight=zenburn

PANDOC_HTML_PROFILE = $(PANDOC_DATA_DIR) --section-divs \
	$(PANDOC_HTML_THANKS_AND_COOKIE) \
	$(PANDOC_HTML_FOOTER)

PANDOC_HTML_INDEX = --template ./pandoc/templates/default.html5 \
	$(PANDOC_HTML_FOOTER)

# Blog posts macros
BLOG_POSTS_WIP_SRC := $(wildcard $(BLOG_SRC)/*/WIP_*)
BLOG_POSTS_SRC := $(filter-out $(BLOG_POSTS_WIP_SRC), $(wildcard $(BLOG_SRC)/*/*.md) \
	$(wildcard $(BLOG_SRC)/*/*.org) \
	$(wildcard $(BLOG_SRC)/*/*.tex))
BLOG := $(patsubst $(BLOG_SRC)/%.org,$(BLOG_DIST)/%.html, \
	$(patsubst $(BLOG_SRC)/%.md,$(BLOG_DIST)/%.html, \
	$(patsubst $(BLOG_SRC)/%.tex,$(BLOG_DIST)/%.html, \
	$(BLOG_POSTS_SRC))))
