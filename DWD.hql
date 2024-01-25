//轮轨力日志事实表
//建表语句
DROP TABLE IF EXISTS dwd_wheel_rail_force_inc;
CREATE EXTERNAL TABLE dwd_wheel_rail_force_inc(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨垂向力',
    lateral_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨横向力',
    vertical_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨垂向力',
    lateral_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨横向力',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '轮轨力日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_wheel_rail_force_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_wheel_rail_force_inc PARTITION (dt)
SELECT
    id STRING,
    position_along_track DOUBLE ,
    velocity DOUBLE ,
    longitude DOUBLE,
    latitude DOUBLE,
    vertical_wheel_rail_force_left DOUBLE,
    lateral_wheel_rail_force_left DOUBLE ,
    vertical_wheel_rail_force_right DOUBLE ,
    lateral_wheel_rail_force_right DOUBLE ,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_wheel_rail_force_inc PARTITION (dt='2024-01-23')
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE ,
    longitude DOUBLE,
    latitude DOUBLE,
    vertical_wheel_rail_force_left DOUBLE,
    lateral_wheel_rail_force_left DOUBLE ,
    vertical_wheel_rail_force_right DOUBLE ,
    lateral_wheel_rail_force_right DOUBLE ,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';
//加速度日志事实表
//建表语句
DROP TABLE IF EXISTS dwd_acceleration_inc;
CREATE EXTERNAL TABLE dwd_acceleration_inc(
        id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_vehicle_acceleration DOUBLE COMMENT '车体垂向振动加速度',
    lateral_vehicle_acceleration DOUBLE COMMENT '车体横向振动加速度',
    vertical_bogie_acceleration DOUBLE COMMENT '转向架垂向振动加速度',
    lateral_bogie_acceleration DOUBLE COMMENT '转向架横向振动加速度',
    vertical_axle_box_acceleration DOUBLE COMMENT '轴箱垂向振动加速度',
    lateral_axle_box_acceleration DOUBLE COMMENT '轴箱横向振动加速度',
    centrifugal_acceleration DOUBLE COMMENT '离心加速度',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '加速度日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_acceleration_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_acceleration_inc PARTITION (dt)
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    vertical_vehicle_acceleration DOUBLE,
    lateral_vehicle_acceleration DOUBLE,
    vertical_bogie_acceleration DOUBLE,
    lateral_bogie_acceleration DOUBLE,
    vertical_axle_box_acceleration DOUBLE,
    lateral_axle_box_acceleration DOUBLE,
    centrifugal_acceleration DOUBLE,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_acceleration_inc PARTITION (dt='2024-01-23')
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    vertical_vehicle_acceleration DOUBLE,
    lateral_vehicle_acceleration DOUBLE,
    vertical_bogie_acceleration DOUBLE,
    lateral_bogie_acceleration DOUBLE,
    vertical_axle_box_acceleration DOUBLE,
    lateral_axle_box_acceleration DOUBLE,
    centrifugal_acceleration DOUBLE,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';
//轮轴横向力日志事实表
//建表语句
DROP TABLE IF EXISTS dwd_wheel_axle_force_inc;
CREATE EXTERNAL TABLE dwd_wheel_axle_force_inc(
        id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    lateral_wheel_axle_force DOUBLE COMMENT '轮轴横向力',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)COMMENT '轮轴横向力日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_wheel_axle_force_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_wheel_axle_force_inc PARTITION (dt)
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    lateral_wheel_axle_force DOUBLE,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_wheel_axle_force_inc PARTITION (dt='2024-01-23')
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    lateral_wheel_axle_force DOUBLE,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';
//应力日志事实表
//建表语句
DROP TABLE IF EXISTS dwd_stress_inc;
CREATE EXTERNAL TABLE dwd_stress_inc(
        id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    wheel_rail_contact_stress_1 DOUBLE COMMENT '轮轨垂向载荷P1对应接触应力',
    wheel_rail_contact_stress_2 DOUBLE COMMENT '轮轨垂向载荷P2对应接触应力',
    ballast_stress DOUBLE COMMENT '道床应力',
    roadbed_stress DOUBLE COMMENT '路基应力',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)COMMENT '应力日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_stress_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_stress_inc PARTITION (dt)
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    wheel_rail_contact_stress_1 DOUBLE,
    wheel_rail_contact_stress_2 DOUBLE,
    ballast_stress DOUBLE,
    roadbed_stress DOUBLE,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_stress_inc PARTITION (dt='2024-01-23')
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    wheel_rail_contact_stress_1 DOUBLE,
    wheel_rail_contact_stress_2 DOUBLE,
    ballast_stress DOUBLE,
    roadbed_stress DOUBLE,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';
//载荷日志事实表
//建表语句
DROP TABLE IF EXISTS dwd_load_inc;
CREATE EXTERNAL TABLE dwd_load_inc(
        id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    wheel_rail_contact_load_1 DOUBLE COMMENT '轮轨垂向载荷P1',
    wheel_rail_contact_load_2 DOUBLE COMMENT '轮轨垂向载荷P2',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)COMMENT '载荷日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_load_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_load_inc PARTITION (dt)
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    wheel_rail_contact_load_1 DOUBLE,
    wheel_rail_contact_load_2 DOUBLE ,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_load_inc PARTITION (dt='2024-01-23')
SELECT
    id STRING,
    position_along_track DOUBLE,
    velocity DOUBLE,
    longitude DOUBLE,
    latitude DOUBLE,
    wheel_rail_contact_load_1 DOUBLE,
    wheel_rail_contact_load_2 DOUBLE ,
    time_stamp TIMESTAMP
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';
