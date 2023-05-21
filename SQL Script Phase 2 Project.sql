CREATE DATABASE CLASSPASS;

USE CLASSPASS;

SET foreign_key_checks = 0;

CREATE TABLE BUSINESS_OWNER (
    OwnerID CHAR(3) NOT NULL,
    OwnerName VARCHAR(20) NOT NULL,
    OwnerPhoneNumber CHAR(8) NOT NULL,
    CONSTRAINT BUSINESS_OWNER_PK PRIMARY KEY (OwnerID)
);


CREATE TABLE STUDIO (
    StudioID CHAR(3) NOT NULL,
    StudioName VARCHAR(20) NOT NULL,
    StudioLocation VARCHAR(20) NOT NULL,
    StudioPhoneNumber CHAR(8) NOT NULL,
    StudioEmail VARCHAR(30) NOT NULL,
    StudioType VARCHAR(20) NOT NULL, 
    OwnerID CHAR(3) NOT NULL,
    CONSTRAINT STUDIO_PK PRIMARY KEY (StudioID),
    CONSTRAINT STUDIO_FK1 FOREIGN KEY (OwnerID)
        REFERENCES BUSINESS_OWNER (OwnerID)
);

CREATE TABLE CLASS (
    ClassID CHAR(3) NOT NULL,
    ClassName VARCHAR(50) NOT NULL,
    CreditsRequired INT NOT NULL,
    ClassSize INT NOT NULL, 
    StudioID CHAR(3) NOT NULL, 
    CONSTRAINT CLASS_PK PRIMARY KEY (ClassID , StudioID),
    CONSTRAINT CLASS_FK1 FOREIGN KEY (StudioID)
        REFERENCES STUDIO (StudioID)
);


CREATE TABLE INSTRUCTOR (
    InstructorID CHAR(3) NOT NULL,
    StudioID CHAR(3) NOT NULL,
    InstructorName VARCHAR(20) NOT NULL,
    InstructorPhoneNumber CHAR(8) NOT NULL,
    InstructorEmail VARCHAR(30) NOT NULL,
    CONSTRAINT INSTRUCTOR_PK PRIMARY KEY (InstructorID),
    CONSTRAINT INSTRUCTOR_FK FOREIGN KEY (StudioID)
        REFERENCES STUDIO (StudioID)
);




CREATE TABLE INSTRUCTOR_CLASS (
StudioID CHAR(3) NOT NULL,
StartTime TIME NOT NULL,
ClassDate DATE NOT NULL,
ClassID CHAR(3) NOT NULL,
InstructorID CHAR(3) NOT NULL,
CONSTRAINT INSTRUCTOR_CLASS_PK PRIMARY KEY (InstructorID, ClassID, ClassDate, StartTime),
CONSTRAINT INSTRUCTOR_CLASS_FK1 FOREIGN KEY (InstructorID)
	REFERENCES INSTRUCTOR (InstructorID),
CONSTRAINT INSTRUCTOR_CLASS_FK2 FOREIGN KEY (ClassID, StudioID)
	REFERENCES CLASS (ClassID, StudioID)
);



CREATE TABLE USER (
    UserID CHAR(3) NOT NULL,
    FirstName VARCHAR(15) NOT NULL,
    LastName VARCHAR(15) NOT NULL,
    DateOfBirth DATE NOT NULL,
    UserEmail VARCHAR(30) NOT NULL,
    UserPhoneNumber CHAR(8) NOT NULL,
    UserAddress VARCHAR(50) NOT NULL,
    CardNumber CHAR(20) NOT NULL,
    CVV CHAR(3) NOT NULL,
    ExpiryDate DATE NOT NULL, # remember to extract year and month only
    CurrentMembershipType VARCHAR(15) NULL,
    CurrentStartDate DATE NULL,
    CurrentEndDate DATE NULL,
    ReferralUserID CHAR(3),
    CONSTRAINT USER_PK PRIMARY KEY (UserID),
    CONSTRAINT USER_FK1 FOREIGN KEY (ReferralUserID)
        REFERENCES USER (UserID)
);

 CREATE TABLE USERMEMBERSHIPHISTORY (
    StartDate DATE NOT NULL, 
    UserID CHAR(3) NOT NULL, 
    SubscriptionPlan VARCHAR(15) NOT NULL,
    CONSTRAINT USERMEMBERSHIPHISTORY_PK PRIMARY KEY (StartDate, UserID),
    CONSTRAINT USERMEMBERSHIPHISTORY_FK1 FOREIGN KEY (UserID)               
		REFERENCES USER (UserID)
);


