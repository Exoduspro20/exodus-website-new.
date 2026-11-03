// Red Cross registration is submitted to the secure server endpoint, not by email.
const redCrossForm=document.getElementById('registrationForm');
if(redCrossForm){redCrossForm.addEventListener('submit',async event=>{
 event.preventDefault();event.stopImmediatePropagation();
 if(!redCrossForm.reportValidity())return;
 const status=document.getElementById('registrationStatus');const btn=redCrossForm.querySelector('button[type="submit"]');
 const fields=new FormData(redCrossForm);const body={name:fields.get('Full name'),email:fields.get('Email'),phone:fields.get('Phone'),course:fields.get('Course'),preferred_date:fields.get('Preferred date'),location:fields.get('Location'),notes:fields.get('Notes')};
 btn.disabled=true;status.textContent='Submitting your registration request…';
 try{const response=await fetch('/api/red-cross/register',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)});const data=await response.json();if(!response.ok)throw Error(data.error||'Registration could not be submitted');status.textContent='Registration request received. Reference: '+data.reference+'. An instructor will review it; your seat is not yet confirmed.';redCrossForm.reset();}
 catch(error){status.textContent=error.message+' Please try again later.'}finally{btn.disabled=false}
 },true)}
