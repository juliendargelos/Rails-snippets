module HasDisallowedValues extend ActiveSupport::Concern
	included do
		validate do
			begin
				disallowed_values = self.class.disallowed_values
				disallowed_values_messages = self.class.disallowed_values_messages

				if disallowed_values != nil
					disallowed_values.each do |property, values|
						puts property
						values.each do |value|
							if self[:"#{property.to_s}"] == value.to_s
								if disallowed_values_messages[:"#{property.to_s}"] != nil
									message = disallowed_values_messages[:"#{property.to_s}"]
									message = message.gsub /:property([^a-zA-Z0-9_])/, property.to_s+'\1'
									message = message.gsub /:value([^a-zA-Z0-9_])/, value.to_s+'\1'
								else
									message = "The value \"#{value.to_s}\" is disallowed as #{property.to_s}"
								end
								self.errors.add(:"#{property.to_s}", message)
							end
						end
					end
				end
			rescue => e
				self.errors.add(:base, e.message)
			end
		end
  	end

    module ClassMethods
		attr_reader :disallowed_values
		attr_reader :disallowed_values_messages

		def constraints
			constraints = {}
			@disallowed_values.each do |property, values|
				constraints[:"#{property.to_s}"] = lambda { |request| request.username !~ /\A(#{values.join '|'})\z/ }
			end

			constraints
		end

		private

		def disallow_values properties
			@disallowed_values = {} if @disallowed_values == nil
			@disallowed_values_messages = {} if @disallowed_values_messages == nil

			properties.each do |property, values|
				if values != nil
					if values.is_a? Hash
						if values[:values] != nil
							@disallowed_values[:"#{property.to_s}"] = values[:values]
							@disallowed_values_messages[:"#{property.to_s}"] = values[:message] if values[:message] != nil
						end
					elsif values.is_a? Array
						@disallowed_values[:"#{property.to_s}"] = values
					end
				end
			end
		end
    end
end