CREATE TABLE PAYMENT (
    PaymentID CHAR(3) NOT NULL,
    CreditsPurchased INT NOT NULL,
    PaymentAmount INT NOT NULL, 
    UserID CHAR(3) NOT NULL,
    PaymentDate date NOT NULL,
    CONSTRAINT PAYMENT_PK PRIMARY KEY (PaymentID),
    CONSTRAINT PAYMENT_FK1 FOREIGN KEY (UserID)
        REFERENCES USER (UserID)
);

CREATE INDEX idx_instructor_class ON INSTRUCTOR_CLASS (ClassDate, InstructorID, StudioID, ClassID, StartTime);
CREATE TABLE BOOKING (
    BookingID CHAR(3) NOT NULL,
    BookingDate DATE NOT NULL,
    ClassDate DATE NOT NULL,
    Attendance BOOLEAN NOT NULL,
    UserID CHAR(3) NOT NULL,
    InstructorID CHAR(3) NOT NULL,
    StudioID CHAR(3) NOT NULL,
    ClassID CHAR(3) NOT NULL,
    StartTime TIME NOT NULL,
    StarsGiven INT,
    CONSTRAINT BOOKING_PK PRIMARY KEY (BookingID),
    CONSTRAINT BOOKING_FK1 FOREIGN KEY (UserID)
        REFERENCES USER (UserID),
    CONSTRAINT BOOKING_FK2 FOREIGN KEY (ClassDate, InstructorID, StudioID, ClassID, StartTime) 
        REFERENCES INSTRUCTOR_CLASS (ClassDate, InstructorID, StudioID, ClassID, StartTime),
    CONSTRAINT STARSGIVEN_CHECK CHECK (StarsGiven >= 0 AND StarsGiven <= 5)
);

