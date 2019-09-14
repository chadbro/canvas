=begin
    TrustyTrust
    Working 09/13/2019

    This tool allows the creation of bulk 2 way trusts. It will go through a CSV in a given format
    and create a bi-directional trust between all instances in the list.
    
    Notes:
    * You must use a site admin token for this stript. #SorryNotSorry!
    * Very limited error detection is included, so use with caution!
    * A log file will be created with the same name as you CSV file, but with a .log extension
    
    CSV Format:
    canvas_domain,shard_id,account_id
    canvas.instructure.com,1234,1
=end

site_admin_token = ""; #Your site admin token. For the LOLs
input_csv = ""; #Path/name of a properly formatted UTF-8 (no BOM) CSV file containing all the Canvas instances

#++++++++++ You shouldn't need to change anything below this line ++++++++++
require 'typhoeus'
require 'csv'
require 'json'
require 'URI'

logger = Logger.new(input_csv+".log")
logger.formatter = proc do |severity, datetime, progname, msg|
    severity == "INFO" ? severity = "" : severity = "#{severity} "
    puts "#{severity}#{msg}"
    "#{severity}#{msg}\n"
end
logger.info("======== Run started at #{Time.now} ========")
unless File.file?(input_csv)
    logger.fatal("Input file #{input_csv} does not exist. What are you trying to pull here!?")
    exit
end

instances = [];
hydra = Typhoeus::Hydra.new(max_concurrency: 10)
row_count = 0;
logger.info("Starting import of #{input_csv}")
CSV.foreach(input_csv, headers: true) do |row|
    row_count = row_count + 1;
    if row_count == 1 && (!row.headers.include?('canvas_domain') || !row.headers.include?('shard_id') || !row.headers.include?('account_id'))
        logger.fatal("Input file #{input_csv} must contain canvas_domain, shard_id and account_id columns")
        exit
    else
        instances.push({:url=>row['canvas_domain'],:shard=>row['shard_id'],:account=>row['account_id'],:combo=>"#{row['shard_id']}~#{row['account_id']}"})
    end
end
logger.info("Found #{row_count} instances. I hope you put the right stuff in!\nHere we go!")
instances.each do |instance|
    api_url = "https://#{instance[:url]}/api/v1/accounts/#{instance[:combo]}/trust_links"
    logger.info("Queuing #{api_url}")
    instances.each do |dest|
        unless(dest[:combo] == instance[:combo])
            logger.info("   managed_account_id: #{dest[:combo]}")
            make_trust = Typhoeus::Request.new(api_url,
                method: :post,
                headers: { Authorization: "Bearer #{site_admin_token}" },
                params: { 'trust_link[managing_account_id]' => dest[:combo] }
            )
            make_trust.on_complete do |response|
                parsed_data = nil
                if response.code.eql?(200)
                    parsed_data = JSON.parse(response.body)
                    if defined? parsed_data['id'] && parsed_data['managed_account_id'] == instance['account']
                        logger.info("     Success! managed: #{instance[:combo]}, managing: #{dest[:combo]}")
                    else
                        logger.error("setting up managed: #{instance[:combo]}, managing: #{dest[:combo]} (200 code)")
                    end
                else
                    if response.code.eql?(400)
                        logger.error("on managed: #{instance[:combo]}, managing: #{dest[:combo]}. It is possible the trust already exists. (400 code)")
                    elsif response.code.eql?(404)
                        logger.error("on managed #{instance[:combo]}, managing: #{dest[:combo]}. You may have a bad canvas_domain or the managed/managing shard_id or account_id is invalid.(#{instance[:url]}) (404 code)")
                    elsif response.code.eql?(401)
                        logger.error("Your site_admin_token is not valid!")
                    else
                        logger.error("on managed #{instance[:combo]}, managing: #{dest[:combo]}. Canvas URL: #{instance[:url]} (#{response.code} code: #{response.body})")
                    end 
                end
            end
            hydra.queue(make_trust)
        end
    end
end
hydra.run
logger.info("========= Run finished at #{Time.now} =======")