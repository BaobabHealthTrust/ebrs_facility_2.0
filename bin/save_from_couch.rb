doc = JSON.parse(ARGV[0])
doc['document_id'] = doc['_id']
doc = doc.delete_if{|k, v| ['_id', '_rev', 'type'].include?(k)}

models = [BirthRegistrationType, CorePerson, DuplicateRecord,
          GlobalProperty, Guardianship,
          IdentifierAllocationQueue, LevelOfEducation,
          Location, LocationTag, LocationTagMap,
          ModeOfDelivery, Person, PersonAddress,
          PersonAttribute, PersonAttributeType, PersonBirthDetail,
          PersonIdentifier, PersonIdentifierType, PersonName,
          PersonNameCode, PersonRecordStatus, PersonRelationType,
          PersonRelationship, PersonType, PersonTypeOfBirth,
          PotentialDuplicate, Role, Status, User, UserRole]

models.each do |model|
  next if model.table_name != doc['type']
  primary_key = doc[model.primary_key]
  data = model.find(primary_key) rescue nil
  if data.present?
    data.update_columns(doc)
  else
    model.create(doc)
  end
end