const fs=require('node:fs');
const path=require('node:path');
module.exports=async({browser,fixture})=>{
  const checks=[],viewports=[];
  const check=(value,label)=>{checks.push({label,passed:!!value});if(!value)throw new Error(label);};
  const login=async(page,email=fixture.email)=>{await page.goto(fixture.base+'/login');await page.getByLabel('Email',{exact:true}).fill(email);await page.getByLabel('Password',{exact:true}).fill(fixture.password);await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);};
  try{
    for(const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]){
      const before=checks.length;
      for(const account of fixture.roleAccounts){
        const context=await browser.newContext({viewport:{width,height}}),page=await context.newPage();
        const errors=[];page.on('pageerror',e=>errors.push(e.message));await login(page,account.email);
        const label=account.role+' '+width;
        check(await page.locator('[data-dashboard-role]').getAttribute('data-dashboard-role')===account.role,'Dashboard sesuai role '+label);
        check(await page.getByRole('heading',{name:'Dashboard',exact:true}).isVisible(),'Judul Dashboard langsung '+label);
        check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'Tanpa overflow '+label);
        check(!await page.locator('a[href*="expedition"],a[href*="finance"],a[href*="rental"],a[href*="inventory"]').count(),'Tidak ada shortcut route bisnis kosong '+label);
        check(!await page.getByText(/Buka Dashboard Owner|Selamat Datang|Selamat Bekerja|Ringkasan Sistem/i).count(),'Tanpa halaman perantara/banner '+label);
        if(account.role==='Administrator'){
          check(await page.locator('[data-kpi]').count()===4,'Empat KPI sumber nyata '+label);
          check(!await page.locator('[data-pending]').count(),'Administrator tanpa ringkasan finansial '+label);
        }else{
          check(await page.locator('[data-kpi]').count()===(account.role==='Owner'?1:0),'KPI hanya sesuai permission/sumber '+label);
          check(await page.locator('[data-pending]').count()>0,'Status sumber belum tersedia '+label);
          check(!await page.locator('[data-pending] .kpi-value,[data-pending] [data-value]').count(),'Tidak ada angka pengganti sumber '+label);
          check(!await page.getByText('Cabang B Privat',{exact:true}).count(),'Tidak ada kebocoran cabang '+label);
          check(!await page.getByLabel('Audit mulai',{exact:true}).count(),'Tidak ada filter audit tanpa izin '+label);
        }
        if(width<1024){
          check(await page.getByLabel('Buka navigasi',{exact:true}).isVisible(),'Hamburger tetap terlihat '+label);
          const nav=page.locator('.bottom-navigation');check(await nav.isVisible(),'Bottom nav tetap terlihat '+label);
          await nav.locator('[data-nav-id="dashboard"]').click();await page.waitForURL(fixture.base+'/');
          check(await page.locator('[data-dashboard-role]').getAttribute('data-dashboard-role')===account.role,'Shortcut Dashboard mempertahankan role '+label);
          await page.evaluate(()=>scrollTo(0,document.documentElement.scrollHeight));
          check(await page.locator('#account-details').evaluate(el=>el.getBoundingClientRect().bottom<=document.querySelector('.bottom-navigation').getBoundingClientRect().top+1),'Akhir konten tidak tertutup '+label);
        }else{
          check(await page.locator('.sidebar').isVisible(),'Sidebar desktop '+label);
          await page.locator('.primary-navigation [data-nav-id="dashboard"]').click();await page.waitForURL(fixture.base+'/');
          check(await page.locator('[data-dashboard-role]').getAttribute('data-dashboard-role')===account.role,'Sidebar Dashboard mempertahankan role '+label);
        }
        check(!errors.length,'Tanpa error JavaScript '+label);
        if(width===375 || (width===1366&&['Owner','Administrator'].includes(account.role))){
          await page.evaluate(()=>scrollTo(0,0));
          const slug=account.role.toLowerCase().replace(/[^a-z0-9]+/g,'-');await page.screenshot({path:path.join(__dirname,'results',`phase3-${slug}-${width}.png`)});
        }
        await context.close();
      }
      viewports.push({width,height,roles:fixture.roleAccounts.length,passed:checks.length-before});
    }
    const context=await browser.newContext({viewport:{width:375,height:812}}),page=await context.newPage();await login(page);
    const activeAll=Number(await page.locator('[data-kpi="active-users"] .kpi-value').innerText());
    await page.getByLabel('Cabang',{exact:true}).selectOption(String(fixture.branchA));await page.getByRole('button',{name:'Terapkan',exact:true}).click();
    check(await page.locator('[data-kpi="branches"] .kpi-value').innerText()==='1','Filter cabang UI menghasilkan satu cabang');
    check(!await page.getByText('Cabang B Privat',{exact:true}).count(),'Filter cabang UI tidak menampilkan cabang lain');
    check(!await page.locator('[data-audit-id]').count(),'Audit global tidak muncul sebagai audit cabang');
    check(Number(await page.locator('[data-kpi="active-users"] .kpi-value').innerText())<=activeAll,'Filter akun cabang konsisten');
    await page.getByRole('link',{name:'Reset',exact:true}).click();await page.getByLabel('Audit mulai',{exact:true}).fill('2024-01-01');await page.getByLabel('Audit sampai',{exact:true}).fill('2024-01-01');await page.getByRole('button',{name:'Terapkan',exact:true}).click();
    check(await page.getByText('Tidak ada aktivitas pada periode ini',{exact:true}).isVisible(),'Filter periode UI menampilkan empty state nyata');
    check(Number(await page.locator('[data-kpi="active-users"] .kpi-value').innerText())===activeAll,'Periode audit tidak mengubah KPI saat ini');
    await page.getByLabel('Profil akun',{exact:true}).click();await Promise.all([page.waitForURL(fixture.base+'/login'),page.getByRole('button',{name:'Keluar',exact:true}).click()]);await login(page,fixture.scopedEmail);
    check(await page.locator('[data-kpi]').count()===1,'Admin scoped hanya mendapat KPI cabang');
    check(!await page.locator('[data-audit-id]').count(),'Admin scoped tanpa audit global');
    check((await page.request.get(fixture.base+'/?branch='+fixture.branchB)).status()===403,'Backend menolak cabang dashboard di luar scope');
    await context.close();
    fs.writeFileSync(path.join(__dirname,'results','dashboard-browser.json'),JSON.stringify({date:new Date().toISOString(),passed:checks.length,viewports,checks},null,2));
  }catch(error){fs.writeFileSync(path.join(__dirname,'results','dashboard-browser.json'),JSON.stringify({failure:error.message,passed:checks.filter(c=>c.passed).length,viewports,checks},null,2));throw error;}
};
