--[=[
	[[open source code]]
	thanks for using pshade ultimate
	
	pshade is made by Duy Kenjin dz
	
	some code might be obfuscated for privacy or security reason (example : feedback)
	this is not mean to be edited/stolen
	
	This script is still in beta stage so make sure to use the loadstring so it can always be updated
	
	https://randomstring0.github.io/pshade.github.io/
]=]
if _G.pshade then return warn"pshade already loaded!" end
if not game then local game=Workspace['Parent'] end
if not game:IsLoaded() then game["Loaded"]:Wait() end
local update = [=[
	> running shaders now run realtime perfectly
	> added global illumination [ beta ]
	> fixed blur effect
	> added adjust auto load and fix ui size
	> small update for gui
	> fixed some features not showing up
	> faster preview
	> lighting element cannot be deleted fix
	> night theme
	> small fix and error handle 
	> small debug update
	> more games support
	> skybox added
	> filesystem fix
	> slow load fix
	> more adjustment stuff
	> new ui and old ui combination
	> gui dragging fix
	> shader load faster
]=]
_G.pshade=true
_G.vers="1.4.9"
local light
local game=game
local xpcall=xpcall
local type=type
local next=next
local pcall=pcall
local typeof=typeof
local mrandom,schar, mfloor,mhuge=math['random'],string['char'],math['floor'],math['huge']
local mfloor,mceil=math['floor'],math['ceil']
local twait,tspawn=task['wait'], task['spawn']
local mclam,mround=math['clamp'],math['round']
local mcos,msin,mtan=math['cos'],math['sin'],math['tan']
local mabs,mdeg,mrad=math['abs'],math['deg'],math['rad']
local msqrt=math['sqrt']
local di=debug['info']
local findclass=game["FindFirstChildOfClass"]
local getchild=game["GetChildren"]
local clone=game["Clone"]
local destroy=game["Destroy"]
local find=game['FindFirstChild']
local isa=game["IsA"]
local ins=Instance['new']
local ws=findclass(game,'Workspace')
local cam=find(ws,"Camera")
local lg=findclass(game,"Lighting")
local terr=findclass(ws,"Terrain")
local uis=findclass(game,"UserInputService")
local tween=findclass(game,"TweenService")
local http=findclass(game,"HttpService")
local market=findclass(game,"MarketplaceService")
local rs=findclass(game,"RunService")
local plrs=findclass(game,"Players")
local lp=plrs['LocalPlayer']
local pg=lp['PlayerGui']
local mouse=lp:GetMouse()
local sett1=nil
local fenv=getfenv()
local shp=fenv['sethiddenproperty'] or fenv['sethiddenprop'] or fenv['set_hidden_property'] or fenv['set_hidden_prop'] or function() return end
local ghp=fenv['gethiddenproperty'] or fenv['gethiddenprop'] or function() return end
local httpget=function(a) return loadstring(game:HttpGet(a))() end --fenv['HttpGet']
local read,write,file=fenv['readfile'],fenv['writefile'],fenv['isfile']
local setclip=fenv['setclipboard'] or function() return end
local fdist,fsize,ftrans={1.7,0.3,-0.3,-0.9},{0.7,0.2,1.2,0.45},{0.8,0.7,0.9,0.6}
local fls,sre,sflare,rmod={},ins('ScreenGui',pg),ins('ImageLabel'),1
local bmut,ber,lor=11,5,cam['CFrame']['LookVector']
local colorcor,atmosphere,bloom,blur,depth,sky,sray,cloud
local randomstring='https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/'
local technology=ghp(lg,'Technology') or 'ShadowMap'
local lan=httpget(randomstring..'lan/every.json')
local randomsky=randomstring..'sky/'
if rs:IsStudio() then return end
local src=randomstring..'src/'
local flare,motionblur
local wshade=true
local thick = tick()
local restore={}
local shader={}
local skybox={}
local new={}
local wl={}
shader.__index=shader
local sc=httpget(src..'ui')
local image=sc["mainmage"]
local main=image["main"]
local addfr=main["addtionframe"]['Frame']
local mbar=main["mainbar"]['Frame']
local mpage=main['mainpage']
local prop=main["propperty sample"]
local ntf=sc['notif']
local icon=sc['icon']
local click=sc['click']
local clicking=sc['clicking']
local color=sc['colorvalue']
local intro=sc['intro']
local intext=intro['main']['TextLabel']
-- ===== ĐỔI TÊN NGƯỜI TẠO =====
local title=mbar['Frame']['maintitle']
title.Text = "Duy Kenjin dz"
-- ============================
local barfunc=mbar['functionbar']
local page=mpage['page']['Frame']
local spage=mpage['showpage']
local shadertog=addfr['toggleshaderframe']
local togd=shadertog['handle']
local home=spage['home']
local changelog=home['ScrollingFrame']['changelog']
local xddcc="70736861646520756C74696D617465"
coroutine['wrap'](function() httpget(src..'check.lua') end)()
local shader
local check=true
shp(lg,'Technology',"ShadowMap")
local adjust={
	['reflect']=nil,
	['waterspeed']=nil,
}
local tween=function(i,p,d)
	local d=d or 1
	return tween:Create(i,TweenInfo['new'](d,Enum['EasingStyle']['Exponential'],Enum['EasingDirection']['Out']),p):Play()
