//车辆运行安全性异常单日累计表
//脱轨系数 轮重减载率 倾覆系数
//建表语句
DROP TABLE IF EXISTS dws_safety_1d;
CREATE EXTERNAL TABLE dws_safety_1d(
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
)COMMENT '车辆运行安全性异常单日累计表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_safety_1d'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
INSERT OVERWRITE TABLE dws_safety_1d PARTITION (dt)
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
    derailment_coefficient_left,
    derailment_coefficient_right,
    wheel_load_reduction_rate,
    overturning_coefficient,
    time_stamp,
    dt
FROM rolling_stock.dwd_safety_inc
WHERE dt<='2024-01-22'
AND (ABS(derailment_coefficient_left)>0.8
    OR ABS(derailment_coefficient_right)>0.8
    OR wheel_load_reduction_rate>0.6
    OR overturning_coefficient>0.8)
GROUP BY id
ORDER BY id,position_along_track;
//每日装载
INSERT OVERWRITE TABLE dws_safety_1d PARTITION (dt='2024-01-23')
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
    derailment_coefficient_left,
    derailment_coefficient_right,
    wheel_load_reduction_rate,
    overturning_coefficient,
    time_stamp
FROM rolling_stock.dwd_safety_inc
WHERE dt='2024-01-23'
AND (ABS(derailment_coefficient_left)>0.8
    OR ABS(derailment_coefficient_right)>0.8
    OR wheel_load_reduction_rate>0.6
    OR overturning_coefficient>0.8)
