module RoutesHelper
  def string_to_address(str)
	result = str.match(/^(?<address>[a-zA-Z\s]*)\s+(?<no>\d+[a-zA-Z])(,\s+|,|\s+)(?<zip>\d*)\s+(?<city>[\w\söäü]*)(,\s+|,|\s+)(?<country>[a-zA-Z]{2})$/)
	{:strasse => result[:address], :hausnummer => result[:no], :plz => result[:zip], :ort => result[:city], :land => result[:country]}
  end
end
