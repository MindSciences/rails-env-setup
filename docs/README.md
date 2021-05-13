This folder includes documentation about the current repo:

1. Coding Standards
2. Policies
3. Guidelines
4. Resources

---

# 1. Coding Standards

The repo includes `.rubocop.yml` that is used for formatting code. 

# 2. Policies

## Pull Requests

Every change will go into a new branch and a PR will be created to merge. A template is available and will be automatically used when creating a PR. The following steps should be performed by each party:

### Developer
1. Update the `CHANGELOG.md` file and commit all changes to a new branch
2. Create a PR from new branch against `develop` 
3. Fill in the PR template
4. Request a review from the designated reviewer
5. *OPTIONAL* Deploy branch to `development` environment

### Reviewer

1. Go through each step of the checklist
2. If all tasks are completed successfully, merge the PR into `develop`
3. Create a new PR against `production` or `master`
4. Assign PR to release manager

# 3. Guidelines
Any information on good pracitces and related can go here:

### Reviewing Pull Requests
- do once a day - morning or evening
- do setup a local env to easily test changes
- do check for consistency with existing code and good practices
- do ask questions or request comments when something's not clear or too complex

### Changelogs 
The repo must include a `CHANGELOG.md` file to list all changes. The accepted chnages types are:

- **Added** for new features.
- **Changed** for changes in existing functionality.
- **Deprecated** for soon-to-be removed features.
- **Removed** for now removed features.
- **Fixed** for any bug fixes.
- **Security** in case of vulnerabilities.

# 4. Resources
Documentation can be uploaded to the `docs` folder. Any useful links should be listed below:

- Changelogs - https://keepachangelog.com/en/1.0.0/
