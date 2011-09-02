require 'fileutils'

directory "app/assets/javascripts/include"
directory "app/assets/stylesheets/include"
directory "app/views/home"

task :install, :dependency do |t, args|
	case args.dependency
	when "spine"
		Rake::Task["install_spine"].invoke
	when "backbone"
		Rake::Task["install_backbone"].invoke
	when "columnal"
		Rake::Task["install_columnal"].invoke
	when "columnal_without-typography"
		Rake::Task["install_columnal_without_typography"].invoke
	when "twitter_bootstrap"
		Rake::Task["install_twitter_bootstrap"].invoke
	when "twitter_bootstrap_without-grid"
		Rake::Task["install_twitter_bootstrap_without_grid"].invoke
	end
end

task :create_home_controller => ["app/views/home"] do
	# Generate controller
	`script/rails generate controller home`

	# Add index view
	filename = 'app/views/home/index.html.erb'
	File.open(filename, "w") do |file|
		file.puts 'Hello world!'
	end

	# Update routes
	replace_string_in_file('config/routes.rb',
	                       "  # root :to => 'welcome#index'",
	                       "  root :to => 'home#index'",
	                       "  root :to => 'home#index'")

	# Delete public index
	`rm -f public/index.html`
end

task :add_to_gemfile do
	commented_gems = """
# gem 'devise'

# gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# gem 'rack-offline', :git => 'git://github.com/chetan51/rack-offline.git

# Unit / Functional Testing
# group :development, :test do
# 	gem 'jasmine'
# 	gem 'headless'
# end

# HTTP / Rest client
# gem 'rest-client'

# New Relic
# gem 'newrelic_rpm'

# Backup
# gem 'heroku_backup_task'
	"""

	filename = 'Gemfile'
	File.open(filename, "a") do |file|
		file.puts commented_gems
	end
end


task :install_spine => ["app/assets/javascripts/include"] do
	# Fetch Spine.js
	`wget http://maccman.github.com/spine/spine.min.js -O tmp/spine.min.js`

	# Move to assets
	FileUtils.mv('tmp/spine.min.js', 'app/assets/javascripts/include/spine.min.js')

	build_js_app_directory_structure
end

task :install_backbone => ["app/assets/javascripts/include"] do
	# Fetch backbone.js
	`wget http://documentcloud.github.com/backbone/backbone-min.js -O tmp/backbone.min.js`

	# Move to assets
	FileUtils.mv('tmp/backbone.min.js', 'app/assets/javascripts/include/backbone.min.js')

	build_js_app_directory_structure
end

task :install_columnal => ["app/assets/stylesheets/include"] do
	# Fetch Columnal
	`wget http://www.columnal.com/download/columnal-0.85.zip -O tmp/columnal.zip`

	# Unzip it
	`unzip -oq -d tmp tmp/columnal.zip`

	# Move to assets
	`mv tmp/columnal-0.85/code/css app/assets/stylesheets/include/columnal`

	# Remove smallerscreen.css (unnecessary file)
	`rm app/assets/stylesheets/include/columnal/smallerscreen.css`
end

task :install_columnal_without_typography do
	Rake::Task["install_columnal"].invoke

	# Remove typography
	replace_regex_in_file('app/assets/stylesheets/include/columnal/columnal.css', /\/\* TYPE PRESETS\n\/\/.*\/\* END TYPE PRESETS\n\/* \*\//m, "")
end

task :install_twitter_bootstrap => ["app/assets/stylesheets/include"] do
	# Fetch Twitter Bootstrap
	`wget http://twitter.github.com/bootstrap/assets/css/bootstrap-1.1.1.min.css -O tmp/twitter_bootstrap.min.css`

	# Move to assets
	`mv tmp/twitter_bootstrap.min.css app/assets/stylesheets/include/twitter_bootstrap.min.css`
end

task :install_twitter_bootstrap_without_grid do
	Rake::Task["install_twitter_bootstrap"].invoke

	# Remove grid
	replace_regex_in_file('app/assets/stylesheets/include/twitter_bootstrap.min.css', /\.row.*/, "")
	replace_regex_in_file('app/assets/stylesheets/include/twitter_bootstrap.min.css', /\.container{.*/, "")
end


def build_js_app_directory_structure
	`mkdir -p app/assets/javascripts/application/{controllers,models,views}`
end

def replace_string_in_file(filename, search_string, test_string, replace_string)
	text = File.read(filename)
	if text.scan(test_string).length == 0
		text[search_string] = replace_string
		File.open(filename, "w") do |file|
			file.puts text
		end
	end
end

def replace_regex_in_file(filename, search_regex, replace_string)
	text = File.read(filename)
	text.gsub!(search_regex, replace_string)
	File.open(filename, "w") do |file|
		file.puts text
	end
end