end
local drag=function(n,s)
	local dr,di,ds,sp=false,nil,Vector3['new'](0,0,0),nil
	local move=function(i)
		local d=i['Position']-ds
		local p=UDim2['new'](sp['X']['Scale'],sp['X']['Offset']+d['X'],sp['Y']['Scale'],sp['Y']['Offset']+d['Y'])
		tween(s,{Position=p},.15)
	end
	n['InputBegan']:Connect(function(i)
		if i['UserInputType'] == Enum['UserInputType']['MouseButton1'] or i['UserInputType'] == Enum['UserInputType']['Touch'] then
			dr,ds,sp=true,i['Position'],s['Position']
			i['Changed']:Connect(function()
				if i['UserInputState'] == Enum['UserInputState']['End'] then
					dr=false
				end
			end)
		end
	end)
	n['InputChanged']:Connect(function(i)
		if i['UserInputType'] == Enum['UserInputType']['MouseMovement'] or i['UserInputType'] == Enum['UserInputType']['Touch'] then
			di=i
		end
	end)
	uis['InputChanged']:Connect(function(i)
		if i==di and dr then
			move(i)
		end
	end)
end
local notif=function(t,d)
	coroutine['wrap'](function()
		local n=clone(ntf)
		n['Parent']=sc
		n['Image']=image['Image']
		n['title']['Text']=t
		n['Visible']=true
		n['Size']=UDim2['new'](0,0,0,0)
		tween(n,{Size=UDim2['new'](0.512,0,0.118,0)},.3)
		twait(d or 3)
		tween(n,{Position=UDim2['new'](0.5,0,0,-30)},.5)
		twait(.5)
		n:Destroy()
	end)()
end
-- ===== THÔNG BÁO KHI BẬT SCRIPT =====
notif("Script được tạo bởi Duy Kenjin dz", 4)
-- ====================================
local fh=function(s)
	return (s:gsub('..', function(c)
		return schar(tonumber(c, 16))
	end))
end
local random=function(l)
	local s=""
	local l=l or 5
	for i=1,l do
		local n=mrandom(1,3)
		if n==1 then
			s=s..schar(mrandom(65,90))
		elseif n==2 then
			s=s..schar(mrandom(97,122))
		else
			s=s..tostring(mrandom(0,9))
		end
	end
	return s
