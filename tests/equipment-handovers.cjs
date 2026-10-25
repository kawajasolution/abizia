const fs=require('node:fs'),path=require('node:path');
module.exports=async({browser,fixture})=>{
  const checks=[];const check=(ok,label)=>{checks.push({label,passed:!!ok});if(!ok)throw Error(label);};
  const login=async(page,email=fixture.email)=>{await page.goto(fixture.base+'/login');await page.getByLabel('Email',{exact:true}).fill(email);await page.getByLabel('Password',{exact:true}).fill(fixture.password);await Promise.all([page.waitForURL(fixture.base+'/'),page.getByRole('button',{name:'Masuk',exact:true}).click()]);};
  const submit=async(page,form,label)=>{await Promise.all([page.waitForURL(u=>u.pathname==='/equipment/handovers'&&u.searchParams.get('mode')==='detail'),form.getByRole('button',{name:label,exact:true}).click()]);};
  try{
    for(const [width,height] of [[320,640],[375,812],[402,874],[768,1024],[1366,768]]){
      const context=await browser.newContext({viewport:{width,height}}),page=await context.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));await login(page);
      let response=await page.goto(fixture.base+'/equipment/handovers');check(response.status()===200,`M4 daftar HTTP ${width}`);check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`M4 daftar tidak overflow ${width}`);
      const c=fixture.equipment.handover_contracts[String(width)];
      for(const type of ['HANDOVER','RETURN']){
        await page.goto(fixture.base+`/equipment/handovers?mode=create&contract_id=${c.id}&document_type=${type}`);
        const form=page.getByRole('form',{name:'Simpan BA DRAFT',exact:true});await form.getByLabel('Jenis BA',{exact:true}).selectOption(type);await form.getByLabel('Cakupan Unit',{exact:true}).selectOption('ALL');await form.getByLabel('Waktu Kejadian WITA',{exact:true}).fill(`2040-${c.month}-${type==='HANDOVER'?'01':'03'}T09:00`);await form.getByRole('checkbox').check();await form.getByLabel(`Kondisi Unit #${c.unit}`,{exact:true}).fill(type==='HANDOVER'?'Kondisi awal browser':'Dikembalikan utuh');await form.getByLabel(`HM Unit #${c.unit}`,{exact:true}).fill(type==='HANDOVER'?'100.125':'110.250');
        check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`M4 form ${type} responsif ${width}`);await submit(page,form,'Simpan BA DRAFT');
        check((await page.locator('dd').allTextContents()).includes('DRAFT'),`M4 ${type} draft nyata ${width}`);
        if(type==='HANDOVER'){
          await page.getByRole('link',{name:'Edit BA DRAFT',exact:true}).click();const edit=page.getByRole('form',{name:'Simpan BA DRAFT',exact:true});await edit.getByLabel(`Kondisi Unit #${c.unit}`,{exact:true}).fill('Kondisi awal direvisi saat draft');await submit(page,edit,'Simpan BA DRAFT');check(await page.getByText('Kondisi awal direvisi saat draft',{exact:true}).isVisible(),`M4 edit draft tersimpan ${width}`);
          const evidence=page.getByRole('form',{name:`Bukti Unit #${c.unit}`,exact:true});await evidence.locator('input[type=file]').setInputFiles({name:'bukti-browser.png',mimeType:'image/png',buffer:Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jzFEAAAAASUVORK5CYII=','base64')});await submit(page,evidence,'Tambahkan Bukti');check(await page.getByRole('link',{name:'bukti-browser.png',exact:true}).isVisible(),`M4 bukti privat terlampir ${width}`);
        }
        await submit(page,page.getByRole('form',{name:'Konfirmasi BA',exact:true}),'Konfirmasi dan Terbitkan BA');
        check(/^BA\/TESTA\/\d{4}\/\d{6}$/.test(await page.locator('h2.exp-reference').innerText()),`M4 nomor BA ${type} ${width}`);check((await page.locator('dd').allTextContents()).includes(type==='HANDOVER'?'ACTIVE':'COMPLETED'),`M4 lifecycle aktual ${type} ${width}`);check(await page.getByRole('heading',{name:'Histori BA',exact:true}).isVisible(),`M4 histori ${type} ${width}`);check(await page.getByRole('link',{name:'Edit BA DRAFT',exact:true}).count()===0,`M4 confirmed tidak dapat diedit ${type} ${width}`);check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`M4 detail ${type} responsif ${width}`);
        await page.screenshot({path:path.join(__dirname,'results',`phase6-ba-${type.toLowerCase()}-${width}.png`),fullPage:true});
        await page.getByRole('link',{name:'Tampilan Cetak BA',exact:true}).click();await page.emulateMedia({media:'print'});check(!await page.locator('.app-header').isVisible(),`M4 cetak menyembunyikan navigasi ${type} ${width}`);await page.emulateMedia({media:'screen'});
      }
      await page.goto(fixture.base+`/equipment/contracts?mode=detail&id=${c.id}`);check((await page.locator('dd').allTextContents()).includes('COMPLETED'),`M4 kontrak selesai setelah RETURN aktual ${width}`);check(errors.length===0,`M4 tanpa error JS ${width}`);await context.close();
    }
    const context=await browser.newContext(),page=await context.newPage();await login(page,fixture.ownerEmail);await page.goto(fixture.base+'/equipment/handovers');check(await page.getByRole('link',{name:'Buat BA DRAFT',exact:true}).count()===0,'M4 Owner hanya baca BA');await context.close();
  }catch(e){fs.writeFileSync(path.join(__dirname,'results','equipment-handover-browser.json'),JSON.stringify({failure:e.message,checks},null,2));throw e;}
  fs.writeFileSync(path.join(__dirname,'results','equipment-handover-browser.json'),JSON.stringify({date:new Date().toISOString(),passed:checks.length,failed:0,checks},null,2));
};
