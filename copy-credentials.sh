#!/usr/bin/env bash

mkdir -p creds

cp -rf $HOME/.ssh creds/
rm creds/.ssh/authorized_keys
cp -rf $HOME/.dockercfg creds/
cp -rf $HOME/.gitconfig creds/
cp -rf $HOME/.git-credentials creds/
cp -rf $HOME/.git-credential-cache creds/
cp -rf $HOME/.sbt/0.13/sonatype.sbt creds/
cp -rf $HOME/.aws/config creds/
