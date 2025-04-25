+++
title = "Expense Tracker Pt. 2"
date = "2025-01-27T22:42:47-06:00" 
tags = ["Dev", "Python", "Pandas", "DuckDB"]
slug = "expense-tracker-pt2"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
+++

# Parsing AMEX CSV's and loading them into DuckDB

In my [previous post](./expense-tracker.md) I laid out the design for an expense tracker in Python. It's time to start hacking and I'll preprocess the CSV's that Amex so graciously provides. 

After initializing the repo with Git we'll install the necessary packages. Always use a virtual environment! I one time broke my python version with unmanaged packages and it took a hot minute to get it back going. 

```python
python -m venv venv
source venv/bin/activate
pip install pandas
pip install duckdb
```

We'll initialize the connector for the database. DuckDB will find the file or it will create the file if it's not found and connect to it. 

Now, one thing that DuckDB does different is auto incrementing keys as we are so familiar with in SQL. DuckDB does Sequences where you can set a number and increment it by a certain amount. We'll create the sequence, add it as a column for the record ID and then any insertions will just count this sequence. 

We'll use the same columns I defined in the previous post. I also added a `card` column to know which card the transaction is from. I'm using `blue` and `free` as some codenames for my cards so it can be whatever you want in 10 characters. 

```python
conn = duckdb.connect("mydb.duckdb")
conn.execute("CREATE SEQUENCE IF NOT EXISTS credit_id_seq START WITH 1 INCREMENT BY 1;")
table_stmt = """
CREATE TABLE Credit (
    id INTEGER PRIMARY KEY DEFAULT nextval('credit_id_seq'),
    statement_date DATE NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(15,2) NOT NULL,
    category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100),
    card VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)"""
conn.execute(table)
```

We have now created a table! Let's get some data in here. I have downloaded my 2024 and 2023 data from my American Express credit cards as CSV's and Pandas will do some heavy lifting. Afterwards we will extract the columns into a seperate DataFrame.

```python
csv = pd.read_csv("path/to/amex.csv")
filtered_csv = csv[["Date", "Description", "Amount", "Category"]].copy()
```

We now have less data and we gotta clean up the data we have a little, starting with the columns. For better readability in the code, I want to rename these to the column names for the table. We can create a dict of strings for the name of the existing DataFrame column and the name of the table column. 

```python
new_column = {"Date":"statement_date","Description":"description","Category":"sub_category","Amount":"amount"}
filtered_csv.rename(columns=new_column, inplace=True)
```

Now to fix category and sub-category. Amex does it a little differently in which it seems to have a broad category and a more specific one in the same line. 

`Communications-Cable & Internet Comm`

I designed the table around this for now. Left of the hyphen will go into `category` and the right side will be `sub_category`. I can use regex on these columns to clean it up. 

```python
filtered_csv["category"] = filtered_csv["sub_category"].str.extract(r"(.+)-")
filtered_csv.loc[:, "sub_category"] = filtered_csv["sub_category"].str.replace(".+-","", regex=True)
```

Finally, we have to clean up the date. Currently Pandas read it in as a string and it's formatted with `MM/DD/YYYY`. We'll convert the column to a datetime series and format it with `YYYY-MM-DD` for DuckDB.

```python
filtered_csv['statement_date'] = pd.to_datetime(filtered_csv['statement_date'],format="%m/%d/%Y")
filtered_csv['statement_date'] = filtered_csv['statement_date'].dt.strftime('%Y-%m-%d')
```

Now that the data is preprocessed, we can proceed with loading it into a database. Prepared statements can take care of this nicely and it keeps it looking readable. 

```python
for index, row in df.iterrows():
    conn.execute(f"INSERT INTO Credit(statement_date, description, category, sub_category, amount, card) VALUES (?,?,?,?,?,?)", 
    (row["statement_date"], row["description"], row["category"], row["sub_category"], row["amount"],card))
```

And we're done! We have parsed the CSV and loaded it into the database. If you install duckdb in your system you can connect to it and write queries with `duckdb mydb.duckdb`.

Next we'll create CSV's for chase statements and we'll make a table for the checking account. 
