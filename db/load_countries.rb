puts "Loading countries"
countries = ISO3166::Country.all
countries_count = countries.count

countries.each_with_index do |country, index|
    country = Country.create!(name: country.name, country_code: country.country_code, country_short_code: country.alpha2, 
                            nationality: country.nationality, continent: country.continent, region: country.region, 
                            sub_region: country.subregion, world_region: country.world_region, currency: (country.currency.name rescue ""),
                            ioc: country.ioc,gec: country.gec)

    puts "Loaded #{index + 1} of #{countries_count} countries"
end
puts "Loaded countries!!!"