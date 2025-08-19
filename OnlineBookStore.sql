--- Create Database ---
CREATE DATABASE OnlineBookstore;

--- Create Tables ---
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
SELECT * FROM Books;


DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
SELECT * FROM Customers;


DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
SELECT * FROM Orders;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

/*
Data imported using pgAdmin's Import/Export tool:
- Books.csv into 'books' table
- Customers.csv into 'customers' table
- Orders.csv into 'orders' table
Settings: CSV format, comma delimiter, header row included
*/

-- 1) Retrieve all books in the "Fiction" genre:
Select * From Books 
Where Genre='Fiction';

-- 2) Find books published after the year 1950:
Select * From Books 
Where Published_year>1950;

-- 3) List all customers from the Canada:
Select * From Customers 
Where country='Canada';

-- 4) Show orders placed in November 2023:
Select * From Orders 
Where order_date Between '2023-11-01' And '2023-11-30';

-- 5) Retrieve the total stock of books available:
Select Sum(stock) As Total_Stock
From Books;

-- 6) Find the details of the most expensive book:
Select * From Books Order By Price Desc 
Limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
Select c.customer_id , c.name, o.quantity,o.total_amount
From Customers c
inner join Orders o 
On c.customer_id=o.customer_id
where o.quantity >1 ;

-- 8) Retrieve all orders where the total amount exceeds $20:
Select * From Orders 
Where total_amount > 20;

-- 9) List all genres available in the Books table:
Select Distinct genre From Books;

-- 10) Find the book with the lowest stock:
Select * From Books Order By stock Asc 
Limit 1;

-- 11) Calculate the total revenue generated from all orders:
Select sum(total_amount) As Total_Revenue 
From Orders;

-- 12) Retrieve the total number of books sold for each genre:
Select b.Genre, Sum(o.Quantity) As Total_Books_Sold
From Orders o
Join Books b On o.book_id = b.book_id
Group By b.Genre;

-- 13) Find the average price of books in the "Fantasy" genre:
Select avg(price) As Average_Price
From Books
Where genre ='Fantasy';

-- 14) List customers who have placed at least 2 orders:
Select c.name ,o.quantity 
From Customers c 
Inner Join Orders o On C.Customer_id=o.Customer_id 
Where o.quantity >=2;

-- 15) Find the most frequently ordered book:
Select o.book_id, b.title ,count(o.order_id) As ORDER_COUNT 
From orders o
Join books b On b.book_id=o.book_id
group by o.book_id, b.title
Order By count(o.order_id) Desc 
Limit 1;

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
Select * From Books
Where genre='Fantasy'
Order By Price Desc 
Limit 3;

-- 17) Retrieve the total quantity of books sold by each author:
Select b.author , sum(o.quantity) As Total_Books_Sold
From Books b 
Inner Join Orders o On b.book_id=o.book_id
Group By b.author;

-- 18) List the cities where customers who spent over $30 are located:
Select Distinct c.city, o.total_amount
From orders o
Join customers c On o.customer_id=c.customer_id
Where o.total_amount > 30;

-- 19) Find the customer who spent the most on orders:
Select c.customer_id ,c.name ,sum(o.total_amount) As Total_Spent
From Orders o
Join customers c On o.Customer_id=c.Customer_id  
Group By c.customer_id ,c.name
Order By Total_Spent Desc 
Limit 1;

--20) Calculate the stock remaining after fulfilling all orders:
Select b.book_id, b.title, b.stock, Coalesce(Sum(o.quantity),0) As Order_quantity,  
	b.stock- Coalesce(Sum(o.quantity),0) As Remaining_Quantity
From books b
Left Join orders o On b.book_id=o.book_id
Group By b.book_id Order By b.book_id;

