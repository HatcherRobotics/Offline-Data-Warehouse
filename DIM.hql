//轨道车辆信息维度表
//1.建表语句
DROP TABLE IF EXISTS dim_rolling_stock_info_full;
CREATE EXTERNAL TABLE dim_rolling_stock_info_full(
    id STRING COMMENT '主键',
    line_code STRING COMMENT '线路编号',
    line_type TINYINT COMMENT '行别',
    vehicle_no TINYINT COMMENT '车辆编号',
    static_axle_weight DOUBLE COMMENT '静轴重',
    wheel_rail_contact_force_0 DOUBLE COMMENT '轮轨垂向静载荷',
    wheel_rail_contact_stress_0 DOUBLE COMMENT '轮轨静载荷作用下轮轨接触应力'
)   COMMENT '轨道车辆信息维度表'
    PARTITIONED BY (`dt` STRING COMMENT '统计日期')
    STORED AS ORC
    LOCATION '/warehouse/rolling_stock/dim/dim_rolling_stock_info_full'
    TBLPROPERTIES ('orc.compress' = 'snappy');
//2.数据装载
INSERT OVERWRITE TABLE dim_rolling_stock_info_full PARTITION (dt = '2024-01-24')
SELECT id,
       line_code,
       line_type,
       vehicle_no,
       static_axle_weight,
       wheel_rail_contact_force_0,
       wheel_rail_contact_stress_0
FROM rolling_stock.ods_rolling_stock_info_full o
WHERE o.dt = '2024-01-24';
//日志编码维度表
//1.建表语句
DROP TABLE IF EXISTS dim_code_full;
CREATE EXTERNAL TABLE dim_code_full(
    `type` STRING COMMENT '编码类型',
    `code_id` STRING COMMENT '编码ID',
    `code_name` STRING COMMENT '编码名称'
)   COMMENT '日志编码维度表'
    STORED AS ORC
    LOCATION '/warehouse/rolling_stock/dim/dim_code_full'
    TBLPROPERTIES ('orc.compress'='snappy');
//2.数据装载
DROP TABLE IF EXISTS tmp_code_full;
CREATE EXTERNAL TABLE tmp_code_full(
    `type` STRING COMMENT '编码类型',
    `code_id` STRING COMMENT '编码ID',
    `code_name` STRING COMMENT '编码名称'
)   COMMENT '日志编码维度表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/rolling_stock/tmp/tmp_code_full';
INSERT INTO dim_code_full SELECT * FROM tmp_code_full;
