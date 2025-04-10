create database libraryManagement;

use libraryManagement;

create table publisher(
publisher_PublisherName varchar(20) primary key,
publisher_PublisherAddress varchar(100),
publisher_PublisherPhone varchar(15));

create table borrower(
borrower_CardNo int primary key auto_increment,
borrower_BorrowerName varchar(255),
borrower_BorrowerAddress varchar(255),
borrower_BorrowerPhone varchar(12))auto_increment=100;

create table library_branch(
library_branch_BranchID int primary key auto_increment,
library_branch_BranchName varchar(20),
library_branch_BranchAddress varchar(255));

create table books(
book_BookID int primary key auto_increment,
book_Title varchar(255),
book_PublisherName varchar(255),
foreign key(book_PublisherName) references publisher(publisher_PublisherName))auto_increment=1;

create table authors(
book_authors_AuthorID int primary key auto_increment,
book_authors_BookID int,
book_authors_AuthorName varchar(255),
foreign key(book_authors_BookID) references books(book_BookID))auto_increment=1;

create table loans(
book_loans_LoansID int primary key auto_increment,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut varchar(20),
book_loans_DueDate varchar(20),
foreign key(book_loans_BookID) references books(book_BookID),
foreign key(book_loans_BranchID) references library_branch(library_branch_BranchID),
foreign key(book_loans_CardNo) references borrower(borrower_CardNo))auto_increment=1;


create table book_copies(
book_copies_CopiesID int primary key auto_increment,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key(book_copies_BookID) references books(book_BookID),
foreign key(book_copies_BranchID) references library_branch(library_branch_BranchID))auto_increment=1;


select * from authors;
select * from book_copies;
select * from books;
select * from borrower;
select * from loans;
select * from publisher;
select * from library_branch;

-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select * from books;
select * from library_branch;
select * from book_copies;

select lb.library_branch_branchname, b.book_title, bc.book_copies_no_of_copies
from books as b
join book_copies as bc on b.book_bookid = bc.book_copies_bookid
join library_branch as lb on lb.library_branch_branchid = bc.book_copies_branchid
where library_branch_branchname = 'Sharpstown' and book_Title = 'The Lost Tribe';



select sum(book_copies_No_Of_Copies) as sum
from library_branch as lb
join (select * from books as b
join book_copies as bc
on b.book_BookID=bc.book_copies_BookID) as bb
on lb.library_branch_BranchID=bb.book_copies_BranchID
where book_Title="The Lost Tribe" and library_branch_BranchName="Sharpstown";

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select  b.book_title, sum(bc.book_copies_no_of_copies) as Total
from books as b
join book_copies as bc on b.book_bookid = bc.book_copies_bookid
join library_branch as lb on lb.library_branch_branchid = bc.book_copies_branchid
where book_Title = 'The Lost Tribe';


select sum(book_copies_No_Of_Copies) as sum
from library_branch as lb
join (select * from books as b
join book_copies as bc
on b.book_BookID=bc.book_copies_BookID) as bb
on lb.library_branch_BranchID=bb.book_copies_BranchID
where book_Title="The Lost Tribe";

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select * from borrower;
select * from loans;

select b.borrower_BorrowerName from borrower as b
left join loans as l
on b.borrower_CardNo= l.book_loans_CardNo
where l.book_loans_CardNo is null;

-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select * from books;
select * from library_branch;
select * from loans;
select * from borrower;

select  lbb.book_Title,lbb.borrower_BorrowerName,lbb.borrower_BorrowerAddress from library_branch as lib
join (select * from books as b
join (select * from loans as l
join borrower as bo
on l.book_loans_CardNo=bo.borrower_CardNo
where l.book_loans_DueDate='2/3/18') as lb
on b.book_BookID=lb.book_loans_BookID) as lbb
on lbb.book_loans_BranchID=lib.library_branch_BranchID
where lib.library_branch_BranchName='Sharpstown';

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select * from library_branch;
select * from loans;

select lb.library_branch_BranchName,count(*) as no_of_books_loaned from loans as l
join library_branch as lb
on lb.library_branch_BranchID=l.book_loans_BranchID
group by l.book_loans_BranchID;

-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select * from borrower;
select * from loans;

select b.borrower_BorrowerName,b.borrower_BorrowerAddress,count(*) as no_of_book_Checkedout from borrower as b
join loans as l
on b.borrower_CardNo=l.book_loans_CardNo
group by b.borrower_CardNo;


-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select * from books;
select * from library_branch;
select * from book_copies;
select * from authors;

select b.book_title,sum(book_copies_No_Of_Copies) as no_of_copies from books as b
join authors as a
on b.book_BookID=a.book_authors_BookID
join book_copies as bc
on bc.book_copies_BookID=b.book_BookID
join library_branch as l
on l.library_branch_BranchID=bc.book_copies_BranchID
where book_authors_AuthorName='Stephen King' and library_branch_BranchName="Central" 
group by b.book_Title;