GROUP BY id
ORDER BY id,position_along_track;
//车辆运行稳定性异常单日累计表
//蛇行运动
//建表语句
DROP TABLE IF EXISTS dws_hunting_1d;
CREATE EXTERNAL TABLE dws_hunting_1d(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    lateral_bogie_acceleration DOUBLE COMMENT '转向架横向振动加速度',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '车辆运行稳定性异常单日累计表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_hunting_1d'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
INSERT OVERWRITE TABLE dws_hunting_1d PARTITION (dt)
SELECT id,
       position_along_track,
       velocity,
       longitude,
       latitude,
       lateral_bogie_acceleration,
       time_stamp,
       dt
FROM
(SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    lateral_bogie_acceleration,
    LAG(lateral_bogie_acceleration,1) lba1,
    LAG(lateral_bogie_acceleration,2) lba2,
    LAG(lateral_bogie_acceleration,3) lba3,
    LAG(lateral_bogie_acceleration,4) lba4,
    LAG(lateral_bogie_acceleration,5) lba5,
    time_stamp,
    dt
FROM rolling_stock.dwd_hunting_inc) t1
WHERE t1.lba1>8 AND t1.lba2>8 AND t1.lba3>8 AND t1.lba4>8 AND t1.lba5>8 AND t1.lateral_bogie_acceleration>8
        AND dt<='2024-01-22'
GROUP BY id
ORDER BY id,position_along_track;
//每日装载
INSERT OVERWRITE TABLE dws_hunting_1d PARTITION (dt='2024-01-23')
SELECT id,
       position_along_track,
       velocity,
       longitude,
       latitude,
       lateral_bogie_acceleration,
       time_stamp
FROM
(SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    lateral_bogie_acceleration,
    LAG(lateral_bogie_acceleration,1) lba1,
    LAG(lateral_bogie_acceleration,2) lba2,
    LAG(lateral_bogie_acceleration,3) lba3,
    LAG(lateral_bogie_acceleration,4) lba4,
    LAG(lateral_bogie_acceleration,5) lba5,
    time_stamp
FROM rolling_stock.dwd_hunting_inc) t1
WHERE t1.lba1>8 AND t1.lba2>8 AND t1.lba3>8 AND t1.lba4>8 AND t1.lba5>8 AND t1.lateral_bogie_acceleration>8
        AND dt='2024-01-23'
GROUP BY id
ORDER BY id,position_along_track;
//车辆运行平稳性异常单日累计表
//车体振动加速度 通过曲线舒适度
//建表语句
DROP TABLE IF EXISTS dws_stationarity_1d;
CREATE EXTERNAL TABLE dws_stationarity_1d(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_vehicle_acceleration DOUBLE COMMENT '车体垂向振动加速度',
    lateral_vehicle_acceleration DOUBLE COMMENT '车体横向振动加速度',
    centrifugal_acceleration DOUBLE COMMENT '离心加速度',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '车辆运行平稳性异常单日累计表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_stationarity_1d'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
INSERT OVERWRITE TABLE dws_stationarity_1d PARTITION (dt)
SELECT
    id,
    position_along_track,
    velocity,
    longitude,
    latitude,
    vertical_vehicle_acceleration,
    lateral_vehicle_acceleration,
    centrifugal_acceleration,
    time_stamp,
    dt
FROM rolling_stock.dwd_stationarity_inc
WHERE  dt<='2024-01-22' AND
    (vertical_vehicle_acceleration>0.00215*velocity+0.16
   OR lateral_vehicle_acceleration>0.00135*velocity+0.18
   OR centrifugal_acceleration>0.784)
GROUP BY id
ORDER BY id,position_along_track;
//每日装载
INSERT OVERWRITE TABLE dws_stationarity_1d PARTITION (dt='2024-01-23')
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
FROM rolling_stock.dwd_stationarity_inc
WHERE  dt='2024-01-23' AND
    (vertical_vehicle_acceleration>0.00215*velocity+0.16
   OR lateral_vehicle_acceleration>0.00135*velocity+0.18
   OR centrifugal_acceleration>0.784)
GROUP BY id
ORDER BY id,position_along_track;
//车辆与轨道相互作用异常单日累计表
//轮轨垂向力 轮轨横向力 轮轴横向力 线路横向稳定性系数 轮轨接触应力 道床应力 路基应力
//建表语句
DROP TABLE IF EXISTS dws_rail_dynamic_interaction_1d;
CREATE EXTERNAL TABLE dws_rail_dynamic_interaction_1d(
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
) COMMENT '车辆与轨道相互作用异常单日累计表'
PARTITIONED BY (`dt` STRING COMMENT'统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_rail_dynamic_interaction_1d'
TBLPROPERTIES ('orc.compress' = 'snappy');
//数据装载
//首日装载
INSERT OVERWRITE TABLE dws_rail_dynamic_interaction_1d PARTITION (dt)
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
    lateral_stability_coefficient,
    wheel_rail_contact_stress_1,
    wheel_rail_contact_stress_2,
    ballast_stress,
    roadbed_stress,
    time_stamp,
    dt
FROM rolling_stock.dwd_rail_dynamic_interaction_inc
WHERE dt<='2024-01-22' AND
      (vertical_wheel_rail_force_left>170
      OR vertical_wheel_rail_force_right>170
      OR lateral_wheel_rail_force_left>0.4*static_axle_weight
      OR lateral_wheel_rail_force_right>0.4*static_axle_weight
      OR lateral_wheel_axle_force>0.85*(10+static_axle_weight/3)
      OR lateral_stability_coefficient>1
      OR wheel_rail_contact_stress_1>1600
      OR wheel_rail_contact_stress_2>1600
      OR ballast_stress>0.5
      OR roadbed_stress>0.15)
GROUP BY id
ORDER BY id,position_along_track;
//每日装载
INSERT OVERWRITE TABLE dws_rail_dynamic_interaction_1d PARTITION (dt='2024-01-23')
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
    lateral_stability_coefficient,
    wheel_rail_contact_stress_1,
    wheel_rail_contact_stress_2,
    ballast_stress,
    roadbed_stress,
    time_stamp
FROM rolling_stock.dwd_rail_dynamic_interaction_inc
WHERE dt='2024-01-22' AND
      (vertical_wheel_rail_force_left>170
      OR vertical_wheel_rail_force_right>170
      OR lateral_wheel_rail_force_left>0.4*static_axle_weight
      OR lateral_wheel_rail_force_right>0.4*static_axle_weight
      OR lateral_wheel_axle_force>0.85*(10+static_axle_weight/3)
      OR lateral_stability_coefficient>1
      OR wheel_rail_contact_stress_1>1600
      OR wheel_rail_contact_stress_2>1600
      OR ballast_stress>0.5
      OR roadbed_stress>0.15)
GROUP BY id
ORDER BY id,position_along_track;