end
tspawn(function()
	for i=1,mrandom(5,35) do
		local x=ins("IntValue",lg)
		x.Name=random()
	end
end)
local bestname=random()
coroutine['wrap'](function()
if findclass(lg,"BloomEffect") then
	findclass(lg,"BloomEffect")['Enabled']=false
	local b=clone(findclass(lg,"BloomEffect"))
	b['Parent']=lg
	b['Enabled']=true
	bloom=b
	table['insert'](restore,b)
	table['insert'](new,bloom)
end
if findclass(lg,"Sky") then
	local b=clone(findclass(lg,"Sky"))
	b['Parent']=lg
	sky=b
	table['insert'](restore,b)
	table['insert'](new,sky)
end
if findclass(lg,"Atmosphere") then
	local b=clone(findclass(lg,"Atmosphere"))
	b['Parent']=lg
	atmosphere=b
	table['insert'](restore,b)
	table['insert'](new,sky)
end
if findclass(lg,"BlurEffect") then
	findclass(lg,"BlurEffect")['Size']=0
	local b=clone(findclass(lg,"BlurEffect"))
	b['Parent']=lg
	b['Enabled']=true
	blur=b
	table['insert'](restore,b)
	table['insert'](new,sky)
end
if findclass(lg,"DepthOfFieldEffect") then
	findclass(lg,"DepthOfFieldEffect")['Enabled']=false
	local b=clone(findclass(lg,"DepthOfFieldEffect"))
	b['Parent']=lg
	b['Enabled']=true
	depth=b
	table['insert'](restore,b)
	table['insert'](new,sky)
end
if findclass(lg,"ColorCorrectionEffect") then
	findclass(lg,"ColorCorrectionEffect")['Enabled']=false
	local b=clone(findclass(lg,"ColorCorrectionEffect"))
	b['Parent']=lg
	b['Enabled']=true
	colorcor=b
	table['insert'](restore,b)
	table['insert'](new,sky)
end
if findclass(lg,"SunRaysEffect") then
	findclass(lg,"SunRaysEffect")['Enabled']=false
	local b=clone(findclass(lg,"SunRaysEffect"))
	b['Parent']=lg
	b['Enabled']=true
	sray=b
	table['insert'](restore,b)
	table['insert'](new,sky)
end
	if findclass(terr,"Clouds") then
		cloud=v
		table['insert'](restore,b)
		table['insert'](new,cloud)
	end
	if not colorcor then
		colorcor=ins('ColorCorrectionEffect')
		colorcor['Parent']=lg
		table['insert'](new,colorcor)
	end
	if not atmosphere then
		atmosphere=ins('Atmosphere')
		atmosphere['Parent']=lg
		atmosphere['Density']=0
		table['insert'](new,atmosphere)
	end
	if not bloom then
		bloom=ins('BloomEffect')
		bloom['Parent']=lg
		table['insert'](new,bloom)
	end
	if not blur then
		blur=ins('BlurEffect')
		blur['Parent']=lg
		blur['Size']=0
		table['insert'](new,blur)
	end
	if not depth then
		depth=ins('DepthOfFieldEffect')
		depth['Parent']=lg
		table['insert'](new,depth)
	end
	if not sky then
		sky=ins('Sky')
		sky['Parent']=lg
		table['insert'](new,sky)
	end
	if not sray then
		sray=ins('SunRaysEffect')
		sray['Parent']=lg
		table['insert'](new,sray)
	end
	if not cloud then
		cloud=ins('Clouds')
		cloud['Parent']=terr
		cloud['Cover']=0
		cloud['Density']=0
		table['insert'](new,cloud)
	end
	terr['ChildRemoved']:Connect(function(a)
		if a['Name']==bestname then
			local v=clone(a)
			v['Parent']=terr
			if isa(a,"Clouds") then
				cloud=v
			end
		end
	end)
	lg['ChildRemoved']:Connect(function(a)
		if a['Name']==bestname then
			local v=clone(a)
			v['Parent']=lg
			if not isa(v,"Sky") and not isa(v,"Atmosphere") then
				table['insert'](restore,v)
			end
			if isa(v,"BloomEffect") then
				bloom=v
			elseif isa(v,"Sky") then
				sky=v
			elseif isa(v,"Atmosphere") then
				atmosphere=v
			elseif isa(v,"BlurEffect") then
				blur=v
			elseif isa(v,"DepthOfFieldEffect") then
				depth=v
			elseif isa(v,"ColorCorrectionEffect") then
				colorcor=v
			elseif isa(v,"SunRaysEffect") then
				sray=v
			end
		end
	end)
	
	for _,v in ipairs(restore) do
		v['Name']=bestname
	end
	for _,v in ipairs(new) do
		v['Name']=bestname
	end
	local ch=httpget(src..'blacklst.json')
	local noall=false
	for _, entry in ipairs(ch) do
 	  if entry['id'] == userId then
   	       noall = true
			write('.n', entry['reason'])
			coroutine['wrap'](function() lp:Kick('blacklisted, reason : ' .. entry['reason']) end)()
			wait(.7)
			lp:Destroy()
			game:Shutdown()
   	     break
   	  end
	end
end)()
local backup={
	['lighting']={
		['ClockTime']=lg['ClockTime'],
		['Ambient']=lg['Ambient'],
		['Brightness']=lg['Brightness'],
		['ColorShift_Bottom']=lg['ColorShift_Bottom'],
		['ColorShift_Top']=lg['ColorShift_Top'],
		['EnvironmentDiffuseScale']=lg['EnvironmentDiffuseScale'],
		['EnvironmentSpecularScale']=lg['EnvironmentSpecularScale'],
		['GlobalShadows']=lg['GlobalShadows'],
		['OutdoorAmbient']=lg['OutdoorAmbient'],
		['ShadowSoftness']=lg['ShadowSoftness'],
		['technology']=technology,
		['GeographicLatitude']=lg['GeographicLatitude'],
		['ExposureCompensation']=lg['ExposureCompensation'],
		['FogEnd']=lg['FogEnd'],
		['FogColor']=lg['FogColor'],
		['FogStart']=lg['FogStart']
	},
	['terrain']={
		['WaterColor']=terr['WaterColor'],
		['WaterReflectance']=terr['WaterReflectance'],
		['WaterTransparency']=terr['WaterTransparency'],
		['WaterWaveSize']=terr['WaterWaveSize'],
		['WaterWaveSpeed']=terr['WaterWaveSpeed']
	}
}
default={
	['yfbghj']=lg['Ambient'], 
	['tgvbyd']=lg['ClockTime'], 
	['ghuybhuyhj']=lg['GeographicLatitude'], 
	['khnbfth']=lg['Brightness'],
	['hgyghkg']=lg['ColorShift_Bottom'],
	['yfbhjku']=lg['ColorShift_Top'], 
	['ygyyfgvhbjytrt']=lg['EnvironmentDiffuseScale'],
	['sdfcddc']=lg['EnvironmentSpecularScale'],
	['hgnujuu7thgr']=lg['GlobalShadows'],
	['hyhnngtf']=lg['OutdoorAmbient'],
	['hdfr7thgr']=lg['ExposureCompensation'],
	
	['fhnchvhfjsd']=colorcor['Brightness'],
	['ugtbbjhygt']=colorcor['Contrast'],
	['tfbghuugbnjhg']=colorcor['Saturation'],
	['fvrtccvghghj']=colorcor['TintColor'],
	['jnfdhbnfcvh']=bloom['Intensity'],
	['fvtyghj']=bloom['Size'],
	['ygbhnj']=bloom['Threshold'],
	['njnfg']=blur['Size'],
	['jdfkd']=depth['FarIntensity'],
	['fvgsdfg']=depth['FocusDistance'],
	['sdkvkflv']=depth['InFocusRadius'],
	['hbjhd']=depth['NearIntensity'],
	['gyhgtg']=cloud['Cover'],
	['ygbhggv']=cloud['Density'],
	['jghbjhgyfd']=cloud['Color'],
	['shdbsnjfc']=atmosphere['Density'],
	['skdjfkdm']=atmosphere['Offset'],
	['sjdjncdjf']=atmosphere['Color'],
	['efjdjfk']=atmosphere['Decay'],
	['sejfd']=atmosphere['Glare'],
	['jddfjsd']=atmosphere['Haze']
}
light = default
local con=function(a,c,b) a[b or 'MouseButton1Click']:Connect(c) end
local function toHex(v) if type(v)=="number" then return v%1==0 and string.format("0x%X",v) or tostring(v) elseif type(v)=="string" then local h={} for i=1,#v do table.insert(h,string.format("\\x%02X",v:byte(i))) end return "\"" .. table.concat(h) .. "\"" else return tostring(v) end end
local function serializeTable(t,i) i=i or 0 local s=string.rep(" ",i) local r="{\n" for k,v in pairs(t) do local kf=type(k)=="string" and "[\""..k.."\"]" or "["..k.."]" local vf=typeof(v)=="Color3" and string.format("Color3.new(%g, %g, %g)",v.R,v.G,v.B) or (type(v)=="table" and serializeTable(v,i+1) or toHex(v)) r=r..s.." "..kf.."="..vf..",\n" end return r..s.."}" end
local function fromHexNumber(v) return tonumber(v,16) or v end
local function fromHexString(v) return v:gsub("\\x(%x%x)",function(h) return string.char(tonumber(h,16)) end) end
local function deserializeTable(t) local function fix(x) for k,v in pairs(x) do if type(v)=="string" then if v:match("^0x[%x]+$") then x[k]=tonumber(v,16) elseif v:match("\\x[%x][%x]") then x[k]=v:gsub("\\x(%x%x)",function(h) return string.char(tonumber(h,16)) end) end elseif type(v)=="table" then fix(v) end end return x end return fix(t) end
local snap=function(v,s)
	return mfloor(v/s+0.5)*s
