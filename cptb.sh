#!/bin/sh
# cptb.sh : copy tables
source ~/.bash_profile
source ./.cptb.props

if [ $# != 2 ]; then
  echo "Invalid arguments"
  echo "Usage : ./cptb.sh [env_from] [env_to]"
  echo "        [env] : dev, qa, mgqa, stg, mgstg, prd, mgprd"
  echo " * Input your tables for copy in the file ./cptb.txt"
  exit 1
fi
list_of_args="dev qa mgqa stg prd"
function not_exists_in_args() {
  for arg in $list_of_args; do
    if [ "$arg" = "$1" ]; then
      return 1
    fi
  done
  return 0
}
if not_exists_in_args $1; then
  echo "'$1' is not exists in environment list (dev, qa, mgqa, stg, mgstg, prd, mgprd)"
  exit 1
fi
if not_exists_in_args $2; then
  echo "'$2' is not exists in environment list (dev, qa, mgqa, stg, mgstg, prd, mgprd)"
  exit 1
fi

#while [ -z $prompt ]; do read -p "This will be overwrite tables, are you sure to continue (y/n)? " choice;case "$choice" in y|Y ) prompt=true; break;; n|N ) exit 0;; esac; done; prompt=

MSG_DRTN="$1 -> $2"

echo Started at `date`

SRC_HOST=$(eval echo \$$1_host); SRC_PORT=$(eval echo \$$1_port); SRC_DBNM=$(eval echo \$$1_dbnm); SRC_USER=$(eval echo \$$1_user); SRC_PSWD=$(eval echo \$$1_pswd)
TRG_HOST=$(eval echo \$$2_host); TRG_PORT=$(eval echo \$$2_port); TRG_DBNM=$(eval echo \$$2_dbnm); TRG_USER=$(eval echo \$$2_user); TRG_PSWD=$(eval echo \$$2_pswd)

for tab in `cat ./cptb.txt`; do
  echo -e "\e[38;5;51m+[ ${tab} ] \e[m \e[38;5;210m[ ${MSG_DRTN} ]\e[m"

  export PGPASSWORD=$(echo ${SRC_PSWD} |openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:'pick.your.password' -d); psql -h ${SRC_HOST} -p ${SRC_PORT} -d ${SRC_DBNM} -U ${SRC_USER} -c "\copy ${tab} to stdout with (format csv, NULL 'NULL', delimiter ',', quote '\"', escape '\')"  |( export PGPASSWORD=$(echo ${TRG_PSWD} |openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:'pick.your.password' -d) && psql -h ${TRG_HOST} -p ${TRG_PORT} -d ${TRG_DBNM} -U ${TRG_USER} -c "\copy ${tab} from stdin with (format csv, NULL 'NULL', delimiter ',', quote '\"', escape '\');")

  echo ""

  if [ $? == 0 ]; then
    echo -e "${tab} copy completed. [ \e[1;32mOK\e[m ]"
  fi

done

echo Finished at `date`