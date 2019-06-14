view: transactions {
  sql_table_name: personal_finance.transactions ;;

########## FILTER-ONLY FIELDS ##########

filter: goal {
  label: "What Do You Want"
  type: string
}

filter: time {
  label: "When Do You Want It?"
  type: string
}


 ########## DIMENSIONS ##########

  dimension: id {
    primary_key: yes
    sql: ${TABLE}.`id` ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}.`Account Name`
       ;;
  }

  dimension: month_price {
    type: string
    sql: concat(${created_month}, ${amount}) ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount;;
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

  dimension_group: projected {
    type: time
    timeframes: [date, month, week]
    sql: ${TABLE}.projected_date ;;
  }

  dimension: raw_shit { #deal with mint's shitty date formatting CUMAGIC
    type: string
    sql:CASE WHEN ${account_name} = 'Matadors 76' OR ${account_name} = 'Matadors 15' THEN (concat(RIGHT(transactions.Date, 4), '-', CASE WHEN length(SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8)))) = 1 THEN concat('0',SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8))))
      ELSE substring(transactions.Date, 1, 2)
      END, '-', LEFT(RIGHT(transactions.Date, 7), 2)))
      WHEN ${account_name} = 'Matadors Credit Card' THEN concat('20', (RIGHT(transactions.Date, 2)), '-', (CASE WHEN length(SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) = 1 THEN concat('0', (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1))) ELSE (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) END), '-', CASE WHEN length(SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) = 1 THEN concat('0', (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3)))) ELSE (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) END)
      ELSE transactions.Date
      END
       ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.Description ;;
  }

  dimension: description_bucketed {
    type: string
   sql:
    CASE WHEN lower(${description}) IN ('%offee%', '%tarbucks%', '%lue bottle%', '%cafe', '% tea %', '% bowl %') OR ${category} IN ('Coffee Shops', 'Fast Food') THEN "Coffee / Snacks"
    WHEN lower(${description}) LIKE '%rader joe%' OR lower(${description}) LIKE '%cvs%' OR lower(${description}) LIKE '%afeway%' OR ${category} = 'Groceries' THEN "Groceries"
    WHEN lower(${description}) LIKE '%parking%' OR lower(${description}) = 'santa sruz pay' OR ${category} IN ('Parking', 'Parking & Tolls') THEN "Parking"
    WHEN ${category} IN ('Restaurants', 'Food & Dining', 'Alcohol & Bars') OR lower(${description}) LIKE '%sushi%' THEN "Restaurants"
    WHEN lower(${description}) LIKE '%ostco gas' OR lower(${description}) LIKE 'shell' OR  lower(${description}) LIKE '% 76' OR ${category} = "Gas & Fuel" THEN "Gasoline"
    WHEN lower(${description}) = '%altrain%' OR lower(${description}) = 'lyft' OR lower(${description}) LIKE '%uber%' OR lower(${description}) LIKE '%megabus%' OR lower(${description}) LIKE '%bart%' OR ${category} IN ('Public Transportation', 'Rental Car & Taxi') THEN "Transportation"
    WHEN lower(${description}) REGEXP 'box inc|spotify|hulu|hds headspace drive|ufc gym|Classpass Com Pe 552 7th Avenue' THEN "Subscriptions"
    WHEN ${category} IN ('Shopping', 'Books', 'Gift', 'Clothing', 'Other Shopping', 'Movies & DVDs') THEN "Shopping"
    WHEN ${category} = 'Student Loan' THEN "Student Loan"
    WHEN lower(${description}) REGEXP 'atm|payroll|deposit|transfer|interest|^fee' OR ${category} IN ('Check', 'Financial', 'Income', 'Transfer', 'Bank Fee', 'Credit Card Payment', 'Fees & Charges', 'Other Income') THEN "Transactions"
    ELSE "Other"
    END ;;
  }

  dimension: necessary_vs_unnecessary {
    type: string
    sql: CASE WHEN lower(${description}) IN ('acs', '%atm%', 'check %') OR lower(${description_bucketed}) IN ('Parking', 'Gasoline', 'Groceries', 'Transactions') THEN 'Necessary'
    ELSE "Unnecessary"
    END ;;
  }

  dimension: original_description {
    type: string
    sql: ${TABLE}.`Original_Description` ;;
  }

  dimension: total_value_of_credit_card {
    type:  number
    sql:  500 ;;
    value_format_name: "usd"
  }

  dimension: goal_amount {
    type: number
    sql: CAST({% parameter goal %} AS decimal) ;;

  }

  dimension_group: goal_time {
    type: time
    timeframes: [date, day_of_week]
    sql: {% parameter time %};;

  }



  ########## MEASURES ##########

  measure: count {
    type: count
    drill_fields: [created_date, amount, description]
#     html:  <p style="font-weight: bold">{{rendered_value}}</p> ;;
  }

