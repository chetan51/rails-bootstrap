require 'fileutils'

directory "public/javascripts"
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
	end
end


task :install_spine => ["public/javascripts"] do
	# Fetch Spine.js
	`wget http://maccman.github.com/spine/spine.min.js -O tmp/spine.min.js`

	# Move to assets
	FileUtils.mv('tmp/spine.min.js', 'public/javascripts/spine.min.js')

	# Inject script tag into application layout view
	replace_string_in_file('app/views/layouts/application.html.erb',
	                       '</head>',
	                       '  <script src="/javascripts/spine.min.js" type="text/javascript"></script>',
	                       '  <script src="/javascripts/spine.min.js" type="text/javascript"></script>' + "\n" + '</head>')

	build_js_app_directory_structure
end

task :install_backbone => ["public/javascripts"] do
	# Fetch backbone.js
	`wget http://documentcloud.github.com/backbone/backbone-min.js -O tmp/backbone.min.js`

	# Move to assets
	FileUtils.mv('tmp/backbone.min.js', 'public/javascripts/backbone.min.js')

	# Inject script tag into application layout view
	replace_string_in_file('app/views/layouts/application.html.erb',
	                       '</head>',
	                       '  <script src="/javascripts/backbone.min.js" type="text/javascript"></script>',
	                       '  <script src="/javascripts/backbone.min.js" type="text/javascript"></script>' + "\n" + '</head>')

	build_js_app_directory_structure
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