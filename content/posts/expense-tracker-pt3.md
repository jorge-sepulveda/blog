+++
title = "Expense Tracker Pt. 3"
date = "2025-01-28T09:57:08-06:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Dev", "Python", "Pandas", "DuckDB", "Faker"]
+++

# Parsing Chase Files and generating fake data

We are back, recapping our [previous post](./expense-tracker-pt2.md) we had preprocessed an American Express CSV fjle and loaded it into DuckDB. Today we'll do the same for Chase credit cards and I'll share how to generate some fake data to properly demo this functionality. 

## Parsing Chase CSV's

I'll bring back all the snippets I used and I put them into a function for easier use.

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
```

We'll be using a lot of this so let's "borrow" some of the code I wrote to write the new function and we'll go over the differences. We'll make note of all the duplicate logic for the future. 

```python
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

for the `new_column` dict, only different thing here is the `Post Date`. The date formatting remains the same and I'm padding `sub_category` with `nan`. First thing to notice here is that I'm padding a column with null data which may present an issue with the columns I have. Once I parse all the CSV files, I'll come back to the table. 

One big thing is that Amex does their charges in positive numbers and payments are negative. Since the majority of my cards are with Amex, I'll stick with format. Chase is flipped so I have to flip the `amount` column. 

```python
    filtered_csv['amount'] = filtered_csv["amount"]*-1
```

### Load into database

Once this file is ready we can load it into the database and end up with all the compiled data.

```python
conn = duckdb.connect("mydb.duckdb")
csv = read_chase_cc("path/to/chase.csv")
card = "free"
for index, row in csv.iterrows():
    conn.execute(f"INSERT INTO Credit(statement_date, description, category, sub_category, amount, card) VALUES (?,?,?,?,?,?)", 
    (row["statement_date"], row["description"], row["category"], row["sub_category"], row["amount"],card))
```

# Faking the data

We have an early functioning prototype. I can connect to the database and do some read queries on the data. FYI, if you are a first time budgeter you'll realize how expensive it is to exist! The plan after this is parsing a few more files and then organizing the code a little. 

Now, I need to create some fake data to properly demonstrate this is behavior. Luckily `faker` can do this. It's a package that can generate fake data specifically for instances like this!

## Faker usage

Let's pip it first

`pip install faker`

and we'll begin importing it into a file I named `fake_data.py` and instantiate.

```python
from faker import Faker
import pandas
import random

fake = Faker()
```

faker can generate fake dates, companies and numbers with fixed decimals. Only thing it can't fake right now is the categories. I grabbed all the unique categories from my CSV's and built an array with that. 

```python
amexCategories = ['Merchandise & Supplies-General Retail',
 'Business Services-Office Supplies',
 'Merchandise & Supplies-Electronics Stores',
 'Merchandise & Supplies-Internet Purchase',
 'Fees & Adjustments-Fees & Adjustments',
 'Communications-Cable & Internet Comm',
 'Merchandise & Supplies-Computer Supplies',
 'Merchandise & Supplies-Mail Order','Transportation-Auto Services',
 'Merchandise & Supplies-Department Stores',
 'Merchandise & Supplies-Furnishing','Business Services-Internet Services',
 'Transportation-Fuel','Restaurant-Restaurant',
 'Business Services-Other Services','Communications-Other Telecom',
 'Merchandise & Supplies-Groceries',
 'Merchandise & Supplies-Wholesale Stores',
 'Merchandise & Supplies-Hardware Supplies',
 'Merchandise & Supplies-Pharmacies','Restaurant-Bar & Café',
 'Merchandise & Supplies-Clothing Stores',
 'Business Services-Mailing & Shipping',
 'Business Services-Professional Services',
 'Transportation-Parking Charges','Entertainment-Associations',
 'Other-Miscellaneous','Merchandise & Supplies-Book Stores',
 'Entertainment-General Attractions','Other-Charities']
```

After that we can build the dictionary using some good ol fashioned list comprehension. 

```python
num_rows = 20

data = {
    "Date" : [fake.date(pattern="%m/%d/%Y") for _ in range(num_rows)],
    "Description": [fake.company() for _ in range(num_rows)],
    "Amount": [round(fake.random.uniform(-5000,5000),2) for _ in range(num_rows)],
    "Category": [random.choice(amexCategories) for _ in range(num_rows)]
}
df = pd.DataFrame(data)
df.to_csv("fake_amex.csv", index=False)
```

Pass this filename into the original script and we now have fake data populated into the database! I can now showcase what duckdb looks like. First we'll go into the database and run some queries. 

`duckdb mydb.duckdb`

