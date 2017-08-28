#!/bin/bash -l

#Ensure all required gems are installed
bundle install

# Finally run the required tasks with rake
bundle exec rake $*