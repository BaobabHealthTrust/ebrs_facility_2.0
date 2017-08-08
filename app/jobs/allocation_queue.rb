class AllocationQueue
 include SuckerPunch::Job
  workers 1

  def perform()
    ActiveRecord::Base.logger.level = 1
    if SETTINGS['assign_ben']
      queue = IdentifierAllocationQueue.where(assigned: 0)
    else
      queue = []
    end

    if queue.length > 0
      SuckerPunch.logger.info "Approving for #{queue.count} record(s)"
    end

    begin
      (queue || []).each do |record|
        if record.person_identifier_type_id == PersonIdentifierType.where(:name => "Birth Entry Number").last.person_identifier_type_id
         location = Location.find(SETTINGS['location_id'])
         district_code = location.district.code
          district_code_len = district_code.length
          year = Date.today.year
          year_len = year.to_s.length

          last = PersonBirthDetail.where("LEFT(district_id_number, #{district_code_len}) = '#{district_code}'
            AND RIGHT(district_id_number, #{year_len}) = #{Date.today.year}").select(" MAX(SUBSTR(district_id_number,
              #{(district_code_len + 2)}, 7)) AS last_num")[0]['last_num'] rescue 0

          mid_number = (last.to_i + 1).to_s.rjust(7,'0')
          person_birth_detail = PersonBirthDetail.where(person_id: record.person_id).first
          person_birth_detail.update_attributes(district_id_number: "#{district_code}/#{mid_number}/#{year}")
          record.update_attributes(assigned: 1)

        elsif record.person_identifier_type_id == 'BRN'
        end
      end 
    rescue
      AllocationQueue.perform_in(1.5)
    end

    AllocationQueue.perform_in(1.5)
  end

end
