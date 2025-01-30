+++
title = "Expense Tracker Pt. 5"
date = "2025-01-30T10:50:04-06:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Dev", "Python", "DuckDB", "Pandas"]
+++

# Class everything 

Continuing from the [previous post](./expense-tracker-pt4.md), we will put the credit card code in it's own class to follow the pattern for the database interface. I'm excited about this one as one can get creative when refactoring. 

Let's start the class definition. I'll be taking the codename of the card for the database, the string of the filepath and the company that the credit card belongs to. I currently have `chase` and `amex`

```python

class CreditCard:
    def __init__(self, card, fileName, company):
        self.card = card
        self.fn = fileName
        self.company = company
        self.cc_data = pd.DataFrame()
```

## Common functions

Let's take a closer look at the two reading functions I defined. 

```python
def read_amex(fileName):
    csv = pd.read_csv(fileName)
    new_column = {"Date":"statement_date","Description":"description","Category":"sub_category","Amount":"amount"}
    filtered_csv = csv[["Date", "Description", "Amount", "Category"]].copy()
    filtered_csv.rename(columns=new_column, inplace=True)
    filtered_csv["category"] = filtered_csv["sub_category"].str.extract(r"(.+)-")
    filtered_csv.loc[:, "sub_category"] = filtered_csv["sub_category"].str.replace(".+-","", regex=True)
    filtered_csv['statement_date'] = pd.to_datetime(filtered_csv['statement_date'],format="%m/%d/%Y")
    filtered_csv['statement_date'] = filtered_csv['statement_date'].dt.strftime('%Y-%m-%d')
    return filtered_csv

def read_chase_cc(fileName):
    csv = pd.read_csv(fileName)
    new_column = {"Post Date":"statement_date", "Description":"description", "Category":"category", "Amount":"amount"}
    filtered_csv = csv[["Post Date", "Description", "Amount", "Category"]].copy()
    filtered_csv.rename(columns=new_column, inplace=True)
    filtered_csv['statement_date'] = pd.to_datetime(filtered_csv['statement_date'],format="%m/%d/%Y")
    filtered_csv['statement_date'] = filtered_csv['statement_date'].dt.strftime('%Y-%m-%d')
    filtered_csv['amount'] = filtered_csv["amount"]*-1
    filtered_csv["sub_category"]="nan"
    return filtered_csv
```


Everything is the same except for four lines. `new_column` contains a map of the renamed columns. `filtered_csv` makes a copy of the existing csv headers for renaming and only for Chase, we are flipping the amount to keep it consistent. We can create a dictionary of string and dictionaries for the headers. Secondly we can create a dict of strings to string arrays for renaming the columns after reading the file. I'm going to create the dicts at the top of the file. We also have some regex going to get the right side of Amex's Category data. 

```python
card_columns = {"amex": {"Date":"statement_date","Description":"description","Category":"category","Amount":"amount"},
                 "chase":{"Post Date":"statement_date", "Description":"description", "Category":"category", "Amount":"amount"}}
card_mappings = {"amex": ["Date", "Description", "Amount", "Category"],
                 "chase": ["Post Date", "Description", "Amount", "Category"]}
```

Now we can create a single read function for any file as long we have a mapping defined to it. We check the company of the CreditCard to see if it needs either regex or amount flipping. `filtered_csv` and the rename function will use the map by it's company key. 


```python
def read_file(self):
    csv = pd.read_csv(self.fn)
    filtered_csv = csv[card_mappings[self.company]].copy()
    filtered_csv.rename(columns=card_columns[self.company], inplace=True)
    if self.company == "amex":
        filtered_csv["category"] = filtered_csv["category"].str.replace(".+-","",regex=True)
    elif self.company == "chase":
        filtered_csv['amount'] = filtered_csv["amount"]*-1
    else:
        print("something went wrong with company name, aborting")
        return 1
    filtered_csv['statement_date'] = pd.to_datetime(filtered_csv['statement_date'],format="%m/%d/%Y")
    filtered_csv['statement_date'] = filtered_csv['statement_date'].dt.strftime('%Y-%m-%d')
    self.cc_data = filtered_csv
    return 0
```

## Moving everything to it's own file

Now that we have a credit card class we can now keep `main.py` as...`main.py`. I'll move the class to it's own file and import everything to handle functionality. For the class, I could use a wrapper function that inserts into the database but we'll keep it seperate for now. 


Now we can have a small main file. 

```python
from CreditCard import CreditCard
from db import db
def main():
    ducky = db("mydb.duckdb")
    ducky.connect()
    ducky.drop_tables()
    ducky.create_tables()
    fake = CreditCard("fake", "fakedata/fake_amex.csv", "amex")
    fake.read_file()
    print(fake.cc_data)
    ducky.insert_to_credit(fake.cc_data, fake.card)
    return 0
if __name__ == "__main__":
    main()
```