INSERT INTO USER VALUES
('501', 'Hannah', 'Montana', '1995-10-11', 'hannahmontana@gmail.com', '88754321', '10 Anson Street', '1234567890123456', '221', '2027-03-08', '25 Credits', '2023-03-20', '2023-04-20', null),
('502', 'Ash', 'Ketchum', '1995-04-26', 'ashketchum@gmail.com', '86423422', '97 Bukit Timah Road', '3233547890001112', '908', '2026-03-09', '150 Credits', '2023-03-12', '2023-04-12', null),
('503', 'Tony', 'Stark', '1965-04-04', 'iamtonystark@gmail.com', '90132453', '54 Balestier Road', '2243332156678877', '690', '2024-02-12', '85 Credits', '2023-02-27', '2023-04-27', null),
('504', 'Jake', 'Paul', '1997-01-17', 'jakepaul71@gmail.com', '95432281', '71 Victoria Street', '9877433201018788', '766', '2027-05-25', '25 Credits', '2023-03-21', '2023-04-21', null),
('505', 'Bruno', 'Mars', '1985-08-08', 'brunomars@gmail.com', '87437716', '87 Havelock Road', '8893442156657500', '556', '2027-02-27', '45 Credits', '2023-03-02', '2023-04-02', null),
('506', 'Vanessa', 'Hudgens', '1988-06-15', 'vanessahudgens@gmail.com', '87900545', '23 Leng Kee Road', '6574839201922121', '986', '2027-01-28', '85 Credits', '2023-03-05', '2023-04-05', null),
('507', 'Ronald', 'MacDonald', '1955-04-15', 'mickeyds@gmail.com', '95534591', '69 Tiong Bahru Road', '1067543223788889', '206', '2026-06-25', '150 Credits', '2023-03-18', '2023-04-18', null),
('508', 'Farhan', 'Bowman', '1985-06-12', 'farhanbowman@gmail.com', '91234567', '15 Serangoon Street', '4123456789012345', '123', '2025-07-25', '45 Credits', '2023-03-01', '2023-04-01', null),
('509', 'Paige', 'Mcgowan', '1997-11-30', 'paigemcgowan@gmail.com', '87654321', '26 Tampines Lane', '5324567890123456', '456', '2028-08-25', '25 Credits', '2023-02-25', '2023-03-25', null),
(510, 'Beatrice', 'Wagner', '1989-12-02', 'beatricewagner@gmail.com', '82213344', '06 Clementi Street', '1234567890123456', '123', '2024-01-25', '150 Credits', '2023-03-02', '2023-04-02', null),
(511, 'Fatimah', 'Kemp', '1976-01-19', 'fatimahkemp@gmail.com', '93377733', '07 Ang Mo Kio Lane', '2345678901234567', '456', '2024-02-25', '25 Credits', '2023-03-03', '2023-04-03', null),
(512, 'Jenna', 'Marbles', '1988-09-01', 'jennamarbles@gmail.com', '98765438', '83 Prinsep Street', '5675944432221908', '456', '2027-06-18', 'Trial', '2023-02-28', '2023-03-28', 501),
(513, 'King', 'Kong', '1968-07-24', 'kingkong@gmail.com', '91023456', '72 Arab Street', '7171546322890087', '432', '2026-08-12', 'Trial', '2023-03-15', '2023-04-15', 502),
(514, 'Dwayne', 'Johnson', '1972-05-01', 'therock@gmail.com', '93334532', '72 Middle Road', '6688727296584340', '112', '2027-10-22', 'Trial', '2023-03-11', '2023-04-11', 503),
(515, 'Tiger', 'Woods', '1975-12-30', 'golfer3000@gmail.com', '92543789', '45 Selegie Road', '4242879000412527', '237', '2025-11-04', 'Trial', '2023-03-16', '2023-04-16', 504),
(516, 'Lincoln', 'Singh', '1978-03-17', 'lincolnsingh@gmail.com', '93828912', '18 Jurong Road', '6234678901234567', '789', '2023-09-25', 'Trial', '2023-02-26', '2023-03-26', 505),
(517, 'Keira', 'Mata', '2002-09-05', 'keiramata@gmail.com', '90012345', '09 Woodlands Ring', '7345723456789012', '234', '2023-10-25', 'Trial', '2023-02-27', '2023-03-27', 506),
(518, 'Mustafa', 'Russo', '1990-07-24', 'mustafarusso@gmail.com', '81023456', '33 Yishun Lane', '8234890123456789', '567', '2026-11-25', 'Trial', '2023-02-28', '2023-03-28', 507),
('519', 'Kobe', 'Stevens', '1965-04-08', 'kobestevens@gmail.com', '96789012', '04 Bukit Batok Road', '9465237680452356', '890', '2023-12-25', 'Trial', '2023-03-01', '2023-04-01', '508'),
('520', 'Dwayne', 'Singh', '2001-04-25', 'dwaynesingh@gmail.com', '83429345', '71 Victoria Street', '1234123932442345', '234', '2027-01-28', null, null, null, '511'),
('521', 'Fatimah', 'Stark', '1999-07-30', 'fatimahstark@gmail.com', '98342345', '72 Arab Street', '3429478523432342', '253', '2026-06-25', null, null, null, '510'),
('522', 'Farhan', 'Mcgowan', '1967-09-20', 'farhanmcgowan@gmail.com', '93428345', '83 Prinsep Street', '2349432323452345', '435', '2025-07-25', null, null, null, null),
('523', 'King', 'Woods', '1962-08-30', 'kingwoods@gmail.com', '85734133', '45 Selegie Road', '3257134825873248', '545', '2028-08-25', null, null, null, null),
('524', 'Paige', 'Mars', '1999-05-06', 'paigemars@gmail.com', '82347735', '18 Jurong Road', '2359234823852384', '205', '2024-01-25', null, null, null, '512'),
('525', 'Fatimah', 'Marbles', '1978-03-17', 'fatimahmarbles@gmail.com', '92345764', '07 Ang Mo Kio Lane', '8932324823482345', '231', '2024-02-25', null, null, null, '515');


