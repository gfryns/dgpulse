CREATE
OR REPLACE TABLE `{bq_dataset}_bq.scorecards_metrics_account_level` AS (
  WITH AccountsSpend AS (
    SELECT
      account_id,
      account_name,
      date,
      SUM(cost) AS cost
    FROM `{bq_dataset}_bq.campaign_data`
    GROUP BY account_id, account_name, date
  )

  SELECT
    a.account_id,
    a.account_name,
    a.date,
    a.cost,
    aca.dda_conversion_action_status,
    if(aca.dda_conversion_action_status='ENABLED', a.cost, null) AS cost_accounts_with_dda,
    aca.ecl_status,
    if(aca.ecl_status='ENABLED', a.cost, null) AS cost_accounts_with_ecl
    FROM AccountsSpend AS a
    LEFT JOIN `{bq_dataset}_bq.account_conversion_action` AS aca USING (account_id)
);