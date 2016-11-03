connection: "congress"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: transactions {
  join: uber_trips {
    type: left_outer
    relationship: one_to_one
    sql_on: ${transactions.month_price} = ${uber_trips.month_price} ;;
  }
}

explore: uber_trips {}
