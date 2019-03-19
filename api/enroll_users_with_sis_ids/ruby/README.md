Enroll users using SIS IDs for users and sections
This script allows users to be enrolled into Canvas sections using the SIS ID of both the user and section. 

The input CSV has 3 required columns:

    sis_user_id,sis_section_id,role
    12345,ACCT101-01,student
Please reference example.csv

sis_user_id: The SIS ID (NOT Canvas ID) for the user that should be enrolled.
sis_section_id: The SIS ID (NOT Canvas ID) for the section into which the user should be enrolled.
role: The name of the role to be used for the enrollment (See Notes)
Notes
Default Canvas roles (student, teacher, ta and designer) are not valid for the enrollment API. As a result, the script will alter these role to the appropriate values at run time if they are detected as input. Custom roles are also supported.
This script is only designed to add enrollments. It will not delete existing enrollments.
This script enrolls the user as an active user in the course and does not send a notification about the enrollment to the user.