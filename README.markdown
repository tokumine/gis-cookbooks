Ubuntu 10.04 GIS (and Ruby/web) chef cookbooks
==============================================

**Cookbooks in /cookbooks**

**Server config JSON in /server**

Full box setup for:

* web.json - rack box (REE, nginx, passenger, postgres connectors & sinatra)
* database.json - PostGIS 1.4 box (REE, postgis 1.4, postgres 8.4, tuned postgres, GIS template, nightly backups to S3)
* starspan.json - starspan rack box (REE, nginx, passenger, sinatra, gdal, geos & starspan)

How to use with AWS?
---------------------
These recipes have been tested with the ubuntu 10.04 EBS image. 

The AMI is tested on the 32 bit AMI: **ami-714ba518** (but will work on 64bit too)

Look at boot.sh, edit the last line and paste it into the **User Data** form field when you're filling in the server details. The server will bootstrap itself and install the works.

If you have the EC2 API tools installed, you can run it be using the following:

    ec2-run-instances ami-714ba518 -f [path to boot.sh]

If you are in the root of this git repo, and want to make a 100GB EBS instance for example, do:

    ec2-run-instances --block-device-mapping /dev/sda1=:100 ami-714ba518 -f boot.sh -k my_key -g my_sec_group

After a while, visit the URL for the box in a browser and you'll find more details about the box there, along with it's chef output

Todo
-----

* utility (sphinx + memcached)
* Restore commands
* Setup Amazon load balancer and make servers join pool
* monitoring (nagios/monit/bluepill?)

Note
-----
This is the first time I've used Chef, so there are probably lots of no-no's about the way I'm going about using it. Comments welcome!

Draws heavily from jsierles 37s_cookbooks (http://github.com/37signals/37s_cookbooks).