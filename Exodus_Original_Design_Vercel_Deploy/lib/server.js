import {createClient} from '@supabase/supabase-js';
export function admin(){if(!process.env.NEXT_PUBLIC_SUPABASE_URL||!process.env.SUPABASE_SERVICE_ROLE_KEY)throw Error('Supabase environment variables missing');return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL,process.env.SUPABASE_SERVICE_ROLE_KEY,{auth:{persistSession:false,autoRefreshToken:false}})}
export async function identity(request){const token=(request.headers.get('authorization')||'').replace(/^Bearer\s+/i,'');if(!token)return {error:'Login required',status:401};const db=admin();const {data,error}=await db.auth.getUser(token);if(error||!data?.user)return {error:'Invalid session',status:401};return {db,user:data.user}}
export async function instructor(db,id){const {data}=await db.from('profiles').select('role').eq('id',id).single();return ['instructor','admin'].includes(data?.role)}
export function fail(error,status=400){return Response.json({error},{status})}