We can run this and we'll have the fake data again. 

```
D select * from Credit
  ;
┌───────┬────────────────┬────────────────────────────────┬───────────────┬─────────────────────┬─────────┬─────────────────────────┐
│  id   │ statement_date │          description           │    amount     │      category       │  card   │       created_at        │
│ int32 │      date      │            varchar             │ decimal(15,2) │       varchar       │ varchar │        timestamp        │
├───────┼────────────────┼────────────────────────────────┼───────────────┼─────────────────────┼─────────┼─────────────────────────┤
│     1 │ 1977-04-08     │ Wiggins and Sons               │       3738.90 │ Fuel                │ fake    │ 2025-01-30 11:25:42.97  │
│     2 │ 1979-12-28     │ Larson, Mcintyre and Williams  │       3915.99 │ Computer Supplies   │ fake    │ 2025-01-30 11:25:42.971 │
│     3 │ 1995-03-02     │ Bolton Ltd                     │        877.08 │ Book Stores         │ fake    │ 2025-01-30 11:25:42.971 │
│     4 │ 2002-08-04     │ Nelson, Davis and Smith        │      -4629.24 │ Office Supplies     │ fake    │ 2025-01-30 11:25:42.971 │
│     5 │ 1985-11-13     │ Tran-Dean                      │      -2188.84 │ General Retail      │ fake    │ 2025-01-30 11:25:42.972 │
│     6 │ 2009-12-24     │ Herring Group                  │         12.07 │ General Attractions │ fake    │ 2025-01-30 11:25:42.972 │
│     7 │ 1979-11-25     │ Hunt, Moore and Taylor         │       3617.31 │ Miscellaneous       │ fake    │ 2025-01-30 11:25:42.972 │
│     8 │ 1998-12-14     │ Rose, Nguyen and Rojas         │        535.19 │ Other Services      │ fake    │ 2025-01-30 11:25:42.972 │
│     9 │ 2011-11-12     │ Gentry Group                   │      -2040.82 │ Department Stores   │ fake    │ 2025-01-30 11:25:42.973 │
│    10 │ 1974-12-13     │ Johnson-Davis                  │      -3592.03 │ Parking Charges     │ fake    │ 2025-01-30 11:25:42.973 │
│    11 │ 1985-08-17     │ Andersen, Woods and Valenzuela │       4324.99 │ Book Stores         │ fake    │ 2025-01-30 11:25:42.973 │
│    12 │ 2018-08-27     │ Contreras, Velasquez and Moore │       3849.47 │ Department Stores   │ fake    │ 2025-01-30 11:25:42.974 │
│    13 │ 1988-05-08     │ French, Myers and Fox          │       -957.94 │ Other Telecom       │ fake    │ 2025-01-30 11:25:42.974 │
│    14 │ 2008-06-30     │ Cummings-Walker                │       3594.99 │ Computer Supplies   │ fake    │ 2025-01-30 11:25:42.974 │
│    15 │ 1995-09-18     │ Cabrera-Stanley                │       4805.67 │ Other Services      │ fake    │ 2025-01-30 11:25:42.974 │
│    16 │ 2022-10-25     │ Martin-Johnson                 │       4344.48 │ General Attractions │ fake    │ 2025-01-30 11:25:42.975 │
│    17 │ 2006-11-22     │ Young-Blake                    │       3300.25 │ Department Stores   │ fake    │ 2025-01-30 11:25:42.975 │
│    18 │ 1975-12-31     │ Stone, Hancock and Campbell    │      -3810.37 │ Electronics Stores  │ fake    │ 2025-01-30 11:25:42.975 │
│    19 │ 1992-01-15     │ Blankenship Ltd                │      -3955.90 │ Pharmacies          │ fake    │ 2025-01-30 11:25:42.975 │
│    20 │ 1977-02-07     │ Owen-Nunez                     │        263.28 │ Electronics Stores  │ fake    │ 2025-01-30 11:25:42.976 │
├───────┴────────────────┴────────────────────────────────┴───────────────┴─────────────────────┴─────────┴─────────────────────────┤
│ 20 rows                                                                                                                 7 columns │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

We have now organized everything into classes. It's a lot more readable now and we can extend make more classes for tables, logging and graphing, which are the upcoming plans for this project. I have no problem staring at terminals and queries to get my information but graphs can be really helpful once we have a pattern of the queries we want to make. 

Stay tuned for more!

Repo link: {{<link href="https://github.com/jorge-sepulveda/py-expenses">}}https://github.com/jorge-sepulveda/py-expenses{{</link>}}
