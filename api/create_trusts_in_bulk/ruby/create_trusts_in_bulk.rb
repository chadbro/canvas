# working as of 9/13/2019

require 'csv'
require 'typhoeus'
require 'byebug'

### CHANGE THESE VALUES
domain = '' # e.g. 'domain' in 'https://domain.instructure.com'
token = ''  # api token for account admin user
csv = '' # this should contain a combo header

#================
# Don't edit from here down unless you know what you're doing.

base_url = "https://#{domain}.instructure.com"
test_url = "#{base_url}/accounts/self"

raise "Error: can't locate the update CSV" unless File.exist?(csv)


test = Typhoeus.get(test_url, followlocation: true)
raise "Error: The token, domain, or env variables are not set correctly" unless test.code == 200

CSV.foreach(csv, {:headers => true}) do |row|
  delete_trust = Typhoeus.post(
            base_url + "/api/v1/accounts/self/trust_links?trust_link[managing_account_id]=#{row['combo']}",
            headers: {:authorization => 'Bearer ' + token }
            )
  if delete_trust.code == 200
    puts "A Trust has been offically established with #{row['combo']}"
  elsif delete_trust.code == 400
    puts "Error: Trust already exists with #{row['combo']}. Error 400"
  else
    puts "You Don't Trust Anyone!"
    puts "Moving right along..."
  end
end
puts "Completed establishing trusts."