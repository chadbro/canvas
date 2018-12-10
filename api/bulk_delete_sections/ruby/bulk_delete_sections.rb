#Working as of 12/7/2018
require 'typhoeus'
require 'csv'
require 'json'

################### Change these values only ##################
access_token = ''				#Your access token for Canvas
domain = ''							#The should be the first part of the url
env = ''								#Either blank for prod, or type test or beta
csv_file = ''						#The full path to the location of the mapping file /full/path/to/the/file.csv
################### Do not change these #######################

default_headers = { 'Authorization' => "Bearer #{access_token}"}

hydra = Typhoeus::Hydra.new(max_concurrency: 40)

env != '' ? env << '.' : env
base_url = "https://#{domain}.#{env}instructure.com/"

CSV.foreach(csv_file, {headers: true}) do |row|
	if row.headers[0] != 'canvas_section_id'
		puts "First column needs to be 'canvas_section_id'."
	else
	get_section = Typhoeus::Request.new(base_url + "api/v1/sections/#{row['canvas_section_id']}",
									  method: :get,
									  headers: default_headers)
	get_section.on_complete do |response|
		if response.success?
			delete_section = Typhoeus::Request.new(base_url + "api/v1/sections/#{row['canvas_section_id']}",
												  method: :delete,
												  headers: default_headers)
				delete_section.on_complete do |response|
					if response.success?
						puts "#{row['canvas_section_id']} is successfully deleted"
					elsif response.timed_out?
				        puts "Unable to find the section #{row['canvas_section_id']}, response timed out"
					elsif response.code == 0
				        puts response.return_message
					else
				    	puts "HTTP request failed: " + response.code.to_s
					end
				end
				hydra.queue(delete_section)
		elsif response.timed_out?
			puts "Unable to find the section #{row['canvas_section_id']}, response timed out"
		elsif response.code == 0
			puts response.return_message
		else
			puts "HTTP request failed: " + response.code.to_s
		end
	end
	hydra.queue(get_section)
end
	hydra.run
end
	puts 'You have now complety deleted the section_ids.'