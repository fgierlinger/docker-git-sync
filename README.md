# Synchronise git repository

Keep pulling a git directory for new changes. Intended use is for a containerized application, that is getting its config or content from a git repository. The _frontend_ container shall have a shared volume with this git-sync container. The git-sync container will keep the git repository up to date.

## Variables

All configuration is done via environment variables.

| Variable | Default value | Description |
| :------- | :------------ | :---------- |
| `GIT_SYNC_DIR` | | (Required) Destination directory inside the container where the repository is cloned to |
| `GIT_SYNC_REPO` | | (Required) Repository that shall be cloned. If authentication is required, username and password can be included in the url (https://username:password@github.com/user/repo.git) |
| `GIT_SYNC_SLEEP` | 1 | Time in seconds to sleep between the pulls |
| `GIT_SYNC_PULL_OPTS` | -f | Options to pass to the `git pull` command |
| `GIT_SYNC_BRANCH` | origin/master | Branch to checkout |
| `GIT_SYNC_NOTEMPTY` | false | Per default git only clones into empty directories. If for whatever reason the directory is not empty, set this variable to true to still merge the git repository into the existing directory |
| `GIT_SYNC_NOTEMPTY_OPTS` | --mixed | Options to pass to the `git reset` command, in case there is already content in the directory |

## Example use

```
docker run -ti --rm 
    -e GIT_SYNC_DIR=/tmp/mygitdir
    -e GIT_SYNC_REPO=https://github.com/fgierlinger/docker-git-sync 
    git-sync:latest
```

# Author
Frédéric Gierlinger

# License
MIT
