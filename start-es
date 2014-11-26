#!/usr/bin/env bash

# Helper script for making sure your development Elastic Search node is up and
# running. Assumes you have the esruby repo installed at the same folder level as
# cs391 and that you've already ran "kitchen create" at least once in esruby.

echo "Installing Ruby Depedencies"
bundle install
echo "Provisioning/Updating Test Server"
cd ../esruby/
git fetch origin
git merge origin/master
bundle install
berks install
kitchen create
cd ../esruby/.kitchen/kitchen-vagrant/default-ubuntu-1404
vagrant up
cd ../../../
kitchen converge
echo "Test Server Running and Ready!"