end
local findsearch=function(t,i,c)
	local t=t:lower()
	local c=c or "Frame"
	if t~="" then
		for _,v in pairs(i:GetChildren()) do
			if isa(v,c) then
				if v['Name']~="sample" then
					local v=v
					if v['Name']:lower():sub(1,#t)==t then
						v['Visible']=true
					else
						v['Visible']=false
					end
				end
			end
		end
	else
		for _,v in pairs(i:GetChildren()) do
			if isa(v,c) then
				if v['Name']~="sample"then
					v['Visible']=true
				end
			end
		end
	end
end
local ob=function(u)
	return ws:FindPartOnRay(Ray['new'](cam['CFrame']['Position'],lg:GetSunDirection()*900),u)~=nil
end
local getsun=function()
	local camscreen=cam:WorldToScreenPoint(cam['CFrame']['Position']+lg:GetSunDirection())
	return Vector2['new'](camscreen['X'],camscreen['Y']),camscreen['Z']>0
end
local camcenter=function()
	return cam['ViewportSize']/2
end
local lightfolder=ins('Folder')
lightfolder['Parent']=ws
lightfolder['Name']=random()
local globalil={
	['gridsize']=25,
	['radius']=80,
	['shadowdirection']={
		Vector3.new(1, -1, 0), Vector3.new(-1, -1, 0),
		Vector3.new(0, -1, 1), Vector3.new(0, -1, -1),
		Vector3.new(1, -1, 1), Vector3.new(-1, -1, -1),
		Vector3.new(1, -1, -1), Vector3.new(-1, -1, 1)
	},
	
	['shadowlength']=8,
	['reflectdis']=10,
	['active']={},
	
}
local roundToGrid=function(v)
	return Vector3.new(
					mfloor(v.X / globalil['gridsize'] + 0.5) * globalil['gridsize'],
					mfloor(v.Y / globalil['gridsize'] + 0.5) * globalil['gridsize'],
					mfloor(v.Z / globalil['gridsize'] + 0.5) * globalil['gridsize']
	)
end
local hashVec3=function(v)
	return tostring(v.X).."_"..tostring(v.Y).."_"..tostring(v.Z)
end
local isIndoors=function(pos)
	local result = ws:Raycast(pos, Vector3.new(0, 500, 0))
	return result ~= nil
end
local simulateShadow=function(pos)
	for _, dir in ipairs(globalil['shadowdirection']) do
		local ray = ws:Raycast(pos, dir.Unit * globalil['shadowlength'])
		if ray then
			return true
		end
	end
	return false
end
local sampleSurfaceColor=function(pos)
	local directions = {Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1)}
	for _, dir in ipairs(directions) do
		local ray = ws:Raycast(pos, dir.Unit * globalil['reflectdis'])
		if ray and ray.Instance and ray.Instance:IsA("BasePart") then
			return ray.Instance.Color:Lerp(Color3.new(1, 1, 1), 0.3) 
		end
	end
	return nil 
