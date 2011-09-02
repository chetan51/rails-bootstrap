#/bin/bash

rm -rf project
rails new project
cd project
cp -r ../../lib/* lib/tasks

rake bootstrap:install['spine']
rake bootstrap:install['backbone']
rake bootstrap:install['columnal_without-typography']
rake bootstrap:install['twitter_bootstrap_without-grid']

rake bootstrap:create_home_controller
rake bootstrap:add_to_gemfile