class LocationTagMap < ActiveRecord::Base
    self.table_name = :location_tag_map
    self.primary_keys = :location_id, :location_tag_id
end
