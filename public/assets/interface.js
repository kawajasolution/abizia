'use strict';
(() => {
  const sidebar = document.getElementById('primary-sidebar');
  const toggle = document.querySelector('[data-drawer-toggle]');
  const overlay = document.querySelector('.drawer-overlay');
  const workspace = document.getElementById('workspace');
  const bottom = document.getElementById('bottom-navigation');
  const mobile = matchMedia('(max-width:1023px)');
  let drawerOpen = false;
  const sidebarScrollKey = 'hls-v2.sidebar.scrollTop';
  function restoreSidebarScroll() {
    if (!sidebar) return;
    const saved = Number(sessionStorage.getItem(sidebarScrollKey));
    if (Number.isFinite(saved) && saved >= 0) requestAnimationFrame(() => { sidebar.querySelector('.primary-navigation')?.scrollTo(0, saved); });
  }
  const focusable = root => [...root.querySelectorAll('a[href],button:not([disabled]),summary,input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex="0"]')].filter(el => {
    if (!el.getClientRects().length || el.closest('[inert]')) return false;
    const closed = el.closest('details:not([open])');
    return !closed || el === closed.querySelector(':scope > summary');
  });
  function setDrawer(open, restore = true) {
    if (!sidebar || !toggle) return;
    drawerOpen = !!open && mobile.matches;
    sidebar.classList.toggle('is-open', drawerOpen);
    document.body.classList.toggle('drawer-open', drawerOpen);
    toggle.setAttribute('aria-expanded', String(drawerOpen));
    sidebar.inert = mobile.matches && !drawerOpen;
    workspace.inert = drawerOpen;
    if (bottom) bottom.inert = drawerOpen;
    overlay.hidden = !drawerOpen;
    if (drawerOpen) {
      document.querySelector('.profile-menu')?.removeAttribute('open');
      sidebar.setAttribute('role', 'dialog'); sidebar.setAttribute('aria-modal', 'true');
      sidebar.querySelector('.drawer-close').focus();
    } else {
      sidebar.removeAttribute('role'); sidebar.removeAttribute('aria-modal');
      if (restore && mobile.matches) toggle.focus();
    }
  }
  if (sidebar && toggle) {
    restoreSidebarScroll();
    const navigation = sidebar.querySelector('.primary-navigation');
    navigation?.addEventListener('scroll', () => sessionStorage.setItem(sidebarScrollKey, String(navigation.scrollTop)), { passive: true });
    sidebar.addEventListener('click', event => { if (event.target.closest('a[href]') && navigation) sessionStorage.setItem(sidebarScrollKey, String(navigation.scrollTop)); });
    setDrawer(false, false);
    toggle.addEventListener('click', () => setDrawer(!drawerOpen));
    document.querySelectorAll('[data-drawer-close]').forEach(button => button.addEventListener('click', () => setDrawer(false)));
    sidebar.addEventListener('click', event => { if (event.target.closest('a[href]')) setDrawer(false); });
    mobile.addEventListener('change', () => setDrawer(false, false));
    document.addEventListener('keydown', event => {
      if (!drawerOpen) return;
      if (event.key === 'Escape') { event.preventDefault(); setDrawer(false); }
      if (event.key === 'Tab') {
        const items = focusable(sidebar), first = items[0], last = items.at(-1);
        if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
        else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
      }
    });
  }
  const profile = document.querySelector('.profile-menu');
  profile?.addEventListener('click', event => { if (event.target.closest('a[href]')) profile.open = false; });
  document.addEventListener('click', event => { if (profile?.open && !profile.contains(event.target)) profile.open = false; });
  document.addEventListener('keydown', event => { if (event.key === 'Escape' && profile?.open) { profile.open = false; profile.querySelector('summary').focus(); } });
  const dialog = document.getElementById('confirmation-dialog');
  let pendingForm = null, pendingSubmitter = null;
  const clearErrors = form => form.querySelectorAll('[aria-invalid]').forEach(field => { field.removeAttribute('aria-invalid'); field.removeAttribute('aria-describedby'); const error = document.getElementById(field.id + '-error'); if (error) error.hidden = true; });
  function validate(form) {
    clearErrors(form);
    if (form.checkValidity()) return true;
    for (const field of form.querySelectorAll('input,select,textarea')) {
      if (field.validity.valid) continue;
      field.setAttribute('aria-invalid', 'true');
      const error = document.getElementById(field.id + '-error');
      if (error) { error.textContent = field.validity.valueMissing ? 'Isian ini wajib diisi.' : field.validity.typeMismatch ? 'Format isian belum sesuai.' : 'Periksa panjang dan format isian.'; error.hidden = false; field.setAttribute('aria-describedby', error.id); }
    }
    form.querySelector('[aria-invalid]')?.focus(); return false;
  }
  function busy(form) {
    form.dataset.submitting = 'true'; form.setAttribute('aria-busy', 'true');
    document.querySelector('.loading-state').hidden = false;
    // Keep all successful controls (including submitter) intact for native submission.
    form.querySelectorAll('button[type="submit"],button:not([type])').forEach(button => { button.setAttribute('aria-disabled', 'true'); button.classList.add('is-loading'); });
  }
  document.querySelectorAll('form[method="post"]').forEach(form => {
    form.noValidate = true;
    form.addEventListener('submit', event => {
      if (form.dataset.submitting === 'true') { event.preventDefault(); return; }
      if (!validate(form)) { event.preventDefault(); return; }
      if (form.dataset.confirm && form.dataset.confirmed !== 'true' && typeof dialog?.showModal === 'function') {
        event.preventDefault(); pendingForm = form; pendingSubmitter = event.submitter;
        document.getElementById('confirmation-description').textContent = form.dataset.confirm;
        dialog.showModal(); dialog.querySelector('[data-confirm-cancel]').focus(); return;
      }
      busy(form);
    });
    form.addEventListener('input', event => { if (event.target.hasAttribute('aria-invalid')) clearErrors(form); });
  });
  document.querySelector('[data-confirm-cancel]')?.addEventListener('click', () => dialog.close());
  document.querySelector('[data-confirm-accept]')?.addEventListener('click', () => {
    const form = pendingForm, submitter = pendingSubmitter; dialog.close();
    if (form) { form.dataset.confirmed = 'true'; form.requestSubmit(submitter || undefined); }
  });
  dialog?.addEventListener('close', () => { if (pendingSubmitter?.isConnected) pendingSubmitter.focus(); pendingForm = null; pendingSubmitter = null; });
  window.addEventListener('pageshow', () => {
    document.querySelector('.loading-state').hidden = true;
    document.querySelectorAll('form[data-submitting]').forEach(form => { delete form.dataset.submitting; delete form.dataset.confirmed; form.removeAttribute('aria-busy'); form.querySelectorAll('[aria-disabled]').forEach(button => { button.removeAttribute('aria-disabled'); button.classList.remove('is-loading'); }); });
  });
})();

document.querySelectorAll('[data-add-item]').forEach(button=>button.addEventListener('click',()=>{const box=button.form?.querySelector('[data-bill-items]');const first=box?.querySelector('.bill-item');if(!box||!first)return;const row=first.cloneNode(true);row.querySelectorAll('input').forEach(i=>i.value='');box.appendChild(row);}));document.addEventListener('click',e=>{if(!e.target.matches('[data-remove-item]'))return;const box=e.target.closest('[data-bill-items]');const rows=box?.querySelectorAll('.bill-item')||[];if(rows.length>1)e.target.closest('.bill-item').remove();});
