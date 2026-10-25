const fs=require('node:fs'),path=require('node:path');
module.exports=async({browser,fixture})=>{
 const checks=[],viewports=[];
 const check=(pass,label)=>{checks.push({label,passed:!!pass});if(!pass)throw new Error(label);};
 const login=async(page,email=fixture.email)=>{await page.goto(fixture.base+'/login');await page.getByLabel('Email',{exact:true}).fill(email);await page.getByLabel('Password',{exact:true}).fill(fixture.password);await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);};
 const chooseRoute=async(page)=>{await page.getByLabel('Pilih rute',{exact:true}).selectOption(String(fixture.expedition.route));await page.getByRole('button',{name:'Gunakan Rute',exact:true}).click();};
 try{
  for(const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]){
   const start=checks.length,context=await browser.newContext({viewport:{width,height}}),page=await context.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));await login(page);
   for(const route of ['/trucking/dns','/trucking/manifests','/trucking/tracking']){
    const response=await page.goto(fixture.base+route);check(response.status()===200,`Route nyata ${route} ${width}`);
    check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow daftar ${route} ${width}`);
    check(await page.locator('.primary-navigation [aria-current="page"]').count()===1,`Satu menu aktif ${route} ${width}`);
   }
   await page.goto(fixture.base+'/trucking/dns');await page.getByRole('link',{name:'Tambah DN',exact:true}).click();await chooseRoute(page);
   for(const [name,label] of [['customer_id','Customer'],['sender_id','Pengirim'],['receiver_id','Penerima']])await page.getByLabel(label,{exact:true}).selectOption(fixture.expedition.dnInput[name]);
   await page.getByLabel('Deskripsi barang',{exact:true}).fill('Barang browser '+width);await page.getByLabel('Jumlah',{exact:true}).fill('1.250');await page.getByLabel('Satuan',{exact:true}).fill('Koli');
   await page.evaluate(()=>scrollTo(0,document.documentElement.scrollHeight));
   check(await page.getByRole('button',{name:'Simpan DN',exact:true}).evaluate(el=>{const b=el.getBoundingClientRect(),nav=document.querySelector('.bottom-navigation'),top=nav&&getComputedStyle(nav).display!=='none'?nav.getBoundingClientRect().top:innerHeight;return b.bottom<=top&&b.top>=0;}),`Simpan bebas bottom nav ${width}`);
   await page.screenshot({path:path.join(__dirname,'results',`phase5-dn-form-${width}.png`)});
   await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan DN',exact:true}).click()]);
   const dnId=new URL(page.url()).searchParams.get('id');check(!!dnId,`DN browser tersimpan ${width}`);check(await page.getByText('Barang browser '+width,{exact:true}).isVisible(),`Detail DN ${width}`);
   check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow detail ${width}`);
   await page.getByRole('link',{name:'Edit DN',exact:true}).click();await page.getByLabel('Deskripsi barang',{exact:true}).fill('Barang browser edit '+width);await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan DN',exact:true}).click()]);check(await page.getByText('Barang browser edit '+width,{exact:true}).isVisible(),`Edit DN nyata ${width}`);
   await page.goto(fixture.base+'/trucking/manifests?mode=create');await chooseRoute(page);await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan Manifest',exact:true}).click()]);
   await page.locator(`input[name="dn_ids[]"][value="${dnId}"]`).check();await Promise.all([page.waitForURL(u=>u.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Tambahkan DN Terpilih',exact:true}).click()]);check(await page.getByText(/Aktif dalam draf/).count()===1,`Keanggotaan DN nyata ${width}`);
   await page.goto(fixture.base+'/trucking/tracking?mode=detail&id='+dnId);check(await page.locator('.exp-timeline li').count()===3,`Tracking tiga event aktual ${width}`);check(!await page.getByRole('button',{name:/Berangkat|Terima|Transit/}).count(),`Tracking internal hanya baca ${width}`);check(await page.getByText('Belum tercatat',{exact:true}).count()===1,`Penerimaan tidak difiktifkan ${width}`);
   check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow tracking ${width}`);await page.screenshot({path:path.join(__dirname,'results',`phase5-tracking-${width}.png`),fullPage:true});
   await page.goto(fixture.base+'/trucking/dns');await page.getByLabel('Pencarian',{exact:true}).fill('not-found-unique');await page.getByRole('button',{name:'Cari / Filter',exact:true}).click();check(await page.getByText('Belum ada dokumen yang sesuai',{exact:true}).isVisible(),`Pencarian empty aktual ${width}`);
   check(errors.length===0,`Tanpa error JS ${width}`);viewports.push({width,height,passed:checks.length-start});await context.close();
  }
  const context=await browser.newContext(),page=await context.newPage();await login(page,fixture.ownerEmail);await page.goto(fixture.base+'/trucking/dns');check(!await page.getByRole('link',{name:'Tambah DN',exact:true}).count(),'Owner tanpa aksi tambah');check((await page.goto(fixture.base+'/trucking/dns?mode=create')).status()===403,'Owner create URL ditolak');
  await context.close();const anonymous=await browser.newContext(),p=await anonymous.newPage();await p.goto(fixture.base+'/trucking/tracking?mode=detail&id='+fixture.expedition.dn);check(new URL(p.url()).pathname==='/login','Tracking tidak publik');await anonymous.close();
  fs.writeFileSync(path.join(__dirname,'results','expedition-browser.json'),JSON.stringify({date:new Date().toISOString(),passed:checks.length,viewports,checks},null,2));
 }catch(e){fs.writeFileSync(path.join(__dirname,'results','expedition-browser.json'),JSON.stringify({failure:e.message,viewports,checks},null,2));throw e;}
};
