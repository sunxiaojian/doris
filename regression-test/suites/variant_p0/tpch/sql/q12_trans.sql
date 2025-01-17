SELECT
  CAST(L.var["L_SHIPMODE"] AS TEXT),
  SUM(CASE
      WHEN CAST(O.var["O_ORDERPRIORITY"] AS TEXT) = '1-URGENT'
           OR CAST(O.var["O_ORDERPRIORITY"] AS TEXT) = '2-HIGH'
        THEN 1
      ELSE 0
      END) AS HIGH_LINE_COUNT,
  SUM(CASE
      WHEN CAST(O.var["O_ORDERPRIORITY"] AS TEXT) <> '1-URGENT'
           AND CAST(O.var["O_ORDERPRIORITY"] AS TEXT) <> '2-HIGH'
        THEN 1
      ELSE 0
      END) AS LOW_LINE_COUNT
FROM
  orders O,
  lineitem L
WHERE
  CAST(O.var["O_ORDERKEY"] AS INT) = CAST(L.var["L_ORDERKEY"] AS INT)
  AND CAST(L.var["L_SHIPMODE"] AS TEXT) IN ('MAIL', 'SHIP')
  AND CAST(L.var["L_COMMITDATE"] AS DATE) < CAST(L.var["L_RECEIPTDATE"] AS DATE)
  AND CAST(L.var["L_SHIPDATE"] AS DATE) < CAST(L.var["L_COMMITDATE"] AS DATE)
  AND CAST(L.var["L_RECEIPTDATE"] AS DATE) >= DATE '1994-01-01'
  AND CAST(L.var["L_RECEIPTDATE"] AS DATE) < DATE '1994-01-01' + INTERVAL '1' YEAR
GROUP BY
  CAST(L.var["L_SHIPMODE"] AS TEXT)
ORDER BY
  CAST(L.var["L_SHIPMODE"] AS TEXT)