CREATE EXTERNAL TABLE ods_rolling_stock_data_inc(
    id STRING,
    position_along_track DOUBLE COMMENT '里程',
    velocity DOUBLE COMMENT '速度',
    longitude DOUBLE COMMENT '经度',
    latitude DOUBLE COMMENT '纬度',
    vertical_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨垂向力',
    lateral_wheel_rail_force_left DOUBLE COMMENT '左轮轮轨横向力',
    vertical_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨垂向力',
    lateral_wheel_rail_force_right DOUBLE COMMENT '右轮轮轨横向力',
    vertical_vehicle_acceleration DOUBLE COMMENT '车体垂向振动加速度',
    lateral_vehicle_acceleration DOUBLE COMMENT '车体横向振动加速度',
    vertical_bogie_acceleration DOUBLE COMMENT '转向架垂向振动加速度',
    lateral_bogie_acceleration DOUBLE COMMENT '转向架横向振动加速度',
    vertical_axle_box_acceleration DOUBLE COMMENT '轴箱垂向振动加速度',
    lateral_axle_box_acceleration DOUBLE COMMENT '轴箱横向振动加速度',
    centrifugal_acceleration DOUBLE COMMENT '离心加速度',
    lateral_wheel_axle_force DOUBLE COMMENT '轮轴横向力',
    wheel_rail_contact_load_1 DOUBLE COMMENT '轮轨垂向载荷P1',
    wheel_rail_contact_load_2 DOUBLE COMMENT '轮轨垂向载荷P2',
    wheel_rail_contact_stress_1 DOUBLE COMMENT '轮轨垂向载荷P1对应接触应力',
    wheel_rail_contact_stress_2 DOUBLE COMMENT '轮轨垂向载荷P2对应接触应力',
    ballast_stress DOUBLE COMMENT '道床应力',
    roadbed_stress DOUBLE COMMENT '路基应力',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)   COMMENT '轨道车辆日志表'
    PARTITIONED BY (`dt` STRING COMMENT '统计日期')
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
    LOCATION '/warehouse/rolling_stock/ods/ods_rolling_stock_data_inc';


DROP TABLE IF EXISTS ods_rolling_stock_info_full;
CREATE EXTERNAL TABLE ods_rolling_stock_info_full(
    id STRING COMMENT '主键',
    line_code STRING COMMENT '线路编号',
    line_type TINYINT COMMENT '行别',
    vehicle_no TINYINT COMMENT '车辆编号',
    static_axle_weight DOUBLE COMMENT '静轴重',
    wheel_rail_contact_load_0 DOUBLE COMMENT '轮轨垂向静载荷',
    wheel_rail_contact_stress_0 DOUBLE COMMENT '轮轨静载荷作用下轮轨接触应力'
)   COMMENT '轨道车辆信息表'
    PARTITIONED BY(`dt` STRING COMMENT '统计日期')
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/rolling_stock/ods/ods_rolling_stock_info_full';
