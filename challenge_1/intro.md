### Safely Adding a New NOT NULL Column to a Table with Millions of Records Without Downtime

- Typically, Rails migrations are additive. This means they're executed sequentially when the `rails db:migrate` command is run, which speeds up DDL and DML processes. However, as your project grows and tables accumulate millions of records, executing a simple ALTER TABLE command through a migration can lock the table until the migration completes. During this period, your system can experience downtime. Requests queue up, waiting for the lock to be released, and migrations can sometimes last for an hour or more. This level of downtime is often unacceptable.

### Achieving This Without Downtime

- One approach to mitigate this problem is to employ a technique inspired by the LHM (Large Hadron Migrator) gem. This method sidesteps the locking issue by:
  - Creating a new "shadow" table that includes the desired new column.
  - Copying data from the existing table to this new shadow table.
  - Once data migration is complete, dropping the original table.
  - Renaming the shadow table to the original table's name.

- For this process to be reliable, it must be:
  1. Safe from data loss.
  2. Backward compatible. This means that while the migration is in progress, any new incoming requests that update the table (e.g., INSERT, UPDATE, DELETE operations) must also be reflected in the shadow table.

This synchronicity can be achieved using SQL triggers. Specifically:
- Set up three triggers corresponding to INSERT, UPDATE, and DELETE operations.
- Once established, test the setup by performing the aforementioned operations on the original table. Check that these operations also execute on the shadow table. By comparing the data between the two tables, we can ensure data consistency and safety.