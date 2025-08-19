CREATE
OR REPLACE TABLE `{bq_dataset}_bq.scorecards_metrics_campaign_level` AS (
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
    cac.has_product_feed
  FROM `{bq_dataset}_bq.campaign_data` AS cd
  LEFT JOIN `{bq_dataset}_bq.campaigns_assets_count` AS cac USING (account_id, campaign_id)
);