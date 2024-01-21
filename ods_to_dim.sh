#!/bin/bash

APP='rolling_stock'

if [ -n "$2" ]; then
    do_date=$2
else
    do_date=$(date -d '-1 day' +%F)
fi

dim_rolling_stock_info_full="
insert overwrite table ${APP}.dim_rolling_stock_info_full partition (dt = '$do_date')
select id,
       line_code,
       line_type,
       vehicle_no,
       static_axle_weight,
       wheel_rail_contact_force_0,
       wheel_rail_contact_stress_0
from ${APP}.ods_rolling_stock_info_full o
where o.dt = '$do_date';
"

case $1 in
'dim_rolling_stock_info_full')
    hive -e "${dim_rolling_stock_info_full}"
    ;;
"all")
    hive -e "${dim_rolling_stock_info_full}"
    ;;
esac
