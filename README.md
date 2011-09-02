## Rails Bootstrap ##

Rails Bootstrap lets you create a boilerplate Rails project, furnished with all the gems, libraries and dependencies you need to get started immediately on your project.

### Usage ###

Start Rails project and install Rails Bootstrap:

    rails new project_name
    cd project_name
    cp -r path_to_rails-bootstrap/lib/* lib/tasks

Bootstrap your project:

    rake bootstrap:install['spine']
    rake bootstrap:install['backbone']
    rake bootstrap:install['columnal']           # or rake install['columnal_without-typography']
    rake bootstrap:install['twitter_bootstrap']  # or rake install['twitter_bootstrap_without-grid']
    rake bootstrap:add_to_gemfile                # adds a bunch of useful gems (commented out) to the Gemfile, so you can enable the ones you want at your leisure

### Included dependencies ###

- [Backbone.js](http://documentcloud.github.com/backbone/)

- [Spine.js](http://maccman.github.com/spine/)

- [Columnal](http://www.columnal.com/)

- [Twitter Bootstrap](http://twitter.github.com/bootstrap/)

Please feel free to fork and add more! All the magic happens in `lib/bootstrap.rake`.

### A little bonus ###

Everyone needs to replace `public/index.html` with a dedicated Home controller and respective view. That's exactly what the nifty little command below does.

    rake bootstrap:create_home_controller

Specifically, it creates a Home controller, sets the root URL for your website to point to its index method, which renders `app/views/home/index.html.erb`.