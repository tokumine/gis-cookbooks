Ubuntu 10.04 GIS (and Ruby/web) chef cookbooks
==============================================

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
These recipes have been tested with the ubuntu 10.04 EBS image. 

The AMI tested is: **ami-714ba518**

Look at boot.sh, edit the last line and paste it into the **User Data** form field when you're filling in the server details. The server will bootstrap itself and install the works.

If you have the EC2 API tools installed, you can run it be using the following:

    ec2-run-instances --block-device-mapping /dev/sda1=:[EBS disk size, eg: 100] ami-714ba518 -f [path to boot.sh]

The above snippet will create a 100GB EBS instance for example

After a while, visit the URL for the box in a browser and you'll find more details about the box there, along with it's chef output

Todo
-----

* web boxes (nginx + passenger)
* database (postgres 8.4 + postgis 1.5.1)
* utility (sphinx + memcached)
* configure backup of data/logs to S3
* Restore commands
* Configure EBS drives
* Setup Amazon load balancer and make servers join pool
* monitoring (nagios/monit/bluepill?)
* add some hints for how to specify the size of EBS boxes initially
* logrotate

Note
-----
This is the first time I've used Chef, so there are probably lots of no-no's about the way I'm going about using it. Comments welcome!

Draws heavily from jsierles 37s_cookbooks (http://github.com/37signals/37s_cookbooks).