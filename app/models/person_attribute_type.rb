class PersonAttributeType < ActiveRecord::Base
    self.table_name = :person_attribute_type
    self.primary_key = :person_attribute_type_id
    has_many :person_attributes, :foreign_key: "person_attribute_type_id"
    include EbrsAttribute

end
