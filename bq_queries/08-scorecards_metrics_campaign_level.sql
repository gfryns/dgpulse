CREATE
OR REPLACE VIEW `{bq_dataset}_bq.scorecards_metrics_campaign_level_view` AS (
  WITH CampaignsUsingLookalikes AS (
    SELECT
      account_id,
      campaign_id,
      MAX(is_lookalike_audience) AS uses_lookalike_audience
    FROM `{bq_dataset}_bq.audience_performance`
    GROUP BY 1, 2
  ),
  OptimizedTargetingSpend AS (
    SELECT
      date,
      account_id,
      campaign_id,
      SUM(IF(IFNULL(uses_optimized_targeting, FALSE), cost, 0))/1e6 AS cost_optimized_targeting,
      SUM(IF(NOT IFNULL(uses_optimized_targeting, FALSE), cost, 0))/1e6 AS cost_non_optimized_targeting
    FROM `{bq_dataset}.adgroupad_asset_view`
    GROUP BY date, account_id, campaign_id
  )
  SELECT
    cd.account_id,
    cd.account_name,
    cd.campaign_id,
    cd.campaign_name,
    cd.date,
    cd.cost,
    cd.budget_amount,
    cd.budget_amount > 100 AS has_budget_more_than_100,
    if(cd.budget_amount > 100, cd.cost, 0) AS cost_campaigns_with_budget_more_than_100,
    cac.has_image_plus_video,
    if(cac.has_image_plus_video='YES', cd.cost, null) AS cost_campaigns_with_image_plus_video,
    cac.dmaa_portrait_mkt_imgs_count,
    cac.dmaa_mkt_imgs_count,
    cac.dmaa_square_mkt_imgs_count,
    if((cac.dmaa_portrait_mkt_imgs_count>0
      AND cac.dmaa_mkt_imgs_count>0
      AND cac.dmaa_square_mkt_imgs_count>0
    ), cd.cost, 0) AS cost_campaigns_with_3_aspect_ratio_images,
    cac.landscape_video_count,
    cac.portrait_video_count,
    cac.square_video_count,
    if((cac.landscape_video_count>0
      AND cac.portrait_video_count>0
      AND cac.square_video_count>0
    ), cd.cost, 0) AS cost_campaigns_with_3_aspect_ratio_videos,
    cac.aga_headlines_count,
    cac.dmaa_descriptions_count,
    cac.has_product_feed,
    cl.uses_lookalike_audience,
    ot.cost_optimized_targeting,
    ot.cost_non_optimized_targeting
  FROM `{bq_dataset}_bq.campaign_data` AS cd
  LEFT JOIN `{bq_dataset}_bq.campaigns_assets_count_view` AS cac USING (account_id, campaign_id)
  LEFT JOIN CampaignsUsingLookalikes AS cl USING (account_id, campaign_id)
  LEFT JOIN OptimizedTargetingSpend AS ot USING (date, account_id, campaign_id)
);