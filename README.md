Yamon [![Build Status](https://travis-ci.org/Toubib/yamon.svg?branch=master)](https://travis-ci.org/Toubib/yamon) [![Coverage Status](https://img.shields.io/coveralls/Toubib/yamon.svg)](https://coveralls.io/r/Toubib/yamon?branch=master)
=====

The goal of Yamon is to present services alerts and their reports in a useful and efficient way.
Monitoring systems generally don't use databases for performances reasons.
Yamon duplicates the data into a database to get the power of relationnal queries.
Yamon is not a replacement for monitoring systems but is more like an extension.
The goal of the project is absoluly not to have all the monitoring systems features but only alert data management and reporting.

Application description
-----------------------

- Alerts page
Main page of the program. You can see here last alerts and set filters to get what you want.
With edition mode, you can tag alerts with reports.

- Hosts and services pages
You can here define hosts and services, and tag them.
These data should be normally filled by an external system, like Nagios™.

- reports page
You can here write reports for your alerts and tag them.
If no "estimation date" is given, this should mean the report is not based on a single dated event. It's useful to reuse a report for a repeated event, like website delivery.
"Priority" is used to order reports list on the alert page.

- tags pages
Used to manage tags.
"Css class" is used to style the tag on the tables.

- dispo-stats page
This page is used to get monthly statistics from your services.

Models description
------------------

see db.png

CurrentAlert is used as a buffer for nagios event.
Once alert is done, it's then moved to Alert table.

Host and Service are here to define what you are monitoring.

An alert or group of alert can have a report to describe the event.
Each object report, service or host can have tags.

The user table is for edit mode where you need to be logged.

### To generate the db schema

```
rake diagram:all
```

see https://github.com/preston/railroady

 To add a user
--------------

 Load the rails console: `rails c`
```
 > u = User.new
 > u.name="test"
 > u.password="test"
 > u.save
```

Thanks
------

- icons: http://www.icon-king.com/projects/nuvola/
- calendar: http://javascriptcalendar.org/

