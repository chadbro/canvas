# Working as of 3/29/2019

require 'csv'
require 'typhoeus'
require 'byebug'

### CHANGE THESE VALUES
domain = '' # e.g. 'domain' in 'https://domain.instructure.com'
token = ''  # api token for account admin user
env = ''	#Either blank for prod, or type test or beta
status = 'true' # use 'false' to turn off blueprint courses
csv = '' # Path to file that should contain a sis_course_id header

#================
# Don't edit from here down unless you know what you're doing.

env != '' ? env << '.' : env
base_url = "https://#{domain}.#{env}instructure.com/"
test_url = "#{base_url}/accounts/self"

raise "Error: can't locate the update CSV" unless File.exist?(csv)


test = Typhoeus.get(test_url, followlocation: true)
raise "Error: The token, domain, or env variables are not set correctly" unless test.code == 200

CSV.foreach(csv, {:headers => true}) do |row|
  enable_blueprint_course = Typhoeus.put(
            base_url + "/api/v1/courses/sis_course_id:" + row['sis_course_id'] + "?course[blueprint]=#{status}",
            headers: {:authorization => 'Bearer ' + token }
            )
  if enable_blueprint_course.code == 200
    puts "Course #{row['sis_course_id']} blueprint course equals #{status}"
  elsif enable_blueprint_course.code == 400
    puts "Error: #{row['sis_course_id']} that didn't work Error 400."
  else
    puts "Course #{row['sis_course_id']} had failed blueprint course to be #{status}."
    puts "Moving right along..."
  end
end
puts "Finished enabling blueprint courses."