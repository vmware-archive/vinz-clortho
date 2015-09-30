# Clortho

<img src="http://i.giphy.com/Sf0xvEgdWyraU.gif" alt="Clortho" width="100%">

Clortho is a Ruby-based tool for managing SSH authentication when dealing with git.

## Requirements

Clortho requires a `.git-authors` file to be present, similar in format to [git-duet](https://github.com/git-duet/git-duet) and [git-pair](https://github.com/pivotal/git_scripts). In addition to authors and email addresses, Clortho will look for a `sshkey_paths` entry where each pair of initials below points to the location of a private key (perhaps on a flash drive). For example:

``` yaml
sshkey_paths:
  jd: /Volumes/jdoe/.ssh/id_rsa
  fb: /Volumes/fbar/.ssh/id_rsa
```
See the [.git-authors](.git-authors) file in this repository as a full example.

Clortho also requires the [Octokit](https://github.com/octokit/octokit.rb) rubygem for communicating with GitHub. You can install this via `gem install octokit`.

## Usage
Run `git ssh-login (committer-initials)` to add the SSH key corresponding to the committer's initials. The key expiry is set to 12:30 PM if executed before 12:30 PM, 6:00 PM if executed after that but before 6:00 PM, or within 15 minutes if executed after 6:00 PM.

```
Usage: git ssh-login [options] (committer-initials)

    -h, --help                       Shows help
    -v, --version                    Returns version
        --add-to-github              Adds a public key to GitHub
```

You can also use `git push-authenticated [args]` to authenticate all existing keys for a period of 5 seconds and then push immediately. It takes the same arguments as `git push` (and just passes them on).