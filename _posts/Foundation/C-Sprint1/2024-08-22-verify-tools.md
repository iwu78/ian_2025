---
layout: post
title: Sprint 1 - Verify Tools
description: Verifying Tools and Software for Sprint 1
type: collab
categories:
  - Sprint 1
comments: True
---

----------------- Checking git version -----------------
```console
iwu88@LG17:~/vscode/ian_2025$ git --version
git version 2.34.1
```
----------------- Checking ruby version -----------------
```console
iwu88@LG17:~/vscode/ian_2025$ ruby -v
ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux-gnu]
```
----------------- Checking python version -----------------
```console
iwu88@LG17:~/vscode/ian_2025$ python --version
Python 3.10.12
```
----------------- Verifying Jupyter Kernels -----------------
```console
iwu88@LG17:~/vscode/ian_2025$ jupyter kernelspec list
Available kernels:
  python3    /home/iwu88/vscode/ian_2025/venv/share/jupyter/kernels/python3
  java       /usr/local/share/jupyter/kernels/java
```
Verifying creation of project environment variables
```console
iwu88@LG17:~/vscode/ian_2025$ echo "Repos home dir: /home/iwu88/vscode"
"Repos home dir: /home/iwu88/vscode"
```
```console
iwu88@LG17:~/vscode/ian_2025$ echo "Project dir: $project_dir/ian_2025"
"Project dir: $project_dir/ian_2025"
```
```console
iwu88@LG17:~/vscode/ian_2025$ echo "Posts dir: $project/_posts"
"Posts dir: $project/_posts"
```
```console
iwu88@LG17:~/vscode/ian_2025$ echo "Notebooks dir: $project/_notebooks"
"Notebooks dir: $project/_notebooks"
```
```console
iwu88@LG17:~/vscode/ian_2025$ echo "Repo: https://github.com/nighthawkcoders/ian_2025.git"
"Repo: https://github.com/nighthawkcoders/ian_2025.git"
```
Verifying configuration of GitHub 
```console
iwu88@LG17:~/vscode/ian_2025$ git config --global --list
user.email=keledang777@gmail.com
user.name=iwu78
credential.https://github.com.helper=
credential.https://github.com.helper=!/usr/bin/gh auth git-credential
```