INSERT INTO USERMEMBERSHIPHISTORY VALUES
('2021-11-04', 501, 'Trial'),
('2023-02-11', 502, 'Trial'),
('2023-01-26', 503, 'Trial'),
('2023-02-20', 504, 'Trial'),
('2023-02-01', 505, 'Trial'),
('2023-02-04', 506, 'Trial'),
('2023-02-17', 507, 'Trial'),
('2023-01-28', 508, 'Trial'),
('2023-01-24', 509, 'Trial'),
('2023-02-01', 510, 'Trial'),
('2023-02-02', 511, 'Trial'),
('2022-08-01', 520, 'Trial'),
('2022-09-13', 521, 'Trial'),
('2022-10-15', 522, 'Trial'),
('2022-10-23', 523, 'Trial'),
('2022-10-31', 524, 'Trial'),
('2022-11-11', 525, 'Trial'),
('2023-03-12', 502, '150 Credits'),
('2023-02-27', 503, '85 Credits'),
('2023-03-21', 504, '25 Credits'),
('2023-03-02', 505, '45 Credits'),
('2023-03-05', 506, '85 Credits'),
('2023-03-18', 507, '150 Credits'),
('2023-03-01', 508, '45 Credits'),
('2023-02-25', 509, '25 Credits'),
('2023-03-02', 510, '150 Credits'),
('2023-03-03', 511, '25 Credits'),
('2023-02-28', 512, 'Trial'),
('2023-03-15', 513, 'Trial'),
('2023-03-11', 514, 'Trial'),
('2023-03-16', 515, 'Trial'),
('2023-02-26', 516, 'Trial'),
('2023-02-27', 517, 'Trial'),
('2023-02-28', 518, 'Trial'),
('2023-03-01', 519, 'Trial'),
('2021-12-05', 501, '25 Credits'),
('2022-01-06', 501, '150 Credits'),
('2022-02-07', 501, '45 Credits'),
('2022-03-08', 501, '25 Credits'),
('2022-04-09', 501, '85 Credits'),
('2022-05-10', 501, '25 Credits'),
('2022-06-11', 501, '25 Credits'),
('2022-07-12', 501, '45 Credits'),
('2022-08-13', 501, '25 Credits'),
('2022-09-14', 501, '85 Credits'),
('2022-10-15', 501, '25 Credits'),
('2022-11-16', 501, '85 Credits'),
('2022-12-17', 501, '25 Credits'),
('2023-01-18', 501, '150 Credits'),
('2023-02-19', 501, '45 Credits'),
('2023-03-20', 501, '45 Credits');




INSERT INTO INSTRUCTOR VALUES 
('301', '101', 'Johnny', '92221345', 'johnnylegend@gmail.com'),
('302', '101', 'Alden', '96503212', 'aldennuts@gmail.com'),
('303', '101', 'Phil', '98888030', 'philguy@gmail.com'),
('304', '102', 'Gru', '82621442', 'gruminion@gmail.com'),
('305', '102', 'Alice', '86457878', 'aliceinwonderland@gmail.com'),
('306', '102', 'Bob', '88880888', 'bobthebuilder@gmail.com'),
('307', '103', 'Jimmy', '83940596', 'jimmyneutron@gmail.com'),
('308', '103', 'Kim', '89892304', 'kimpossible@gmail.com'),
('309', '103', 'Megan', '84444448', 'megannnn@gmail.com'),
('310', '104', 'Harry', '92221345', 'harrystyles@gmail.com'),
('311', '104', 'Ron', '94545711', 'ron81@gmail.com'),
('312', '104', 'Sandra', '99767898', 'sandra66@gmail.com'),
('313', '105', 'Annette', '88310626', 'annette19@gmail.com'),
('314', '105', 'Phil', '86674866', 'phil6@gmail.com'),
('315', '105', 'Bernadette', '98490171', 'bernadette95@gmail.com'),
('316', '106', 'Greg', '80383502', 'greg41@gmail.com'),
('317', '106', 'Pablo', '88393971', 'pablo50@gmail.com'),
('318', '106', 'Joanna', '99608145', 'joanna62@gmail.com'),
('319', '107', 'Damon', '97459804', 'damon47@gmail.com'),
('320', '107', 'Gene', '91134795', 'gene6@gmail.com'),
('321', '107', 'Christine', '92636685', 'christine73@gmail.com'),
('322', '108', 'Salvatore', '93682179', 'salvatore31@gmail.com'),
('323', '108', 'Angelina', '90738504', 'angelina70@gmail.com'),
('324', '108', 'Robin', '95146894', 'robin17@gmail.com'),
('325', '109', 'Krystal', '81246483', 'krystal44@gmail.com'),
('326', '109', 'Silvia', '92818518', 'silvia40@gmail.com'),
('327', '109', 'Kirk', '85933921', 'kirk75@gmail.com'),
('328', '110', 'Christa', '81906242', 'christa68@gmail.com'),
('329', '110', 'Lou', '80604672', 'lou8@gmail.com'),
('330', '110', 'Pam', '83983351', 'pam20@gmail.com'),
('331', '111', 'Jensen', '81906444', 'jensengotguts@gmail.com'),
(332, 111, 'Damian', '80615272', 'damiantime@gmail.com'),
(333, 111, 'Jean', '94983660', 'jeandearc@gmail.com');

