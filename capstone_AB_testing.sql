-- Use this table to
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2
 -- Goal 1: create a date range
-- Goal 2: see if any item_id has been ordered within this range by joining orders table
-- sub tables: final_assignment
--             item_level_orders

SELECT final_assignment.item_id,
       final_assignment.test_assignment,
       final_assignment.test_number,
       final_assignment.test_start_date,
       (CASE
            WHEN invoice_id IS NOT NULL THEN 1
            ELSE 0
        END) AS order_binary
FROM
    (SELECT *,
            DATE(test_start_date + interval '30' day) AS next_30_day_from_today
   FROM dsv1069.final_assignments) final_assignment
LEFT JOIN
  (SELECT invoice_id,
          item_id,
          DATE(paid_at) AS order_day
   FROM dsv1069.orders) item_level_orders
  ON item_level_orders.item_id = final_assignment.item_id
  AND item_level_orders.order_day > final_assignment.test_start_date
  AND item_level_orders.order_day <= final_assignment.next_30_day_from_today
WHERE test_number = 'item_test_2'
