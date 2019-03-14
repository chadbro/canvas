Enable Blueprint Courses
---
This script takes a csv file with one header **sis_course_id** and enables/disables them as a blueprint course. This column refers to the **sis_id** of the courses that should be enabled/disabled as a blueprint.

In the script there is a variable **status** that needs to be changed. **Defaulted at *true***, but can be changed to *false* to turn off blueprint courses in bulk.

**Best case use: Enabling or Disabling blueprint courses in bulk.**

Please see the `courses.csv` as a template to structure your CSV file.

Pro Tip:
1. Courses must be provisioned before script is ran. The api is a `PUT` request to update the course to be a blueprint course
2. In the `courses.csv` only the first column **sis_course_id** is required
3. Ruby Gems required are:'csv','typhoeus','byebug'

References: 
API - https://canvas.instructure.com/doc/api/courses.html#method.courses.update