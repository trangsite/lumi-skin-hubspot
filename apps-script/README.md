# Google Sheet → HubSpot contact sync (Apps Script)

Demo integration for the fictional brand Lumi Skin (portfolio project, simulated data).

## What it does
Reads rows from a Google Sheet (`email`, `firstname`, `lastname`, `phone`),
searches HubSpot by email, then creates the contact or updates it (upsert).
Phone numbers are normalised to +84 format. The result of each row is written
to a `status` column.

## How it works
1. `POST /crm/v3/objects/contacts/search` filtered on email
2. If found: `PATCH /crm/v3/objects/contacts/{id}`; if not: `POST /crm/v3/objects/contacts`

## Setup
1. Create a HubSpot service key (Development → Keys → Service keys) with the scopes
   `crm.objects.contacts.read` and `crm.objects.contacts.write`.
2. In the Sheet: Extensions → Apps Script → Project Settings → Script Properties →
   add `HUBSPOT_TOKEN` with the key value. The token is never stored in code.
3. Paste `sync-leads-to-hubspot.gs`, run `syncLeadsToHubSpot`, authorise.

## Notes
- Re-running is safe: existing emails are updated, not duplicated.
- Legacy private apps are not available on new HubSpot accounts, so a service key is used.
- All data is fictional. Test emails use plus-addressing on one Gmail inbox.