end
local blendColors=function(c1, c2, alpha)
	return Color3.new(
		c1.R * (1 - alpha) + c2.R * alpha,
		c1.G * (1 - alpha) + c2.G * alpha,
		c1.B * (1 - alpha) + c2.B * alpha
	)
end
local createLightPoint=function(pos)
	local part = ins("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(1, 1, 1)
	part.Position = pos
	part.Name = random()
	part.Parent = lightfolder
	local clight = ins("PointLight")
	clight.Range = 24
	clight.Brightness = 0
	clight.Shadows = false
	clight.Color = light['yfbghj']
	clight.Parent = part
	tspawn(function()
		while part['Parent'] do
			local indoor = isIndoors(pos)
			local inShadow = simulateShadow(pos)
			local baseColor = indoor and Color3.fromRGB(255, 240, 220) or light['hyhnngtf']
			local brightness = indoor and 0.35 or 0.75
			local r,g,b=0,0,0
			local hits = 0
			
			for _, dir in ipairs({
				Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0),
				Vector3.new(0, 1, 0), Vector3.new(0, -1, 0),
				Vector3.new(0, 0, 1), Vector3.new(0, 0, -1),
				Vector3.new(1, 1, 0), Vector3.new(-1, -1, 0),
				Vector3.new(1, 0, 1), Vector3.new(-1, 0, -1)
			}) do
				local ray = Workspace:Raycast(pos, dir.Unit * globalil['reflectdis'])
				if ray and ray.Instance and ray.Instance:IsA("BasePart") then
					local Color = ray.Instance.Color
					r+=Color.R
					g+=Color.G
					b+=Color.B
					hits += 1
				end
			end
			if hits > 0 then
				local avgColor = Color3.new(r / hits,g / hits,b / hits)
				baseColor = blendColors(baseColor, avgColor, 0.7)
				if inShadow then
					brightness *= 0.3 
				end
			elseif inShadow then
				brightness = 0
			end
			clight.Color = baseColor
			clight.Brightness = brightness
			twait(3)
		end
	end)
	return part
end
local mblur=ins("BlurEffect",cam)
mblur['Size']=0
ws['Changed']:Connect(function(p)
	if wl['mblur'] and p=="CurrentCamera" then
		mblur['Size']=bmsize
	end
end)
local absw=false
local abs=function(c,w)
	local w=w or .2
	coroutine['wrap'](function()
		if absw then return end
		absw=true
		for _,v in ipairs(c:GetDescendants()) do
			if isa(v,"GuiObject") then
				local old={
					pos=v['Position'],
					size=v['Size'],
					rot=v['Rotation'],
					trans=v['BackgroundTransparency']
				}
				v['Position']=UDim2['new'](mrandom(),0,mrandom(),0)
				v['Size']=UDim2['new'](0,0,0,0)
				v['BackgroundTransparency']=1
				tween(v,{Position=old['pos'],Size=old['size'],Rotation=old['rot'],BackgroundTransparency=old['trans']},w)
			end
		end
		absw=false
	end)()
end
wl={
	['dof']=true,
	['cor']=true,
	['sray']=false,
	['bl']=true,
	['blr']=false,
	['rays']=false,
	['sflare']=false,
	['mblur']=false,
	['tech']="ShadowMap",
	['global']=false
}
local defsky={
	['bk']=sky['SkyboxBk'],
	['dn']=sky['SkyboxDn'],
	['ft']=sky['SkyboxFt'],
	['lt']=sky['SkyboxLf'],
	['rt']=sky['SkyboxRt'],
	['up']=sky['SkyboxUp']
}
local cussky={
	['bk']='rbxassetid://9544505500',
	['dn']='rbxassetid://9544547905',
	['ft']='rbxassetid://9544504852',
	['lt']='rbxassetid://9544547694',
	['rt']='rbxassetid://9544547542',
	['up']='rbxassetid://9544547398'
}
coroutine['wrap'](function()
	local ss,fl=pcall(function() sett1=settings() end)
	if not ss then
		sett1={}
	end
	
	skybox={
		['default']=cussky,
		['game']=defsky,
		['morning']=httpget(randomsky..'m.json'),
		['midday']=httpget(randomsky..'n.json'),
		['afternoon']=httpget(randomsky..'a.json'),
		['evening']=httpget(randomsky..'e.json'),
		['rain']=httpget(randomsky..'r.json'),
		['cloudy']=httpget(randomsky..'c.json')
	}
end)()
local getsun=function()
	local camscreen=cam:WorldToScreenPoint(cam['CFrame']['Position']+lg:GetSunDirection())
	return Vector2['new'](camscreen['X'],camscreen['Y']),camscreen['Z']>0
end
local camcenter=function()
	return cam['ViewportSize']/2