#   measure: total_income {
#     type:  sum
#     sql: ${amount} ;;
#     filters: {
#       field: amount
#       value: ""
#     }
#   }

  measure: total_amount_raw {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
#     html:
#     {% if value > 0 %}
#       <p style="color: #45BF55; font-weight: bold">{{ rendered_value }}</p>
#     {% elsif value < 0 %}
#       <p style="color: #E52D21; font-weight: bold">{{ rendered_value }}</p>
#     {% else %}
#       <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% endif %}
#      ;;
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
  }

  measure: total_amount_only_earning {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
    filters: {
      field: amount
      value: "> 0"
    }
  }

  measure: amount_spent_per_transaction {
    type: number
    sql: ${total_amount_only_spending} / ${count} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
#     html:
#       <p style="color: #E52D21; font-weight: bold">{{ rendered_value }}</p>
#      ;;
  }

  measure: total_amount_on_matadors_cc {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
    group_label: "Specific Accounts"
    filters: {
      field: account_name
      value: "Matadors Credit Card"
    }

  }

    measure: total_amount_on_matadors_76 {
      type: sum
      sql: ${amount} ;;
      value_format_name: usd
      drill_fields: [created_date, amount, description]
      group_label: "Specific Accounts"
      filters: {
        field: account_name
        value: "Matadors 76"
      }

  }

    measure: total_amount_on_matadors_15 {
      type: sum
      sql: ${amount} ;;
      value_format_name: usd
      drill_fields: [created_date, amount, description]
      group_label: "Specific Accounts"
      filters: {
        field: account_name
        value: "Matadors 15"
      }

    }

  measure: total_amount_on_simple_13 {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
    group_label: "Specific Accounts"
    filters: {
      field: account_name
      value: "Simple 13"
    }

  }

  measure: total_spending_gas {
    type: sum
    sql: ${amount};;
    value_format_name: usd
    filters: {
      field: description_bucketed
      value: "Gasoline"
    }
  }

  measure: total_spending_parking {
    type: sum
    sql: ${amount};;
    value_format_name: usd
    filters: {
      field: description_bucketed
      value: "Parking"
    }
  }

  measure: total_spending_groceries {
    type: sum
    sql: ${amount};;
    value_format_name: usd
    filters: {
      field: description_bucketed
      value: "Groceries"
    }
  }


  measure: net_worth {
    type: number
    sql: ${total_amount_on_simple_13} + ${total_amount_on_matadors_15} + ${total_amount_on_matadors_76} + (${total_amount_on_matadors_cc} - ${total_value_of_credit_card})  ;;
    value_format_name: usd
    drill_fields: [created_date, amount, description]
  }

  measure: running_total {
    type:  running_total
    sql: ${amount} ;;
    value_format_name: "usd"

    }

  measure: total_necessary_expenditures {
    type:  average
    sql: ${amount} ;;
    value_format_name: "usd"
    filters: {
      field: necessary_vs_unnecessary
      value: "Necessary"
    }
  }

  measure: total_income {
    type: sum
    sql: ${amount} ;;
    filters: {
      field: description
      value: "%Looker Inc Payroll%,%Deposit Looker%"
    }
    value_format_name: usd
    drill_fields: [created_date, amount, description]
  }

  measure: average_income {
    type: average
    sql: ${amount} ;;
    filters: {
      field: description
      value: "%Looker Inc Payroll%,%Deposit Looker%"
    }
    value_format_name: usd
    drill_fields: [created_date, amount, description]
  }

  measure: average_rent {
    type: average
    sql: ${amount} ;;
    filters: {
      field: description
      value: "The Commons Rent"
    }
    value_format_name: usd
    drill_fields: [created_date, amount, description]
  }

  measure: safe_to_spend_this_month {
    type: number
    sql: ${transactions.net_worth} - ${total_necessary_transactions_by_month.total_necessary_spending} ;;
    value_format_name: usd
  }

  measure:goal_amount_monthly {
  type: average
  sql: ${goal_amount} ;;
}
  }
