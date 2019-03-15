Bulk Update Course Grading Standards
---
This script takes a csv file with one header **sis_course_id**. The *sis_course_id's* in this column refer to courses SIS_ID (in Canvas UI) that should have an assigned grading standard (grading scheme) enabled via the API.

The **grading_standard_id** is the appropriate id of the grading standard (grading scheme) found by the api (https://canvas.instructure.com/doc/api/grading_standards.html#method.grading_standards_api.context_index).

**Best case use: This script assigns grading standards to courses in bulk, course by course.**

Please see the `grading_standards.csv` as a template to structure your CSV file.