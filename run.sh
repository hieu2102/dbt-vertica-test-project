#!/bin/bash

source /home/dbt-env/bin/activate
while :
do 
sleep 1
dbt run-operation run_proc

done 
