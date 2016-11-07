module FormHelper
	def has_error? entity, field
		entity.errors.messages.key? field
	end

	def error_for entity, field, all = nil
		errors = entity.errors.messages[field]
		if errors == nil
		  all == :all ? [] : nil
		elsif all == :all
		  errors.map { |error| error.ucfirst }
		else
		  errors.length == 0 ? nil : errors[0].ucfirst
		end
	end
end
