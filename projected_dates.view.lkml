view: projected_dates {
  derived_table: {
    sql: SELECT general_date.date AS date
       FROM (
            SELECT
                DATE_ADD('2016-12-01', INTERVAL (numbers.number) DAY) AS date
            FROM
                (SELECT
                    p0.n
                    + p1.n*2
                    + p2.n * POWER(2,2)
                    + p3.n * POWER(2,3)
                    + p4.n * POWER(2,4)
                    + p5.n * POWER(2,5)
                    + p6.n * POWER(2,6)
                    + p7.n * POWER(2,7)
                    + p8.n * POWER(2,8)
                    + p9.n * POWER(2,9)
                    + p10.n * POWER(2,10)
                    + p11.n * POWER(2,11)
                    + p12.n * POWER(2,12)
                    + p13.n * POWER(2,13)
                    + p14.n * POWER(2,14)
                    + p15.n * POWER(2,15)
                    + p16.n * POWER(2,16)
                    + p17.n * POWER(2,17)
                    + p18.n * POWER(2,18)
                    + p19.n * POWER(2,19)
                    + p20.n * POWER(2,20)
                    as number
                  FROM
                    (SELECT 0 as n UNION SELECT 1) p0,
                    (SELECT 0 as n UNION SELECT 1) p1,
                    (SELECT 0 as n UNION SELECT 1) p2,
                    (SELECT 0 as n UNION SELECT 1) p3,
                    (SELECT 0 as n UNION SELECT 1) p4,
                    (SELECT 0 as n UNION SELECT 1) p5,
                    (SELECT 0 as n UNION SELECT 1) p6,
                    (SELECT 0 as n UNION SELECT 1) p7,
                    (SELECT 0 as n UNION SELECT 1) p8,
                    (SELECT 0 as n UNION SELECT 1) p9,
                    (SELECT 0 as n UNION SELECT 1) p10,
                    (SELECT 0 as n UNION SELECT 1) p11,
                    (SELECT 0 as n UNION SELECT 1) p12,
                    (SELECT 0 as n UNION SELECT 1) p13,
                    (SELECT 0 as n UNION SELECT 1) p14,
                    (SELECT 0 as n UNION SELECT 1) p15,
                    (SELECT 0 as n UNION SELECT 1) p16,
                    (SELECT 0 as n UNION SELECT 1) p17,
                    (SELECT 0 as n UNION SELECT 1) p18,
                    (SELECT 0 as n UNION SELECT 1) p19,
                    (SELECT 0 as n UNION SELECT 1) p20) as numbers) as general_date

 ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  set: detail {
    fields: [date]
  }
}
