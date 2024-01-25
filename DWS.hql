//车辆运行安全性汇总表:脱轨系数 轮重减载率 倾覆系数
//建表语句
DROP TABLE IF EXISTS dws_rolling_stock_safety_detail;
CREATE EXTERNAL TABLE dws_rolling_stock_safety_detail(
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
    derailment_coefficient_decision BOOLEAN COMMENT '脱轨系数决策',
    wheel_load_reduction_rate_decision BOOLEAN COMMENT '轮重减载率决策',
    overturning_coefficient_decision BOOLEAN COMMENT '倾覆系数决策',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '车辆运行安全性汇总表'
PARTITIONED BY (`dt` STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_rolling_stock_safety_detail'
TBLPROPERTIES ('orc.compress'='snappy');
//数据装载
//首日装载
INSERT OVERWRITE TABLE dws_rolling_stock_safety_detail PARTITION (dt)
SELECT id,
       position_along_track,
       velocity,
       longitude,
       vertical_wheel_rail_force_left,
       lateral_wheel_rail_force_left,
       vertical_wheel_rail_force_right,
       lateral_wheel_rail_force_right,
       lateral_wheel_rail_force_left/vertical_wheel_rail_force_left AS derailment_coefficient_left,
       lateral_wheel_rail_force_right/vertical_wheel_rail_force_right AS derailment_coefficient_right,
       MIN(vertical_wheel_rail_force_left,vertical_wheel_rail_force_right)/(SELECT wheel_rail_contact_stress_0 FROM dim_rolling_stock_info_full) AS wheel_load_reduction_rate,
       ABS(vertical_wheel_rail_force_left-vertical_wheel_rail_force_right)/(vertical_wheel_rail_force_left+vertical_wheel_rail_force_right) AS overturning_coefficient,


FROM dwd_wheel_rail_force_inc WHERE dt<'2024-01-25' GROUP BY dt;

//每日装载
//车辆运行稳定性汇总表:蛇行运动
//建表语句
DROP TABLE IF EXISTS dws_rolling_stock_hunting_detail;
CREATE EXTERNAL TABLE dws_rolling_stock_hunting_detail(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    lateral_bogie_acceleration DOUBLE COMMENT '转向架横向振动加速度',
    hunting_instability_decision BOOLEAN COMMENT '蛇行失稳决策',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
) COMMENT '车辆运行稳定性汇总表'
PARTITIONED BY (`dt` STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_rolling_stock_hunting_detail'
TBLPROPERTIES ('orc.compress'='snappy');
//数据装载
//首日装载
//每日装载
//车辆运行平稳性汇总表:车体振动加速度 通过曲线舒适度
//建表语句
DROP TABLE IF EXISTS dws_rolling_stock_stationarity_detail;
CREATE EXTERNAL TABLE dws_rolling_stock_stationarity_detail(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_vehicle_acceleration DOUBLE COMMENT '车体垂向振动加速度',
    lateral_vehicle_acceleration DOUBLE COMMENT '车体横向振动加速度',
    centrifugal_acceleration DOUBLE COMMENT '离心加速度',
    vehicle_vibration_acceleration BOOLEAN COMMENT '车体振动加速度决策',
    curve_comfort BOOLEAN COMMENT'通过曲线舒适度决策',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)COMMENT '车辆运行平稳性汇总表'
PARTITIONED BY (`dt` STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_rolling_stock_stationarity_detail'
TBLPROPERTIES ('orc.compress'='snappy');
//数据装载
//首日装载
//每日装载
//车辆与轨道相互作用汇总表
//建表语句
DROP TABLE IF EXISTS dws_rolling_stock_rail_dynamic_interaction_detail;
CREATE EXTERNAL TABLE dws_rolling_stock_rail_dynamic_interaction_detail(
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
    vertical_wheel_rail_force_decision BOOLEAN COMMENT '轮轨垂向力决策',
    lateral_wheel_rail_force_decision BOOLEAN COMMENT '轮轨横向力决策',
    lateral_wheel_axle_force_decision BOOLEAN COMMENT '轮轴横向力决策',
    lateral_stability_coefficient_decision BOOLEAN COMMENT '线路横向稳定性系数决策',
    wheel_rail_contact_stress_decision BOOLEAN COMMENT '轮轨接触应力决策',
    ballast_stress_decision BOOLEAN COMMENT '道床应力决策',
    roadbed_stress_decision BOOLEAN COMMENT '路基应力决策',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)COMMENT '车辆与轨道相互作用汇总表'
PARTITIONED BY (`dt` STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/rolling_stock/dws/dws_rolling_stock_rail_dynamic_interaction_detail'
TBLPROPERTIES ('orc.compress'='snappy');
//数据装载
//首日装载
//每日装载