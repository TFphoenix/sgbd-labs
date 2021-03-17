#!/usr/bin/python

import MySQLdb


class Query:
	'common counter for all queries'
	count = 0

	def __init__(self, db, table):
		self.db = db
		self.cursor = db.cursor()
		self.table = table

	def execute(self, sql):
		try:
			self.cursor.execute(sql)
			db.commit()		
		except:
			db.rollback()

	def drop(self):
		sql = "DROP TABLE IF EXISTS " + self.table
		self.execute(sql)

	def create(self, attrs):
		sql = "CREATE TABLE " + self.table + " (" + attrs + ")"
		self.execute(sql)

	def insert(self, attrs, val):
		sql = "INSERT INTO " + self.table + " (" + attrs + ") VALUES (" + val + ")"
		self.execute(sql)

	def insertlist(self, attrs, vals):
		try:
			for val in vals:
				sql = "INSERT INTO " + self.table + " (" + attrs + ") VALUES (" + val + ")"
				self.cursor.execute(sql)
			db.commit()
		except:
			db.rollback()
			

	
'open database connection'
db = MySQLdb.connect("localhost", "user", "OpQw120-", "userdb")

'create College table'
c = Query(db, "College")
c.drop()
attrs = "cName CHAR(20) NOT NULL, state CHAR(2), enroll INT"
c.create(attrs)

'insert rows'
vals = []
attrs = "cName, state, enroll"
vals = []
vals += ["'Stanford', 'CA', 15000"]
vals += ["'Berkeley', 'CA', 36000"]
vals += ["'MIT', 'MA', 10000"]
vals += ["'Cornell', 'NY', 21000"]
c.insertlist(attrs, vals)

'create Student table'
s = Query(db, "Student")
s.drop()
attrs = "sID INT NOT NULL, sName CHAR(20), gpa FLOAT, sizeHS INT"
s.create(attrs)

'insert rows'
vals = []
attrs = "sID, sName, gpa, sizeHS"
vals = []
vals += ["123, 'Amy', 3.9, 1000"]
vals += ["234, 'Bob', 3.6, 1500"]
vals += ["345, 'Craig', 3.5, 500"]
vals += ["456, 'Doris', 3.9, 1000"]
vals += ["567, 'Edward', 2.9, 2000"]
vals += ["678, 'Fay', 3.8, 200"]
vals += ["789, 'Gary', 3.4, 800"]
vals += ["987, 'Helen', 3.7, 800"]
vals += ["876, 'Irene', 3.9, 400"]
vals += ["765, 'Jay', 2.9, 1500"]
vals += ["654, 'Amy', 3.9, 1000"]
vals += ["543, 'Craig', 3.4, 2000"]
s.insertlist(attrs, vals)

'create Apply table'
a = Query(db, "Apply")
a.drop()
attrs = "sID INT NOT NULL, cName CHAR(20) NOT NULL, major CHAR(20), decision CHAR(1)"
a.create(attrs)

'insert rows'
vals = []
attrs = "sID, cName, major, decision"
vals = []
vals += ["123, 'Stanford', 'CS', 'Y'"]
vals += ["123, 'Stanford', 'EE', 'N'"]
vals += ["123, 'Berkeley', 'CS', 'Y'"]
vals += ["123, 'Cornell', 'EE', 'Y'"]
vals += ["234, 'Berkeley', 'biology', 'N'"]
vals += ["345, 'MIT', 'bioengineering', 'Y'"]
vals += ["345, 'Cornell', 'bioengineering', 'N'"]
vals += ["345, 'Cornell', 'CS', 'Y'"]
vals += ["345, 'Cornell', 'EE', 'N'"]
vals += ["678, 'Stanford', 'history', 'Y'"]
vals += ["987, 'Stanford', 'CS', 'Y'"]
vals += ["987, 'Berkeley', 'CS', 'Y'"]
vals += ["876, 'Stanford', 'CS', 'N'"]
vals += ["876, 'MIT', 'biology', 'Y'"]
vals += ["876, 'MIT', 'marine biology', 'N'"]
vals += ["765, 'Stanford', 'history', 'N'"]
vals += ["765, 'Cornell', 'history', 'N'"]
vals += ["765, 'Cornell', 'psychology', 'Y'"]
vals += ["543, 'MIT', 'CS', 'N'"]

a.insertlist(attrs, vals)



'disconnect from the database'
db.close()
