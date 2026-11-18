-- Lumi Skin | BigQuery queries (simulated data, 2026-08-15 to 2026-11-12)
-- Dataset: lumi_skin | Tables: contacts, deals, orders, ad_spend
-- Rules: Revenue = deals with Deal_Stage = 'Completed'. Customer = contact with 1+ Completed deal.
-- Campaign comes from contacts.First_Touch_UTM_Campaign (first touch).
-- Note: BigQuery changes spaces in column names to underscores (Deal Stage -> Deal_Stage).


-- Q1. Spend, leads and CPL by campaign
-- Expected: total spend 30,000,000 | total leads 600 | blended CPL 50,000
SELECT
Campaign,
SUM(Spend_VND) AS spend_vnd,
SUM(Leads) AS leads,
ROUND(SAFE_DIVIDE(SUM(Spend_VND), SUM(Leads))) AS cpl_vnd
FROM lumi_skin.ad_spend
GROUP BY Campaign
ORDER BY spend_vnd DESC;


-- Q2. Customers and conversion by campaign
-- Expected: 139 customers in total (README says 142 buyers; 3 buyers have no Completed order)
WITH buyers AS (
SELECT Associated_Contact_Email AS email, COUNT(*) AS orders
FROM lumi_skin.deals
WHERE Deal_Stage = 'Completed'
GROUP BY email
)
SELECT
c.First_Touch_UTM_Campaign AS campaign,
COUNT(*) AS leads,
COUNTIF(b.email IS NOT NULL) AS customers,
ROUND(100 * SAFE_DIVIDE(COUNTIF(b.email IS NOT NULL), COUNT(*)), 2) AS conversion_pct
FROM lumi_skin.contacts AS c
LEFT JOIN buyers AS b ON c.Email = b.email
GROUP BY campaign
ORDER BY conversion_pct DESC;


-- Q3. Completed revenue and ROAS by campaign
-- Expected: total revenue 122,386,000 | blended ROAS about 4.08
WITH spend AS (
SELECT Campaign, SUM(Spend_VND) AS spend_vnd
FROM lumi_skin.ad_spend
GROUP BY Campaign
),
revenue AS (
SELECT c.First_Touch_UTM_Campaign AS campaign, SUM(d.Amount) AS revenue_vnd
FROM lumi_skin.deals AS d
JOIN lumi_skin.contacts AS c ON d.Associated_Contact_Email = c.Email
WHERE d.Deal_Stage = 'Completed'
GROUP BY campaign
)
SELECT
s.Campaign,
s.spend_vnd,
r.revenue_vnd,
ROUND(SAFE_DIVIDE(r.revenue_vnd, s.spend_vnd), 1) AS roas
FROM spend AS s
LEFT JOIN revenue AS r ON s.Campaign = r.campaign
ORDER BY roas DESC;


-- Q4. Repeat rate by campaign (customers with 2+ Completed orders / all customers)
-- Expected: blended repeat rate about 35%
WITH buyers AS (
SELECT Associated_Contact_Email AS email, COUNT(*) AS orders
FROM lumi_skin.deals
WHERE Deal_Stage = 'Completed'
GROUP BY email
)
SELECT
c.First_Touch_UTM_Campaign AS campaign,
COUNT(*) AS customers,
COUNTIF(b.orders >= 2) AS repeat_customers,
ROUND(100 * SAFE_DIVIDE(COUNTIF(b.orders >= 2), COUNT(*)), 2) AS repeat_rate_pct
FROM buyers AS b
JOIN lumi_skin.contacts AS c ON b.email = c.Email
GROUP BY campaign
ORDER BY repeat_rate_pct DESC;


-- Q5. Monthly revenue and AOV (average order value), Completed orders, by close date
-- Expected: 2026-08: 20 orders, 15,306,000 | 2026-09: 64, 36,029,000 | 2026-10: 80, 48,680,000 | 2026-11: 35, 22,371,000
-- (total 199 orders, 122,386,000)
SELECT
FORMAT_DATE('%Y-%m', Close_Date) AS month,
COUNT(*) AS orders,
SUM(Amount) AS revenue_vnd,
ROUND(AVG(Amount)) AS aov_vnd
FROM lumi_skin.deals
WHERE Deal_Stage = 'Completed'
GROUP BY month
ORDER BY month;
