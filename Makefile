include build/variables.mk
include build/blog.mk
include build/index.mk
include build/deployment.mk

# Default target
all: $(BLOG) blog-index index

# Clean target to remove temporary files
clean:
	@(rm -fr $(DIST_PATH) 2>/dev/null || true) \
	&& mkdir -p {$(PROFILE_DIST),$(BLOG_DIST)}

# Deploy all targets, commit changes, and rebase the repository
deploy-all: commit rebase deploy-blog deploy-profile

# Initialize the project
init: clean init-profile-remote init-profile-subtree

# Print macro variables for debugging
print-%: @echo $*=$($*)

