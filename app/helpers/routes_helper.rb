module RoutesHelper
  def string_to_address(str)
	Rails.logger.debug(:hier)
	Rails.logger.debug(str)
	result = str.match(/^(?<address>[a-zA-Z\s]*)(\s+(?<no>(\d*[a-zA-Z]?)))?(,\s+|,|\s+)(?<zip>\d{5}?)\s+(?<city>[a-zA-Z\söäü]*)(,\s+|,|\s+)(?<country>[a-zA-Z]{2})$/)
	if result.nil? 
		nil 
	else
		{:street => result[:address], :number => result[:no], :zip => result[:zip], :city => result[:city], :country => result[:country]}
	end
  end
end
