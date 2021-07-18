# Push Code to Multiple Git Remotes Using SSH

This simple tutorial will demonstrate one method (there are many) of pushing a single repository to multiple remotes, along with using SSH-Keys for identity.

The reason for doing this could include : multiple backups, high availability CI/CD pipelines, improved internet speeds around the globe, etc.

>NOTE : The longest portion of this tutorial is setting up the SSH Keys. But once done, it's just a few simple commands
>to push remotes to several Git Service Providers and can be used for any number of repositories.

## Git Service Providers

While there are many Git service providers, this tutorial will focus on three. If you're following this tutorial in its entirety, you will need an account on the providers listed below. If you already have accounts, you will be adding a new repository named : `git-remote-demo` to each of your accounts.  These new repositories can of course be deleted after.

- [Github][] (the primary checkout, push and pull remote)
- [Gitlab][] (secondary push remote)
- [Bitbucket][] (tertiary push remote)

> NOTE: If you have an instance of Gitlab running in a Homelab
> setup, you could also add a localhost or IP based remote for local
> backups in addition to cloud storage.

## SSH Keys Overview

Searching the web you'll find a multitude of suggestions regarding SSH key best practices. For the purposes of this tutorial, we'll keep it simple yet fairly secure by using the following:

- Unique SSH key for each Service Provider
- Use modern ed25519 algorithm for keys
- Each key will have a passphrase
- A comment will be added to each public key for easy user identification
- Use ssh-add `<key-name>` to ssh-agent for loading the keys
- An ssh config file will be used for identities.

## Generating SSH Keys

If you are on Windows, Use [Git-SCM][] or [WSL2][], it's just easier. For everyone else, use your default system terminal to perform
the commands.

For each ssh-keygen command, set a unique passphrase when prompted. We'll do this for all three Git Service Providers.

### Github

```bash
# Generate the Github Key Pair and Enter Unique Passphrase
ssh-keygen -t ed25519 -C "SSH Key for Github Demo" -f ~/.ssh/id_ed25519_gh_demo

# Update permissions
chmod 600 ~/.ssh/id_ed25519_gh_demo
chmod 644 ~/.ssh/id_ed25519_gh_demo.pub
```

### Gitlab

```bash
# Generate the Gitlab Key Pair and Enter Unique Passphrase
ssh-keygen -t ed25519 -C "SSH Key for Gitlab Demo" -f ~/.ssh/id_ed25519_gl_demo

# Update the permissions
chmod 600 ~/.ssh/id_ed25519_gh_demo
chmod 644 ~/.ssh/id_ed25519_gh_demo.pub
```

### Bitbucket

```bash
# Generate the Bitbucket Key Pair and Enter Unique Passphrase
ssh-keygen -t ed25519 -C "SSH Key for Bitbucket Demo" -f ~/.ssh/id_ed25519_bb_demo

# Update permissions
chmod 600 ~/.ssh/id_ed25519_bb_demo
chmod 644 ~/.ssh/id_ed25519_bb_demo.pub
```

## Update SSH Config File

In the `~/.ssh/` folder, create a file called `config` with no extension. You can do this from the terminal you are in now with the following command.

```bash
# create config file
touch ~/.ssh/config && chmod 600 ~/.ssh/config
```

With a text editor, browse to and open the config file adding the following content. The identities should match the keys we created earlier.

```bash
Host github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_gh_demo

Host gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_gl_demo

Host bitbucket.org
    User git
    IdentityFile ~/.ssh/id_ed25519_bb_demo
```

## Add SSH Key to Github

Log into your [Github][] account, and perform the following tasks. The following link is a Github example. Use it in conjunction with the commands below to setup your public key.

- [Add SSH Key to Github][]

```shell
# In your local desktop terminal, print and copy the contents of the Gitbub public key

cat ~/.ssh/id_ed25519_gh_demo.pub
```

```shell
# Copy the full line from your command, it should look similar to this

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAFuwriycA2Nm7jBzAHIKEx+WwVOrK0YtOFribY2sH6 SSH Key for Github Demo

```

## Add SSH Key to Gitlab

Log into your [Gitlab][] account, and perform the following tasks. The following link is a Gitlab example. Use it in conjunction with the commands below to setup your public key.

- [Add SSH Key to Gitlab][]

```shell
# In your local desktop terminal, print and copy the contents of the Gitbub public key

cat ~/.ssh/id_ed25519_gl_demo.pub
```

```shell
# Copy the full line from your command, it should look similar to this

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAByZlA4+y2tBSAE2oBHuNBTxpWRHCMjOLiGmgTz7xre SSH Key for Gitlab Demo

```

## Add SSH Key to Bitbucket

Log into your [Bitbucket][] account, and perform the following tasks. The following link ia Bitbucket example. Use it in conjunction with the commands below to setup your public key.

- [Add SSH Key to Bitbucket][]

```shell
# In your local desktop terminal, print and copy the contents of the Bitbucket public key

cat ~/.ssh/id_ed25519_bb_demo.pub
```

```shell
# Copy the full line from your command, it should look similar to this

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXer2Vs4t96EKveib2P2XuZRnoTRfguXkTT+t5jcQoC SSH Key for Bitbucket Demo

```

## Loading SSH Keys to Agent

