- connection: congress

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: transactions
  
  joins: 
    - join: uber_trips
      type: left_outer
      relationship: one_to_one
      sql_on: ${transactions.month_price} = ${uber_trips.month_price}

- explore: uber_trips

