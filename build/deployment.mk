# Commit changes if there are any
commit:
ifneq ($(shell git status --short),)
	@git checkout master
	@git add .
	@git commit
endif

# Rebase the repository
rebase:
	@git checkout master \
		&& git fetch --all \
		&& git pull --rebase origin master \
		--recurse-submodules

# Deploy profile subtree
deploy-profile:
	@git checkout master \
		&& git diff --quiet \
		&& git subtree split --prefix $(PROFILE_PREFIX) -b gh-profile \
		&& git push -f $(PROFILE_REMOTE) gh-profile:master \
		&& git branch -D gh-profile

# Push changes to the blog repository
deploy-blog:
	@git checkout master \
		&& git diff --quiet \
		&& git push origin master --force

# Initialize the profile remote repository
init-profile-remote:
	@(git remote rm $(PROFILE_REMOTE) 2>/dev/null \
		&& git remote add $(PROFILE_REMOTE) $(PROFILE_REMOTE_URL)) \
		|| git remote add $(PROFILE_REMOTE) $(PROFILE_REMOTE_URL)

# Initialize the profile subtree
init-profile-subtree: init-profile-remote
	@[[ -d $(PROFILE_DIST) ]] \
		|| git subtree add --prefix $(PROFILE_DIST) $(PROFILE_REMOTE) master -m '🤖 add profile subtree'

