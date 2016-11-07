module AssetsHelper
	ASSETS = __dir__ + '/../assets'
	STYLESHEETS = ASSETS + '/stylesheets'
	JAVASCRIPTS = ASSETS + '/javascripts'
	IMAGES = ASSETS + '/images'

	def current_asset_name
		"#{controller_name}-#{action_name}"
	end

	def current_asset directory, attributes, type, &block
		asset = current_asset_name

		attributes[:media] = 'all' if (type == 'sass' || type == 'scss' || type == 'scss') && !attributes.key? :media
		attributes['data-turbolinks-track'] = true if !attributes.key? 'data-turbolinks-track' && turbolinks_enabled?

		if File.file? "#{directory}/#{asset}.#{type}"
			return block.call asset, attributes
		end

		return ''
	end

	def current_stylesheet attributes = {}, type = 'sass'
		current_asset STYLESHEETS, attributes, type do |asset, attributes|
			stylesheet_link_tag asset, attributes
		end
	end

	def current_javascript attributes = {}, type = 'js'
		html = ''

		if turbolinks_enabled?
			html += javascript_include_tag 'application.js', 'data-turbolinks-track' => true
		end

		html += current_asset JAVASCRIPTS, attributes, type do |asset, attributes|
			javascript_include_tag asset, attributes
		end

		html.html_safe
	end

	def enable_turbolinks
		@turbolinks_enabled = true
	end

	def disable_turbolink
		@turbolinks_enabled = false
	end

	def turbolinks_enabled?
		return @turbolinks_enabled == true
	end

	def get_svg file
		path = IMAGES + "/#{file}.svg"

		if File.file? path
			raw File.read path
		end
	end
end
