CREATE OR REPLACE TABLE `rapido-data-engineering.rapido_data_warehouse.tbl_analytics` AS (
    SELECT
        f.trip_id,
        f.VendorID,
        d.tpep_pickup_datetime,
        d.pick_hour,
        d.pick_day,
        d.pick_month,
        d.pick_year,
        d.pick_weekday,
        d.tpep_dropoff_datetime,
        d.drop_hour,
        d.drop_day,
        d.drop_month,
        d.drop_year,
        d.drop_weekday,
        p.passenger_count,
        t.trip_distance,
        r.rate_code_name AS service_category,
        pick.pickup_latitude,
        pick.pickup_longitude,
        drop_loc.dropoff_latitude,
        drop_loc.dropoff_longitude,
        pay.payment_type_name AS payment_method,
        f.fare_amount,
        f.extra,
        f.mta_tax,
        f.tip_amount,
        f.tolls_amount,
        f.improvement_surcharge,
        f.total_amount
    FROM `rapido-data-engineering.rapido_data_warehouse.fact_table` f
    JOIN `rapido-data-engineering.rapido_data_warehouse.datetime_dim` d
        ON f.datetime_id = d.datetime_id
    JOIN `rapido-data-engineering.rapido_data_warehouse.passenger_count_dim` p
        ON f.passenger_count_id = p.passenger_count_id
    JOIN `rapido-data-engineering.rapido_data_warehouse.trip_distance_dim` t
        ON f.trip_distance_id = t.trip_distance_id
    JOIN `rapido-data-engineering.rapido_data_warehouse.rate_code_dim` r
        ON f.rate_code_id = r.rate_code_id
    JOIN `rapido-data-engineering.rapido_data_warehouse.pickup_location_dim` pick
        ON f.pickup_location_id = pick.pickup_location_id
    JOIN `rapido-data-engineering.rapido_data_warehouse.dropoff_location_dim` drop_loc
        ON f.dropoff_location_id = drop_loc.dropoff_location_id
    JOIN `rapido-data-engineering.rapido_data_warehouse.payment_type_dim` pay
        ON f.payment_type_id = pay.payment_type_id
);
