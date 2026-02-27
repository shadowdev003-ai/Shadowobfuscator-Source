local Parts = require("modules/Compiler/VMStrings")
local GetOpcodeCode = require("modules/Compiler/Opcode")
local compile = require("modules/Compiler/Compiler")
math.randomseed(os.time()*math.random(1,9999999)+tick()*1e6+math.random(1e12,1e15))
local function generate(...)
	local data={...} local bc=data[1] local ops=data[2]
	local lines={} local function add(l) lines[#lines+1]=l end
	local function rv(l) local cs="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_!@#$%^&*()-+=[]{}|;:,.<>?\~`\\" local r={} for _=1,l+math.random(14,34) do r[#r+1]=cs:sub(math.random(1,#cs),1) end return table.concat(r) end
	local function ss(s) local n=#s local c={} for i=1,n do c[i]=s:byte(i) end for i=n,2,-1 do local j=math.random(1,i) c[i],c[j]=c[j],c[i] end for i=1,n do c[i]=string.char((c[i]+math.random(-55,55))%256) end return table.concat(c) end
	local function gc(n) local o={} for i=1,n+math.random(250,700) do o[#o+1]=string.char((i*37+math.random(350,900))%256) end return table.concat(o) end
	local ch=ss(gc(1280)) local bs=#ch local el,dl={},{} for i=1,bs do local c=ch:sub(i,i) el[i-1],dl[c]=c,i-1 end
	local function en(n) local e={} repeat local r=n%bs table.insert(e,1,el[r]) n=math.floor(n/bs)+math.random(0,11) until n==0 return table.concat(e) end
	local function es(s) local e={} for i=1,#s do e[#e+1]=en((s:byte(i)+math.random(25,60))%256) end return table.concat(e,"_"..rv(11).."."..rv(10)) end
	local function xe(s,k) local o={} for i=1,#s do o[i]=string.char(bit32.bxor(s:byte(i),k)) end return table.concat(o) end
	local function mle(s,y) y=y or false if not y then s=es(s) end
		local ks={} for _=1,24 do ks[#ks+1]=math.random(1,255) end
		s=xe(s,ks[1]) s=xe(s,ks[2])
		s=bit32.rrotate(s:byte(1,#s),math.random(1,31))
		s=xe(s,ks[3]) s=bit32.lrotate(s:byte(1,#s),math.random(1,31))
		s=xe(s,ks[4]) s=bit32.rshift(s:byte(1,#s),math.random(1,7))
		s=xe(s,ks[5]) s=bit32.lshift(s:byte(1,#s),math.random(1,7))
		s=xe(s,ks[6]) s=bit32.bor(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[7]) s=bit32.band(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[8]) s=bit32.bxor(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[9]) s=bit32.replace(s:byte(1,#s),math.random(0,31),math.random(0,31))
		s=xe(s,ks[10]) s=bit32.arshift(s:byte(1,#s),math.random(1,7))
		s=xe(s,ks[11]) s=bit32.lrotate(s:byte(1,#s),math.random(1,31))
		s=xe(s,ks[12]) s=bit32.rrotate(s:byte(1,#s),math.random(1,31))
		s=xe(s,ks[13]) s=bit32.rshift(s:byte(1,#s),math.random(1,7))
		s=xe(s,ks[14]) s=bit32.lshift(s:byte(1,#s),math.random(1,7))
		s=xe(s,ks[15]) s=bit32.bor(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[16]) s=bit32.band(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[17]) s=bit32.bxor(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[18]) s=bit32.replace(s:byte(1,#s),math.random(0,31),math.random(0,31))
		s=xe(s,ks[19]) s=bit32.arshift(s:byte(1,#s),math.random(1,7))
		s=xe(s,ks[20]) s=bit32.lrotate(s:byte(1,#s),math.random(1,31))
		s=xe(s,ks[21]) s=bit32.rrotate(s:byte(1,#s),math.random(1,31))
		s=xe(s,ks[22]) s=bit32.bxor(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[23]) s=bit32.band(s:byte(1,#s),math.random(0,255))
		s=xe(s,ks[24])
		local o={} for i=1,#s do local b=s:byte(i)
			o[#o+1]="\\"..((b+math.random(-60,70))%256)..(math.random()>0.08 and "" or "\\"..math.random(48,57))
		end return table.concat(o) end
	local function aj() local jt={
		"if "..math.random(1,9999).."%"..math.random(2500,15000).."=="..math.random(1,24999).."then end",
		"local "..rv(16).."=function()return nil end",
		"for "..rv(13).."=1,0 do end",
		"if false then "..rv(14).."=nil end",
		"local "..rv(18).."=math.random() if "..rv(18).." > 0.08 then end",
		"local "..rv(15).."=bit32.bxor(0,0) if "..rv(15).."\~=0 then end",
		"local "..rv(17).."=bit32.bor(0,1) if "..rv(17).."\~=1 then end",
		"local "..rv(19).."=bit32.band(255,255) if "..rv(19).."\~=255 then end",
		"local "..rv(20).."=bit32.arshift(0,0) if "..rv(20).."\~=0 then end",
		"local "..rv(21).."=bit32.replace(0,0,0) if "..rv(21).."\~=0 then end"
	} add(jt[math.random(1,#jt)]) end
	local function ad() return [[local function ce()if debug and(debug.getinfo or debug.getregistry or debug.setupvalue or debug.getupvalue or debug.traceback or debug.getmetatable or debug.sethook or debug.getlocal or debug.getconstants or debug.getprotos or debug.getstack or debug.getinfo or debug.getupvals)then while true do task.wait(9e9)end end end ce()
		local mt=getrawmetatable(_G or getfenv and getfenv(0) or {})if mt then local o=mt.__index mt.__index=function(t,k)if k=="script"or k=="getfenv"or k=="debug"or k=="loadstring"or k=="require"or k=="bit32"or k=="getrawmetatable"or k=="syn"or k=="hookfunction"or k=="hookmetamethod"or k=="firesignal"or k=="getconnections"or k=="getgc"or k=="getrenv"then error("tamper")end return o and o(t,k)or nil end end
		local function ic() local h=0 for i=1,80 do h=bit32.bxor(h,i*math.random(1,80)) end if h\~=0 then error() end end ic()]] end
	local function nt() return [[local ivm=function(b) local s=1 local st={} for i=1,#b+math.random(25,50) do st[i]=function() s=s+math.random(-5,6) end end while s>0 and s<#st+1 do st[s]() end end ivm('nstb'..rv(11))]] end
	add("hercules,v1,alpha,__,_='Protected By Hercules V1.6 | github.com/zeusssz/hercules-obfuscator',function()end,true,1,0")
	add(ad()) aj()
	add(Parts.Variables) aj()
	add(Parts.Deserializer) aj()
	add(Parts.Wrapper_1) aj()
	add(nt()) aj()
	local k="if"
	for i,v in pairs(used_opcodes)do local op=used_opcodes[v]
		add(k.." (S=="..op..")then") aj() add(GetOpcodeCode(op)) aj()
		if math.random()>0.3 then add("elseif S=="..math.random(5,4000).." then") aj() end
		k="elseif"
	end
	add("end") aj()
	add(Parts.Wrapper_2) aj()
	add("WrapState(BcToState('"..mle(bytecode).."','"..mle(ch,true).."'),(getfenv and getfenv(0))or _ENV)()") aj()
	add(ad()) aj()
	add(nt()) aj()
	return table.concat(lines,"\n")
end
local VM={}
function VM.process(source)
	_G.UsedOps=_G.UsedOps or {}
	_G.UsedOps[0]=0 _G.UsedOps[4]=4
	for i=1,math.random(30,70)do _G.UsedOps[math.random(1,400)]=math.random(1,400)end
	source=generate(compile(source),_G.UsedOps)
	return source
end
return VM