If you have followed the ssh-key naming convention, you can use the following script to load all of your keys
each time you open up a terminal. Create a file called `load-keys.sh` somewhere in your home directory. It
(the script or function) can be anywhere that is easily accessed.

You need to run this script once each log in session. If you log out, or reboot, you'll need to re-run the script
to load the keys into the agent. Alternatively, you could add the commands as a function, source it from the
~/.bashrc` file and call it that way. A sample function is in the repo of this tutorial along with the script below.

Each key will require you to provide the passphrase you entered when generating the keys.

```shell
#!/usr/bin/env bash

# Simple script to load SSH keys into agent

set -e

# declare array of abbreviations
declare -a abbv=(gh gl bb)

clear ||:
echo '------------------------------'
echo 'Adding SSH Keys to SSH-Agent'
echo '------------------------------'
echo ''

# now loop through array
for i in "${abbv[@]}"
do
    KEY="/home/${USER}/.ssh/id_ed25519_${i}_demo"
    echo "Adding SSH Key : ${KEY}"
    ssh-add "$KEY"
    echo ''
done

echo "Finished"
echo

# end script
```

### Output from Script or Function

```shell
------------------------------
Adding SSH Keys to SSH-Agent
------------------------------

Adding SSH Key: id_ed25519_gh_demo
Enter passphrase for /home/$USER/.ssh/id_ed25519_gh_demo: 
Identity added: /home/$USER/.ssh/id_ed25519_gh_demo (SSH Key for Github Demo)

Adding SSH Key: id_ed25519_gl_demo
Enter passphrase for /home/$USER/.ssh/id_ed25519_gl_demo: 
Identity added: /home/$USER/.ssh/id_ed25519_gl_demo (SSH Key for Gitlab Demo)

Adding SSH Key: id_ed25519_bb_demo
Enter passphrase for /home/$USER/.ssh/id_ed25519_bb_demo: 
Identity added: /home/$USER/.ssh/id_ed25519_bb_demo (SSH Key for Bitbucket Demo)

Finished
```

## Creating the Project

There are many command line tools to create repositories remotely, and most differ between service providers. To ensure 
a smooth push for this tutorial, we need to create repo's in each of the destinations.

When creating the repos, there should be `no gitignores`, `no README` files, just a blank repository.

- Log into Github and create a Repo named - git-remote-demo
- Log into Gitlab and create a Repo named - git-remote-demo
- Log into Bitbucket and create a Repo named - git-remote-demo

Keep those pages open, as well need them in the next section.

## Adding Multiple Remote Repositories

Now that we have SSH Keys built, installed on the Git Service Providers, and loaded to the SSH-Agent,
it's time to build the demo repository.

We will first make our directories, then initialize and add remotes. In a terminal, issue the following commands. We'll
use the /tmp directory to prevent any potential conflicts elsewhere.

```bash
# create directories

mkdir -p /tmp/git-remote-demo && cd /tmp/git-remote-demo

# Initialize the repository

git init

# Add the remotes for Github, Gitlab, and Bitbucket
# Note : change <account> to your Github, Gitlab, and Bitbucket account respectively 
# Make sure the URLs match what you created in the previous section.

git remote add origin git@github.com:<account>/git-remote-demo.git
git remote set-url --add --push origin git@github.com:<account>/git-remote-demo.git
git remote set-url --add --push origin git@gitlab.com:<account>/git-remote-demo.git
git remote set-url --add --push origin git@bitbucket.org:<account>/git-remote-demo.git

# Check that remotes were added properly

git remote -v

# You should see something similar to, <account> should reflect your entries from above

origin	git@github.com:<account>/git-remote-demo.git (fetch)
origin	git@gitlab.com:<account>/git-remote-demo.git (push)
origin	git@bitbucket.org:<account>/git-remote-demo.git (push)
origin	git@github.com:<account>/git-remote-demo.git (push)

# Add a Base README.md file and commit changes

echo '# Git Multi-Remote Demo' >> README.md
git add . && git commit -am "Git Multi-Remote Initial Commit"

# You should see something similar to

[master (root-commit) 3551b7f] Git Multi-Remote Initial Commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md

# Push to the repositories
git push

#
# The results below show the work of this tutorial, so the number of objects will be off a bit from
# what you would get from a single README.md file.
# 
# As you can see, both push urls (Gitlab and Bitucket) are populated, as is the main push/pull
# repo on Github
#

Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 32 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 385 bytes | 385.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)

To gitlab.com:<account>/git-remote-demo.git
   494a55a..59b37b9  master -> master

Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 32 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 385 bytes | 385.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)

To bitbucket.org:<account>/git-remote-demo.git
   494a55a..59b37b9  master -> master

Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 32 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 385 bytes | 385.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.

To github.com:<account>/git-remote-demo.git
   494a55a..59b37b9  master -> master

```

[Git-SCM]: https://git-scm.com/
[WSL2]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[Github]: https://github.com/
[Gitlab]: https://gitlab.com/
[Bitbucket]: https://bitbucket.org/
[Sourceforge]: https://sourceforge.net/
[Add SSH Key to Github]: https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
[Add SSH Key to Gitlab]: https://www.tutorialspoint.com/gitlab/gitlab_ssh_key_setup.htm
[Add SSH Key to Bitbucket]: https://manage.accuwebhosting.com/knowledgebase/3608/How-to-add-my-SSH-key-to-GithuborBitbucket.html
