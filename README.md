# cptb
Copy tables between postgres database.

## What does it?
Occasionally data synchronization requests come in to DBA, when we are operating database systems.
This bash script is made easy to use and based on \copy psql command. and running on my local pc by proxy(The turnneling severs are in .cptb.props)
cptb does copy tables from postgresql to postgresql.

## Prerequisites
cpdb is a tiny bash shell script so it needs some install before use.

### psql
> <span style='color: #9061ff'> PostgreSQL interactive terminal </span>
> 
> psql 13.9
>
> https://www.postgresql.org/download/

Here is sample for installing required before use cptb.

```bash
$ sudo tee /etc/yum.repos.d/pgdg.repo << EOF
[pgdg13]
name=PostgreSQL 13 for RHEL/CentOS 7 - x86_64
baseurl=https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-7-x86_64
enabled=1
gpgcheck=0
EOF

$ sudo yum update

$ sudo yum install postgresql13 postgresql13-server
```

## Usage
And use like this
```bash
$ tee cptb.txt << EDS
ldcchnls.dccnt_tmr_ofdty_apts_basc   => You can puut in the name of tables here, between "EDS"
EDS
ldcchnls.dccnt_tmr_ofdty_apts_basc
$
```
```bash
$ ./cptb.sh qa dev
This will be overwrite tables, are you sure to continue (y/n)? y
Started at Fri, Feb 10, 2023 10:26:28 AM
+[ ldcchnls.dccnt_tmr_ofdty_apts_basc ]  [ qa -> dev ]
COPY 1
ldcchnls.dccnt_tmr_ofdty_apts_basc copy completed. [ OK ]
Finished at Fri, Feb 10, 2023 10:26:41 AM

$ ./cptb.sh qa prd
This will be overwrite tables, are you sure to continue (y/n)? y
Started at Fri, Feb 10, 2023 10:29:40 AM
+[ ldcchnls.dccnt_tmr_ofdty_apts_basc ]  [ qa -> prd ]
COPY 1
ldcchnls.dccnt_tmr_ofdty_apts_basc copy completed. [ OK ]
Finished at Fri, Feb 10, 2023 10:29:55 AM

$ ./cptb.sh qa stg
This will be overwrite tables, are you sure to continue (y/n)? y
Started at Fri, Feb 10, 2023 10:28:54 AM
+[ ldcchnls.dccnt_tmr_ofdty_apts_basc ]  [ qa -> stg ]
COPY 1
ldcchnls.dccnt_tmr_ofdty_apts_basc copy completed. [ OK ]
Finished at Fri, Feb 10, 2023 10:29:11 AM

$ ./cptb.sh prd qa
This will be overwrite tables, are you sure to continue (y/n)? y
Started at Fri, Feb 10, 2023 10:36:51 AM
+[ ldcchnls.dccnt_tmr_ofdty_apts_basc ]  [ prd -> qa ]
ERROR:  duplicate key value violates unique constraint "pk_dccnt_tmr_ofdty_apts_basc"
DETAIL:  Key (tmr_ofdty_apts_srno)=(1) already exists.
CONTEXT:  COPY dccnt_tmr_ofdty_apts_basc, line 1
ldcchnls.dccnt_tmr_ofdty_apts_basc copy completed. [ OK ]
Finished at Fri, Feb 10, 2023 10:37:06 AM
```