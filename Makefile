# P A N B L O K E
#
# Pandoc
#       Blog
#           MaKe

all: $(blog) blog_index profile

clean:
	@(rm -fr $(dist_path) 2>/dev/null || true) && mkdir -p {$(profile_dist),$(blog_dist)}

print-%: ; @echo $*=$($*)

########### VARIABLES #############

blog_src = ./blog
dist_path = ./dist
blog_dist = ./dist/blog
profile_dist = ./dist/profile
profile_prefix = 'dist/profile'
profile_remote = 'gh-profile'
profile_remote_url = 'https://github.com/$(GH_USER)/$(GH_USER).git'
blog_posts_src := $(wildcard $(blog_src)/*/*.md) \
									$(wildcard $(blog_src)/*/*.org)
blog := $(patsubst $(blog_src)/%.org,$(blog_dist)/%.html, \
					$(patsubst $(blog_src)/%.md,$(blog_dist)/%.html, \
						$(blog_posts_src)))

########### BLOG #############

$(blog_dist)/%.html: $(blog_src)/%.md
	@mkdir -p $(@D)
	@pandoc -i $< -t html -o $@ \
		--template ./templates/root.html \
		--toc \
		--highlight-style themes/dracula.theme

$(blog_dist)/%.html: $(blog_src)/%.org
	@mkdir -p $(@D)
	@pandoc -f org -i $< -t html -o $@ \
		--template ./templates/root.html \
		--toc \
		--highlight-style themes/dracula.theme

remove_index:
	@rm $(blog_dist)/index.html 2>/dev/null || true

blog_index: $(blog) remove_index
	@$(foreach series, $(wildcard $(blog_dist)/*), \
		ls $(series) \
			| grep -v index.html \
			| ./scripts/filename2index.sh \
			| pandoc -t html -o $(series)/index.html \
				--metadata title:"$(shell echo '$(series)' | ./scripts/directory2title.sh)" \
				--template ./templates/root.html \
				--highlight-style themes/dracula.theme;)
	@ls $(blog_dist) \
	  	| grep -v index.html \
	  	| ./scripts/directory2index.sh \
	  	| pandoc -t html -o $(blog_dist)/index.html \
				--metadata title:"$(GH_USER)/blog" \
	  		--template ./templates/root.html \
	  		--highlight-style themes/dracula.theme

########### PROFILE #############

profile: $(wildcard ./README.org) $(wildcard ./README.md)
	@[[ -f ./README.org ]] && bash -c 'cat ./README.org \
		| tee >(pandoc -f org -t gfm -o $(profile_dist)/README.md) \
		| pandoc -f org -t html -o ./index.html --template ./templates/root.html' || true
	@[[ -f ./README.md ]] && bash -c 'cat ./README.md \
		| tee >(pandoc -t gfm -o $(profile_dist)/README.md) \
		| pandoc -t html -o ./index.html --template ./templates/root.html' || true

########### DEPLOY #############

commit:
ifneq ($(shell git status --short),)
	@git checkout master
	@git add .
	@git commit
endif

rebase:
	@git checkout master \
		&& git fetch --all \
		&& git pull --rebase origin master \

deploy-profile:
	@git checkout master \
		&& git diff --quiet \
		&& git subtree push \
			--prefix $(profile_prefix) \
			$(profile_remote) master

deploy-blog:
	@git checkout master \
		&& git diff --quiet \
		&& git push origin master

deploy-all: commit rebase deploy-blog deploy-profile

########### INIT #############

init-profile-remote:
	@(git remote rm $(profile_remote) 2>/dev/null \
		&& git remote add $(profile_remote) $(profile_remote_url)) \
		|| git remote add $(profile_remote) $(profile_remote_url)

init-profile: init-profile-remote
	@[[ -d $(profile_dist) ]] \
		|| git subtree add --prefix $(profile_dist) $(profile_remote) master -m '🤖 add profile subtree'

init: clean init-profile-remote init-profile

########### END #############

.PHONY: all deploy deploy-blog deploy-profile init-profile-remote init-profile clean init commit rebase
