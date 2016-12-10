connection: "congress"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: transactions {
  label: "Transactions"
#   join: uber_trips {
#     type: left_outer
#     relationship: one_to_one
#     sql_on: ${transactions.month_price} = ${uber_trips.month_price} ;;
#   }

# join:  transactions {
#   type: left_outer
#   sql_on: ${projected_dates.date} = ${transactions.created_date} ;;
# }
  join: total_necessary_transactions_by_month {
    type: left_outer
    relationship: many_to_one
    sql_on: (${transactions.necessary_vs_unnecessary} = ${total_necessary_transactions_by_month.necessary}) ;;
  }
  join: monthly_spending {
    type: left_outer
    relationship: many_to_one
    sql_on: ${transactions.created_month} = ${monthly_spending.transactions_created_month} ;;
  }
}
