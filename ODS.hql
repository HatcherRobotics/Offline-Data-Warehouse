//轨道车辆日志数据（车辆在行驶过程中每半分钟发送） 轨道车辆维度数据（存储在数据库中）
//日志数据采集：将日志数据文件通过Flume导入到Kafka，再从Kafka中将数据通过Flume导入到HDFS
//维度数据采集：每天通过DataX全量同步MySQL的一张表格到HDFS
//hive分区表按天分区
//ODS层：存放未经过处理的原始数据，结构上与源系统保持一致，是数据仓库的数据准备区。
//ODS层的表结构设计依托于从业务系统同步过来的数据结构
//ODS 层要保存全部历史数据，故其压缩格式应选择压缩比较高的，此处选择 gzip
//ODS 层表名的命名规范为：ods_表名_单分区增量全量标识（inc/full）
//轨道车辆日志表（增量日志表）
CREATE DATABASE rolling_stock;
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
    static_axle_weight DOUBLE COMMENT '静轴重',
    wheel_rail_contact_load_0 DOUBLE COMMENT '轮轨垂向静载荷',
    wheel_rail_contact_stress_0 DOUBLE COMMENT '轮轨静载荷作用下轮轨接触应力',
    time_stamp TIMESTAMP COMMENT '日志采集时间'
)   COMMENT '轨道车辆日志表'
    PARTITIONED BY (`dt` STRING COMMENT '统计日期')
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
    LOCATION '/warehouse/rolling_stock/ods/ods_rolling_stock_data_inc';

//轨道车辆信息表（全量表）
DROP TABLE IF EXISTS ods_rolling_stock_info_full;
CREATE EXTERNAL TABLE ods_rolling_stock_info_full(
    id STRING COMMENT '主键',
    line_code STRING COMMENT '线路编号',
    line_type TINYINT COMMENT '行别',
    vehicle_no TINYINT COMMENT '车辆编号'
)   COMMENT '轨道车辆信息表'
    PARTITIONED BY(`dt` STRING COMMENT '统计日期')
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/rolling_stock/ods/ods_rolling_stock_info_full';
