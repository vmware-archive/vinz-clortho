# Vinz Clortho [![Build Status](https://travis-ci.org/pivotal/vinz-clortho.svg?branch=master)](https://travis-ci.org/pivotal/vinz-clortho)

<img src="http://i.giphy.com/Sf0xvEgdWyraU.gif" alt="Vinz Clortho" width="100%">

Vinz Clortho is a Ruby-based tool for managing SSH authentication when dealing with git.

## Installation

```
gem install vinz-clortho
```

## Usage

```
git ssh-login [options] [committer-initials]

    -h, --help                       Shows help
    -v, --version                    Returns version
        --add-to-github              Adds a public key to GitHub
```

The key expiry is set to 12:30 PM if executed before 12:30 PM, 6:00 PM if executed after that but before 6:00 PM, or within 15 minutes if executed after 6:00 PM. You can also use `git push-authenticated [args]` to authenticate all existing keys for a period of 5 seconds and then push immediately. It takes the same arguments as `git push` (and just passes them on).

## Where should I put my keys so that Vinz Clortho can find them?

Perhaps the easiest way to add a key is to place it on a USB key. Vinz Clortho currently looks for keys that match the path `/Volumes/*/.ssh/id_rsa`. Otherwise, specifying `committer-initials` will look for SSH key locations within a `.git-authors` file in either the current directory or any ancestor directory. The format for this file is similar to [git-duet](https://github.com/git-duet/git-duet) and [git-pair](https://github.com/pivotal/git_scripts). Vinz Clortho will look for a `sshkey_paths` entry in this file where each pair of initials below points to the location of a private key. For example:

``` yaml
sshkey_paths:
  jd: /Users/jdoe/.ssh/id_rsa
  fb: ~/fbar/ssh_keys/id_rsa
```
See the [.git-authors](.git-authors) file in this repository as a full example.

