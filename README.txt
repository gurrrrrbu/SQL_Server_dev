SQL_Server_Dev_LAB_06
Name: Tandin Phurba
Std No: N01654961

# SQL Server Auditing & Trigger Lab

This lab demonstrates how to implement auditing and data‑integrity controls in **AdventureWorks2022** using SQL Server triggers. It includes:

# What the script does
- Creates a custom schema **Training**
- Builds two audit tables:
  - **ProductPriceAudit** – logs product price changes
  - **SchemaChangeLog** – logs CREATE/ALTER/DROP TABLE events
- Adds three triggers:
  - **AFTER UPDATE** trigger to record price changes
  - **INSTEAD OF DELETE** trigger to prevent deleting products used in sales orders
  - **Database‑level DDL trigger** to log schema changes
- Tests the triggers with sample updates and table creation/deletion
- Demonstrates enabling/disabling nested triggers

# Purpose
This lab helps you understand:
- How DML and DDL triggers work
- How to design audit tables
- How to enforce business rules using triggers
- How SQL Server logs schema changes

#How to run
1. Open SSMS  
2. Select **AdventureWorks2022**  
3. Run the script in order  
4. Query the audit tables to view results
