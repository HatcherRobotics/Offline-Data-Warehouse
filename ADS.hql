//车辆运行安全性异常单月统计
DROP TABLE IF EXISTS ads_safety_last_month;
CREATE EXTERNAL TABLE ads_safety_last_month(
    id STRING,
    top_longitude DOUBLE COMMENT '最应关注位置',
    top_latitude DOUBLE COMMENT '最应关注位置',
    max_derailment_coefficient DOUBLE COMMENT '最大异常脱轨系数',
    max_wheel_load_reduction_rate DOUBLE COMMENT '最大异常轮重减载率',
    max_overturning_coefficient DOUBLE COMMENT '最大异常倾覆系数',
    derailment_coefficient_anomaly_num INTEGER COMMENT '脱轨系数异常次数',
    wheel_load_reduction_rate_anomaly_num INTEGER COMMENT '轮重减载率异常次数',
    overturning_coefficient_anomaly_num INTEGER COMMENT '倾覆系数异常次数'
) COMMENT '车辆运行安全性异常单月统计'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/warehouse/rolling_stock/ads/ads_safety_last_month';
//车辆运行稳定性异常单月统计
DROP TABLE IF EXISTS ads_hunting_last_month;
CREATE EXTERNAL TABLE ads_safety_last_month(
    id STRING,
    top_longitude DOUBLE COMMENT '最应关注位置',
    top_latitude DOUBLE COMMENT '最应关注位置',
    max_lateral_bogie_acceleration DOUBLE COMMENT '最大异常加速度',
    hunting_anomaly_num INTEGER COMMENT '蛇行运动异常次数'
) COMMENT '车辆运行稳定性异常单月统计'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/warehouse/rolling_stock/ads/ads_hunting_last_month';
//车辆运行平稳性异常单月统计
DROP TABLE IF EXISTS ads_stationarity_last_month;
CREATE EXTERNAL TABLE ads_stationarity_last_month(
    id STRING,
    top_longitude DOUBLE COMMENT '最应关注位置',
    top_latitude DOUBLE COMMENT '最应关注位置',
    max_vertical_vehicle_acceleration DOUBLE COMMENT '最大异常车体垂向加速度',
    max_lateral_vehicle_acceleration DOUBLE COMMENT '最大异常车体横向加速度',
    max_centrifugal_acceleration DOUBLE COMMENT '最大异常离心加速度',
    vertical_vehicle_acceleration_anomaly_num INTEGER COMMENT '车体垂向加速度异常次数',
    lateral_vehicle_acceleration_anomaly_num INTEGER COMMENT '车体横向加速度异常次数',
    centrifugal_acceleration_anomaly_num INTEGER COMMENT '离心加速度异常次数'
) COMMENT '车辆运行平稳性异常单月统计'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/warehouse/rolling_stock/ads/ads_stationarity_last_month';
//车辆与轨道相互作用异常单月统计
DROP TABLE IF EXISTS ads_rail_dynamic_interaction_last_month;
CREATE EXTERNAL TABLE ads_rail_dynamic_interaction_last_month(
    id STRING,
    top_longitude DOUBLE COMMENT '最应关注位置',
    top_latitude DOUBLE COMMENT '最应关注位置',
    max_vertical_wheel_rail_force_left DOUBLE COMMENT '最大异常左轮轮轨垂向力',
    max_vertical_wheel_rail_force_right DOUBLE COMMENT '最大异常右轮轮轨垂向力',
    max_lateral_wheel_rail_force_left DOUBLE COMMENT '最大异常左轮轮轨横向力',
    max_lateral_wheel_rail_force_right DOUBLE COMMENT '最大异常右轮轮轨横向力',
    max_lateral_stability_coefficient DOUBLE COMMENT '最大异常线路横向稳定性系数',
    max_wheel_rail_contact_stress_1 DOUBLE COMMENT '最大异常轮轨垂向载荷P1对应接触应力',
    max_wheel_rail_contact_stress_2 DOUBLE COMMENT '最大异常轮轨垂向载荷P2对应接触应力',
    max_ballast_stress DOUBLE COMMENT '最大异常道床应力',
    max_roadbed_stress DOUBLE COMMENT '最大异常路基应力',
    vertical_wheel_rail_force_left_anomaly_num INTEGER COMMENT '左轮轮轨垂向力异常次数',
    vertical_wheel_rail_force_right_anomaly_num INTEGER COMMENT '右轮轮轨垂向力异常次数',
    lateral_wheel_rail_force_left_anomaly_num INTEGER COMMENT '左轮轮轨横向力异常次数',
    lateral_wheel_rail_force_right_anomaly_num INTEGER COMMENT '右轮轮轨横向力异常次数',
    lateral_stability_coefficient_anomaly_num INTEGER COMMENT '线路横向稳定性系数异常次数',
    wheel_rail_contact_stress_1_anomaly_num INTEGER COMMENT '轮轨垂向载荷P1对应接触应力异常次数',
    wheel_rail_contact_stress_2_anomaly_num INTEGER COMMENT '轮轨垂向载荷P2对应接触应力异常次数',
    ballast_stress_anomaly_num INTEGER COMMENT '道床应力异常次数',
    roadbed_stress_anomaly_num INTEGER COMMENT '路基应力异常次数'
)COMMENT '车辆与轨道相互作用异常单月统计'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/warehouse/rolling_stock/ads/ads_rail_dynamic_interaction_last_month';