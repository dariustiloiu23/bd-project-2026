# County-Level Examination Management System

An Oracle SQL database project for managing national exams (like the Baccalaureate or National Evaluation) at the county level.
The system handles everything from schools, examination centers, and candidates to supervisors, exam rooms, anonymized papers, and teacher evaluations.

## What the System Does
Territorial & School Hierarchy: Keeps track of counties, examination centers, and schools (including structures subordinated to main schools).
Supervision & Rooms: Uses a ternary association (REPART_SUPRAV) to assign teachers to specific rooms during exam sessions.
Grading Workflow: Candidates submit anonymized papers (LUCRARE with secret barcodes) which are graded independently by evaluators (EVALUARE).
Data Integrity: Schema normalized up to 3NF, with primary/foreign keys, unique CNP constraints, and valid grade ranges (1.00 to 10.00).

## SQL Queries & Features
The queries in queries/02_advanced_queries.sql cover the core database requirements:
Aggregations & HAVING: Finding schools with candidate counts above the overall average.
Correlated Subqueries: Finding students scoring above their school's session average.
WITH Clause & Inline Views: Filtering exam rooms that exceed average room capacity.
Data Formatting: Using NVL, DECODE, and CASE expressions for labels and exam seasons.
Relational Division: Finding candidates who attended all available exam sessions using double NOT EXISTS.
4-Table Outer Join: Viewing candidate lists along with their papers and grades (even if ungraded).
Top-N Analysis: Getting the top 3 highest scores across the county.
Views & Subquery DML: Creating a join view (V_CANDIDATI_SCOLI) and testing valid/invalid DML, plus updates and deletions using subqueries.

## Bonus Topics (in PDF)
The documentation (144tiloiu_darius_lucian_bd1.pdf) also includes:
Advanced normalization examples (BCNF, 4NF, 5NF) and a case for denormalization.
A comparison with NoSQL (MongoDB), including a JSON document design and basic CRUD commands.
