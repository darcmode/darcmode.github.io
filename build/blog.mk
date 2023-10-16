# Generate HTML from Markdown source
$(BLOG_DIST)/%.html: $(BLOG_SRC)/%.md
	@mkdir -p $(@D)
	@pandoc -i $< -t html -o $@ $(PANDOC_HTML_BLOG)

# Generate HTML from Org source
$(BLOG_DIST)/%.html: $(BLOG_SRC)/%.org
	@mkdir -p $(@D)
	@pandoc -f org -i $< -t html -o $@ $(PANDOC_HTML_BLOG)

# Generate HTML from LaTeX source
$(BLOG_DIST)/%.html: $(BLOG_SRC)/%.tex
	@mkdir -p $(@D)
	@pandoc -f latex -i $< -t html -o $@ $(PANDOC_HTML_BLOG)

# Generate index.html files for blog sections
blog-index: $(BLOG)
	@$(foreach series, $(wildcard $(BLOG_SRC)/*), \
		ls $(series) \
			| grep -v index.html \
			| ./scripts/filename2index.py \
			| pandoc -t html -o $(patsubst $(BLOG_SRC)/%,$(BLOG_DIST)/%,$(series))/index.html \
				$(PANDOC_HTML_INDEX) \
				--metadata title:"$(shell echo '$(series)' | ./scripts/directory2title.py)";)
	@ls $(BLOG_SRC) \
			| grep -v index.html \
			| ./scripts/directory2index.py \
			| pandoc -t html -o $(BLOG_DIST)/index.html \
				$(PANDOC_HTML_INDEX) \
				--metadata title:"$(GH_USER)/blog"
