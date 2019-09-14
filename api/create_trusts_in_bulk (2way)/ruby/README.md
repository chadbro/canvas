# Bulk Establishing Trusts
This script allows the creation of bulk 2 way trusts. It will go through a CSV in a given format
and create a bi-directional trust between all instances in the list.
    
Notes:
* You must use a site admin token for this stript. #SorryNotSorry!
* Very limited error detection is included, so use with caution!
* A log file will be created with the same name as you CSV file, but with a .log extension
    
# CSV Format:
__canvas_domain,shard_id,account_id__

school.instructure.com,1234,1