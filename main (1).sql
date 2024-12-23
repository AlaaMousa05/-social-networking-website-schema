CREATE TABLE Users (
    login VARCHAR(255) PRIMARY KEY,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    description  CLOB,
    dateJoined DATE NOT NULL
);

CREATE TABLE Links (
    userr VARCHAR(255),
    linkNo Number(25,0),
    link CLOB,
    PRIMARY KEY (userr, linkNo),
    FOREIGN KEY (userr) REFERENCES Users(login)
);

CREATE TABLE Entries (
    entryId Number(25,0) PRIMARY KEY,
    userr VARCHAR(255) NOT NULL ,
    time DATE  NOT NULL,
    FOREIGN KEY (userr) REFERENCES Users(login)
);

CREATE TABLE Comments (
    entry Number(25,0),
    parentEntry Number(25,0),
    rootEntry Number(25,0),
    text CLOB NOT NULL,
    PRIMARY KEY (entry),
    FOREIGN KEY (entry) REFERENCES Entries(entryId),
    FOREIGN KEY (parentEntry) REFERENCES Entries(entryId),
    FOREIGN KEY (rootEntry) REFERENCES Entries(entryId)
);

CREATE TABLE Images (
    entry Number(25,0),
    caption CLOB,
    image BLOB,
    PRIMARY KEY (entry,image),
    FOREIGN KEY (entry) REFERENCES Entries(entryId)
);

CREATE TABLE Blurbs (
    entry Number(25,0),
    text CLOB NOT NULL,
    PRIMARY KEY (entry,text),
    FOREIGN KEY (entry) REFERENCES Entries(entryId)
);

CREATE TABLE Friends (
    userr VARCHAR(255),
    friend VARCHAR(255),
    sinceDate DATE NOT NULL,
    PRIMARY KEY (userr, friend),
    FOREIGN KEY (userr) REFERENCES Users(login),
    FOREIGN KEY (friend) REFERENCES Users(login)
);

-- Insert Users
INSERT INTO Users (login, firstName, lastName, password, description, dateJoined)
VALUES 
('adnan99', 'Adnan', 'mousa', '200111', 'Loves programming', '2022-01-15'),
('Yazeed33', 'Yazeed', 'sleat', '2000333', 'Enjoys photography', '2021-08-21'),
('khaled789', 'Khaled', 'Zaid', '2000444', 'Hobbies: Traveling', '2023-05-30'),
('nour321', 'Nour', 'Abu-Laila', '2008899', 'Tech enthusiast', '2024-02-10');

-- Insert Links
INSERT INTO Links (userr, linkNo, link)
VALUES 
('adnan99', 1, 'http://adnan.com'),
('adnan99', 2, 'http://adnan.tech'),
('Yazeed33', 1, 'http://yazed.com'),
('nour321', 1, 'http://nourtech.com');

-- Insert Entries
INSERT INTO Entries (entryId, userr, time)
VALUES 
(1, 'adnan99', '2024-12-01'),
(2, 'Yazeed33', '2024-12-02'),
(3, 'adnan99', '2024-12-03'),
(4, 'nour321', '2024-12-04');

-- Insert Comments
INSERT INTO Comments (entry, parentEntry, rootEntry, text)
VALUES 
(2, 1, 1, 'Great post!'),
(3, 2, 2, 'Nice work!'),
(4, 1, 1, 'Amazing entry!'),
(1, 3, 3, 'Interesting perspective!');

-- Insert Images
INSERT INTO Images (entry, caption, image)
VALUES 
(1, 'Adnan''s first post', 'image1.jpg'),  
(2, 'Yazeed''s photo', 'image2.jpg'),      
(3, 'Adnan''s second post', 'image3.jpg'), 
(4, 'Nour''s blog post', 'image4.jpg');    

-- Insert Blurbs
INSERT INTO Blurbs (entry, text)
VALUES 
(1, 'This is a sample blurp text for Adnan.'),
(2, 'Yazeed shares her photography thoughts.'),
(3, 'Khaled shares his thoughts on travel.'),
(4, 'Nour shares tech tips!');

INSERT INTO Friends (userr, friend, sinceDate) VALUES
('nour321', 'adnan99', '2024-01-01'),
('Yazeed33', 'khaled789', '2024-01-02'),
('khaled789', 'adnan99', '2024-01-03'),
('nour321', 'Yazeed33', '2024-01-04');

-- Q3 
-- 1- Left Outer Join:
SELECT 
    Users.login AS UserLogin,
    Friends.friend AS Friend
FROM 
    Users
LEFT OUTER JOIN 
    Friends ON Users.login = Friends.userr;

-- 2- Right Outer Join:
SELECT 
    Users.login AS UserLogin,
    Friends.friend AS Friend
FROM 
    Users
RIGHT OUTER JOIN 
    Friends ON Users.login = Friends.friend;

-- 3- Full Outer Join:
SELECT  
    U.login AS UserLogin, 
    U.firstName,  
    U.lastName,
    F.friend AS Friend,
    F.sinceDate
FROM   
    Users U FULL OUTER JOIN    Friends F ON Users.login = Friends.userr;



-- Q4 SQL to retrieve the names of users who have posted comments on entries made by their friends. Use a subquery to identify the entries created by each user's frinds

SELECT
    u.userr AS UserName,
    f.friend AS FriendName,
    t.text AS CommentText
FROM Friends f
JOIN Entries e ON f.friend = e.userr  
JOIN Comments t ON e.entryId= t.parentEntry 
JOIN Entries u ON t.entry = u.entryId
WHERE  u.userr = f.userr;
    
-- Q5  SQL query to display the users and the number of friends for each user. 

SELECT 
    u.login AS UserLogin,
    u.firstName AS FirstName,
    COUNT(f.friend) AS FriendCount
FROM 
    Users u
LEFT JOIN 
    Friends f ON u.login = f.userr  
    OR u.login = f.friend           
GROUP BY 
    u.login, u.firstName ;

