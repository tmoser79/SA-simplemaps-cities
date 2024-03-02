# Makefile version 1.0.1

APP="SA_cities.tgz"
APP_DIR="SA_cities"
USER="tmoser@splunk.com"

SC_TOKEN="eyJraWQiOiJuVk9JUHZrTkFpbG9WMEliM0UzWnVNQjR5UGVlVTNhWHBKaGw1Nlc4aWxvIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULkZOMU9XUUdLOXlNNTNsbWV4VUVYa0VBd2lXVC1JZ09odi1MaEswcExtSGsiLCJpc3MiOiJodHRwczovL2lkcC5sb2dpbi5zcGx1bmsuY29tL29hdXRoMi9hdXNnemp3c2V0Y2hQVklsZzJwNyIsImF1ZCI6ImFwaS5zcGx1bmsuY29tIiwiaWF0IjoxNzA3NzQzMjc4LCJleHAiOjE3MDc3NzIwNzgsImNpZCI6IjBvYWd6anZwcXRzZHRZUDM1MnA3IiwidWlkIjoiMDB1Y2RyYnU5b0JYU1E3T0gycDciLCJzY3AiOlsib3BlbmlkIl0sImF1dGhfdGltZSI6MTcwNzc0MzI3OCwic3ViIjoidG1vc2VyQHNwbHVuay5jb20iLCJ1bmFtZSI6InRtb3Nlcl9zcGx1bmsiLCJuYW1lIjoiVG9tYXMgTW9zZXIiLCJ1c2VyIjp7ImVtYWlsIjoidG1vc2VyQHNwbHVuay5jb20iLCJsZGFwX2RuIjoidG1vc2VyIn0sImVtYWlsIjoidG1vc2VyQHNwbHVuay5jb20ifQ.FGa1JHKRNwnh50LEe9rGnXxketEHk_anji_jnzDYrkpSPNrWwGIMUjCSLjNS4oIcl5430vBvbcrqFToW0zET9OvyS_lCj67GFWQfaxI1RWgT-Afb4wNFSE-UsiLbsPO8dMZroAY7r9xc53qghvC37FPi6cAVCbUw-zFnup5m5BoypiSN61Jx-NTSRDM2NLB5oQVQSwefMFTPDfbmjcDka3nuZB9IisjKeovWJPwduhvHHY6HQzu37OyKpRuOjbtyq42sLc7j3LLWrHKhfjbEcF0ou0-hHhkRwikNxX9OR3kBkmm6NqDppqktWgf-AIJsiI6eyzOaFLsIW4jNTmiB-A"

REQID="cf233351-3cb1-4ced-8b10-980bc42bcde9"

SPLUNKBASE_EXCLUDE = "splunkbase_exclude"
RELEASE = $(shell cat default/app.conf | grep version | cut -f2 -d= | sed -E 's/ +//')

authenticate:
	curl -u ${USER} --url "https://api.splunk.com/2.0/rest/login/splunk"

submit:
	find -L . -type f -name "*.py[co]" -exec rm {} \; 
	tar cvzhf ../${APP} ../${APP_DIR}
	curl -X POST \
     -H "Authorization: bearer $(SC_TOKEN)" \
     -H "Cache-Control: no-cache" \
     -F "app_package=@\"./$(APP)\"" \
     --url "https://appinspect.splunk.com/v1/app/validate"	

status:
	curl -X GET \
    -H "Authorization: bearer $(SC_TOKEN)" \
        --url "https://appinspect.splunk.com/v1/app/validate/status/$(REQID)"

report:
	curl -X GET \
	-H "Authorization: bearer $(SC_TOKEN)" \
	-H "Cache-Control: no-cache" \
	-H "Content-Type: text/html" \
	--url "https://appinspect.splunk.com/v1/app/report/$(REQID)" | html2text > report.txt

package:
	echo "Creating release $(RELEASE) for Splunkbase"; \
	cd ..; \
	rm -f $(APP)-*; \
	tar -X $(APP_DIR)/$(SPLUNKBASE_EXCLUDE) -cvzf $(APP_DIR)-$(RELEASE).tar.gz $(APP_DIR)

all: package
