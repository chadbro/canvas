# Bulk Delete Sections

Create a 1-column CSV with headers canvas_section_id see sample CSV.

Install dependencies with `bundle install`, run script with `ruby bulk_delete_sections.rb`.

If your csv was formatted properly, you should see the http response codes for each batch of courses
being added to each blueprint course. Keep in mind these are added in batches; so the number of status codes
you see returned in your terminal could be substantially less than the total number of lines in your csv.