# Creating Trusts In Bulk
This script allows the creation of trusts in a 1 way direction. It will go through a CSV in a given format
and create a one way direction of trusts between all instances in the csv file with the `domain` that is set .
    
Notes:
* You must use a site admin token for this stript
* Very limited error detection is included, so use with caution!
    
# CSV Format:
__combo__

shared~account_id