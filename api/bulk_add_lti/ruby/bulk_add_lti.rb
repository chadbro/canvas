#Working as of 09/12/2019
require 'typhoeus'
require 'csv'
require 'json'

################### Change these values only ##################
access_token = ''				    #Your access token for Canvas
domain = ''							#The should be the first part of the url
env = ''						    #Either blank for prod, or type test or beta
csv_file = ''						#The full path to the location of the mapping file /full/path/to/the/file.csv
################### Do not change these #######################

default_headers = { 'Authorization' => "Bearer #{access_token}"}

hydra = Typhoeus::Hydra.new(max_concurrency: 40)

env != '' ? env << '.' : env
base_url = "https://#{domain}.#{env}instructure.com/"

CSV.foreach(csv_file, {headers: true}) do |row|
	if row.headers[0] != 'canvas_course_id' || row.headers[1] != 'name' || row.headers[2] != 'consumer_key' || row.headers[3] != 'shared_secret' || row.headers[4] != 'config_url'
		puts "First column needs to be 'canvas_course_id', followed by 'name', 'consumer_key', 'shared_secret' and 'config_url'."
	else
	get_course = Typhoeus::Request.new(base_url + "api/v1/courses/#{row['canvas_course_id']}",
									  method: :get,
									  headers: default_headers)
	get_course.on_complete do |response|
		if response.success?
			update_course = Typhoeus::Request.new(base_url + "api/v1/courses/#{row['canvas_course_id']}/external_tools",
												  method: :post,
												  headers: default_headers,
                                                  params: { 'config_type' => 'by_url',
                                                            'name' => row['name'],
                                                            'privacy_level' => 'anonymous',
                                                            'consumer_key' => row['consumer_key'],
                                                            'shared_secrect' => row['shared_secret'],
                                                            'config_url' => row['config_url'] })
				update_course.on_complete do |response|
					if response.success?
						puts "Succesfully added #{row['name']} to #{row['canvas_course_id']}"
					elsif response.timed_out?
				        puts "Unable to find the course #{row['canvas_course_id']}, response timed out"
					elsif response.code == 0
				        puts response.return_message
					else
				    	puts "HTTP request failed: " + response.code.to_s
					end
				end
				hydra.queue(update_course)
		elsif response.timed_out?
			puts "Unable to find the course #{row['canvas_course_id']}, response timed out"
		elsif response.code == 0
			puts response.return_message
		else
			puts "HTTP request failed: " + response.code.to_s
		end
	end
	hydra.queue(get_course)
end
	hydra.run
end
	puts 'Completed adding LTIs to courses.'