module SmartyStreets
  class Location
    attr_accessor :street, :street2, :secondary
    attr_accessor :city, :state, :zip_code
    attr_accessor :last_line, :addressee, :urbanization
    attr_accessor :delivery_point_barcode, :components, :meta_data, :analysis
  end
end
