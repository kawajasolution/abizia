const fs=require('node:fs'),path=require('node:path');
module.exports=async({browser,fixture})=>{
 const checks=[],viewports=[];const check=(ok,label)=>{checks.push({label,passed:!!ok});if(!ok)throw new Error(label);};
 const login=async(page,email=fixture.email)=>{await page.goto(fixture.base+'/login');await page.getByLabel('Email',{exact:true}).fill(email);await page.getByLabel('Password',{exact:true}).fill(fixture.password);await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);};
 const submit=async(page,formName,buttonName)=>{
  const form=page.getByRole('form',{name:formName,exact:true});const url=page.url();
  await form.getByRole('button',{name:buttonName,exact:true}).click();
  await Promise.all([page.waitForNavigation({waitUntil:'load'}),page.getByRole('button',{name:'Ya, simpan',exact:true}).click()]);
  await page.waitForLoadState('load');check(!await page.getByRole('heading',{name:'Permintaan tidak dapat diproses',exact:true}).count(),'Tindakan tanpa error '+buttonName);
 };
 try{
  for(const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]){
   const start=checks.length,context=await browser.newContext({viewport:{width,height}}),page=await context.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));await login(page);
   for(const route of ['/trucking/dns','/trucking/manifests','/trucking/transit','/trucking/receipts','/trucking/claims','/trucking/tracking']){
    const r=await page.goto(fixture.base+route);check(r.status()===200,`Enam route operasional ${route} ${width}`);check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow ${route} ${width}`);check(await page.locator('.primary-navigation [aria-current="page"]').count()===1,`Menu aktif ${route} ${width}`);
   }
   await page.goto(fixture.base+'/trucking/dns?mode=create');await page.getByLabel('Pilih rute',{exact:true}).selectOption(String(fixture.expedition.route));await page.getByRole('button',{name:'Gunakan Rute',exact:true}).click();
   for(const [name,label] of [['customer_id','Customer'],['sender_id','Pengirim'],['receiver_id','Penerima']])await page.getByLabel(label,{exact:true}).selectOption(fixture.expedition.dnInput[name]);
   await page.getByLabel('Deskripsi barang',{exact:true}).fill('Operasional browser '+width);await page.getByLabel('Jumlah',{exact:true}).fill('2');await page.getByLabel('Satuan',{exact:true}).fill('Koli');await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan DN',exact:true}).click()]);
   const dnId=new URL(page.url()).searchParams.get('id');await submit(page,'Konfirmasi DN','Konfirmasi DN');check((await page.locator('h2.exp-reference').innerText()).startsWith('DN/'),'Nomor resmi DN pada UI '+width);
   await page.goto(fixture.base+'/trucking/manifests?mode=create');await page.getByLabel('Pilih rute',{exact:true}).selectOption(String(fixture.expedition.route));await page.getByRole('button',{name:'Gunakan Rute',exact:true}).click();await page.getByLabel('Kendaraan',{exact:true}).selectOption(fixture.expedition.manifestInput.vehicle_id);await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan Manifest',exact:true}).click()]);
   const manifestId=new URL(page.url()).searchParams.get('id');await page.locator(`input[name="dn_ids[]"][value="${dnId}"]`).check();await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Tambahkan DN Terpilih',exact:true}).click()]);
   await submit(page,'Konfirmasi Manifest','Konfirmasi Manifest');check((await page.locator('h2.exp-reference').innerText()).startsWith('MF/'),'Nomor resmi Manifest UI '+width);await submit(page,'Keberangkatan Aktual','Berangkatkan Kendaraan');await submit(page,'Kedatangan Kendaraan','Catat Kendaraan Tiba');
   const arrivalForm=page.getByRole('form',{name:'Kedatangan DN Aktual',exact:true});await arrivalForm.locator(`input[name="dn_ids[]"][value="${dnId}"]`).check();await submit(page,'Kedatangan DN Aktual','Catat DN Tiba');
   const unload=page.locator('form').filter({has:page.getByRole('button',{name:'Catat Penurunan DN',exact:true})});await unload.getByLabel('Alasan/catatan penurunan',{exact:true}).fill('Diturunkan aktual melalui browser');await submit(page,await unload.getAttribute('aria-label'),'Catat Penurunan DN');await submit(page,'Selesaikan Perjalanan','Selesaikan Manifest');
   await page.goto(fixture.base+'/trucking/receipts?mode=detail&id='+dnId);check(await page.getByText('Belum tercatat',{exact:true}).count()===1,'Manifest selesai belum diterima UI '+width);
   await page.getByLabel('Nama penerima aktual',{exact:true}).fill('Penerima browser '+width);await page.getByLabel('Catatan kondisi penerimaan',{exact:true}).fill('Utuh sesuai DN');await page.getByLabel('Jumlah dan kondisi sesuai; diterima utuh',{exact:true}).check();
   await page.getByRole('button',{name:'Terima Barang',exact:true}).evaluate(el=>el.scrollIntoView({block:'center'}));check(await page.getByRole('button',{name:'Terima Barang',exact:true}).evaluate(el=>{const r=el.getBoundingClientRect(),nav=document.querySelector('.bottom-navigation');return r.top>=0&&r.bottom<=(nav&&getComputedStyle(nav).display!=='none'?nav.getBoundingClientRect().top:innerHeight);}),`Penerimaan bebas bottom nav ${width}`);
   await page.screenshot({path:path.join(__dirname,'results',`phase5-receipt-${width}.png`)});await submit(page,'Konfirmasi Penerimaan','Terima Barang');check(await page.getByText(/Penerima browser/).count()>=1,'Penerimaan aktual ditampilkan '+width);await submit(page,'Selesaikan DN','Selesaikan DN');
   await page.goto(fixture.base+'/trucking/claims?mode=create&dn_id='+dnId);await page.getByLabel('Cabang pelapor',{exact:true}).selectOption(String(fixture.branchA));await page.getByLabel('Jenis masalah',{exact:true}).fill('Kondisi barang');await page.getByLabel('Deskripsi permasalahan',{exact:true}).fill('Laporan browser '+width);await page.getByLabel('Nama pelapor',{exact:true}).fill('Pelapor browser');await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan Klaim',exact:true}).click()]);
   const claimId=new URL(page.url()).searchParams.get('id');check(await page.getByText('Belum dilampirkan',{exact:true}).count()===1,'Bukti dapat menyusul UI '+width);await page.getByLabel('Bukti tambahan',{exact:true}).setInputFiles(fixture.operations.proofPath);await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Unggah Bukti',exact:true}).click()]);check(await page.locator('a[href*="/trucking/evidence?id="]').count()===1,'Bukti privat tersedia lewat endpoint berizin '+width);
   for(const state of ['REVIEWING','APPROVED','CLOSED']){await page.getByLabel('Status berikutnya',{exact:true}).selectOption(state);await page.getByLabel('Catatan penanganan',{exact:true}).fill('Penanganan '+state);await page.getByRole('button',{name:'Simpan Status Klaim',exact:true}).click();await Promise.all([page.waitForNavigation({waitUntil:'load'}),page.getByRole('button',{name:'Ya, simpan',exact:true}).click()]);await page.waitForLoadState('load');}
   check(await page.getByText('CLOSED',{exact:true}).count()===1,'Klaim selesai operasional '+width);check(!await page.getByRole('button',{name:'Simpan Status Klaim',exact:true}).count(),'CLOSED tidak menawarkan transisi baru '+width);check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'Detail klaim tanpa overflow '+width);await page.screenshot({path:path.join(__dirname,'results',`phase5-claim-${width}.png`),fullPage:true});
   await page.goto(fixture.base+'/trucking/tracking?mode=detail&id='+dnId);check(await page.getByText('Penerimaan aktual',{exact:true}).count()>=1,'Tracking menampilkan penerimaan aktual '+width);check(await page.locator('.exp-timeline li').count()>=7,'Tracking berisi timeline operasional nyata '+width);
   const cancellation=fixture.operations.auditCancellation;
   const cancelledResponse=await page.goto(fixture.base+'/trucking/manifests?mode=detail&id='+cancellation.id);
   check(cancelledResponse.status()===200,'A04 detail pembatalan aktual '+width);
   const cancellationEvent=page.locator('.exp-timeline li').filter({has:page.locator('.exp-cancellation-reason')});
   check(await cancellationEvent.count()===1,'A04 satu event pembatalan historis '+width);
   check(await cancellationEvent.getByText(cancellation.reason,{exact:false}).isVisible(),'A04 alasan pembatalan terlihat '+width);
   check((await cancellationEvent.innerText()).includes(cancellation.actor),'A04 aktor event terlihat '+width);
   check((await cancellationEvent.innerText()).includes(cancellation.time+' WITA'),'A04 waktu event terlihat '+width);
   check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'A04 detail pembatalan tanpa overflow '+width);
   await page.screenshot({path:path.join(__dirname,'results',`phase5-cancellation-${width}.png`),fullPage:true});
   check(errors.length===0,'Tanpa error JS '+width);viewports.push({width,height,passed:checks.length-start});await context.close();
  }
  fs.writeFileSync(path.join(__dirname,'results','trucking-browser.json'),JSON.stringify({date:new Date().toISOString(),passed:checks.length,viewports,checks},null,2));
 }catch(e){fs.writeFileSync(path.join(__dirname,'results','trucking-browser.json'),JSON.stringify({failure:e.message,viewports,checks},null,2));throw e;}
};
