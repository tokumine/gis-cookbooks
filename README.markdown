Ubuntu 10.04 Ruby/GIS Chef cookbooks
==============================================

Make deploying Ruby/GIS apps on AWS simple and safe. 

* Targets **ubuntu 10.04 EBS**. (tested 32bit AMI: **ami-714ba518**. 64bit should be ok)
* Designed for **Chef Solo**. Nothing fancy. Simple.
* Uses debs where possible

What can it build?
------------------
* web.json - rack (REE, nginx, passenger, postgres connectors & sinatra)
* database.json - PostGIS 1.4 (REE, postgis 1.4, tuned postgres 8.4, GIS template, nightly S3 backups)
* utility.json - Memcached and Sphinx ready for indexing as a remote search index
* full_stack.json - web.json + database.json + utility.json
* starspan.json - starspan + rack (starspan is a highspeed raster analysis tool)

**found in /server**

How to use with AWS Web Console?
--------------------------------
Edit the last line of boot.sh to pick the server type & paste it all (boot.sh) into the **User Data**  field when making a new server. The server will bootstrap itself.

How to use with EC2 API tools?
--------------------------------
Make a 50GB EBS instance:

    ec2-run-instances --block-device-mapping /dev/sda1=:50 ami-714ba518 -f boot.sh -k my_key -g [my_sec_group]

Notes
------
* Takes ~5-10 mins to build. **Make tea, not emails**
* WWW the server URL to see the chef log (eventually).

Todo
-----
* Amazon load balancer and join pool
* monitoring (nagios/monit/bluepill?)

Thanks
-------
* United Nations Environment Programme World Conservation Monitoring Centre
* Vizzuality
* jsierles 37s_cookbooks (http://github.com/37signals/37s_cookbooks)
* Heroku's Orionz bitfrost_recipes (http://github.com/orionz/bifrost-recipies)
