Ubuntu 10.04 GIS (and Ruby/web) chef cookbooks
==============================================

Make deploying Ruby/GIS apps simple and backed up on AWS. 

* Targets **ubuntu 10.04 EBS**. (tested 32bit AMI: **ami-714ba518**. 64bit should be ok)
* Designed for **Chef Solo**. Nothing fancy. Simple.
* Uses debs where possible

What can it build?
------------------
* full_stack.json - web.json + database.json + utility.json
* web.json - rack box (REE, nginx, passenger, postgres connectors & sinatra)
* database.json - PostGIS 1.4 box (REE, postgis 1.4, postgres 8.4, tuned postgres, GIS template, nightly backups to S3)
* utility.json - Memcached and Sphinx ready for indexing as a remote search index
* starspan.json - starspan rack box (REE, nginx, passenger, sinatra, gdal, geos & starspan)

**found in /server**

How to use with AWS Web Console?
--------------------------------
Edit the last line of boot.sh to define the server type you want and paste it into the **User Data** form field when you're filling in the server details. The server will bootstrap itself.

How to use with EC2 API tools?
--------------------------------
You can make a 50GB EBS instance by:

    ec2-run-instances --block-device-mapping /dev/sda1=:50 ami-714ba518 -f boot.sh -k my_key -g [my_sec_group]

Notes
------
* Takes ~5-10 mins to build. **Make tea, not emails**
* WWW the server URL to see the chef log (eventually).

Todo
-----
* Amazon load balancer and join pool
* monitoring (nagios/monit/bluepill?)

Note2
------


Thanks to
----------
* United Nations Environment Programme World Conservation Monitoring Centre
* Vizzualty
* jsierles 37s_cookbooks (http://github.com/37signals/37s_cookbooks)
* Heroku's Orionz ()
