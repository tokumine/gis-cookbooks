default.db_backup[:hostname]                = "postgres_box.com"
default.db_backup[:notification_email]      = "si@tinypla.net"
default.db_backup[:send_notification]       = true 
default.db_backup[:keep_backups_for]        = 60

#FOR S3 backups
default.db_backup[:s3_access_key_id]        = "EDIT ME"
default.db_backup[:s3_secret_access_key]    = "EDIT ME"
default.db_backup[:s3_bucket]               = "/ppe-backups/production/postgis/"
