+++
title = "Expense Tracker Pt. 6"
date = "2025-01-31T12:14:09-06:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Dev", "Python", "DuckDB", "Pandas"]
slug = "expense-tracker-pt6"
+++

# Reading Chase files into a new class

Time to continue the quest of managing bank data and reaching for the dream of good, private and fast budgeting. Following the pattern from earlier we'll create a `Checking` class. This data is structured similarly to the previous ones except with a missing category and the amounts for money coming in is positive and money coming out is negative. We defined transactions going on credit cards as positive and payments as negative. This is the other way around and we'll keep it that way for now as it conceptually makes sense(money is weird). We'll also establish column mappings to keep it consistent and pave the the way for other banks. 

```python
import pandas as pd
from io import StringIO
account_columns = {"chase":{"Posting Date":"posting_date", "Description":"description", "Type":"type", "Amount":"amount", "Balance":"remaining_balance"}}
account_mappings = { "chase": ["Posting Date", "Description", "Amount", "Type", "Balance"]}
class Checking:
    def __init__(self, filePath, company):
        self.fp = filePath
        self.company = company
        self.c_data = pd.DataFrame
```

## Oopsie on the CSV's

Reading the Checking data had a hiccup. Upon reading the file, I had a few extra columns than needed and the data was in the wrong columns, messing up my formatting. Upon throwing the entire kitchen sink of pandas delimiters and quotechars, I looked at the CSV file one more time and realized THERE WAS AN EXTRA COMMA AT THE END!. Chase, if you are reading this, you seem to generate an extra comma in your CSV's while exporting yearly data. I'll see if this happens with regular statements but for now, I'll just fix it myself. 

## Preprocess before the real preprocessing

Now that we know the issue, we can read the file and strip the last comma. 

```python
    def read_file(self):

        # Read the file and clean it in memory
        with open(self.fp, "r") as infile:
            cleaned_lines = [line.rstrip(",\n") + "\n" for line in infile]
```

Now we can either save the file as a csv or read it in memory. I'd prefer to do the latter to avoid file creation on every statement. Since it's a string we have to use StringIO to prepare the file-like object for pandas' `read_csv`

```python
cleaned_data = "\n".join(cleaned_lines)
cleaned_file = StringIO(cleaned_data)
```

Once that is complete, we're cooking. We can parse the files the same as credit cards.

```python
csv = pd.read_csv(self.fp)
print(csv["Posting Date"])
print(csv.columns)
filtered_csv = csv[account_mappings[self.company]].copy()
print(filtered_csv)
filtered_csv.rename(columns=account_columns[self.company], inplace=True)
filtered_csv['posting_date'] = pd.to_datetime(filtered_csv['posting_date'],format="%m/%d/%Y")
filtered_csv['posting_date'] = filtered_csv['posting_date'].dt.strftime('%Y-%m-%d')
print(filtered_csv)
self.c_data = filtered_csv
```

I went back to `db.py` and created an insert function. 

```python
def insert_to_checking(self,checking_data):
    if self.conn == None:
        print("empty db connector")
        return 1
    if len(checking_data) > 0:
        for index, row in checking_data.iterrows():
            self.conn.execute(f"INSERT INTO Checking(posting_date, description, type, amount, remaining_balance) VALUES (?,?,?,?,?)", (row["posting_date"], row["description"], row["type"], row["amount"], row["remaining_balance"]))
        return 0
    else:
        print("Empty dataframe!")
        return 1
```

To top it off, we'll use `main.py` to create it and we're good to go!

```python
ducky = db("mydb.duckdb")
ducky.connect()
ducky.drop_tables()
ducky.create_tables()
chase = Checking("../stmts/Chase/Checking/2024.CSV", "chase")
chase.read_file()
ducky.insert_to_checking(chase.c_data)
ducky.disconnect()
```

Done, I now have checking data and credit card data loaded in DuckDB and I can query my files. Looking into the table now, I can get away with making a composite key with `remaining_balance`. There will never be a 0.0 charge on the card and the odds of hitting the same balance again is very low. If you ever do see a 0 cent charge, email me but call your bank first!

Repo link: {{<link href="https://github.com/jorge-sepulveda/py-expenses">}}https://github.com/jorge-sepulveda/py-expenses{{</link>}}
