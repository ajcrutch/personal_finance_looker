view: transactions {
  sql_table_name: personal_finance.transactions ;;

  dimension: account_name_original {
    type: string
    hidden: yes
    sql: ${TABLE}.`Account Name` ;;
  }

  dimension: account_name {
    type: string
    sql: CASE WHEN ${account_name_original} = "xxxxxx7630 S07" THEN "Checking Account 7630"
      WHEN ${account_name_original} = "S07 FREE CHECKIN" THEN "Checking Account 1530"
      WHEN ${account_name_original} = "xxxxxx7630 S01" THEN "Savings Account 7630"
      WHEN ${account_name_original} = "S01 PRIMARY SHAR" THEN "Savings Account 1530"
      ELSE null
      END
       ;;
  }

  dimension: account_type {
    type: string
    sql: CASE WHEN ${account_name} LIKE "Savings%" THEN "Savings"
      WHEN ${account_name} LIKE "Checking%" THEN "Checking"
      ELSE null
      END
       ;;
  }

  dimension: account_number {}

  dimension: month_price {
    type: string
    sql: concat(${created_month}, ${amount}) ;;
  }

  dimension: amount {
    type: number
    sql: CASE WHEN ${transaction_type} = 'debit' THEN -1*${TABLE}.Amount
      ELSE ${TABLE}.Amount
      END
       ;;
    value_format_name: usd
  }

  dimension: category {
    type: string
    sql: ${TABLE}.Category ;;
  }

  dimension_group: created {
    type: time
    timeframes: [date, week, month, year, day_of_week, month_num, week_of_year, month_name, day_of_month]
    sql: ${raw_shit} ;;
  }

  dimension: raw_shit {
    type: string
    sql: concat(RIGHT(transactions.Date, 4), '-', CASE WHEN length(SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8)))) = 1 THEN concat('0',SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8))))
      ELSE substring(transactions.Date, 1, 2)
      END, '-', LEFT(RIGHT(transactions.Date, 7), 2))
       ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.Description ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.Labels ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.Notes ;;
  }

  dimension: original_description {
    type: string
    sql: ${TABLE}.`Original Description` ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.`Transaction Type` ;;
  }

  measure: count {
    type: count
    drill_fields: [account_name]
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
  }
}
