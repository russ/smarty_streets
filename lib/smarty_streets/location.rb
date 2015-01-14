module SmartyStreets
  class Location
    # Request & Response fields
    attr_accessor :input_id
    attr_accessor :street, :street2, :secondary
    attr_accessor :city, :state, :zipcode
    attr_accessor :lastline, :addressee, :urbanization
    attr_accessor :candidates

    # Response only fields
    attr_accessor :input_index, :candidate_index
    attr_accessor :delivery_line_1, :delivery_line_2, :delivery_point_barcode
    attr_accessor :components, :metadata, :analysis
  end
end
