require 'fileutils'

directory "app/assets/javascripts/include"
directory "app/assets/stylesheets/include"
directory "app/views/home"

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

task :install, :dependency do |t, args|
	case args.dependency
	when "spine"
		Rake::Task["install_spine"].invoke
	when "backbone"
		Rake::Task["install_backbone"].invoke
	when "columnal"
		Rake::Task["install_columnal"].invoke
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