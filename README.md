# Organization Chart
The code allows for the creation of an organization chart. The development is divided into Front-end (Flutter) and Back-end (Spring Boot).
The application features login and registration areas, role and organizational unit management. It is possible to associate employees to each unit, dividing them into groups and displaying them hierarchically. This means creating a separate organization chart that only includes the employees of a specific group (this is possible for all groups).

# FRONT-END:
To run the application, set "DEVICE TO USE" to "CHROME".
The main classes are located in the lib and lib\model directories.

# BACK-END:
To view the directories containing the classes and the usage of different patterns in the project, refer to: src\main\java\...

# IMPORTANT:
Modify the file: application.properties. You only need to create a database and modify the fields; the tables will be automatically created when the back-end of the project is started.

# NOTE:
To use the DTO and Mapper, it was not possible to establish the relationship between User and Organigram as the former is abstract (for the correct implementation of the FACTORY METHOD pattern). This creates a conflict with the Mapper creation process.
If the mapper is not used, and the code inside DBSave is uncommented while commenting out the code that currently uses the DTO, Mapper, and removing the tables, all tables will be recreated, and in this case, the relationship between User and Organigram will be established.

