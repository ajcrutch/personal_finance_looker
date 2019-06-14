view: total_necessary_transactions_by_month {
  derived_table: {
    sql:
    SELECT "Necessary", AVG(total_spending_gas) as average_total_spending_gas, AVG(total_spending_groceries) as average_total_spending_groceries, AVG(total_spending_parking) as average_total_spending_parking
    FROM
      (SELECT
            DATE_FORMAT((CASE WHEN (transactions.`Account Name`) = 'Matadors 76' OR (transactions.`Account Name`) = 'Matadors 15' THEN (concat(RIGHT(transactions.Date, 4), '-', CASE WHEN length(SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8)))) = 1 THEN concat('0',SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8))))
                ELSE substring(transactions.Date, 1, 2)
                END, '-', LEFT(RIGHT(transactions.Date, 7), 2)))
                WHEN (transactions.`Account Name`) = 'Matadors Credit Card' THEN concat('20', (RIGHT(transactions.Date, 2)), '-', (CASE WHEN length(SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) = 1 THEN concat('0', (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1))) ELSE (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) END), '-', CASE WHEN length(SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) = 1 THEN concat('0', (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3)))) ELSE (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) END)
                ELSE transactions.Date
                END) ,'%Y-%m') AS `created_month`,
            COALESCE(SUM(CASE WHEN (CASE WHEN lower(transactions.Description) IN ('%offee%', '%tarbucks%', '%lue bottle%', '%cafe', '% tea %', '% bowl %') OR transactions.Category IN ('Coffee Shops', 'Fast Food') THEN "Coffee / Snacks"
              WHEN lower(transactions.Description) LIKE '%rader joe%' OR lower(transactions.Description) LIKE '%cvs%' OR lower(transactions.Description) LIKE '%afeway%' OR transactions.Category = 'Groceries' THEN "Groceries"
              WHEN lower(transactions.Description) LIKE '%parking%' OR lower(transactions.Description) = 'santa sruz pay' OR transactions.Category IN ('Parking', 'Parking & Tolls') THEN "Parking"
              WHEN transactions.Category IN ('Restaurants', 'Food & Dining', 'Alcohol & Bars') OR lower(transactions.Description) LIKE '%sushi%' THEN "Restaurants"
              WHEN lower(transactions.Description) LIKE '%ostco gas' OR lower(transactions.Description) LIKE 'shell' OR  lower(transactions.Description) LIKE '% 76' OR transactions.Category = "Gas & Fuel" THEN "Gasoline"
              WHEN lower(transactions.Description) = '%altrain%' OR lower(transactions.Description) = 'lyft' OR lower(transactions.Description) LIKE '%uber%' OR lower(transactions.Description) LIKE '%megabus%' OR lower(transactions.Description) LIKE '%bart%' OR transactions.Category IN ('Public Transportation', 'Rental Car & Taxi') THEN "Transportation"
              WHEN lower(transactions.Description) REGEXP 'box inc|spotify|hulu|hds headspace drive|ufc gym|Classpass Com Pe 552 7th Avenue' THEN "Subscriptions"
              WHEN transactions.Category IN ('Shopping', 'Books', 'Gift', 'Clothing', 'Other Shopping', 'Movies & DVDs') THEN "Shopping"
              WHEN transactions.Category = 'Student Loan' THEN "Student Loan"
              WHEN lower(transactions.Description) REGEXP 'atm|payroll|deposit|transfer|interest|^fee' OR transactions.Category IN ('Check', 'Financial', 'Income', 'Transfer', 'Bank Fee', 'Credit Card Payment', 'Fees & Charges', 'Other Income') THEN "Transactions"
              ELSE "Other"
              END  = 'Gasoline') THEN (CASE WHEN transactions.amount = 241.44 THEN 500
              ELSE transactions.amount
              END) ELSE NULL END), 0) AS `total_spending_gas`,
            COALESCE(SUM(CASE WHEN (CASE WHEN lower(transactions.Description) IN ('%offee%', '%tarbucks%', '%lue bottle%', '%cafe', '% tea %', '% bowl %') OR transactions.Category IN ('Coffee Shops', 'Fast Food') THEN "Coffee / Snacks"
              WHEN lower(transactions.Description) LIKE '%rader joe%' OR lower(transactions.Description) LIKE '%cvs%' OR lower(transactions.Description) LIKE '%afeway%' OR transactions.Category = 'Groceries' THEN "Groceries"
              WHEN lower(transactions.Description) LIKE '%parking%' OR lower(transactions.Description) = 'santa sruz pay' OR transactions.Category IN ('Parking', 'Parking & Tolls') THEN "Parking"
              WHEN transactions.Category IN ('Restaurants', 'Food & Dining', 'Alcohol & Bars') OR lower(transactions.Description) LIKE '%sushi%' THEN "Restaurants"
              WHEN lower(transactions.Description) LIKE '%ostco gas' OR lower(transactions.Description) LIKE 'shell' OR  lower(transactions.Description) LIKE '% 76' OR transactions.Category = "Gas & Fuel" THEN "Gasoline"
              WHEN lower(transactions.Description) = '%altrain%' OR lower(transactions.Description) = 'lyft' OR lower(transactions.Description) LIKE '%uber%' OR lower(transactions.Description) LIKE '%megabus%' OR lower(transactions.Description) LIKE '%bart%' OR transactions.Category IN ('Public Transportation', 'Rental Car & Taxi') THEN "Transportation"
              WHEN lower(transactions.Description) REGEXP 'box inc|spotify|hulu|hds headspace drive|ufc gym|Classpass Com Pe 552 7th Avenue' THEN "Subscriptions"
              WHEN transactions.Category IN ('Shopping', 'Books', 'Gift', 'Clothing', 'Other Shopping', 'Movies & DVDs') THEN "Shopping"
              WHEN transactions.Category = 'Student Loan' THEN "Student Loan"
              WHEN lower(transactions.Description) REGEXP 'atm|payroll|deposit|transfer|interest|^fee' OR transactions.Category IN ('Check', 'Financial', 'Income', 'Transfer', 'Bank Fee', 'Credit Card Payment', 'Fees & Charges', 'Other Income') THEN "Transactions"
              ELSE "Other"
              END  = 'Groceries') THEN (CASE WHEN transactions.amount = 241.44 THEN 500
              ELSE transactions.amount
              END) ELSE NULL END), 0) AS `total_spending_groceries`,
            COALESCE(SUM(CASE WHEN (CASE WHEN lower(transactions.Description) IN ('%offee%', '%tarbucks%', '%lue bottle%', '%cafe', '% tea %', '% bowl %') OR transactions.Category IN ('Coffee Shops', 'Fast Food') THEN "Coffee / Snacks"
              WHEN lower(transactions.Description) LIKE '%rader joe%' OR lower(transactions.Description) LIKE '%cvs%' OR lower(transactions.Description) LIKE '%afeway%' OR transactions.Category = 'Groceries' THEN "Groceries"
              WHEN lower(transactions.Description) LIKE '%parking%' OR lower(transactions.Description) = 'santa sruz pay' OR transactions.Category IN ('Parking', 'Parking & Tolls') THEN "Parking"
              WHEN transactions.Category IN ('Restaurants', 'Food & Dining', 'Alcohol & Bars') OR lower(transactions.Description) LIKE '%sushi%' THEN "Restaurants"
              WHEN lower(transactions.Description) LIKE '%ostco gas' OR lower(transactions.Description) LIKE 'shell' OR  lower(transactions.Description) LIKE '% 76' OR transactions.Category = "Gas & Fuel" THEN "Gasoline"
              WHEN lower(transactions.Description) = '%altrain%' OR lower(transactions.Description) = 'lyft' OR lower(transactions.Description) LIKE '%uber%' OR lower(transactions.Description) LIKE '%megabus%' OR lower(transactions.Description) LIKE '%bart%' OR transactions.Category IN ('Public Transportation', 'Rental Car & Taxi') THEN "Transportation"
              WHEN lower(transactions.Description) REGEXP 'box inc|spotify|hulu|hds headspace drive|ufc gym|Classpass Com Pe 552 7th Avenue' THEN "Subscriptions"
              WHEN transactions.Category IN ('Shopping', 'Books', 'Gift', 'Clothing', 'Other Shopping', 'Movies & DVDs') THEN "Shopping"
              WHEN transactions.Category = 'Student Loan' THEN "Student Loan"
              WHEN lower(transactions.Description) REGEXP 'atm|payroll|deposit|transfer|interest|^fee' OR transactions.Category IN ('Check', 'Financial', 'Income', 'Transfer', 'Bank Fee', 'Credit Card Payment', 'Fees & Charges', 'Other Income') THEN "Transactions"
              ELSE "Other"
              END  = 'Parking') THEN (CASE WHEN transactions.amount = 241.44 THEN 500
              ELSE transactions.amount
              END) ELSE NULL END), 0) AS `total_spending_parking`
          FROM personal_finance.transactions  AS transactions

          WHERE
            (CASE WHEN lower(transactions.Description) IN ('acs', '%atm%', 'check %') OR lower((CASE WHEN lower(transactions.Description) IN ('%offee%', '%tarbucks%', '%lue bottle%', '%cafe', '% tea %', '% bowl %') OR transactions.Category IN ('Coffee Shops', 'Fast Food') THEN "Coffee / Snacks"
              WHEN lower(transactions.Description) LIKE '%rader joe%' OR lower(transactions.Description) LIKE '%cvs%' OR lower(transactions.Description) LIKE '%afeway%' OR transactions.Category = 'Groceries' THEN "Groceries"
              WHEN lower(transactions.Description) LIKE '%parking%' OR lower(transactions.Description) = 'santa sruz pay' OR transactions.Category IN ('Parking', 'Parking & Tolls') THEN "Parking"
              WHEN transactions.Category IN ('Restaurants', 'Food & Dining', 'Alcohol & Bars') OR lower(transactions.Description) LIKE '%sushi%' THEN "Restaurants"
              WHEN lower(transactions.Description) LIKE '%ostco gas' OR lower(transactions.Description) LIKE 'shell' OR  lower(transactions.Description) LIKE '% 76' OR transactions.Category = "Gas & Fuel" THEN "Gasoline"
              WHEN lower(transactions.Description) = '%altrain%' OR lower(transactions.Description) = 'lyft' OR lower(transactions.Description) LIKE '%uber%' OR lower(transactions.Description) LIKE '%megabus%' OR lower(transactions.Description) LIKE '%bart%' OR transactions.Category IN ('Public Transportation', 'Rental Car & Taxi') THEN "Transportation"
              WHEN lower(transactions.Description) REGEXP 'box inc|spotify|hulu|hds headspace drive|ufc gym|Classpass Com Pe 552 7th Avenue' THEN "Subscriptions"
              WHEN transactions.Category IN ('Shopping', 'Books', 'Gift', 'Clothing', 'Other Shopping', 'Movies & DVDs') THEN "Shopping"
              WHEN transactions.Category = 'Student Loan' THEN "Student Loan"
              WHEN lower(transactions.Description) REGEXP 'atm|payroll|deposit|transfer|interest|^fee' OR transactions.Category IN ('Check', 'Financial', 'Income', 'Transfer', 'Bank Fee', 'Credit Card Payment', 'Fees & Charges', 'Other Income') THEN "Transactions"
              ELSE "Other"
              END)) IN ('Parking', 'Gasoline', 'Groceries', 'Transactions') THEN 'Necessary'
              ELSE "Unnecessary"
              END  = 'Necessary')
          GROUP BY 1
          ORDER BY DATE_FORMAT((CASE WHEN (transactions.`Account Name`) = 'Matadors 76' OR (transactions.`Account Name`) = 'Matadors 15' THEN (concat(RIGHT(transactions.Date, 4), '-', CASE WHEN length(SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8)))) = 1 THEN concat('0',SUBSTRING(transactions.Date, 1, length(transactions.Date) - length(substring(transactions.Date,2,8))))
                ELSE substring(transactions.Date, 1, 2)
                END, '-', LEFT(RIGHT(transactions.Date, 7), 2)))
                WHEN (transactions.`Account Name`) = 'Matadors Credit Card' THEN concat('20', (RIGHT(transactions.Date, 2)), '-', (CASE WHEN length(SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) = 1 THEN concat('0', (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1))) ELSE (SUBSTRING(transactions.Date, 1, (LOCATE('/', transactions.Date))- 1)) END), '-', CASE WHEN length(SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) = 1 THEN concat('0', (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3)))) ELSE (SUBSTRING((SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))), 1, (length(SUBSTRING(transactions.Date, LOCATE('/',transactions.Date)+1, length(transactions.Date))) -3))) END)
                ELSE transactions.Date
                END) ,'%Y-%m') DESC) k
       ;;
  }

  dimension: necessary {
    type: string
    hidden:  yes
    primary_key: yes
    sql: ${TABLE}.`Necessary` ;;
  }

  dimension: average_total_spending_gas {
    type: number
    sql: ${TABLE}.`average_total_spending_gas` ;;
    value_format_name: usd
  }

  dimension: average_total_spending_groceries {
    type: number
    sql: ${TABLE}.`average_total_spending_groceries` ;;
    value_format_name: usd
  }

  dimension: average_total_spending_parking {
    type: number
    sql: ${TABLE}.`average_total_spending_parking` ;;
    value_format_name: usd
  }

  measure: total_necessary_spending {
    type: average
    sql: abs(${average_total_spending_gas} + ${average_total_spending_groceries} + ${average_total_spending_parking}) ;;
    value_format_name: usd
  }

  measure: safe_to_spend_this_month {
    type: number
    sql: ${transactions.net_worth} - ${total_necessary_spending} ;;
    value_format_name: usd
  }

}
