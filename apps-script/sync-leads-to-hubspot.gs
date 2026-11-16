const HS_CONTACTS = 'https://api.hubapi.com/crm/v3/objects/contacts';

function syncLeadsToHubSpot() {
  const token = PropertiesService.getScriptProperties().getProperty('HUBSPOT_TOKEN');
  if (!token) throw new Error('Missing HUBSPOT_TOKEN in Script Properties');

  const sheet = SpreadsheetApp.getActiveSheet();
  const rows = sheet.getDataRange().getDisplayValues();
  const header = rows[0].map(h => String(h).trim().toLowerCase());
  const col = name => header.indexOf(name);

  ['email', 'firstname', 'lastname', 'phone'].forEach(n => {
    if (col(n) === -1) throw new Error('Missing column in row 1: ' + n);
  });

  let statusCol = col('status');
  if (statusCol === -1) {
    statusCol = header.length;
    sheet.getRange(1, statusCol + 1).setValue('status');
  }

  for (let i = 1; i < rows.length; i++) {
    const email = String(rows[i][col('email')]).trim();
    if (!email) continue;

    const props = {
      email: email,
      firstname: String(rows[i][col('firstname')]).trim(),
      lastname: String(rows[i][col('lastname')]).trim(),
      phone: normalizePhone_(rows[i][col('phone')])
    };

    let result;
    try {
      const id = findContactId_(email, token);
      if (id) {
        hsCall_('patch', HS_CONTACTS + '/' + id, { properties: props }, token);
        result = 'updated';
      } else {
        hsCall_('post', HS_CONTACTS, { properties: props }, token);
        result = 'created';
      }
    } catch (e) {
      result = 'error: ' + e.message;
    }
    sheet.getRange(i + 1, statusCol + 1).setValue(result + ' | ' + new Date().toISOString());
    Utilities.sleep(300);
  }
}

function findContactId_(email, token) {
  const body = {
    filterGroups: [{ filters: [{ propertyName: 'email', operator: 'EQ', value: email }] }],
    limit: 1
  };
  const res = hsCall_('post', HS_CONTACTS + '/search', body, token);
  return res.results && res.results.length ? res.results[0].id : null;
}

function hsCall_(method, url, payload, token) {
  const response = UrlFetchApp.fetch(url, {
    method: method,
    contentType: 'application/json',
    headers: { Authorization: 'Bearer ' + token },
    payload: JSON.stringify(payload),
    muteHttpExceptions: true
  });
  const code = response.getResponseCode();
  if (code < 200 || code >= 300) {
    throw new Error('HTTP ' + code + ' ' + response.getContentText().slice(0, 200));
  }
  return JSON.parse(response.getContentText() || '{}');
}

function normalizePhone_(raw) {
  let p = String(raw).replace(/[^0-9+]/g, '');
  if (!p) return '';
  if (p.charAt(0) === '0') return '+84' + p.slice(1);
  if (p.indexOf('84') === 0) return '+' + p;
  return p;
}
