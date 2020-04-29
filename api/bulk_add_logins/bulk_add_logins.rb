# Working as of 04/16/2020
require 'typhoeus'
require 'csv'
require 'json'

### CHANGE THESE VALUES
domain = '' # e.g. 'domain' in 'https://domain.instructure.com'
token = ''  # api token for account admin user
env = ''	#Either blank for prod, or type test or beta
csv = ''     			# Use the full path /Users/XXXXX/Path/To/File.csv

#================
# Don't edit from here down unless you know what you're doing.

env != '' ? env << '.' : env
base_url = "https://#{domain}.#{env}instructure.com/"
test_url = "#{base_url}/accounts/self"

raise "Error: can't locate the update CSV" unless File.exist?(csv)


test = Typhoeus.get(test_url, followlocation: true)
raise "Error: The token, domain, or env variables are not set correctly" unless test.code == 200

CSV.foreach(csv, {:headers => true}) do |row|
  bulk_add_logins = Typhoeus.post(
            base_url + "/api/v1/accounts/self/logins",
            headers: {:authorization => 'Bearer ' + token },
            body:{
                user:{
                    id: row ['canvas_user_id']
                },
                login:{
                    unique_id: row['login_id'],
                    sis_user_id: row['user_id'],
                    # authentication_provider_id: row['authentication_provider_id']     ####Enable this line if you choose to assign an authentication provider####
                }
            }
        )
  if bulk_add_logins.code == 200
    puts "User #{row['canvas_user_id']} login successfully created."
  elsif bulk_add_logins.code == 400
    puts "Error: #{row['canvas_user_id']} that didn't work Error 400. It may already exist. Check it out at https://#{domain}.#{env}instructure.com/accounts/self/users/#{row['canvas_user_id']}"
  else
    puts "User #{row['canvas_user_id']} additional login failed miserably."
    puts "Moving right along..."
  end
end
puts "Finished creating additional logins for users."