INSERT INTO BUSINESS_OWNER VALUES 
(901, 'Jim', '98897672'),
(902, 'John', '88776655'),
(903, 'Logan', '97738292'),
(904, 'Paul', '90013456'),
(905, 'May', '80203942'),
(906, 'Shane', '83121224'),
(907, 'Mark', '89898900'),
(908, 'Jamie', '90543232'),
(909, 'Charmaine', '87907764'),
(910, 'Phuoc', '89234562');

INSERT INTO STUDIO VALUES
('101', 'Yoga Haus', 'Orchard', '89014344', 'yogahaus@gmail.com', 'Yoga', '901'),
('102', 'Spyn', 'Toa Payoh', '81838107', 'spyn@gmail.com', 'Cycling', '901'),
('103', 'Anytime Fitness', 'Bukit Panjang', '91655131', 'anytimefitness@gmail.com', 'Gym', '902'),
('104', 'GymBros', 'Tanjong Pagar', '84508185', 'gymbros@gmail.com', 'Gym', '903'),
('105', 'Meditation Centre', 'Bukit Batok', '95797040', 'meditationcentre@gmail.com', 'Meditation', '904'),
('106', 'Singapore Finest', 'Clarke Quay', '88042403', 'singaporefinest@gmail.com', 'Cardio', '905'),
('107', 'Django Gym', 'Changi', '84007172', 'djangogym@gmail.com', 'Dancing', '906'),
('108', 'Thick and Thin', 'Yishun', '88374969', 'thickthin@gmail.com', 'Gym', '907'),
('109', 'Power and Muscle', 'Clementi', '88027741', 'musclepower@gmail.com', 'Weightlifting', '908'),
('110', 'Pilates For You', 'Simei', '83734376', 'pilatesforyou@gmail.com', 'Pilates', '909'),
('111', 'Zumbamania', 'Simei', '83467534', 'zumbamania@gmail.com', 'Dancing', '910');

INSERT INTO CLASS VALUES
('201', 'Yin Yoga', 10, 10, '101'),
('202', 'Hot Yoga', 15, 13, '101'),
('203', 'Flow Yoga', 10, 15, '101'),
('204', 'Rhythmic Ride', 10, 20, '102'),
('205', 'Spintopia', 5, 10, '102'),
('206', 'TGIF', 5, 15, '102'),
('207', 'HIIT', 15, 20, '103'),
('208', 'Beast Mode', 15, 10, '103'),
('209', 'Cardio Summit', 10, 15, '103'),
('210', 'Shredz', 10, 20, '104'),
('211', 'xTx', 5, 10, '104'),
('212', 'POWer', 10, 15, '104'),
('213', 'Reiki', 15, 20, '105'),
('214', 'Mindfulness', 5, 10, '105'),
('215', 'Guided Flow', 10, 15, '105'),
('216', 'Bootycamp', 10, 20, '106'),
('217', 'Fierce Fest', 10, 10, '106'),
('218', 'One More Rep', 5, 15, '106'),
('219', 'All that Jazz', 5, 20, '107'),
('220', 'Dance till Dawn', 15, 10, '107'),
('221', 'Waltz', 15, 15, '107'),
('222', 'ENCORE', 10, 20, '108'),
('223', 'RESET', 10, 10, '108'),
('224', 'DESTROY', 20, 15, '108'),
('225', 'Push', 10, 20, '109'),
('226', 'Pull', 10, 10, '109'),
('227', 'Legs', 15, 15, '109'),
('228', 'Inch by Inch', 5, 20, '110'),
('229', 'Barre Star', 5, 10, '110'),
('230', 'Raise the Barre', 5, 15, '110'),
('231', 'Dancing with the Stars', 10, 20, '111'),
('232', 'Drop Dead', 5, 10, '111'),
('233', 'Just Dance', 5, 20, '111');

