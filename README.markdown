Basic Ubuntu 10.04 Ruby/GIS chef cookbooks
==========================================

Has cookbooks for

* Ruby 1.8.7/gems/sinatra
* nginx 0.8.36 + Passenger
* GDal
* GEOS
* StarSpan
* emacs

Currently has full box setup for:

* starspan sinatra box (gdal, geos, starspan, nginx, passenger & sinatra)

How to use with AWS?
---------------------
These recipes have been tested with the ubuntu 10.04 EBS image. Why EBS? no reason really, just I feel better that way. The AMI I've used is ami-714ba518

Look at boot.sh, edit the last line and paste it into the User Data form field when you're filling in the server details. The server will bootstrap itself and install the works.

After a while, visit the URL for the box and you'll find more details there.

Todo
-----

* web boxes (nginx + REE)
* database (postgres 8.4 + postgis 1.5.1)
* utility (sphinx + memcache)
* configure backup of data/logs to S3
* Restore commands
* Move web server directories onto the temporary partition on EC2 boxes
* Configure EBS drives
* Setup Amazon load balancer and make servers join pool
* monitoring (nagios/monit/bluepill?)

Note
-----
This is the first time I've used Chef, so there are probably lots of no-no's about the way I'm going about using it. Comments welcome!

