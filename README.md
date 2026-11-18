# Lumi Skin: HubSpot CRM Portfolio Project

Portfolio project for a **fictional** D2C skincare brand in Ho Chi Minh City, Vietnam.
I set up a HubSpot CRM, connected the lead sources, built automations and dashboards, and wrote SQL for campaign reports.

> **All data is simulated.** Lumi Skin is not a real company. Emails use example.com / example.org / example.net. Please do not enter real personal data on the landing page.

## Links

- Full case study (Notion): [your Notion link]
- Looker Studio dashboard: https://datastudio.google.com/reporting/f13f8b86-d86e-4311-a3fb-44bff54f0101  
- Video walkthrough (Loom, 4-5 min): [your Loom link]
- Landing page (GitHub Pages): https://trangsite.github.io/lumi-skin-hubspot/

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

## What I built

1. **HubSpot setup:** deal pipeline, 10 custom contact properties, lists, lifecycle rules, data governance rules.
2. **Data work:** cleaned a messy Excel file (648 rows → 600 unique contacts) and imported 600 contacts and 242 deals.
3. **Lead capture:** website form with hidden UTM fields, Meta Instant Form connected to HubSpot, API sync with Apps Script.
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

| Real (built and tested) | Simulated |
|---|---|
| HubSpot configuration, imports, workflows, dashboards | All customer, order and ad-spend data |
| Landing page with HubSpot form and tracking | 10 Meta test leads (loaded by CSV) |
| Meta Instant Form connected to HubSpot Ads | Shopify (Real - tested leads) |
| Apps Script → HubSpot API (3 test contacts) | WhatsApp (process and templates only) |

Not done on purpose: running paid ads and adding a payment method to Meta.

## Security

No API tokens are stored in this repo. The HubSpot token is kept in Apps Script **Script Properties**, not in the code.
Note: HubSpot private apps are no longer available on my account, so I used a **Service Key** instead.

## Author

Trang Nguyen, CRM / marketing operations. Contact: thuytrangdalat99@gmail.com
