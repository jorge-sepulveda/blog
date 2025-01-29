+++
title = "Expense Tracker Pt4"
date = "2025-01-29T12:05:39-06:00"
tags = ["Dev", "Python", "DuckDB"]
+++

# Putting the database in a class

We've made some great progress in making an expense tracker. Now it's time for some cleanup. Per the [last post](./expense-tracker-pt3.md), I have removed the `sub_category` column from the database. I can run Group By queries to compile all the different categories and it makes it simpler without needing to regex all of that. For now, we'll put the database in a class to clean up the file. We hacked a starting project and now need to organize it a bit now that we know it's working. 

I created a file called `db.py` and started building a class.

## Starting the db class

```python
class db:
    def __init__(self,db_name):
        self.db_name = db_name
        self.conn = None

```

from the main file, we'll be providing a name for the database and an empty connector when we instantiate it.

## Connecting and disconnecting

We'll add a few functions for connecting to the database and closing the connection when we're done with all of our queries. I'm checking if `conn` is `None` to make sure we're not getting errors on nonexistent connections. 


```python
def connect(self):
    self.conn = duckdb.connect(self.db_name)
    return 0

def disconnect(self):
    if self.conn != None:
        self.conn.close()
        self.conn = None
        return 1
    else:
        print("Database connector is none.")
        return 1
```

## Dropping da tables

Since I'm inserting so many few records, I'm currently deleting and recreating the database along with the sequences. Once I dive into how to prevent duplicate insertions, this won't be needed but for now this works. DuckDB takes less than a second to do all the work. We'll put all the statements in a string array and execute them with list comprehension. 

```python
def drop_tables(self):
    if self.conn == None:
        print("connector unavailable")
        return 1
    drop_credit_sequence = "DROP SEQUENCE IF EXISTS credit_id_seq"
    drop_checking_sequence = "DROP SEQUENCE IF EXISTS checking_id_seq"
    drop_checking = "DROP TABLE if exists Checking"
    drop_credit = "DROP TABLE if exists Credit"
    drops = [drop_credit_sequence, drop_checking_sequence, drop_checking, drop_credit]
    [self.conn.execute(i) for i in drops]
    return 0
```

## Creating the tables and sequences

We'll create all of the tables and similarly to the drop table function, We'll have the create statements and run them in order from the array. 

```python
def create_tables(self):
    if self.conn == None:
        print("empty connector, run connect()")
        return 1
    credit_sequence = "CREATE SEQUENCE IF NOT EXISTS credit_id_seq START WITH 1 INCREMENT BY 1;"
    checking_sequence = "CREATE SEQUENCE IF NOT EXISTS checking_id_seq START WITH 1 INCREMENT BY 1;"
    credit_stmt = """
    CREATE TABLE Credit (
        id INTEGER PRIMARY KEY DEFAULT nextval('credit_id_seq'),
        statement_date DATE NOT NULL,
        description VARCHAR(255),
        amount DECIMAL(15,2) NOT NULL,
        category VARCHAR(100) NOT NULL,
        card VARCHAR(10) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """
    checking_stmt = """
    CREATE TABLE Checking (
        id INTEGER PRIMARY KEY DEFAULT nextval('checking_id_seq'),
        details VARCHAR(10) NOT NULL,
        posting_date DATE NOT NULL,
        description VARCHAR(255),
        amount DECIMAL(15,2) NOT NULL,
        type VARCHAR(20) NOT NULL,
        remaining_balance DECIMAL(15,2) NOT NULL

    )
    """
    statements = [credit_sequence,checking_sequence, credit_stmt, checking_stmt]
    [self.conn.execute(i) for i in statements]
    return 0
```

## inserting the data

To top off the database class, we'll create an `insert_to_credit` function that will take the pandas dataframe we create from reading the functions 

```python
def insert_to_credit(self, cc_data, card):
    if self.conn == None:
        print("empty db connector")
        return 1
    if len(cc_data) > 0:
        for index, row in cc_data.iterrows():
            self.conn.execute(f"INSERT INTO Credit(statement_date, description, category, amount, card) VALUES (?,?,?,?,?)", (row["statement_date"], row["description"], row["category"], row["amount"],card))
        return 0
    else:
        print("Empty dataframe!")
        return 1
```

And that's it! We migrated all of the database logic into it's own class for compartmentalization. We can test it and run it. I'm going to call my object `ducky`. 

```python
ducky = db("mydb.duckdb")
ducky.connect()
#...logic for creating the dataframes
ducky.drop_tables()
ducky.create_tables()
ducky.insert_to_credit(cc_pd, "free")
ducky.disconnect()
```

The code is looking a lot cleaner and we'll proceed with putting the credit card logic in it's own class as well. We'll follow up from the previous post where we saw the duplicate logic. 
