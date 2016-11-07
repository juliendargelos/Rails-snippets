module HasSlug extend ActiveSupport::Concern
	DEFAULT_FROM = 'name'
	DEFAULT_TO = 'slug'
	DEFAULT_DELIMITER = '-'
	DEFAULT_LOWERCASE = true

	included do
    	before_save :update_slug
  	end

	def update_slug
		options = self.class.slug_options

		options = {} if options == nil

		from = options[:from] == nil ? DEFAULT_FROM : options[:from].to_s
		to = options[:to] == nil ? DEFAULT_TO : options[:to].to_s
		delimiter = options[:delimiter] == nil ? DEFAULT_DELIMITER : options[:delimiter].to_s
		lowercase = options[:lowercase] == nil ? DEFAULT_LOWERCASE : (options[:lowercase] ? true : false)

		slug = self[:"#{from}"].to_slug delimiter: delimiter, lowercase: lowercase

		self[:"#{to}"] = slug

		n = 0
		while self.class.find_by(:"#{to}" => self[:"#{to}"]) != nil do
			self[:"#{to}"] = slug + "#{delimiter}#{n}"
			n += 1
		end
	end

    module ClassMethods
		attr_reader :slug_options

		private

		def slug options
			@slug_options = options
		end
    end
end
