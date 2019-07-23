# Looks up addresses using a variety of free Geocoding services, and Google.
# Tries to find the address using free services first, the first address found
# successfully is returned.
# 
# Usage:
# 	MultiGeocoderService.search("7600 Madison Ave, Fair Oaks, CA 95628")
# 
class MultiGeocoderService
	SERVICES = [:esri, :geocoder_ca, :google]

	def self.search(address, options = {})
		Geocoder.configure timeout: 30

		Rails.logger.tagged('MultiGeocoderService: ') do
			SERVICES.each do |service_key|
				begin
					Rails.logger.info "Trying a geocoder lookup with the #{service_key} service"
					lookup_service = Geocoder::Lookup.get(service_key)
					result = lookup_service.search(address, options).first
					if result.state_code.present? &&
						 result.postal_code.present? &&
						 result.city.present?

						response = {
							state_code: result.state_code,
							postal_code: result.postal_code,
							city: result.city,
							address: address1_from_result(service_key, result),
							name: name_from_result(service_key, result),
							latitude: result.latitude,
							longitude: result.longitude
						}

						return OpenStruct.new(response)
					end
				rescue StandardError => error
					Rails.logger.warn "error trying the #{service_key} service: #{error}"
					Rails.logger.info "Trying the next service.."
					next
				end
			end
			nil
		end
	end

	# Returns "Madison Ave, Fair Oaks"
	def self.name_from_result(service, result)
		case service
		when :esri
			location = result.data.dig('locations').first
			attributes = location.dig('feature', 'attributes')
			street = attributes.dig('StName') + ' ' + attributes.dig('StType')
			street + ', ' + attributes.dig('City')
		when :geocoder_ca
			result.data.dig('standard','staddress') + ', ' + result.city
		else
			"#{result.route}, #{result.city}"
		end
	end

	# Returns "7600 Madison Ave"
	def self.address1_from_result(service, result)
		case service
		when :esri
			location = result.data.dig('locations').first
			location.dig('feature', 'attributes', 'ShortLabel')
		when :geocoder_ca
			data = result.data
			data.dig('standard', 'stnumber') + ' ' + data.dig('standard', 'staddress')
		else
			result.street_address
		end
	end
end