```
D select * from Credit;
┌───────┬────────────────┬────────────────────────────────┬───────────────┬────────────────────────┬─────────────────────┬─────────┬─────────────────────────┐
│  id   │ statement_date │          description           │    amount     │        category        │    sub_category     │  card   │       created_at        │
│ int32 │      date      │            varchar             │ decimal(15,2) │        varchar         │       varchar       │ varchar │        timestamp        │
├───────┼────────────────┼────────────────────────────────┼───────────────┼────────────────────────┼─────────────────────┼─────────┼─────────────────────────┤
│     1 │ 1977-04-08     │ Wiggins and Sons               │       3738.90 │ Transportation         │ Fuel                │ fake    │ 2025-01-28 13:14:43.766 │
│     2 │ 1979-12-28     │ Larson, Mcintyre and Williams  │       3915.99 │ Merchandise & Supplies │ Computer Supplies   │ fake    │ 2025-01-28 13:14:43.767 │
│     3 │ 1995-03-02     │ Bolton Ltd                     │        877.08 │ Merchandise & Supplies │ Book Stores         │ fake    │ 2025-01-28 13:14:43.767 │
│     4 │ 2002-08-04     │ Nelson, Davis and Smith        │      -4629.24 │ Business Services      │ Office Supplies     │ fake    │ 2025-01-28 13:14:43.768 │
│     5 │ 1985-11-13     │ Tran-Dean                      │      -2188.84 │ Merchandise & Supplies │ General Retail      │ fake    │ 2025-01-28 13:14:43.768 │
│     6 │ 2009-12-24     │ Herring Group                  │         12.07 │ Entertainment          │ General Attractions │ fake    │ 2025-01-28 13:14:43.768 │
│     7 │ 1979-11-25     │ Hunt, Moore and Taylor         │       3617.31 │ Other                  │ Miscellaneous       │ fake    │ 2025-01-28 13:14:43.768 │
│     8 │ 1998-12-14     │ Rose, Nguyen and Rojas         │        535.19 │ Business Services      │ Other Services      │ fake    │ 2025-01-28 13:14:43.769 │
│     9 │ 2011-11-12     │ Gentry Group                   │      -2040.82 │ Merchandise & Supplies │ Department Stores   │ fake    │ 2025-01-28 13:14:43.769 │
│    10 │ 1974-12-13     │ Johnson-Davis                  │      -3592.03 │ Transportation         │ Parking Charges     │ fake    │ 2025-01-28 13:14:43.77  │
│    11 │ 1985-08-17     │ Andersen, Woods and Valenzuela │       4324.99 │ Merchandise & Supplies │ Book Stores         │ fake    │ 2025-01-28 13:14:43.77  │
│    12 │ 2018-08-27     │ Contreras, Velasquez and Moore │       3849.47 │ Merchandise & Supplies │ Department Stores   │ fake    │ 2025-01-28 13:14:43.77  │
│    13 │ 1988-05-08     │ French, Myers and Fox          │       -957.94 │ Communications         │ Other Telecom       │ fake    │ 2025-01-28 13:14:43.77  │
│    14 │ 2008-06-30     │ Cummings-Walker                │       3594.99 │ Merchandise & Supplies │ Computer Supplies   │ fake    │ 2025-01-28 13:14:43.771 │
│    15 │ 1995-09-18     │ Cabrera-Stanley                │       4805.67 │ Business Services      │ Other Services      │ fake    │ 2025-01-28 13:14:43.771 │
│    16 │ 2022-10-25     │ Martin-Johnson                 │       4344.48 │ Entertainment          │ General Attractions │ fake    │ 2025-01-28 13:14:43.771 │
│    17 │ 2006-11-22     │ Young-Blake                    │       3300.25 │ Merchandise & Supplies │ Department Stores   │ fake    │ 2025-01-28 13:14:43.772 │
│    18 │ 1975-12-31     │ Stone, Hancock and Campbell    │      -3810.37 │ Merchandise & Supplies │ Electronics Stores  │ fake    │ 2025-01-28 13:14:43.772 │
│    19 │ 1992-01-15     │ Blankenship Ltd                │      -3955.90 │ Merchandise & Supplies │ Pharmacies          │ fake    │ 2025-01-28 13:14:43.772 │
│    20 │ 1977-02-07     │ Owen-Nunez                     │        263.28 │ Merchandise & Supplies │ Electronics Stores  │ fake    │ 2025-01-28 13:14:43.772 │
├───────┴────────────────┴────────────────────────────────┴───────────────┴────────────────────────┴─────────────────────┴─────────┴─────────────────────────┤
│ 20 rows                                                                                                                                          8 columns │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

And here it is in all its' glory! We now have chase data coming in and we can generate fake amex data using Faker for maximum privacy. 

## Takeaways 

### Database 

After playing with two categories, I'll redesign the table to have only one category and fill it with the right side. I currently don't have a need a categorize categories and it will make it simpler when adding data that only has a single string for the category. 

### Code

Now that we have two files and we are processing them to have the same column, we can implement classes with functions. Once we start parsing Checking account data, we'll move everything to classes. 


