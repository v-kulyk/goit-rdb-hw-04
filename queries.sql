-- Create database
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

-- Create authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- Create genres table
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

-- Create books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publication_year YEAR,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Create users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Create borrowed_books table
CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

# 2. Заповніть таблиці простими видуманими тестовими даними. Достатньо одного-двох рядків у кожну таблицю.
INSERT INTO authors (author_name) VALUES 
('Іван Франко'),
('Леся Українка');

INSERT INTO genres (genre_name) VALUES 
('Поезія'),
('Драма');

INSERT INTO books (title, publication_year, author_id, genre_id) VALUES 
('Великий шум', 1907, 1, 1),
('Лісова пісня', 1911, 2, 2);

INSERT INTO users (username, email) VALUES 
('user1', 'user1@example.com'),
('user2', 'user2@example.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES 
(1, 1, '2024-10-20', '2024-11-20'),
(2, 2, '2024-10-21', '2024-11-21');

#3. Перейдіть до бази даних, з якою працювали у темі 3. Напишіть запит за допомогою операторів FROM та INNER JOIN, 
# що об’єднує всі таблиці даних, які ми завантажили з файлів: 
# order_details, orders, customers, products, categories, employees, shippers, suppliers. Для цього ви маєте знайти спільні ключі.
use mydb;
SELECT
    o.id AS order_id,
    o.date AS order_date,
    c.name AS customer_name,
    c.contact AS customer_contact,
    c.city AS customer_city,
    c.country AS customer_country,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    s.name AS shipper_name,
    s.phone AS shipper_phone,
    p.name AS product_name,
    p.price AS product_price, 
    p.unit AS product_unit,
    od.quantity,
    cat.name AS category_name,
    cat.description AS category_description,
    sup.name AS supplier_name,
    sup.contact AS supplier_contact,
    sup.country AS supplier_country
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id;

#4. Виконайте запити, перелічені нижче.
#4.1 Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).
SELECT
    COUNT(*)
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id;

#4.2 Змініть декілька операторів INNER на LEFT чи RIGHT. Визначте, що відбувається з кількістю рядків. Чому? Напишіть відповідь у текстовому файлі.
SELECT
    COUNT(*) as cnt
FROM
    orders o
    RIGHT JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    RIGHT JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN order_details od ON o.id = od.order_id
    LEFT JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    LEFT JOIN suppliers sup ON p.supplier_id = sup.id;
#Висновок: Стабільна кількість рядків у результаті вказує на те, що набір даних, імовірно, має повну відповідність між таблицями (всі зв'язки є коректними, відсутні "зайві" записи).
#Для порівняння: якби ми використовували LEFT JOIN і в лівій таблиці були записи без відповідників у правій таблиці, результат містив би більше рядків, де відсутні значення були б null.
#Оскільки в завданнях #3 та #4.1 використовується INNER JOIN, заміна його на LEFT чи RIGHT JOIN могла б тільки збільшити кількість рядків у результаті, а не зменшити їх.

#4.3 Оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.
SELECT
    o.id AS order_id,
    o.date AS order_date,
    c.name AS customer_name,
    c.contact AS customer_contact,
    c.city AS customer_city,
    c.country AS customer_country,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    s.name AS shipper_name,
    s.phone AS shipper_phone,
    p.name AS product_name,
    p.price AS product_price, 
    p.unit AS product_unit,
    od.quantity,
    cat.name AS category_name,
    cat.description AS category_description,
    sup.name AS supplier_name,
    sup.contact AS supplier_contact,
    sup.country AS supplier_country
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE
	o.employee_id > 3 AND o.employee_id <= 10;
    
#4.4 Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, середню кількість товару (кількість товару знаходиться в order_details.quantity)
SELECT
    cat.name as cat_name, COUNT(*) as num_rows, AVG(od.quantity) as avg_quantity
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE
	o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name;

#4.5 Відфільтруйте рядки, де середня кількість товару більша за 21.
SELECT
    cat.name as cat_name, COUNT(*) as num_rows, AVG(od.quantity) as avg_quantity
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE
	o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING avg_quantity > 21;

#4.6 Відсортуйте рядки за спаданням кількості рядків.
SELECT
    cat.name as cat_name, COUNT(*) as num_rows, AVG(od.quantity) as avg_quantity
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE
	o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING avg_quantity > 21
ORDER BY num_rows DESC;

#4.7 Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.
SELECT
    cat.name as cat_name, COUNT(*) as num_rows, AVG(od.quantity) as avg_quantity
FROM
    orders o
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN customers c ON o.customer_id = c.id
    INNER JOIN employees e ON o.employee_id = e.employee_id
    INNER JOIN shippers s ON o.shipper_id = s.id
    INNER JOIN products p ON od.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE
	o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING avg_quantity > 21
ORDER BY num_rows DESC
LIMIT 4 OFFSET 1;