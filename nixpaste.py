#!/usr/bin/env python

import logging
import random
import urllib
from bottle import Bottle, run, request, response, static_file, template, TEMPLATE_PATH, BaseRequest
import fcntl
import base64
import hashlib
import os
import json
import re
from copy import copy

os.umask(0077)

syntaxRe = re.compile ("^[a-zA-Z_-]+$")

configfile = file(os.getenv("NIXPASTE_CONFIG", "config.json"), "r")
config = json.load(configfile)
configfile.close()

# TypeError: Key has type <type 'unicode'> (not a string)
for k,v in config.items():
	del config[k]
	config[str(k)] = v

app = Bottle()
app.config.update (config)

TEMPLATE_PATH.insert(0, os.path.abspath (config["VIEWS"]))

def mergeConfig(**v):
	c = copy(config)
	c.update(v)
	return c

class Storage:
	def __init__ (self, config):
		self.config = config
		
	def hashname (self, num):
		h = hashlib.pbkdf2_hmac('sha256', str(num), self.config["SALT"], 200000, self.config["LENGTH"])
		return base64.urlsafe_b64encode(h)

	def firstview (self, hashname):
		return self.fullpath(hashname)+".firstview"
		
	def markviewed (self, hashname):
		try:
			os.unlink (self.firstview (hashname))
		except:
			pass

	def isfirstview (self, hashname):
		try:
			os.stat (self.firstview (hashname))
			return True
		except:
			return False
		
	def dirname (self, hashname):
		return os.path.join (self.config["DIR"], hashname[0], hashname[1])
		
	def fullpath (self, hashname):
		return os.path.join (self.dirname (hashname), hashname)

	def deletetoken (self, hashname):
		h = hashlib.pbkdf2_hmac('sha256', hashname+"|delete", self.config["SALT"]+"|delete", 200000, self.config["LENGTH"])
		return base64.urlsafe_b64encode(h)
		
	def delete (self, hashname, token):
		if self.deletetoken(hashname) == token:
			f = file(os.path.join (self.config["DIR"], "db"), "r+b")

			fcntl.lockf(f, fcntl.LOCK_EX)

			try:
				f.seek(0)
				db = json.load (f)

				filename = self.fullpath (hashname)
				stat = os.stat(filename)
				os.unlink(filename)
				self.markviewed (hashname)
				
				db["byte_size"] -= stat.st_size
				db["file_count"] -= 1
				if self.hashname (db["first"]) == hashname:
					db["first"] += 1

				f.seek (0)
				f.truncate ()
				json.dump (db, f)
				f.flush()

				return True
					
			finally:
				fcntl.lockf(f, fcntl.LOCK_UN)
				f.close()

		return False

	def store (self, data):
		try:
			os.makedirs (self.config["DIR"], 0700)
		except:
			pass
		
		try:
			f = file(os.path.join (self.config["DIR"], "db"), "r+b")
		except:
			f = file(os.path.join (self.config["DIR"], "db"), "w+b")

		fcntl.lockf(f, fcntl.LOCK_EX)
		try:
			f.seek(0)
			db = json.load (f)
		except Exception, e:
			print e
			db = { "byte_size": 0, "file_count": 0, "first": 0, "last": 0 }

		try:
			if len(data) > self.config["MAX_BYTES"]:
				raise RuntimeError("Too large")
				
			while db["byte_size"] + len(data) > self.config["MAX_BYTES"] or db["file_count"] + 1 > self.config["MAX_FILES"]:
				if db["first"]:
					evict = self.fullpath (self.hashname (db["first"]))
					try:
						db["byte_size"] -= os.path.getsize(evict)
						os.unlink (evict)
					except:
						pass
					db["file_count"] -= 1
					db["first"] += 1
	
			db["byte_size"] += len(data)
			db["file_count"] += 1
			db["last"] += 1
			if not db["first"]:
				db["first"] = db["last"]

			hashname = self.hashname (db["last"])
			dirname = self.dirname (hashname)
			
			try:
				os.makedirs (dirname, 0700)
			except:
				pass
				
			paste = file(self.fullpath (hashname), "wb")
			paste.write (data)
			paste.close()

			firstview = file(self.firstview (hashname), "wb")
			firstview.close ()

			f.seek (0)
			f.truncate ()
			json.dump (db, f)
			f.flush()
			
			return hashname
		finally:
			fcntl.lockf(f, fcntl.LOCK_UN)
			f.close()

	def get (self, hashname):
		try:
			f = file(self.fullpath (hashname), "r")
			data = f.read()
			f.close()

			if self.isfirstview (hashname):
				return data, self.deletetoken (hashname)
			else:
				return data, None
		except:
			return None, None

@app.get("/")
def index():
	return template ("index.tpl", **app.config)

@app.get("/favicon.ico")
def favicon():
	return static_file ("favicon.ico", app.config["STATIC"])
	
@app.get("/about")
def index():
	return template ("about.tpl", **app.config)

@app.post("/")
def paste():
	isBrowser = False
	text = request.forms.get(app.config["POST_FIELD"])
	if not text:
		text = request.forms.get("browser_text")
		isBrowser = True
	if not text:
		response.status = 400
		return 'No data\n'
		
	try:
		storage = Storage (app.config)
		hashname = storage.store (text)
		redirect = '{0}/{1}'.format(app.config["URL"], hashname)
		if isBrowser:
			response.status = 303
			syntax = request.forms.get("syntax", "")
			if syntaxRe.match (syntax):
				redirect += "?"+syntax
			response.set_header ('Location', redirect)
		else:
			storage.markviewed (hashname)
		return redirect+"\n"
	except Exception as ex:
		logging.error(ex)
		response.status = 400
		return 'Bad request\n'.format(ex)

@app.get("/css/<res>")
def css(res):
	return static_file(res, os.path.join(app.config["STATIC"], "css"))
		
@app.get("/js/<res>")
def js(res):
	return static_file(res, os.path.join(app.config["STATIC"], "js"))

@app.get("/img/<res>")
def img(res):
	return static_file(res, os.path.join(app.config["STATIC"], "img"))

@app.get("/raw/<hashname>")
def getRaw(hashname):
	return getPaste (hashname, "raw")

@app.get("/del/<hashname>/<token>")
def delete(hashname, token):
	storage = Storage(app.config)
	if not storage.delete (hashname, token):
		response.status = 404
		return '{0} could not be deleted.'.format(hashname)

	response.status = 303
	response.set_header ('Location', app.config["URL"])
	return '{0} has been deleted.'.format(hashname)
	
@app.get("/<hashname>")
def get(hashname):
	return getPaste (hashname, request.query_string)


def getPaste (hashname, syntax):
	storage = Storage(app.config)
	text, deletetoken = storage.get (hashname)
	storage.markviewed (hashname)

	if not text:
		response.status = 404
		return '{0} not found.'.format(hashname)

	if syntax == "raw":
		response.content_type = 'text/plain; charset=UTF-8'
		return text + '\n'
		
	if not syntaxRe.match (syntax):
		syntax = ""
	
	response.content_type = 'text/html; charset=UTF-8'
	return template ("index.tpl", **mergeConfig(pasteHash=hashname, pasteText=text, pasteSyntax=syntax, deleteToken=deletetoken))

if __name__ == '__main__':
	app.run(host="0.0.0.0", port="8080")
