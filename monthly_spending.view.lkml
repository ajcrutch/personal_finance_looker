view: monthly_spending {
  derived_table: {
    sql: -- raw sql results do not include filled-in values for 'transactions.created_month'


      SELECT
        DATE_FORMAT((CASE WHEN (transactions.`Account Name`) = 'Matadors 76' OR (transactions.`Account Name`) = 'Matadors 15' THEN (concat(RIGHT(transactions.Date, 4), '-', CASE WHEN length(SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8)))) = 1 THEN concat('0',SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8))))
            ELSE substring(transactions.Date, 1, 2)
            END, '-', LEFT(RIGHT(transactions.Date, 7), 2)))
            WHEN (transactions.`Account Name`) = 'Matadors Credit Card' THEN concat('20', (RIGHT(transactions.Date, 2)), '-', (CASE WHEN length(SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) = 1 THEN concat('0', (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1))) ELSE (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) END), '-', CASE WHEN length(SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) = 1 THEN concat('0', (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3)))) ELSE (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) END)
            ELSE transactions.Date
            END) ,'%Y-%m') AS `transactions.created_month`,
        COALESCE(SUM(transactions.amount ), 0) AS `transactions.total_amount_raw`,
        COALESCE(SUM(CASE WHEN (transactions.`Account Name`
              = 'Matadors 15') THEN abs(transactions.amount)*(RAND()*1.5)  ELSE NULL END), 0) AS `transactions.total_amount_on_matadors_15`,
        COALESCE(SUM(CASE WHEN (transactions.`Account Name`
              = 'Matadors 76') THEN abs(transactions.amount)*(RAND()*1.5)  ELSE NULL END), 0) AS `transactions.total_amount_on_matadors_76`,
        COALESCE(SUM(CASE WHEN (transactions.`Account Name`
              = 'Matadors Credit Card') THEN transactions.amount  ELSE NULL END), 0) AS `transactions.total_amount_on_matadors_cc`,
        COALESCE(SUM(CASE WHEN (transactions.`Account Name`
              = 'Simple 13') THEN abs(transactions.amount)*(RAND()*1.5)  ELSE NULL END), 0) AS `transactions.total_amount_on_simple_13`
      FROM personal_finance.transactions  AS transactions

      GROUP BY 1
      ORDER BY DATE_FORMAT((CASE WHEN (transactions.`Account Name`) = 'Matadors 76' OR (transactions.`Account Name`) = 'Matadors 15' THEN (concat(RIGHT(transactions.Date, 4), '-', CASE WHEN length(SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8)))) = 1 THEN concat('0',SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8))))
            ELSE substring(transactions.Date, 1, 2)
            END, '-', LEFT(RIGHT(transactions.Date, 7), 2)))
            WHEN (transactions.`Account Name`) = 'Matadors Credit Card' THEN concat('20', (RIGHT(transactions.Date, 2)), '-', (CASE WHEN length(SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) = 1 THEN concat('0', (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1))) ELSE (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) END), '-', CASE WHEN length(SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) = 1 THEN concat('0', (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3)))) ELSE (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) END)
            ELSE transactions.Date
            END) ,'%Y-%m') DESC
      LIMIT 500
       ;;
  }

  dimension: transactions_created_month {
    type: string
    sql: ${TABLE}.`transactions.created_month` ;;
  }

  dimension: transactions_total_amount_raw {
    type: number
    sql: ${TABLE}.`transactions.total_amount_raw` ;;
  }

  dimension: transactions_total_amount_on_matadors_15 {
    type: number
    sql: ${TABLE}.`transactions.total_amount_on_matadors_15` ;;
  }

  dimension: transactions_total_amount_on_matadors_76 {
    type: number
    sql: ${TABLE}.`transactions.total_amount_on_matadors_76` ;;
  }

  dimension: transactions_total_amount_on_matadors_cc {
    type: number
    sql: ${TABLE}.`transactions.total_amount_on_matadors_cc` ;;
  }

  dimension: transactions_total_amount_on_simple_13 {
    type: number
    sql: ${TABLE}.`transactions.total_amount_on_simple_13` ;;
  }

  measure: highest_spending_ {
    type: max
    sql: ${transactions_total_amount_raw} ;;
    value_format_name: usd
  }

  set: detail {
    fields: [transactions_created_month, transactions_total_amount_raw, transactions_total_amount_on_matadors_15, transactions_total_amount_on_matadors_76, transactions_total_amount_on_matadors_cc, transactions_total_amount_on_simple_13]
  }
}
