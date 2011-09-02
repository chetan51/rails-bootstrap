#/bin/bash

rm -rf project
rails new project
cd project
cp -r ../../lib/* lib/tasks
rake create_home_controller

rake install['spine']
rake install['backbone']
rake install['columnal_without-typography']
rake install['twitter_bootstrap_without-grid']

rake add_to_gemfile