# Clortho

<img src="http://i.giphy.com/Sf0xvEgdWyraU.gif" alt="Clortho" width="100%">

Clortho is a Ruby-based tool for managing SSH authentication when dealing with git. It assumes an environment where SSH keys are not stored on the computer, but rather on a flash drive.

## Requirements

Clortho assumes a [git-duet](https://github.com/git-duet/git-duet) environment, and requires a `.git-authors` file to be present. In addition to authors and email addresses, Clortho will look for a `sshkey_paths` entry where each pair of initials below points to the location of a private key. For example:

``` yaml
sshkey_paths:
  jd: /Volumes/jdoe/.ssh/id_rsa
  fb: /Volumes/fbar/.ssh/id_rsa
```
See the [.git-authors](.git-authors) file in this repository as a full example.


## Usage
Run `gitlogin.rb <committer-initials>` to add the SSH key corresponding to the committer's initials. (Currently, this must be run in the same directory as the `.git-authors` file.) The key expiry is set to 12:30 PM if executed before 12:30 PM, 6:00 PM if executed after that but before 6:00 PM, or within 15 minutes if executed after 6:00 PM.