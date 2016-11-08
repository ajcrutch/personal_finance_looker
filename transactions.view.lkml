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

  dimension: description_bucketed {
    type: string
   sql:
    CASE WHEN ${description} LIKE '%offee%' OR ${description} LIKE '%tarbucks%' OR ${description} LIKE '%Blue Bottle%'  THEN "Coffee"
    WHEN ${description} LIKE '%rader Joe%' OR ${description} LIKE '%CVS%' OR ${description} LIKE '%Safeway%'  THEN "Groceries"
    WHEN ${description} LIKE '%Parking%' OR ${description} = 'Santa Cruz Pay'  THEN "Parking"
    WHEN ${description} = 'Costco Gas' OR ${description} = 'Shell' OR  ${description} LIKE '% 76'THEN "Gasoline"
    WHEN ${description} = 'Caltrain' OR ${description} = 'Lyft' OR  lower(${description}) LIKE '%uber%'THEN "Transportation"
    WHEN ${description} = 'Box Inc' OR ${description} = 'Spotify' OR ${description} = 'Hulu' OR lower(${description}) LIKE '%eadspace%' THEN "Subscriptions"
    ELSE "Other"
    END ;;
  }

  dimension: necessary_vs_unnecessary {
    type: string
    sql: CASE WHEN lower(${description}) = 'acs' OR lower(${description}) LIKE '%ATM%'
    OR lower(${description}) LIKE 'check %' OR lower(${description_bucketed}) = 'Parking' OR lower(${description_bucketed}) = 'Gasoline' OR lower(${description_bucketed}) = 'Groceries' THEN 'Necessary'
    ELSE "Unnecessary"
    END ;;
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
    html:  <p style="font-weight: bold">{{rendered_value}}</p> ;;
  }

  measure: total_amount_raw {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
    html:
    {% if value > 0 %}
      <p style="color: #45BF55; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value < 0 %}
      <p style="color: #E52D21; font-weight: bold">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
     ;;
  }

  measure: total_amount_only_spending {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
    filters: {
      field: amount
      value: "< 0"
    }
    html:
    {% if value > 0 %}
      <p style="color: #45BF55; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value < 0 %}
      <p style="color: #E52D21; font-weight: bold">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; font-weight: bold">{{ rendered_value }}</p>
    {% endif %}
     ;;
  }

  measure: amount_spent_per_transaction {
    type: number
    sql: ${total_amount_only_spending} / ${count} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
    html:
      <p style="color: #E52D21; font-weight: bold">{{ rendered_value }}</p>
     ;;
  }

}
