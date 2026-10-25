const fs = require('node:fs');
const path = require('node:path');
const fixture = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
// Reuse only the installed Playwright library read-only; never run old project tests.
const { chromium } = require(process.env.HLS_PLAYWRIGHT_MODULE || 'D:/xampp/htdocs/hlstransport/node_modules/playwright');
const results = [];
let browser;
async function check(condition, label) { results.push({label, passed: !!condition}); if (!condition) throw new Error(label); }
(async () => {
  browser = await chromium.launch({headless:true});
  for (const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]) {
    const context = await browser.newContext({viewport:{width,height}});
    const page = await context.newPage();
    const errors=[]; page.on('pageerror', e=>errors.push(e.message));
    await page.goto(fixture.base+'/login');
    await check(await page.locator('.brand img').evaluate(img=>img.complete && img.naturalWidth===2170 && Math.abs(img.getBoundingClientRect().width/img.getBoundingClientRect().height-2170/725)<0.01),`Logo resmi utuh dan proporsional ${width}`);
    await check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Login tanpa overflow ${width}`);
    await page.screenshot({path:path.join(__dirname,'results',`login-${width}.png`),fullPage:true});
    await page.getByLabel('Email',{exact:true}).fill(fixture.email);
    await page.getByLabel('Password',{exact:true}).fill(fixture.password);
    await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);
    await check(await page.getByRole('heading',{name:'Dashboard',exact:true}).isVisible(),`Login ${width}`);
    for (const route of ['/','/branches','/users','/roles','/audit']) {
      const response = await page.goto(fixture.base+route);
      await check(response.status()===200,`Route ${route} ${width}`);
      await check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Tanpa overflow halaman ${route} ${width}`);
      await check(!await page.locator('a[href*="expedition"],a[href*="finance"],a[href*="rental"]').count(),`Tidak ada menu bisnis ${route} ${width}`);
    }
    await check(errors.length===0,`Tanpa error JavaScript ${width}`);
    await page.screenshot({path:path.join(__dirname,'results',`foundation-${width}.png`),fullPage:true});
    await page.getByLabel('Profil akun',{exact:true}).click();
    await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);
    await check(await page.getByRole('button',{name:'Masuk',exact:true}).isVisible(),`Logout ${width}`);
    await context.close();
  }
  const context=await browser.newContext({viewport:{width:375,height:812}});
  const page=await context.newPage();
  await page.goto(fixture.base+'/login');
  await page.getByLabel('Email',{exact:true}).fill(fixture.email);
  await page.getByLabel('Password',{exact:true}).fill(fixture.password);
  await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);
  await page.goto(fixture.base+'/branches?mode=create');
  await page.getByLabel('Kode',{exact:true}).fill('BROWSER');
  await page.getByLabel('Nama',{exact:true}).fill('Cabang Browser Uji');
  await page.getByLabel('Alamat',{exact:true}).fill('Alamat fiktif pengujian');
  await Promise.all([page.waitForURL(url=>url.pathname==='/branches'&&url.searchParams.get('mode')==='detail'),page.getByRole('button',{name:'Simpan Cabang',exact:true}).click()]);
  await check(await page.getByText('Cabang Browser Uji',{exact:true}).isVisible(),'Form create cabang mobile');
  await page.goto(fixture.base+'/users');
  await page.getByLabel('Nama',{exact:true}).fill('Pengguna Browser');
  await page.getByLabel('Email',{exact:true}).fill('browser@example.test');
  await page.getByLabel('Role',{exact:true}).selectOption({label:'Owner'});
  await page.getByLabel('Password (12–72 byte)',{exact:true}).fill(fixture.password);
  await page.getByLabel('Cabang Browser Uji',{exact:true}).check();
  await Promise.all([page.waitForURL(fixture.base+'/users'),page.getByRole('button',{name:'Simpan pengguna',exact:true}).click()]);
  await check(await page.getByText('browser@example.test',{exact:true}).isVisible(),'Form create pengguna mobile');
  await context.close();
  for (const [email, allowed] of [[fixture.scopedEmail,true],[fixture.ownerEmail,true]]) {
    const ctx=await browser.newContext(); const p=await ctx.newPage(); await p.goto(fixture.base+'/login');
    await p.getByLabel('Email',{exact:true}).fill(email); await p.getByLabel('Password',{exact:true}).fill(fixture.password);
    await Promise.all([p.waitForURL(fixture.base+'/'),p.getByRole('button',{name:'Masuk',exact:true}).click()]);
    await check(!await p.getByRole('link',{name:'Pengguna',exact:true}).count(),'Navigasi pengguna disembunyikan '+email);
    const response=await p.goto(fixture.base+'/branches');
    await check(response.status()===(allowed?200:403),'Akses cabang browser '+email);
    if(allowed) await check(!await p.getByText('Cabang B Privat',{exact:true}).count(),'Cabang lain tidak bocor pada browser');
    await ctx.close();
  }
  await require('./navigation.cjs')({browser,fixture});
  await require('./dashboard.cjs')({browser,fixture});
  await require('./master-data.cjs')({browser,fixture});
  await require('./expedition.cjs')({browser,fixture});
  await require('./trucking-operations.cjs')({browser,fixture});
  await require('./equipment-contracts.cjs')({browser,fixture});
  await require('./equipment-handovers.cjs')({browser,fixture});
  await require('./equipment-timesheets.cjs')({browser,fixture});
})().then(()=>{fs.writeFileSync(path.join(__dirname,'results','browser.json'),JSON.stringify({passed:results.length,checks:results},null,2));console.log(`${results.length} foundation browser checks and navigation suite passed`);}).catch(e=>{fs.writeFileSync(path.join(__dirname,'results','browser.json'),JSON.stringify({failure:e.message,checks:results},null,2));console.error(e.message);process.exitCode=1;}).finally(async()=>{if(browser)await browser.close();});
