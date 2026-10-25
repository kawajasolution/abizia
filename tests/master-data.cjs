const fs=require('node:fs'),path=require('node:path');
module.exports=async({browser,fixture})=>{
 const checks=[],viewports=[];const check=(pass,label)=>{checks.push({label,passed:!!pass});if(!pass)throw new Error(label);};
 const login=async(page,email=fixture.email)=>{await page.goto(fixture.base+'/login');await page.getByLabel('Email',{exact:true}).fill(email);await page.getByLabel('Password',{exact:true}).fill(fixture.password);await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);};
 try{
  for(const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]){
   const start=checks.length,context=await browser.newContext({viewport:{width,height}}),page=await context.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));await login(page);
   for(const [route,group] of Object.entries(fixture.masterGroups)){
    const response=await page.goto(fixture.base+route);check(response.status()===200,`Daftar nyata ${route} ${width}`);
    check(await page.getByLabel('Pencarian',{exact:true}).isVisible(),`Pencarian tersedia ${route} ${width}`);
    check(await page.getByRole('link',{name:'Tambah Data',exact:true}).isVisible(),`Tombol tambah terpisah ${route} ${width}`);
    check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow ${route} ${width}`);
    check(await page.locator('.primary-navigation [aria-current="page"]').count()===1,`Satu menu aktif ${route} ${width}`);
   }
   await page.goto(fixture.base+'/master/customers');await page.evaluate(()=>scrollTo(0,0));await page.screenshot({path:path.join(__dirname,'results',`phase4-list-${width}.png`)});
   await page.getByRole('link',{name:'Tambah Data',exact:true}).click();
   check(!await page.locator('table').count(),`Form terpisah dari daftar ${width}`);
   await page.getByLabel('Kode',{exact:true}).fill('UI-'+width);await page.getByLabel('Nama',{exact:true}).fill('Customer browser '+width);await page.getByLabel('Cabang',{exact:true}).selectOption(String(fixture.branchA));await page.getByLabel('Jenis customer',{exact:true}).selectOption('company');await page.getByLabel('Telepon',{exact:true}).fill('08123456789');await page.getByLabel('Email',{exact:true}).fill('customer-ui@example.test');
   await page.evaluate(()=>scrollTo(0,document.documentElement.scrollHeight));
   if(width<1024)check(await page.getByRole('button',{name:'Simpan Customer',exact:true}).evaluate(el=>el.getBoundingClientRect().bottom<=document.querySelector('.bottom-navigation').getBoundingClientRect().top+1),`Simpan tidak tertutup bottom nav ${width}`);
   check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Form tanpa overflow ${width}`);
   await page.screenshot({path:path.join(__dirname,'results',`phase4-form-${width}.png`)});
   await Promise.all([page.waitForURL(url=>url.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan Customer',exact:true}).click()]);
   check(await page.getByText('Customer browser '+width,{exact:true}).isVisible(),`Tambah/detail customer UI ${width}`);
   await page.getByRole('link',{name:'Edit Data',exact:true}).click();await page.getByLabel('Nama',{exact:true}).fill('Customer browser edit '+width);await page.getByRole('button',{name:'Simpan Customer',exact:true}).click();
   check(await page.getByRole('dialog').isVisible(),`Konfirmasi edit ${width}`);
   await Promise.all([page.waitForURL(url=>url.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Ya, simpan',exact:true}).click()]);
   check(await page.getByText('Customer browser edit '+width,{exact:true}).isVisible(),`Edit/detail UI ${width}`);
   await page.getByRole('button',{name:'Nonaktifkan',exact:true}).click();await page.getByRole('button',{name:'Ya, simpan',exact:true}).click();
   check(await page.getByRole('button',{name:'Aktifkan kembali',exact:true}).isVisible(),`Nonaktif UI ${width}`);
   await page.getByRole('button',{name:'Aktifkan kembali',exact:true}).click();await page.getByRole('button',{name:'Ya, simpan',exact:true}).click();
   check(await page.getByRole('button',{name:'Nonaktifkan',exact:true}).isVisible(),`Aktif kembali UI ${width}`);
   await page.getByRole('link',{name:'Kembali ke daftar',exact:true}).click();await page.getByLabel('Pencarian',{exact:true}).fill('UI-'+width);await page.getByRole('button',{name:'Cari / Filter',exact:true}).click();check(await page.locator('tbody tr').count()===1,`Pencarian UI ${width}`);
   check(!errors.length,`Tidak ada error JS master ${width}`);viewports.push({width,height,passed:checks.length-start});await context.close();
  }
  const context=await browser.newContext({viewport:{width:375,height:812}}),page=await context.newPage();await login(page);
  for(const [route,group] of Object.entries(fixture.masterGroups))for(const entity of group.tabs){
   const id=fixture.masterFixtures[entity].id;
   check((await page.goto(fixture.base+route+'?'+new URLSearchParams({tab:entity,mode:'edit',id}))).status()===200,'Form tab nyata '+entity);
   check(await page.getByLabel('Kode',{exact:true}).inputValue()===fixture.masterFixtures[entity].fields.code,'Form memuat data tersimpan '+entity);
   check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'Form mobile tab tidak overflow '+entity);
  }
  await page.goto(fixture.base+'/master/customers?q=PAGE-');const code=await page.locator('tbody tr:first-child td:first-child').innerText();await page.getByRole('link',{name:'Berikutnya',exact:true}).click();check(await page.locator('tbody tr:first-child td:first-child').innerText()!==code,'Pagination browser catatan berbeda');
  await page.getByLabel('Profil akun',{exact:true}).click();await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);await login(page,fixture.ownerEmail);await page.goto(fixture.base+'/master/customers');check(!await page.getByRole('link',{name:'Tambah Data',exact:true}).count(),'Owner tidak memperoleh aksi create');check((await page.request.get(fixture.base+'/master/customers?mode=create')).status()===403,'Owner URL create ditolak backend');
  await page.getByLabel('Profil akun',{exact:true}).click();await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);await login(page,fixture.scopedEmail);check((await page.goto(fixture.base+'/master/assets?tab=units')).status()===200,'Tab equipment scoped tersedia sesuai izin');check((await page.request.get(fixture.base+'/master/routes?tab=routes&mode=detail&id='+fixture.masterFixtures.routes.id)).status()===404,'Rute lintas endpoint ditolak backend');
  const sender=fixture.roleAccounts.find(a=>a.role==='Admin Pengirim');await page.getByLabel('Profil akun',{exact:true}).click();await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);await login(page,sender.email);await page.goto(fixture.base+'/master/assets');check(!await page.getByRole('link',{name:'Unit Equipment',exact:true}).count(),'Tab tanpa permission tidak ditampilkan');check((await page.request.get(fixture.base+'/master/assets?tab=units')).status()===403,'Tab tanpa permission ditolak backend');
  await context.close();fs.writeFileSync(path.join(__dirname,'results','master-browser.json'),JSON.stringify({date:new Date().toISOString(),passed:checks.length,viewports,checks},null,2));
 }catch(error){fs.writeFileSync(path.join(__dirname,'results','master-browser.json'),JSON.stringify({failure:error.message,passed:checks.filter(c=>c.passed).length,viewports,checks},null,2));throw error;}
};
