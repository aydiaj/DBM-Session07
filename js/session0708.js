(() => {
  'use strict';
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
  const panels = $$('.lesson');
  const n = panels.length;
  // Expanded dataset uses a new database; old recorded practice keys must not carry over.
  const KEY = 'dbm-session0708-progress-v2';
  const THEME = 'dbm-session0708-theme-v1';
  let state = { completed: [], values: {} };
  try {
    const saved = JSON.parse(localStorage.getItem(KEY) || 'null');
    if (saved && Array.isArray(saved.completed) && saved.values && typeof saved.values === 'object') {
      state = {completed:[...new Set(saved.completed.filter(i => Number.isInteger(i) && i >= 0 && i < n))],values:saved.values};
    }
  } catch { $('#s6-storage-status').textContent = 'Progress storage unavailable. Keep your own notes.'; }
  const persist = () => {
    try { localStorage.setItem(KEY, JSON.stringify(state)); }
    catch { $('#s6-storage-status').textContent = 'Progress storage unavailable. Keep your own notes.'; }
  };
  let current = 0, timer;
  const toast = message => {
    const el = $('#s6-toast'); el.textContent=message; el.classList.add('show');
    clearTimeout(timer); timer=setTimeout(() => el.classList.remove('show'),2200);
  };
  const setMenu = open => {
    document.body.classList.toggle('nav-open',open);
    $('#s6-menu').setAttribute('aria-expanded',String(open));
    $('#s6-scrim').hidden=!open;
    if(open) $('.step-link.active')?.focus();
  };
  const render = () => {
    $$('.step-link').forEach((el,i)=>{
      el.classList.toggle('active',i===current);
      el.classList.toggle('done',state.completed.includes(i));
      if(i===current)el.setAttribute('aria-current','step'); else el.removeAttribute('aria-current');
    });
    $$('[data-complete]').forEach(el=>{
      const done=state.completed.includes(Number(el.dataset.complete));
      el.setAttribute('aria-pressed',String(done));
      el.textContent=done?'✓ Step complete':'✓ Mark step complete';
    });
    $('#s6-progress-text').textContent=state.completed.length+' / '+n;
    $('#s6-progress').setAttribute('aria-valuenow',String(state.completed.length));
    $('#s6-progress-fill').style.width=(100*state.completed.length/n)+'%';
  };
  const show = (index, updateHash=true, focus=true) => {
    current=Math.max(0,Math.min(n-1,index)); panels.forEach((p,i)=>p.hidden=i!==current);
    render(); setMenu(false);
    if(updateHash){try{history.replaceState(null,'','#step-'+String(current+1).padStart(2,'0'));}catch{location.hash='#step-'+String(current+1).padStart(2,'0');}}
    if(focus){window.scrollTo({top:0,behavior:matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth'});$('#s6-title-'+current).focus({preventScroll:true});}
  };
  $$('.step-link').forEach(el=>el.addEventListener('click',()=>show(Number(el.dataset.step))));
  $$('[data-prev]').forEach(el=>el.addEventListener('click',()=>show(current-1)));
  $$('[data-next]').forEach(el=>el.addEventListener('click',()=>show(current+1)));
  $$('[data-complete]').forEach(el=>el.addEventListener('click',()=>{
    const i=Number(el.dataset.complete);
    if(state.completed.includes(i)){state.completed=state.completed.filter(x=>x!==i);toast('Step reopened.');}
    else{state.completed.push(i);toast('Step saved as complete.');}
    persist();render();
  }));
  $('#s6-menu').addEventListener('click',()=>setMenu(!document.body.classList.contains('nav-open')));
  $('#s6-close').addEventListener('click',()=>{setMenu(false);$('#s6-menu').focus();});
  $('#s6-scrim').addEventListener('click',()=>{setMenu(false);$('#s6-menu').focus();});
  document.addEventListener('keydown',e=>{
    if(e.key==='Escape'&&document.body.classList.contains('nav-open')){setMenu(false);$('#s6-menu').focus();}
    if(e.key==='Tab'&&document.body.classList.contains('nav-open')){
      const elements=$$('button:not([disabled]),a[href]',$('#s6-sidebar')).filter(el=>el.getClientRects().length);
      if(!elements.length)return;
      const first=elements[0],last=elements.at(-1);
      if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus();}
      if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus();}
    }
  });
  window.addEventListener('resize',()=>{if(window.innerWidth>1000)setMenu(false);});
  const theme = mode => {
    document.body.dataset.theme=mode;
    $('#s6-theme').setAttribute('aria-pressed',String(mode==='dark'));
    $('#s6-theme').setAttribute('aria-label','Switch to '+(mode==='dark'?'light':'dark')+' theme');
  };
  try{theme(localStorage.getItem(THEME)==='dark'?'dark':localStorage.getItem(THEME)==='light'?'light':matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');}catch{theme('light');}
  $('#s6-theme').addEventListener('click',()=>{
    const next=document.body.dataset.theme==='dark'?'light':'dark';theme(next);
    try{localStorage.setItem(THEME,next);}catch{}
  });
  const applyHash = () => {
    if(location.hash==='#sources'){show(n-1,false,false);requestAnimationFrame(()=>$('#sources').scrollIntoView());return;}
    const match=location.hash.match(/^#step-(\d{1,2})$/);
    if(match&&Number(match[1])>=1&&Number(match[1])<=n)show(Number(match[1])-1,false,false);
    else show(0,false,false);
  };
  window.addEventListener('hashchange',applyHash);
  $('#s6-sources-link').addEventListener('click',e=>{e.preventDefault();show(n-1);requestAnimationFrame(()=>$('#sources').scrollIntoView({block:'start'}));});
  $$('[data-save]').forEach(el=>{
    const key=el.dataset.save;
    if(Object.prototype.hasOwnProperty.call(state.values,key)){
      if(el.type==='checkbox')el.checked=!!state.values[key];else el.value=state.values[key];
    }
    el.addEventListener('input',()=>{state.values[key]=el.type==='checkbox'?el.checked:el.value;persist();});
  });
  const dialog=$('#s6-reset-dialog');
  $('#s6-reset').addEventListener('click',()=>{setMenu(false);dialog.showModal();});
  $('#s6-cancel-reset').addEventListener('click',()=>dialog.close());
  $('#s6-confirm-reset').addEventListener('click',()=>{
    state={completed:[],values:{}};
    $$('[data-save]').forEach(el=>{if(el.type==='checkbox')el.checked=false;else el.value='';});
    persist();dialog.close();show(0);toast('Workshop progress reset.');
  });
  document.addEventListener('click',async e=>{
    const button=e.target.closest('.copy-btn');if(!button)return;
    const code=$('pre code',button.closest('.code-shell'));if(!code)return;
    try{
      if(navigator.clipboard&&window.isSecureContext) await navigator.clipboard.writeText(code.textContent);
      else{const t=document.createElement('textarea');t.value=code.textContent;t.style.position='fixed';t.style.opacity='0';document.body.append(t);t.select();const ok=document.execCommand('copy');t.remove();if(!ok)throw Error('copy');}
      toast('Code copied.');
    }catch{toast('Select and copy the code with your keyboard.');}
  });
  // Browser-only seed simulation: no connection to SQL Server and no writes.
  const { rows } = window.DBM0708Seed;
  const pageSize=10;
  let page=1;
  function drawBrowser(){
    const key=$('#sim-keyword').value.trim().toLowerCase(),cat=Number($('#sim-category').value),sup=Number($('#sim-supplier').value),raw=$('#sim-max').value,available=$('#sim-available').checked;
    const limit=raw===''?Infinity:Number(raw);
    const good=raw===''||(Number.isFinite(limit)&&limit>=0);
    const filtered=good?rows.filter(r=>(!key||r[1].toLowerCase().includes(key))&&(!cat||r[5]===cat)&&(!sup||r[6]===sup)&&r[2]<=limit&&(!available||(r[4]&&r[3]>0))).sort((a,b)=>a[2]-b[2]||a[0]-b[0]):[];
    const pages=Math.ceil(filtered.length/pageSize);
    $('#sim-count').textContent=good?filtered.length+' matches · Page '+page+' of '+pages:'Enter a non-negative price.';
    const body=$('#sim-rows');body.replaceChildren();
    for(const r of filtered.slice((page-1)*pageSize,page*pageSize)){
      const tr=document.createElement('tr');
      for(const value of [r[0],r[1],r[2].toFixed(2),r[3],r[5]]){const td=document.createElement('td');td.textContent=value;tr.append(td);}
      body.append(tr);
    }
    if(!body.children.length){const tr=document.createElement('tr'),td=document.createElement('td');td.colSpan=5;td.textContent='No matching items on this page.';tr.append(td);body.append(tr);}
    $('#sim-page').value=String(page);
    $('#sim-prev').disabled=page===1;$('#sim-next').disabled=page>=pages;
  }
  $$('.sim-controls input,.sim-controls select').forEach(el=>el.addEventListener('input',()=>{page=1;drawBrowser();}));
  $('#sim-prev').addEventListener('click',()=>{page=Math.max(1,page-1);drawBrowser();});
  $('#sim-next').addEventListener('click',()=>{page++;drawBrowser();});
  $('#sim-go').addEventListener('click',()=>{
    const requested=Number($('#sim-page').value);
    if(!Number.isInteger(requested)||requested<1||requested>10000){toast('Enter a whole page number from 1 to 10000.');return;}
    page=requested;drawBrowser();
  });
  $('#sim-reset').addEventListener('click',()=>{
    $('#sim-keyword').value='';$('#sim-category').value='0';$('#sim-supplier').value='0';$('#sim-max').value='';$('#sim-available').checked=true;page=1;drawBrowser();
  });
  drawBrowser();
  applyHash();
})();
