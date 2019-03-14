Enable Blueprint Courses
---
This script takes a csv file with one header **sis_course_id** and enables/disables them as a blueprint course. This column refers to the **sis_id** of the courses that should be enabled as a blueprint.

In the script there is a variable **status** that needs to be changed. **Defaulted at *true***, but can be changed to *false* to turn off blueprint courses in bulk.

**Best case use: Enabling blueprint courses in bulk.**

Please see the `courses.csv` as a template to structure your CSV file.