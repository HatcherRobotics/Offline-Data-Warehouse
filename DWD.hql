//车辆运行安全性日志事实表
//脱轨系数 轮重减载率 倾覆系数
//建表语句
DROP TABLE IF EXISTS dwd_safety_inc;
CREATE EXTERNAL TABLE dwd_safety_inc(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨垂向力',
    lateral_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨横向力',
    vertical_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨垂向力',
    lateral_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨横向力',
    derailment_coefficient_left DOUBLE COMMENT '左轮脱轨系数',
    derailment_coefficient_right DOUBLE COMMENT '右轮脱轨系数',
    wheel_load_reduction_rate DOUBLE COMMENT '轮重减载率',
    overturning_coefficient DOUBLE COMMENT '倾覆系数',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '安全性相关日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_safety_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_safety_inc PARTITION (dt)
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_wheel_rail_force_left,
    lateral_wheel_rail_force_left,
    vertical_wheel_rail_force_right,
    lateral_wheel_rail_force_right,
    lateral_wheel_rail_force_left/vertical_wheel_rail_force_left AS derailment_coefficient_left,
    lateral_wheel_rail_force_right/vertical_wheel_rail_force_right AS derailment_coefficient_right,
    LEAST(vertical_wheel_rail_force_left/wheel_rail_contact_stress_0,vertical_wheel_rail_force_right/wheel_rail_contact_stress_0) AS wheel_load_reduction_rate,
    ABS(vertical_wheel_rail_force_left-vertical_wheel_rail_force_right)/(vertical_wheel_rail_force_left+vertical_wheel_rail_force_right) AS overturning_coefficient,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_safety_inc PARTITION (dt='2024-01-23')
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_wheel_rail_force_left,
    lateral_wheel_rail_force_left,
    vertical_wheel_rail_force_right,
    lateral_wheel_rail_force_right,
    lateral_wheel_rail_force_left/vertical_wheel_rail_force_left AS derailment_coefficient_left,
    lateral_wheel_rail_force_right/vertical_wheel_rail_force_right AS derailment_coefficient_right,
    LEAST(vertical_wheel_rail_force_left/wheel_rail_contact_stress_0,vertical_wheel_rail_force_right/wheel_rail_contact_stress_0) AS wheel_load_reduction_rate,
    ABS(vertical_wheel_rail_force_left-vertical_wheel_rail_force_right)/(vertical_wheel_rail_force_left+vertical_wheel_rail_force_right) AS overturning_coefficient,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';

//车辆运行稳定性日志事实表
//蛇行运动
//建表语句
DROP TABLE IF EXISTS dwd_hunting_inc;
CREATE EXTERNAL TABLE dwd_hunting_inc(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    lateral_bogie_acceleration DOUBLE COMMENT '转向架横向振动加速度',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '稳定性相关日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_hunting_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_hunting_inc PARTITION (dt)
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    lateral_bogie_acceleration,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_hunting_inc PARTITION (dt='2024-01-23')
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    lateral_bogie_acceleration,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';

//车辆运行平稳性日志事实表
//车体振动加速度 通过曲线舒适度
//建表语句
DROP TABLE IF EXISTS dwd_stationarity_inc;
CREATE EXTERNAL TABLE dwd_stationarity_inc(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_vehicle_acceleration DOUBLE COMMENT '车体垂向振动加速度',
    lateral_vehicle_acceleration DOUBLE COMMENT '车体横向振动加速度',
    centrifugal_acceleration DOUBLE COMMENT '离心加速度',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '平稳性相关日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_stationarity_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_stationarity_inc PARTITION (dt)
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_vehicle_acceleration,
    lateral_vehicle_acceleration,
    centrifugal_acceleration,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_stationarity_inc PARTITION (dt='2024-01-23')
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_vehicle_acceleration,
    lateral_vehicle_acceleration,
    centrifugal_acceleration,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';

//车辆与轨道相互作用日志事实表
//轮轨垂向力 轮轨横向力 轮轴横向力 线路横向稳定性系数 轮轨接触应力 道床应力 路基应力
//建表语句
DROP TABLE IF EXISTS dwd_rail_dynamic_interaction_inc;
CREATE EXTERNAL TABLE dwd_rail_dynamic_interaction_inc(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨垂向力',
    vertical_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨垂向力',
    static_axle_weight DOUBLE COMMENT '静轴重',
    lateral_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨横向力',
    lateral_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨横向力',
    lateral_wheel_axle_force DOUBLE COMMENT '轮轴横向力',
    lateral_stability_coefficient DOUBLE COMMENT '线路横向稳定性系数',
    wheel_rail_contact_stress_1 DOUBLE COMMENT '轮轨垂向载荷P1对应接触应力',
    wheel_rail_contact_stress_2 DOUBLE COMMENT '轮轨垂向载荷P2对应接触应力',
    ballast_stress DOUBLE COMMENT '道床应力',
    roadbed_stress DOUBLE COMMENT '路基应力',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '车辆与轨道相互作用日志事实表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dwd/dwd_rail_dynamic_interaction_inc'
TBLPROPERTIES ('orc.compress' = 'snappy');
//首日装载
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rolling_stock.dwd_rail_dynamic_interaction_inc PARTITION (dt)
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_wheel_rail_force_left,
    vertical_wheel_rail_force_right,
    static_axle_weight,
    lateral_wheel_rail_force_left,
    lateral_wheel_rail_force_right,
    lateral_wheel_axle_force,
    ABS((lateral_wheel_rail_force_left+lateral_wheel_rail_force_right)/(10+(vertical_wheel_rail_force_left+vertical_wheel_rail_force_right)/3))  AS lateral_stability_coefficient,
    wheel_rail_contact_stress_1,
    wheel_rail_contact_stress_2,
    ballast_stress,
    roadbed_stress,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt<='2024-01-22';
//每日装载
INSERT OVERWRITE TABLE rolling_stock.dwd_rail_dynamic_interaction_inc PARTITION (dt='2024-01-23')
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_wheel_rail_force_left,
    vertical_wheel_rail_force_right,
    static_axle_weight,
    lateral_wheel_rail_force_left,
    lateral_wheel_rail_force_right,
    lateral_wheel_axle_force,
    ABS((lateral_wheel_rail_force_left+lateral_wheel_rail_force_right)/(10+(vertical_wheel_rail_force_left+vertical_wheel_rail_force_right)/3))  AS lateral_stability_coefficient,
    wheel_rail_contact_stress_1,
    wheel_rail_contact_stress_2,
    ballast_stress,
    roadbed_stress,
    time_stamp
FROM rolling_stock.ods_rolling_stock_data_inc
WHERE dt='2024-01-23';