INSERT INTO INSTRUCTOR_CLASS VALUES
('101', '15:00', '2023-03-22', '201', '301'),
('101', '14:00', '2023-03-21', '202', '301'),
('101', '14:00', '2023-03-23', '203', '302'),
('101', '09:00', '2023-03-22', '201', '302'),
('101', '15:00', '2023-03-21', '202', '302'),
('101', '09:00', '2023-03-25', '203', '303'),
('102', '10:00', '2023-03-22', '204', '304'),
('102', '11:00', '2023-03-21', '205', '304'),
('102', '07:00', '2023-03-25', '206', '305'),
('103', '20:00', '2023-03-21', '207', '307'),
('103', '10:00', '2023-03-25', '208', '308'),
('103', '10:00', '2023-03-22', '209', '309'),
('104', '10:00', '2023-03-23', '210', '310'),
('104', '20:00', '2023-03-22', '211', '311'),
('104', '20:00', '2023-03-21', '212', '312'),
('105', '10:00', '2023-03-21', '213', '313'),
('105', '08:00', '2023-03-23', '214', '314'),
('105', '09:00', '2023-03-22', '215', '315'),
('106', '13:00', '2023-03-25', '216', '316'),
('106', '10:00', '2023-03-21', '217', '317'),
('106', '12:00', '2023-03-25', '218', '318'),
('107', '19:00', '2023-03-23', '219', '319'),
('107', '18:00', '2023-03-22', '220', '320'),
('107', '16:00', '2023-03-21', '221', '321'),
('108', '17:00', '2023-03-21', '222', '322'),
('108', '15:00', '2023-03-25', '223', '323'),
('108', '14:00', '2023-03-23', '224', '324'),
('109', '14:00', '2023-03-21', '225', '325'),
('109', '11:00', '2023-03-23', '226', '326'),
('109', '10:00', '2023-03-22', '227', '327'),
('110', '10:00', '2023-03-21', '228', '328'),
('110', '19:00', '2023-03-23', '229', '329'),
('110', '12:00', '2023-03-22', '230', '330'),
('111', '13:00', '2022-11-02', '231', '331'),
('111', '16:00', '2022-11-02', '232', '332'),
('111', '10:00', '2022-10-24', '233', '333'),
('101', '09:00', '2022-08-10', '203', '302'),
('101', '15:00', '2022-10-20', '202', '302'),
('101', '15:00', '2022-11-02', '203', '303');

