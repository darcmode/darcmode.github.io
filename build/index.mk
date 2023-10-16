# Generate html index file from GitHub profile as Org or Markdown source
index: $(wildcard ./README.org) $(wildcard ./README.md)
	@[[ -f ./README.org ]] && bash -c 'cat ./README.org \
		| tee >(pandoc -f org -t gfm -o $(PROFILE_DIST)/README.md) \
		| pandoc -f org -t html -o ./index.html $(PANDOC_HTML_PROFILE_ARGS)' \
			|| true
	@[[ -f ./README.md ]] && bash -c 'cat ./README.md \
		| tee >(pandoc -t gfm -o $(PROFILE_DIST)/README.md) \
		| pandoc -t html -o ./index.html $(PANDOC_HTML_PROFILE_ARGS)' \
			|| true
