const fs = require('node:fs');
const path = require('node:path');
module.exports = async ({browser,fixture}) => {
  const checks=[], viewports=[];
  const check=(condition,label)=>{checks.push({label,passed:!!condition});if(!condition)throw new Error(label);};
  const login=async(page,email=fixture.email)=>{
    await page.goto(fixture.base+'/login');
    await page.getByLabel('Email',{exact:true}).fill(email);
    await page.getByLabel('Password',{exact:true}).fill(fixture.password);
    await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);
  };
  const openGroup=async(page,label)=>{
    const group=page.locator('.nav-group').filter({has:page.locator('summary').filter({hasText:label})});
    if(!await group.evaluate(el=>el.open))await group.locator('summary').click();
  };
  try {
    for(const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]) {
      const start=checks.length;
      const context=await browser.newContext({viewport:{width,height}}),page=await context.newPage();
      const errors=[];page.on('pageerror',e=>errors.push(e.message));
      await login(page);
      check(await page.getByRole('heading',{name:'Dashboard',exact:true}).isVisible(),`Dashboard langsung ${width}`);
      check(await page.locator('.primary-navigation .nav-direct').getAttribute('href')==='/',`Dashboard bukan accordion ${width}`);
      check(await page.locator('.primary-navigation [data-nav-id]').count()===24,`Dua puluh empat route nyata admin ${width}`);
      check(await page.locator('.bottom-navigation a').count()===4,`Empat shortcut admin ${width}`);
      check(!await page.locator('.bottom-navigation button,.bottom-navigation [data-drawer-toggle],a[href*="profile"],button[aria-label="Notifikasi"]').count(),`Tanpa menu/profil/notifikasi palsu ${width}`);
      const mobile=width<1024;
      const toggle=page.getByLabel('Buka navigasi',{exact:true});
      const openDrawer=async()=>{await toggle.click();await page.waitForFunction(()=>document.getElementById('primary-sidebar').getBoundingClientRect().left>=-0.5);};
      check(await toggle.isVisible()===mobile,`Hamburger sesuai viewport ${width}`);
      check(await page.locator('.bottom-navigation').isVisible()===mobile,`Bottom nav sesuai viewport ${width}`);
      if(mobile){
        check(await page.locator('[data-drawer-toggle]').count()===1,`Satu hamburger ${width}`);
        const box=await toggle.boundingBox(),logo=await page.locator('.header-brand').boundingBox(),profile=await page.locator('.profile-trigger').boundingBox();
        check(box.x<24 && logo.x>=box.x+box.width && profile.x>=logo.x+logo.width,`Urutan header kiri ke kanan ${width}`);
        check(await page.locator('#primary-sidebar').evaluate(el=>el.inert),`Drawer tertutup inert ${width}`);
        const metrics=await page.locator('.bottom-navigation').evaluate(el=>({height:el.getBoundingClientRect().height,label:parseFloat(getComputedStyle(el.querySelector('a')).fontSize),icon:el.querySelector('svg').getBoundingClientRect().width}));
        check(metrics.height>=60&&metrics.height<=64&&metrics.label>=10&&metrics.label<=11&&metrics.icon>=20&&metrics.icon<=22,`Ukuran bottom nav ${width}`);
        await openDrawer();
        check(await toggle.getAttribute('aria-expanded')==='true',`Drawer buka ${width}`);
        check(await page.locator('.sidebar-brand img').evaluate(img=>{const box=img.getBoundingClientRect(),side=img.closest('.sidebar').getBoundingClientRect();return box.x>=0&&box.right<=side.right&&Math.abs(box.width/box.height-2170/725)<0.01;}),`Logo drawer tidak terpotong ${width}`);
        check(await page.evaluate(()=>document.getElementById('workspace').inert&&document.getElementById('bottom-navigation').inert&&getComputedStyle(document.body).overflow==='hidden'),`Kunci scroll dan fokus latar ${width}`);
        check(await page.locator('.drawer-close').evaluate(el=>el===document.activeElement),`Fokus awal X ${width}`);
        await page.evaluate(()=>{const side=document.getElementById('primary-sidebar');window.testFirst=side.querySelector('.brand');window.testLast=side.querySelector('.nav-group:last-of-type > summary');window.testFirst.focus();});
        await page.keyboard.press('Shift+Tab');check(await page.evaluate(()=>document.activeElement===window.testLast),`Focus trap mundur ${width}`);
        await page.keyboard.press('Tab');check(await page.evaluate(()=>document.activeElement===window.testFirst),`Focus trap maju ${width}`);
        await page.keyboard.press('Escape');
        check(await toggle.getAttribute('aria-expanded')==='false'&&await toggle.evaluate(el=>el===document.activeElement),`Escape dan restore fokus ${width}`);
        await openDrawer();await page.locator('.drawer-overlay').click({position:{x:width-4,y:height/2}});
        check(await toggle.getAttribute('aria-expanded')==='false',`Overlay menutup ${width}`);
        await openDrawer();await page.locator('.drawer-close').click();
        check(await toggle.getAttribute('aria-expanded')==='false',`X menutup ${width}`);
        await openDrawer();await openGroup(page,'Master Data');
        await Promise.all([page.waitForURL(fixture.base+'/branches'),page.locator('.primary-navigation [data-nav-id="branches"]').click()]);
        check(await toggle.getAttribute('aria-expanded')==='false',`Pilih submenu menutup drawer ${width}`);
        await page.locator('.bottom-navigation [data-nav-id="users"]').click();await page.waitForURL(fixture.base+'/users');
        check(await toggle.isVisible(),`Hamburger tetap terlihat setelah navigasi ${width}`);
        await openDrawer();await openGroup(page,'Pengaturan');
        await page.screenshot({path:path.join(__dirname,'results',`phase2-drawer-${width}.png`)});
        await page.keyboard.press('Escape');
      }else{
        check(await page.locator('#primary-sidebar').isVisible()&&!await page.locator('#primary-sidebar').evaluate(el=>el.inert),`Sidebar desktop terlihat dan aktif ${width}`);
        await openGroup(page,'Pengaturan');
        const group=page.locator('.nav-group').filter({has:page.locator('summary').filter({hasText:'Pengaturan'})});
        await group.locator('summary').click();check(!await group.evaluate(el=>el.open),`Accordion tutup ${width}`);
        await group.locator('summary').click();check(await group.evaluate(el=>el.open),`Accordion buka ${width}`);
      }
      const links=await page.locator('.primary-navigation [data-nav-id]').evaluateAll(nodes=>nodes.map(n=>n.getAttribute('href')));
      for(const route of links){
        const response=await page.goto(fixture.base+route);check(response.status()===200,`Menu menuju route nyata ${route} ${width}`);
        check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow ${route} ${width}`);
        check(await page.locator('.primary-navigation [aria-current="page"]').count()===1,`Satu menu aktif ${route} ${width}`);
      }
      const image=mobile?page.locator('.header-brand img'):page.locator('.sidebar-brand img');
      check(await image.evaluate(img=>img.complete&&img.naturalWidth===2170&&Math.abs(img.getBoundingClientRect().width/img.getBoundingClientRect().height-2170/725)<0.01),`Logo utuh dan proporsional ${width}`);
      if(mobile){
        await page.locator('.app-footer').scrollIntoViewIfNeeded();
        check(await page.locator('.app-footer').evaluate(el=>el.getBoundingClientRect().bottom<=document.querySelector('.bottom-navigation').getBoundingClientRect().top+1),`Konten terakhir bebas bottom nav ${width}`);
      }
      await page.goto(fixture.base+'/branches?mode=create');
      await page.evaluate(()=>scrollTo(0,document.documentElement.scrollHeight));
      if(mobile)check(await page.getByRole('button',{name:'Simpan Cabang',exact:true}).evaluate(el=>el.getBoundingClientRect().bottom<=document.querySelector('.bottom-navigation').getBoundingClientRect().top+1),`Tombol simpan tidak tertutup ${width}`);
      check(await page.locator('.app-header').evaluate(el=>Math.abs(el.getBoundingClientRect().top)<1),`Header tetap di atas saat scroll ${width}`);
      await page.evaluate(()=>window.scrollTo(0,0));
      await page.screenshot({path:path.join(__dirname,'results',`phase2-${width}.png`)});
      check(!errors.length,`Tidak ada error JS ${width}`);
      viewports.push({width,height,passed:checks.length-start});await context.close();
    }
    // Exercise real confirmation, validation, loading and pagination on foundation data.
    const context=await browser.newContext({viewport:{width:375,height:812}}),page=await context.newPage();await login(page);
    await page.goto(fixture.base+'/branches?mode=create');
    await page.getByRole('button',{name:'Simpan Cabang',exact:true}).click();
    check(await page.getByLabel('Kode',{exact:true}).getAttribute('aria-invalid')==='true','Validasi field tanpa kehilangan halaman');
    await page.goto(fixture.base+'/branches');
    const edit=page.locator('tr').filter({hasText:'TESTA'}).getByRole('link',{name:'Edit',exact:true});await edit.click();
    await page.getByLabel('Alamat',{exact:true}).fill('Perubahan UI teruji');
    await page.getByRole('button',{name:'Simpan Cabang',exact:true}).click();
    check(await page.getByRole('dialog').isVisible(),'Modal konfirmasi tampil pada edit nyata');
    await page.getByRole('button',{name:'Batal',exact:true}).click();
    check(!await page.getByRole('dialog').count()||!await page.getByRole('dialog').isVisible(),'Batal konfirmasi tidak submit');
    check(await page.getByLabel('Alamat',{exact:true}).inputValue()==='Perubahan UI teruji','Batal mempertahankan input');
    await page.getByRole('button',{name:'Simpan Cabang',exact:true}).click();
    await page.keyboard.press('Escape');check(!await page.locator('#confirmation-dialog').isVisible(),'Escape menutup modal konfirmasi');
    await page.getByRole('button',{name:'Simpan Cabang',exact:true}).click();
    await page.evaluate(()=>{sessionStorage.removeItem('test-loading-visible');const state=document.querySelector('.loading-state');new MutationObserver(()=>{if(!state.hidden&&state.getBoundingClientRect().height>0)sessionStorage.setItem('test-loading-visible','true');}).observe(state,{attributes:true,attributeFilter:['hidden']});});
    await page.route('**/branches',async route=>{if(route.request().method()==='POST')await new Promise(resolve=>setTimeout(resolve,150));await route.continue();});
    await Promise.all([page.waitForURL(url=>url.pathname==='/branches'&&url.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Ya, simpan',exact:true}).click()]);
    check(await page.evaluate(()=>sessionStorage.getItem('test-loading-visible')==='true'),'Loading state terlihat sebelum navigasi submit nyata');
    check(await page.getByRole('status').filter({hasText:'Data master disimpan.'}).isVisible(),'Alert sukses setelah simpan');
    await page.goto(fixture.base+'/audit');const first=await page.locator('tbody tr:first-child td:first-child').innerText();
    await page.getByRole('link',{name:'Berikutnya',exact:true}).click();
    check(await page.locator('tbody tr:first-child td:first-child').innerText()!==first,'Pagination memuat catatan berbeda');
    // Account switching is tested in the same browser context to detect stale menus.
    for(const account of fixture.roleAccounts){
      await page.getByLabel('Profil akun',{exact:true}).click();
      await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);
      await login(page,account.email);
      const expected=account.role==='Administrator'?['dashboard','users','branches','roles']:account.role==='Admin Pengirim'?['dashboard','dn','tracking']:account.role==='Admin Transit'?['dashboard','manifest','transit']:account.role==='Admin Penerima'?['dashboard','receipts','claims']:account.role==='Admin Sewa'?['dashboard','contracts','timesheets']:account.role==='Operator Alat Berat'?['dashboard','timesheets-own']:['dashboard'];
      check(JSON.stringify(await page.locator('.bottom-navigation [data-nav-id]').evaluateAll(nodes=>nodes.map(n=>n.dataset.navId)))===JSON.stringify(expected),`Shortcut permission ${account.role}`);
      const response=await page.request.get(fixture.base+'/users');check(response.status()===(account.role==='Administrator'?200:403),`Backend permission ${account.role}`);
      check(!await page.locator('.primary-navigation a[href*="expedition"],.primary-navigation a[href*="finance"],.primary-navigation a[href*="rental"]').count(),`Tanpa menu bisnis ${account.role}`);
    }
    // Scoped Administrator has branch access but no global administrative shortcuts.
    await page.getByLabel('Profil akun',{exact:true}).click();await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);await login(page,fixture.scopedEmail);
    check(JSON.stringify(await page.locator('.bottom-navigation [data-nav-id]').evaluateAll(nodes=>nodes.map(n=>n.dataset.navId)))===JSON.stringify(['dashboard','branches']),'Shortcut admin scoped mengikuti cakupan global');
    await page.goto(fixture.base+'/branches');check(!await page.getByText('Cabang B Privat',{exact:true}).count(),'Cabang tersembunyi setelah pergantian akun');
    await context.close();
    fs.writeFileSync(path.join(__dirname,'results','navigation.json'),JSON.stringify({passed:checks.length,viewports,checks},null,2));
  }catch(error){fs.writeFileSync(path.join(__dirname,'results','navigation.json'),JSON.stringify({failure:error.message,passed:checks.filter(c=>c.passed).length,viewports,checks},null,2));throw error;}
};
