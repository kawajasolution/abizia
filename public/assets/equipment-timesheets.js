(() => {
  const host=document.querySelector('[data-work-intervals]'),template=document.querySelector('#ts-interval-template');
  if(!host||!template)return;
  let sequence=host.children.length;
  document.querySelector('[data-add-interval]')?.addEventListener('click',()=>{
    if(host.children.length>=100)return;
    const fragment=template.content.cloneNode(true),index=++sequence;
    fragment.querySelectorAll('[id],[for],[name]').forEach(el=>{for(const attr of ['id','for','name'])if(el.hasAttribute(attr))el.setAttribute(attr,el.getAttribute(attr).replaceAll('ENTRY_INDEX',String(index)));});
    host.append(fragment);host.lastElementChild.querySelector('input')?.focus();
  });
  host.addEventListener('click',event=>{const button=event.target.closest('[data-remove-interval]');if(button&&host.children.length>1)button.closest('fieldset').remove();});
})();