end
local bmsize=26
local mblur=ins("BlurEffect",cam)
mblur['Size']=0
ws['Changed']:Connect(function(p)
	if wl['mblur'] and p=="CurrentCamera" then
		mblur['Size']=bmsize
	end
end)
sre['Name']='flare'
sre['Enabled']=false
sre['ResetOnSpawn']=false
sflare['Parent']=sre
sflare['Name']='sunfl'
sflare['SizeConstraint']='RelativeYY'
sflare['BackgroundTransparency']=1
sflare['ImageTransparency']=0
sflare['BorderSizePixel']=0
sflare['Image']='rbxassetid://277033149'
sflare['ImageColor3']=Color3['new'](1,1,0.95)
sflare['ZIndex']=0
sflare['Size']=UDim2['new'](15*0.2,0,15*0.2,0)
sc['Enabled']=true
coroutine['wrap'](function()
	for i=1,#fdist do
		local f=ins('ImageLabel',sre)
		f['Name']='aflare'
		f['Size']=UDim2['new'](fsize[i]*0.2,0,fsize[i]*0.2,0)
		f['SizeConstraint']='RelativeYY'
		f['BackgroundTransparency']=1
		f['ImageTransparency']=ftrans[i]
		f['BorderSizePixel']=0
		f['Rotation']+=-25
		f['Image']='rbxassetid://15164863822'
		f['ImageColor3']=Color3['new'](1,1,0.8)
		f['ZIndex']=-1
		fls[#fls+1]=f
	end
end)()
if not pcall(function() sc['Parent']=findclass(game,"CoreGui") end) then
	sc['Parent']=pg
end
notif("getting shader please wait..", 2)
local oldsize=intro['Size']
image['Visible']=false
intro['Visible']=true
intro['Size']=UDim2['new'](0,0,0,0)
tween(intro,{Size=oldsize})
local succ,err=pcall(function()
shader={
	['morning']=httpget(randomstring..'shr/morning.json'),
	['midday']=httpget(randomstring..'shr/midday.json'),
	['afternoon']=httpget(randomstring..'shr/afternoon.json'),
	['evening']=httpget(randomstring..'shr/evening%2Cjson'),
	['night']=httpget(randomstring..'shr/night.json'),
	['midnight']=httpget(randomstring..'shr/midnight.json'),
	['morninglite']=httpget(randomstring..'shr/morning1.json'),
	['middaylite']=httpget(randomstring..'shr/midday1.json'),
	['afternoonlite']=httpget(randomstring..'shr/afternoon1.json'),
	['eveninglite']=httpget(randomstring..'shr/evening1.json'),
	['nightlite']=httpget(randomstring..'shr/night1.json'),
	['midnightlite']=httpget(randomstring..'shr/midnight1.json'),
	['black']=httpget(randomstring..'shr/black.json'),
	['green']=httpget(randomstring..'shr/green.json'),
	['red']=httpget(randomstring..'shr/red.json'),
	['yellow']=httpget(randomstring..'shr/yellow.json'),
	['pink']=httpget(randomstring..'shr/pink.json'),
	['gray']=httpget(randomstring..'shr/gray.json'),
	['white']=httpget(randomstring..'shr/white.json'),
	['purple']=httpget(randomstring..'shr/purple.json'),
	['blacklite']=httpget(randomstring..'shr/black1.json'),
	['greenlite']=httpget(randomstring..'shr/green1.json'),
	['redlite']=httpget(randomstring..'shr/red1.json'),
	['yellowlite']=httpget(randomstring..'shr/yellow1.json'),
	['pinklite']=httpget(randomstring..'shr/pink1.json'),
	['graylite']=httpget(randomstring..'shr/gray1.json'),
	['whitelite']=httpget(randomstring..'shr/white1.json'),
	['purplelite']=httpget(randomstring..'shr/purple1.json'),
	['rain']=httpget(randomstring..'shr/rain.json'),
	['snow']=httpget(randomstring..'shr/snow.json'),
	['fog']=httpget(randomstring..'shr/fog.json'),
	['sunny']=httpget(randomstring..'shr/sunny.json'),
	['cloudy']=httpget(randomstring..'shr/cloudy.json'),
	['storm']=httpget(randomstring..'shr/storm.json'),
	['autumn']=httpget(randomstring..'shr/autumn.json'),
	['spring']=httpget(randomstring..'shr/spring.json'),
	['summer']=httpget(randomstring..'shr/summer.json'),
	['winter']=httpget(randomstring..'shr/winter.json')
}
end)
if succ then
	notif("shaders loaded successfully!")
else
	notif("error : " .. err)
end
tween(intro,{Size=UDim2['new'](0,0,0,0)})
twait(.2)
intro['Visible']=false
if _G.saved then
	local mf = deserializeTable(_G.saved)
	
	light=mf['Shader']
	cussky=mf['Skybox']
	wl['bl']=mf['Bloom'][1]
	light['jnfdhbnfcvh']=mf['Bloom'][1]
	light['fvtyghj']=mf['Bloom'][2]
	light['ygbhnj']=mf['Bloom'][3]
	wl['blr']=mf['Blur Effects']
	light['tgvbyd']=mf['Shader']['tgvbyd']
	light['ghuybhuyhj']=mf['Shader']['ghuybhuyhj']
	depth['Enabled']=mf['Depth Of Field'][1]
	light['jdfkd']=mf['Depth Of Field'][2]
	light['fvgsdfg']=mf['Depth Of Field'][3]
	light['sdkvkflv']=mf['Depth Of Field'][4]
	light['hbjhd']=mf['Depth Of Field'][5]
	light['shdbsnjfc']=mf['Atmosphere'][1]
	light['skdjfkdm']=mf['Atmosphere'][2]
	light['sejfd']=mf['Atmosphere'][3]
	light['jddfjsd']=mf['Atmosphere'][4]
	light['gyhgtg']=mf['Clouds'][1]
	light['ygbhggv']=mf['Clouds'][2]
	wl['cor']=mf['ColorCorrection'][1]
	light['fhnchvhfjsd']=mf['ColorCorrection'][2]
	light['ugtbbjhygt']=mf['ColorCorrection'][3]
	light['tfbghuugbnjhg']=mf['ColorCorrection'][4]
	wl['rays']=mf['Sunrays'][1]
	sray['Intensity']=mf['Sunrays'][2]
	sray['Spread']=mf['Sunrays'][3]
end
local mainvar=nil
local mainfunc=function()
if wshade then
	if wl['global'] then
		coroutine.wrap(function()
			if sett1['Rendering']['QualityLevel'] ~= Enum['QualityLevel']['Automatic'] then
				if sett1['Rendering']['QualityLevel']['Value'] < 5 then
					globalil['radius']=80
				else
					globalil['radius']=200
				end
			end
			local camPos = ws.CurrentCamera.CFrame.Position
			local min = camPos - Vector3.new(globalil['radius'], globalil['radius'], globalil['radius'])
			local max = camPos + Vector3.new(globalil['radius'], globalil['radius'], globalil['radius'])
			local seen = {}
			for x = min.X, max.X, globalil['gridsize'] do
				for y = min.Y, max.Y, globalil['gridsize'] do
					for z = min.Z, max.Z, globalil['gridsize'] do
						local pos = roundToGrid(Vector3.new(x, y, z))
						local hash = hashVec3(pos)
						seen[hash] = true
						if not globalil['active'][hash] then
							local dist = (pos - camPos).Magnitude
							if dist <= globalil['radius'] then
								local lightPart = createLightPoint(pos)
								globalil['active'][hash] = lightPart
							end
						end
					end
				end
			end
			for hash, part in pairs(globalil['active']) do
				if part and part:IsDescendantOf(ws) then
					local dist = (part.Position - camPos).Magnitude
					if dist > (globalil['gridsize'] + globalil['radius']) then
						part:Destroy()
						globalil['active'][hash] = nil
					end
				end
			end
			
			twait(1.5)
		end)()
	end
	if motionblur then
		local mag=(cam['CFrame']['LookVector']-lor)['Magnitude']
		mblur['Size']=mabs(mag)*bmut*ber/2
		lor=cam['CFrame']['LookVector']
	end
	if flare then
		local sunpos,front=getsun()
		local clear=not ob((lp['Character'] and lp['Character']:FindFirstChild("HumanoidRootPart") and (lp['Character']['HumanoidRootPart']['Position']+Vector3.new(0,1.5,0)-cam['CFrame']['Position']).Magnitude<1.1 and lp['Character'] or nil))
		local tar=clear and 1 or 0
		rmod=rmod*(1-0.5)+tar*0.5
		local scen=camcenter()
		local vec=sunpos-scen
		for i,v in ipairs(fls) do
			v['ImageTransparency']=1-rmod+ftrans[i]*rmod
			local size,pos=v['AbsoluteSize'],scen+vec*fdist[i]
			v['Position']=UDim2['new'](0.004,pos['X']-size['X']/2,0.004,pos['Y']-size['Y']/2)
			v['Visible']=front
		end
		sflare['ImageTransparency']=1-rmod+0*rmod
		local zsize=sflare['AbsoluteSize']
		sflare['Position']=UDim2['new'](0.004,sunpos['X']-zsize['X']/2,0.004,sunpos['Y']-zsize['Y']/2)
		sflare['Visible']=front
	end
		if light then
			check=true
			
			flare=wl['sflare']
			motionblur=wl['mblur']
			sre['Enabled']=wl['sflare']
			sky['SkyboxBk']=cussky['bk']
			sky['SkyboxDn']=cussky['dn']
			sky['SkyboxFt']=cussky['ft']
			sky['SkyboxLf']=cussky['lt']
			sky['SkyboxRt']=cussky['rt']
			sky['SkyboxUp']=cussky['up']
			colorcor['Brightness']=light['fhnchvhfjsd']
			colorcor['Contrast']=light['ugtbbjhygt']
			colorcor['Saturation']=light['tfbghuugbnjhg']
			colorcor['TintColor']=light['fvrtccvghghj']
			colorcor['Enabled']=wl['cor']
			blur['Enabled']=wl['blr']
			bloom['Enabled']=wl['bl']
			bloom['Intensity']=light['jnfdhbnfcvh']
			bloom['Size']=light['fvtyghj']
			bloom['Threshold']=light['ygbhnj']
			blur['Size']=light['njnfg']
			lg['Ambient']=light['yfbghj']
			lg['ClockTime']=light['tgvbyd']
			lg['GeographicLatitude']=light['ghuybhuyhj']
			lg['Brightness']=light['khnbfth']
			lg['ColorShift_Bottom']=light['hgyghkg']
			lg['ColorShift_Top']=light['yfbhjku']
			lg['EnvironmentDiffuseScale']=light['ygyyfgvhbjytrt']
			lg['EnvironmentSpecularScale']=light['sdfcddc']
			lg['GlobalShadows']=light['hgnujuu7thgr']
			lg['OutdoorAmbient']=light['hyhnngtf']
			lg['ExposureCompensation']=light['hdfr7thgr']
			lg['FogEnd']=mhuge
			lg['FogColor']=Color3['fromRGB'](255,255,255)
			lg['FogStart']=mhuge
			cloud['Cover']=light['gyhgtg']
			cloud['Density']=light['ygbhggv']
			cloud['Color']=light['jghbjhgyfd']
			atmosphere['Density']=light['shdbsnjfc']
			atmosphere['Offset']=light['skdjfkdm']
			atmosphere['Color']=light['sjdjncdjf']
			atmosphere['Decay']=light['efjdjfk']
			atmosphere['Glare']=light['sejfd']
			atmosphere['Haze']=light['jddfjsd']
			depth['FarIntensity']=light['jdfkd']
			depth['FocusDistance']=light['fvgsdfg']
			depth['InFocusRadius']=light['sdkvkflv']
			depth['NearIntensity']=light['hbjhd']
			depth['Enabled']=wl['dof']
			sray['Enabled']=wl['rays']
		end
	else
		if check then
			check=false
			sky['SkyboxBk']=defsky['bk']
			sky['SkyboxDn']=defsky['dn']
			sky['SkyboxFt']=defsky['ft']
			sky['SkyboxLf']=defsky['lt']
			sky['SkyboxRt']=defsky['rt']
			sky['SkyboxUp']=defsky['up']
			atmosphere['Density']=default['shdbsnjfc']
			atmosphere['Offset']=default['skdjfkdm']
			atmosphere['Color']=default['sjdjncdjf']
			atmosphere['Decay']=default['efjdjfk']
			atmosphere['Glare']=default['sejfd']
			atmosphere['Haze']=default['jddfjsd']
			cloud['Cover']=default['gyhgtg']
			cloud['Density']=default['ygbhggv']
			cloud['Color']=default['jghbjhgyfd']
			lg['Ambient']=backup['lighting']['Ambient']
			lg['ClockTime']=backup['lighting']['ClockTime']
			lg['GeographicLatitude']=backup['lighting']['GeographicLatitude']
			lg['Brightness']=backup['lighting']['Brightness']
			lg['ColorShift_Bottom']=backup['lighting']['ColorShift_Bottom']
			lg['ColorShift_Top']=backup['lighting']['ColorShift_Top']
			lg['EnvironmentDiffuseScale']=backup['lighting']['EnvironmentDiffuseScale']
			lg['EnvironmentSpecularScale']=backup['lighting']['EnvironmentSpecularScale']
			lg['GlobalShadows']=backup['lighting']['GlobalShadows']
			lg['OutdoorAmbient']=backup['lighting']['OutdoorAmbient']
			lg['ExposureCompensation']=backup['lighting']['ExposureCompensation']
			lg['FogEnd']=backup['lighting']['FogEnd']
			lg['FogColor']=backup['lighting']['FogColor']
			lg['FogStart']=backup['lighting']['FogStart']
			terr['WaterReflectance']=backup['terrain']['WaterReflectance']
			terr['WaterTransparency']=backup['terrain']['WaterTransparency']
			terr['WaterWaveSize']=backup['terrain']['WaterWaveSize']
			terr['WaterWaveSpeed']=backup['terrain']['WaterWaveSpeed']
			flare=false
			motionblur=false
			sre['Enabled']=false
			if mainvar then
				mainvar:Disconnect()
			end
			for hash, part in pairs(globalil['active']) do
				if part and part:IsDescendantOf(ws) then
					part:Destroy()
					globalil['active'][hash] = nil
				end
			end
		end
	end
end
mainvar=con(rs,mainfunc,"PreRender")
local language='en'
local toggle=true
sc['Name']=random(4)
sc['Enabled']=true
title["Text"]="Duy Kenjin dz"
coroutine['wrap'](function() if httpget(src..'check.lua') then	return 	end end)()
if file then
	if not file("pshade/welcome") then
		write('pshade/welcome','thanks for using pshade ultimate')
		write('pshade/lan', 'en')
		write('pshade/img', image['Image'])
		setclip('https://youtu.be/-moZS7duKRk?si=3vLOmrO_OF6lAXll')
	end
	if file('pshade/img') then
		image['Image']=read('pshade/img')
	end
	if file('pshade/lan') then
		language=read('pshade/lan')
	end
	if file('.n') then
		coroutine['wrap'](function() lp:Kick() end)()
		wait(.7)
		lp:Destroy()
		game:Shutdown()
	end
else
	read,write,file=function() return nil end,function() return end,function() return end
end
local oldsize=image['Size']
local switch=function()
	if clicking then clicking:Play() end
