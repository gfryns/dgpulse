-- Copyright 2025 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     https://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


SELECT
  ad_group_criterion.resource_name AS ad_group_criterion_resource_name,
  ad_group_criterion.criterion_id AS ad_group_criterion_id,
  ad_group_criterion.display_name AS ad_group_criterion_name,
  ad_group_criterion.type AS ad_group_criterion_type,
  user_list.id AS user_list_id,
  user_list.name AS user_list_name,
  user_list.type AS user_list_type,
    user_list.description AS user_list_description,
  user_list.membership_status AS user_list_membership_status
FROM
  ad_group_criterion
WHERE
  ad_group_criterion.type = 'USER_LIST'