INSERT INTO BOOKING VALUES 
(401, '2023-03-09', '2023-03-22', 1, 512, 301, 101, 201, '15:00', 5),
(402, '2023-03-15', '2023-03-21', 0, 513, 301, 101, 202, '14:00', null),
(403, '2023-03-20', '2023-03-25', 0, 501, 303, 101, 203, '09:00', null),
(404, '2023-03-12', '2023-03-25', 1, 502, 303, 101, 203, '09:00', 2),
(405, '2023-03-10', '2023-03-22', 1, 503, 301, 101, 201, '15:00', null),
(406, '2023-03-11', '2023-03-22', 1, 514, 301, 101, 201, '15:00', 3),
(407, '2023-03-16', '2023-03-22', 1, 515, 301, 101, 201, '15:00', 1),
(408, '2023-03-21', '2023-03-22', 1, 504, 301, 101, 201, '15:00', null),
(409, '2023-03-11', '2023-03-21', 1, 505, 301, 101, 202, '14:00', 5),
(410, '2023-03-09', '2023-03-21', 1, 506, 301, 101, 202, '14:00', 2),
(411, '2023-03-10', '2023-03-25', 1, 507, 303, 101, 203, '09:00', 4),
(412, '2023-03-11', '2023-03-22', 1, 508, 301, 101, 201, '15:00', 3),
(413, '2023-03-09', '2023-03-21', 1, 509, 302, 101, 202, '15:00', null),
(414, '2023-03-10', '2023-03-21', 1, 516, 302, 101, 202, '15:00', 2),
(415, '2023-03-11', '2023-03-25', 1, 517, 303, 101, 203, '09:00', 3),
(416, '2023-03-09', '2023-03-25', 1, 518, 303, 101, 203, '09:00', 2),
(417, '2023-03-10', '2023-03-23', 0, 519, 302, 101, 203, '14:00', null),
(418, '2023-03-11', '2023-03-21', 1, 510, 302, 101, 202, '15:00', 5),
(419, '2023-03-09', '2023-03-21', 1, 511, 302, 101, 202, '15:00', null),
(420, '2023-03-10', '2023-03-23', 1, 512, 302, 101, 203, '14:00', 3),
(421, '2023-03-11', '2023-03-23', 0, 513, 302, 101, 203, '14:00', null),
(422, '2023-03-09', '2023-03-23', 1, 503, 302, 101, 203, '14:00', 3),
(423, '2023-03-11', '2023-03-23', 0, 514, 302, 101, 203, '14:00', null),
(424, '2023-03-11', '2023-03-21', 0, 512, 302, 101, 202, '15:00', null),
(425, '2023-03-11', '2023-03-21', 1, 514, 302, 101, 202, '15:00', 3),
(426, '2023-03-21', '2023-03-23', 1, 504, 302, 101, 203, '14:00', 4),
(427, '2023-03-20', '2023-03-22', 1, 501, 302, 101, 201, '09:00', 4),
(428, '2023-03-19', '2023-03-22', 1, 502, 302, 101, 201, '09:00', null),
(429, '2022-08-01', '2022-08-10', 1, 520, 302, 101, 203, '09:00', 1),
(430, '2022-10-15', '2022-10-20', 0, 522, 302, 101, 202, '15:00', null),
(431, '2022-10-31', '2022-11-02', 1, 524, 303, 101, 203, '15:00', 1),
(432, '2022-09-13', '2022-11-02', 1, 521, 331, 111, 231, '13:00', 5),
(433, '2022-09-13', '2022-11-02', 1, 521, 332, 111, 232, '16:00', 4),
(434, '2023-10-23', '2023-03-23', 1, 523, 333, 111, 233, '10:00', 2),
(435, '2022-10-31', '2022-11-02', 1, 524, 332, 111, 232, '16:00', 4);


INSERT INTO PAYMENT VALUES
(801, 25, 59, 501, '2021-12-05'),
(802, 150, 315, 502, '2023-03-12'),
(803, 85, 185, 503, '2023-02-27'),
(804, 25, 59, 504, '2023-03-21'),
(805, 45, 99, 505, '2023-03-02'),
(806, 85, 185, 506, '2023-03-05'),
(807, 150, 315, 507, '2023-03-18'),
(808, 45, 99, 508, '2023-03-01'),
(809, 25, 59, 509, '2023-02-25'),
(810, 150, 315, 510, '2023-03-02'),
(811, 25, 59, 511, '2023-03-03'),
(812, 150, 315, 501, '2022-01-05'),
(813, 45, 99, 501, '2022-02-06'),
(814, 25, 59, 501, '2022-03-07'),
(815, 85, 185, 501, '2022-04-08'),
(816, 25, 59, 501, '2022-05-09'),
(817, 25, 59, 501, '2022-06-10'),
(818, 45, 99, 501, '2022-07-11'),
(819, 25, 59, 501, '2022-08-12'),
(820, 85, 185, 501, '2022-09-13'),
(821, 25, 59, 501, '2022-10-14'),
(822, 85, 185, 501, '2022-11-15'),
(823, 25, 59, 501, '2022-12-16'),
(824, 150, 315, 501, '2023-01-17'),
(825, 45, 99, 501, '2023-02-18'),
(826, 45, 99, 501, '2023-03-19');

#Query 1: Query to Return Top 5 Favorites

