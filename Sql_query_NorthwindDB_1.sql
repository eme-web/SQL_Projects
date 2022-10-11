
--Database Used [Northwind]
use Northwind;

--Products with “queso” in ProductName
select * from dbo.products;
select ProductID, productName from dbo.Products
where ProductName LIKE '%queso%';


-- Orders shipping to France or Belgium
SELECT * FROM  dbo.Orders;
select OrderID, CustomerID, ShipCountry from dbo.Orders
where ShipCountry = 'France' or ShipCountry = 'Belgium';

--Alternate solution
select
OrderID, CustomerID, OrderDate, ShipCountry
from dbo.Orders
where ShipCountry in ('France','Belgium');

-- Using Order by
select FirstName, LastName, Title, BirthDate 
from dbo.Employees
 order by BirthDate; 

 --Conveerting date from timestamp to Date
 select FirstName, LastName, Title, cast(BirthDate AS DATE)
from dbo.Employees
 order by BirthDate;

 -- combining two columns using CONCAT
 select FirstName, LastName, CONCAT(FirstName, ' ' ,LastName) AS FullName
 from dbo.Employees;

 -- Using Arithmetic Operator 
 select OrderID, ProductID, UnitPrice, Quantity, TotalPrice = (UnitPrice * Quantity)
 from [Order Details]
 Order by OrderID, ProductID;


 -- using count fxn
 select count(CustomerID) as TotalCustomers
 from dbo.Customers;

 -- When was the first order?
 select min(OrderDate) as FisrtOrder
 from dbo.Orders;

 -- show countries where there are Customers
 select Distinct(Country) as Country
 from dbo.Customers
 group by Country;

 
 --Contact titles for customers
 select * from dbo.Customers;
 select Distinct(ContactTitle), count(ContactTitle) as TotalContactTitle
 from dbo.Customers
 group by ContactTitle;

  --  Products with associated supplier names
 select ProductID, ProductName, CompanyName
 from dbo.Products
 join dbo.Suppliers 
 on Products.SupplierID = dbo.Suppliers.SupplierID;


 --Orders and the Shipper that was used
 select  OrderID, cast(OrderDate as Date) AS OrderDate, CompanyName
 from dbo.Orders
 join dbo.Shippers
 on dbo.Orders.ShipVia = dbo.Shippers.ShipperID
 where OrderID < 10300;


-- Show the different Categories and the total products in each category
select * from dbo.Products;
select * from dbo.Categories;
select CategoryName, count(ProductID) as TotalProducts
from dbo.Categories
join dbo.Products
on dbo.Categories.CategoryID = dbo.Products.CategoryID
group by CategoryName
order by TotalProducts desc;


--Total customers per country/city
select Country, City, count(*) as TotalCustomers
from dbo.Customers
group by Country, City
order by count(*)desc;


--Products that need reordering 
select ProductID, ProductName, UnitsInStock, ReorderLevel
from dbo.Products
where UnitsInStock < ReorderLevel
order by ProductID;


--Products that need reordering Contd
select ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from dbo.Products
where UnitsInStock + UnitsOnOrder <= ReorderLevel
and Discontinued = 0
order by ProductID;


--Customer list by region
select CustomerID, CompanyName,Region
from dbo.Customers
order by 
case 
	when Region is null then 1
	else 0 
	End 
	,region, CustomerID;


--High freight charges
select Top 3 ShipCountry,
AverageFrieght = Avg(Freight)
from dbo.Orders
Group by ShipCountry
order by AverageFrieght desc;


--High freight charges - 2015
select Top 3 ShipCountry, AverageFreight = avg(Freight)
from Orders
where 
	OrderDate  >= '20150101'
    and OrderDate < '20160101'
Group by  ShipCountry
Order by AverageFreight desc;


-- High freight charges - last year
select Top (3) ShipCountry, 
AverageFreight = Avg(freight)
from orders 
where 
	OrderDate >= Dateadd(yy, -1,(select max(OrderDate) from Orders))
Group by ShipCountry
order by AverageFreight desc;




-- Inventory List showing information like EmployeeID, LastName, OrderID,ProductName, Quantity for all orders
-- sort by OrderID and ProductID.

select Employees.EmployeeID, Employees.LastName,
Orders.OrderID, Products.ProductName,
[Order Details].Quantity
from dbo.Employees
join dbo.Orders 
on Orders.EmployeeID = Employees.EmployeeID
join dbo.[Order Details]
on [Order Details].OrderID = Orders.OrderID
join dbo.Products
on Products.ProductID = [Order Details].ProductID
order by 
Orders.OrderID,
Products.ProductID

--Customers with no Orders
select Customer_CustomerID = Customers.CustomerID,
Orders_CustomerID = Orders.CustomerID
from dbo.Customers
	left join Orders
	on Orders.CustomerID = Customers.CustomerID
where Orders.CustomerID is null;


-- Customers with no Orders for EmployeeID 4
select Customers.CustomerID,
Orders.CustomerID
from dbo.Customers
	left join Orders
	on Orders.CustomerID = Customers.CustomerID
	and Orders.EmployeeID = 4
where Orders.CustomerID is null;

