## Rails Bootstrap ##

Rails Bootstrap lets you create a boilerplate Rails project, furnished with all the gems, libraries and dependencies you need to get started immediately on your project.

### Usage ###

    rails new project_name
    cd project_name
    cp -r path_to_rails-bootstrap/lib/* lib/tasks
    rake install['spine']
    rake install['backbone']
    rake install['columnal']           # or rake install['columnal_without-typography']
    rake install['twitter_bootstrap']  # or rake install['twitter_bootstrap_without-grid']

### Included dependencies ###

- [Backbone.js](http://documentcloud.github.com/backbone/)

- [Spine.js](http://maccman.github.com/spine/)

- [Columnal](http://www.columnal.com/)

- [Twitter Bootstrap](http://twitter.github.com/bootstrap/)

Please feel free to fork and add more! All the magic happens in `lib/bootstrap.rake`.

### A little bonus ###

Everyone needs to replace `public/index.html` with a dedicated Home controller and respective view. That's exactly what the nifty little command below does.

    rake create_home_controller

Specifically, it creates a Home controller, sets the root URL for your website to point to its index method, which renders `app/views/home/index.html.erb`.