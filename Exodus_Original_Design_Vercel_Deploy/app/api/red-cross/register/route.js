import {admin,fail} from '../../../../lib/server';
const courses=['Emergency First Aid & CPR/AED','Standard First Aid & CPR/AED','CPR/AED Training','First Aid Recertification'];
export async function POST(req){try{
 const b=await req.json();const clean=k=>typeof b[k]==='string'?b[k].trim():'';
 const name=clean('name'),email=clean('email'),phone=clean('phone'),course=clean('course'),preferred_date=clean('preferred_date'),location=clean('location'),notes=clean('notes');
 if(name.length<2||name.length>120||!/^\S+@\S+\.\S+$/.test(email)||email.length>254||phone.length<7||phone.length>40||!courses.includes(course)||location.length<2||location.length>150||preferred_date.length>120||notes.length>2000)return fail('Please provide valid registration details.');
 const db=admin();const {data,error}=await db.from('red_cross_registrations').insert({full_name:name,email,phone,course,preferred_date,location,notes}).select('id').single();
 if(error){console.error('Red Cross registration storage failed',error.code);return fail('Registration is temporarily unavailable. Please contact EXODUS.',503)}
 return Response.json({ok:true,reference:data.id.slice(0,8).toUpperCase()},{status:201});
 }catch{return fail('Unable to submit registration',400)}}
