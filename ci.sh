#!/bin/bash

npm set registry https://registry.npmjs.org/
npm list phantomjs || npm install phantomjs

#Ensure all required gems are installed
bundle install --quiet

# Finally run the required tasks with rake
bundle exec rake $*