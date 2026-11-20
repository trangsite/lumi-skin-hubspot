# Lumi Skin: HubSpot CRM Portfolio Project

Portfolio project for a **fictional** D2C skincare brand in Ho Chi Minh City, Vietnam.
I set up a HubSpot CRM, connected the lead sources, built automations and dashboards, and wrote SQL for campaign reports.

> **All data is simulated.** Lumi Skin is not a real company. Emails use example.com / example.org / example.net. Please do not enter real personal data on the landing page.

## Links
- Read the full story with screenshots (Notion): https://app.notion.com/p/HubSpot-CRM-Implementation-Lumi-Skin-Portfolio-Project-41dd3a800ccc800f90cefe4dd3d73872?source=copy_link
- Landing page (GitHub Pages): https://trangsite.github.io/lumi-skin-hubspot/
- Admin runbook 5 SOPs (Notion): https://app.notion.com/p/Lumi-Skin-HubSpot-Admin-Runbook-41dd3a800ccc80048cd3c1d6f0716b79?source=copy_link
- Looker Studio dashboard: https://datastudio.google.com/reporting/f13f8b86-d86e-4311-a3fb-44bff54f0101
- Google Drive (dataset, photos, docs): https://drive.google.com/drive/folders/1AmqgrkhIYSL3JHnx6h_mVOzPAKYIVf7w?usp=sharing 

## The problem

The client had no CRM. Leads lived in Excel, and nobody knew which ad campaign brought the best customers. The goal was to track **campaign → lead → purchase**, automate follow-ups, and give the founder a simple dashboard.

## What is in this repo

| Folder / file | What it is |
|---|---|
| `index.html` | Bilingual (EN/VI) landing page with a HubSpot form and tracking code |
| `privacy.html` | Privacy page (needed for the Meta Instant Form) |
| `images/` | Images used by the landing page |
| `apps-script/` | Google Apps Script: reads leads from a Google Sheet and creates or updates contacts in HubSpot (search by email, then create or update) |
| `sql/queries.sql` | 5 BigQuery queries on campaign performance |
| `docs/` | Admin documentation |
| `data/` | data of ad spend daily, contacts, deals |

## What I built

1. **HubSpot setup:** deal pipeline, 10 custom contact properties, lists, lifecycle rules, data governance rules.
2. **Data work:** cleaned a messy Excel file (648 rows → 600 unique contacts) and imported 600 contacts and 242 deals.
3. **Lead capture:** website form with hidden UTM fields; Meta Instant Form connected to HubSpot Ads; Apps Script that syncs contacts through the HubSpot API.
4. **Automation and reporting:** 3 workflows (new lead, abandoned cart, repeat purchase), a HubSpot dashboard, and a Looker Studio dashboard for ad spend vs revenue.
5. **SQL:** 5 queries for spend, CPL, conversion, ROAS, repeat rate, monthly revenue and AOV.

## SQL queries

File: `sql/queries.sql` (BigQuery, dataset `lumi_skin`, tables `contacts`, `deals`, `ad_spend`)

| # | Question |
|---|---|
| 1 | Spend, leads and CPL by campaign |
| 2 | Customers and conversion by campaign |
| 3 | Completed revenue and ROAS by campaign |
| 4 | Repeat rate by campaign |
| 5 | Monthly revenue and AOV |

Key results (simulated data): total spend 30,000,000 VND, completed revenue 122,386,000 VND, blended ROAS 4.08, repeat rate about 35%.
Best ROAS: `google_search_brand` (8.8) and `meta_msg_sensitive` (6.7). Weakest: `google_search_generic` (1.8).

## Real vs simulated

| Real (built and tested) | Simulated or limited |
|---|---|
| HubSpot configuration, imports, workflows, dashboards | All customer, order and ad-spend data |
| Landing page with HubSpot form and tracking | Meta leads: the connection and lead delivery to HubSpot are real, but the leads came from Meta's Lead Ads Testing Tool (test data). 10 more Meta-style contacts were loaded by CSV |
| Meta Instant Form connected to HubSpot Ads | Google Ads: account connected only, no campaigns or data |
| Apps Script → HubSpot API (3 test contacts created) | Shopify (sample order data only) |
| | WhatsApp (process and templates only) |

Not done on purpose: running paid ads and adding a payment method to Meta.

## Security

No API tokens are stored in this repo. The HubSpot token is kept in Apps Script **Script Properties**, not in the code.
Note: HubSpot private apps are no longer available on my account, so I used a **Service Key** instead.

## Author

Trang Nguyen, CRM / marketing operations. 
LinkedIn: www.linkedin.com/in/trang-nguyen-51833921b 
