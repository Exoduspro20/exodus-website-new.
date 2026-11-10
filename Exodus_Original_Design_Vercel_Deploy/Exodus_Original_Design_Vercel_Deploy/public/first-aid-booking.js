// Paste the full public Calendly group-event URL between the quotes below.
// Example format: https://calendly.com/your-account/your-event
const EXODUS_FIRST_AID_CALENDLY_URL = "https://calendly.com/daljit-exoduspro/exodus-emergency-first-aid-cpr-aed-training";
(() => {
  const link = document.getElementById('exodusBookingLink');
  const pending = document.getElementById('exodusBookingPending');
  if (!link || !pending) return;
  try {
    const url = new URL(EXODUS_FIRST_AID_CALENDLY_URL);
    if (url.protocol !== 'https:' || !(['calendly.com','www.calendly.com'].includes(url.hostname))) return;
    link.href = url.href; link.hidden = false; pending.hidden = true;
  } catch (_) { /* No booking URL configured yet. */ }
})();
