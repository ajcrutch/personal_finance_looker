- view: uber_trips
  sql_table_name: personal_finance.uber_trips
  fields:

  - dimension: car_type
    type: string
    sql: ${TABLE}.car_type

  - dimension: city
    type: string
    sql: ${TABLE}.city

  - dimension_group: ride
    type: time
    timeframes: [date, month, year, month_name]
    sql: ${raw_shit}
  
  - dimension: raw_shit
    type: string
    sql: concat(concat('20', substring(${TABLE}.date, 7, 2)), '-',substring(${TABLE}.date, 1, 2), '-', substring(${TABLE}.date, 4, 2))
  
  - dimension: month_price
    type: string
    sql: concat(${ride_month}, RIGHT(${price}, CHAR_LENGTH(${price}) -1))

  - dimension: date_time
    type: string
    sql: ${TABLE}.date_time

  - dimension: driver
    type: string
    sql: ${TABLE}.driver

  - dimension: end_address
    type: string
    sql: ${TABLE}.end_address

  - dimension: end_time
    type: string
    sql: ${TABLE}.end_time

  - dimension: payment_method
    type: number
    sql: ${TABLE}.payment_method
    value_format_name: id

  - dimension: price
    type: string
    sql: ${TABLE}.price

  - dimension: start_address
    type: string
    sql: ${TABLE}.start_address

  - dimension: start_time
    type: string
    sql: ${TABLE}.start_time

  - dimension: trip_id
    type: string
    sql: ${TABLE}.trip_id

  - measure: count
    type: count
    drill_fields: []

