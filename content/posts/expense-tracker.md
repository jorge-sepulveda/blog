+++
title = "Expense Tracker Design"
date = "2025-01-26T23:48:00-06:00"
tags = ["Python", "DuckDB", "Dev", "Pandas"]
+++

# Let's design some budgeting software

One funny thing about me is that I love credit cards and no, not in the irresponsible way of racking them up. I like gathering as many points as I can for use of flights and hotels. Problem here is that now I have several credit cards amongst multiple companies. All of these companies have websites to navigate the data but it's impractical to go through all the sites.

I could use some software like quicken or any existing service that connects to my bank accounts for tracking but given how many data breaches are out there, I don't feel comfortable using those connectors. 

Since I'm being insufferable with the amount of convenience out there, I decided to build my own expense tracker software. I can download the statement CSV's and put them in a database that I and only I control. A decision like this is big because so many mistakes can be made along the way but if we design it right from the start, no issues can arise(or at least, I hope so.)

## Requirements

I want to build something that can take my CSV's and load them into a database. This would include preprocessing the data to prepare it for table insertions. Once the data is inserted, I can use visualization libraries to check things like monthly spending across all my cards and make budgeting decisions from there. I also want to see if I can faciliate the process of inserting data every time I get a statement. 

## Technologies

### Language and Libraries
Our champion for this great task will be Python. I've been using that the longest and Pandas is really really good at reading CSV's. Preprocessing can be done and it will faciliate inserting into a database.

### Database
I thought about using Docker for a database but wanna see if I can keep it...lite. From here I looked into sqlite but my wife told me about about DuckDB, a really fast, little to no dependency DBMS that is tuned for analytical processing. After all the data is loaded, I'll be inserting data once a month and reading a lot more. Best of all, it can be installed with Pip. 

### API
This may be a bit much, but building an API to take my csv file for parsing may prove useful. This can extend to even running a simple website once I have ideas of what graphs to display. 

## Table design

We'll use the CSV's to drive table design. American Express provides CSV's with the following columns. 

`Date,Description,Card Member,Account #,Amount,Extended Details,Appears On Your Statement As,Address,City/State,Zip Code,Country,Reference,Category`

I don't need all of these, so pandas will let me pick and use Date, Description, Amount, and Category. 

Date is well, the date I swiped the card. Description is going to be the business or service I used. Amount is a USD value with two decimals and Category is going to be either restaurants, groceries or online shopping for a few examples. 

With this in mind, I want to have two tables. One for credit card transactions and one for my Checking account. I can correlate statement payments back to Checking and come up with more read queries as I go. Here's the initial table design for Credit. 

```
CREATE TABLE Credit (
    id INTEGER PRIMARY KEY DEFAULT nextval('credit_id_seq'),
    statement_date DATE NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(15,2) NOT NULL,
    category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100),
    card VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Primary key

The primary key will be an incrementing integer called a sequence in DuckDB. I tried using the data for composite keys but want to keep the dataset small. The biggest contender would be the amount and date because there doesn't exist a chance in which I'll go back into a gas station and buy the same water bottle on the same day. 

This seemed great but realized that my wife and I's gym payments are both the same amount and on the same day. Incrementing keys are simple good enough for me. 

## Privacy is key

Once I support all my banks statements and get the preprocessing down, I'll share the source code. I'll also include fake statements that are structured the same way as banks have them. My primary reason for doing this is control of my own data and a challenge of database design and engineering. Something as rich as bank statements are bound to be a fun way to process. 


## Conclusion

We've made an initial design of what the software should do. The following posts will be about parsing the statements for the database!. 