SELECT ROW_NUMBER() OVER (ORDER BY temp5.Count desc) as 'Rank', temp5.ClassName, temp5.ClassDate, temp5.StudioName, temp5.StudioLocation
FROM
(SELECT temp4.ClassName, temp4.ClassDate, temp4.StudioName, temp4.StudioLocation, count(c.ClassName) as Count
FROM class c
INNER JOIN
(SELECT c.ClassName, temp3.ClassDate, s.StudioName, s.StudioLocation
FROM class c
INNER JOIN studio s ON s.StudioID = c.StudioID
INNER JOIN
	(SELECT b.ClassID, b.StudioID, b.StartTime, b.ClassDate
	FROM booking b
	INNER JOIN
		(SELECT * FROM
		(SELECT UserID, max(StarsGiven) AS StarsGiven
		FROM booking b 
		GROUP BY b.UserID) AS temp
		WHERE temp.StarsGiven IS NOT NULL) as temp2
		ON temp2.UserID = b.UserID
	WHERE temp2.StarsGiven IS NOT NULL) as temp3 on temp3.ClassID = c.ClassID) as temp4
ON temp4.ClassName = c.ClassName
GROUP BY temp4.ClassName, temp4.ClassDate, temp4.StudioName, temp4.StudioLocation) as temp5
LIMIT 5;

#Query 2: Query to Return Popularity of instructors and the classes they teach

SELECT I.InstructorName, ClassName, COUNT(DISTINCT B.BookingID) AS NumBookings
FROM INSTRUCTOR I
INNER JOIN INSTRUCTOR_CLASS IC ON IC.InstructorID = I.InstructorID
INNER JOIN BOOKING B ON IC.InstructorID = B.InstructorID AND IC.ClassID = B.ClassID
INNER JOIN CLASS C ON B.StudioID = C.StudioID AND B.ClassID = C.ClassID
WHERE I.StudioID = 101 AND IC.InstructorID IN (
  SELECT InstructorID
  FROM INSTRUCTOR_CLASS
) AND EXTRACT(MONTH FROM B.ClassDate) = 3
GROUP BY I.InstructorName, ClassName
ORDER BY NumBookings DESC;

#Query 3: Query to return Average Rating for class(es) taught by a particular Instructor
    
SELECT 
    INSTRUCTOR.InstructorID, 
    INSTRUCTOR.InstructorName, 
    INSTRUCTOR_CLASS.StudioID, 
    INSTRUCTOR_CLASS.ClassID, 
    CLASS.ClassName,
    AVG(BOOKING.StarsGiven) AS AverageRating
FROM 
    INSTRUCTOR_CLASS
    JOIN BOOKING ON INSTRUCTOR_CLASS.ClassID = BOOKING.ClassID AND INSTRUCTOR_CLASS.StudioID = BOOKING.StudioID
    JOIN INSTRUCTOR ON INSTRUCTOR_CLASS.InstructorID = INSTRUCTOR.InstructorID
    JOIN CLASS ON INSTRUCTOR_CLASS.ClassID = CLASS.ClassID
WHERE 
    INSTRUCTOR_CLASS.InstructorID = '302'
GROUP BY 
    INSTRUCTOR.InstructorID,
    INSTRUCTOR.InstructorName,
    INSTRUCTOR_CLASS.StudioID, 
    INSTRUCTOR_CLASS.ClassID,
    CLASS.ClassName;

#Query 4: Query to find out why users do not convert from trial members to subscription members

SELECT u.userID, count(bookingid) AS Bookings, count(case when attendance = 1 then 1 else null end) AS Attendance, avg(starsgiven) AS 'Stars given'
from USERMEMBERSHIPHISTORY u
LEFT OUTER JOIN booking b 
ON b.userid = u.userid
GROUP BY u.userid
HAVING count(distinct startdate) < 2
ORDER BY count(bookingid) DESC, avg(starsgiven);

#Query 5: Query to Return a Specific User's Transaction History for a Certain Year

SELECT u.UserID, PaymentDate, FirstName, LastName, PaymentAmount, CreditsPurchased
FROM USER u
INNER JOIN Payment p ON u.UserID = p.UserID
WHERE EXTRACT(YEAR from PaymentDate) = 2022
AND u.UserID = 501
ORDER BY PaymentDate DESC;