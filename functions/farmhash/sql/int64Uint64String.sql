CREATE OR REPLACE FUNCTION bqutils.farmhash.uint64StringToInt64(value STRING)
RETURNS INT64
AS
(
  CAST(
    IF(
      -- Check if the numeric value can be safely cast to INT64.
      -- 9223372036854775808 is 2^63, the boundary where INT64 (signed) wraps around to negative values.
      SAFE_CAST(value AS NUMERIC) < CAST('9223372036854775808' AS NUMERIC),
      CAST(value AS NUMERIC),
      -- If the value exceeds 2^63 - 1, encode it to fit into INT64 by adjusting the range.
      -- 18446744073709551616 is 2^64, the maximum value plus one for uint64.
      SAFE_CAST(value AS NUMERIC) - CAST('18446744073709551616' AS NUMERIC)
    )
  AS INT64)
);

CREATE OR REPLACE FUNCTION bqutils.farmhash.int64ToUint64String(value INT64)
RETURNS STRING
AS
(
  IF(
    value < 0,
    -- Re-adjust to the original uint64 value.
    CAST(value + CAST('18446744073709551616' AS NUMERIC) AS STRING),
    -- Add 2^64 to the negative INT64 value to convert it back to its original uint64 value.
    -- If the value is not negative, it was within the INT64 range and requires no adjustment.
    CAST(value AS STRING)
  )
);
