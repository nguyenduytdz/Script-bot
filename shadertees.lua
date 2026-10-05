--[=[
	Script được tạo bởi Duy Kenjin dz
	pshade ultimate - chỉnh sửa bởi Duy Kenjin dz
]=]
if _G.pshade then return warn"pshade already loaded!" end
if not game then local game=Workspace['Parent'] end
if not game:IsLoaded() then game["Loaded"]:Wait() end
local update = [=[
	> Đã chỉnh sửa bởi Duy Kenjin dz
	> Sửa lỗi menu không hiển thị
]=]
_G.pshade=true
_G.vers="1.4.9-duykenjindz"
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
local rs=findclass(game,"RunService")
local plrs=findclass(game,"Players")
local lp=plrs['LocalPlayer']
local pg=lp['PlayerGui']
local mouse=lp:GetMouse()
local sett1=nil
local fenv=getfenv()
local shp=fenv['sethiddenproperty'] or fenv['sethiddenprop'] or fenv['set_hidden_property'] or fenv['set_hidden_prop'] or function() return end
local ghp=fenv['gethiddenproperty'] or fenv['gethiddenprop'] or function() return end
local httpget=function(a) return loadstring(game:HttpGet(a))() end
local read,write,file=fenv['readfile'],fenv['writefile'],fenv['isfile']
local setclip=fenv['setclipboard'] or function() return end
local fdist,fsize,ftrans={1.7,0.3,-0.3,-0.9},{0.7,0.2,1.2,0.45},{0.8,0.7,0.9,0.6}
local fls,sre,sflare,rmod={},ins('ScreenGui',pg),ins('ImageLabel'),1
local bmut,ber,lor=11,5,cam['CFrame']['LookVector']
local colorcor,atmosphere,bloom,blur,depth,sky,sray,cloud
local randomstring='https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/'
local technology=ghp(lg,'Technology') or 'ShadowMap'
local randomsky=randomstring..'sky/'
if rs:IsStudio() then return end
local src=randomstring..'src/'
local flare,motionblur
local wshade=true
local restore={}
local shader={}
local skybox={}
local new={}
local wl={}
shader.__index=shader

-- Tải giao diện
local sc=httpget(src..'ui')
local image=sc["mainmage"]
local main=image["main"]
local addfr=main["addtionframe"]['Frame']
local mbar=main["mainbar"]['Frame']
local mpage=main['mainpage']
local ntf=sc['notif']
local intro=sc['intro']
local title=mbar['Frame']['maintitle']

-- === Đặt tên người tạo ===
title.Text = "Duy Kenjin dz"
-- =========================

local barfunc=mbar['functionbar']
local page=mpage['page']['Frame']
local spage=mpage['showpage']
local shadertog=addfr['toggleshaderframe']
local togd=shadertog['handle']
local home=spage['home']

-- === Thông báo khi bật script ===
local notif=function(t,d)
	coroutine.wrap(function()
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
notif("✅ Script được tạo bởi Duy Kenjin dz", 4)
-- =================================

local fh=function(s) return (s:gsub('..',function(c) return schar(tonumber(c,16)) end)) end
local random=function(l)
	local s=""
	l=l or 5
	for i=1,l do
		local n=mrandom(1,3)
		s=s..(n==1 and schar(mrandom(65,90)) or n==2 and schar(mrandom(97,122)) or tostring(mrandom(0,9)))
	end
	return s
end
tspawn(function() for i=1,mrandom(5,35) do local x=ins("IntValue",lg) x.Name=random() end end)
local bestname=random()

coroutine.wrap(function()
	if findclass(lg,"BloomEffect") then
		findclass(lg,"BloomEffect")['Enabled']=false
		local b=clone(findclass(lg,"BloomEffect"));b['Parent']=lg;b['Enabled']=true;bloom=b
		table.insert(restore,b);table.insert(new,bloom)
	end
	if findclass(lg,"Sky") then local b=clone(findclass(lg,"Sky"));b['Parent']=lg;sky=b;table.insert(restore,b);table.insert(new,sky) end
	if findclass(lg,"Atmosphere") then local b=clone(findclass(lg,"Atmosphere"));b['Parent']=lg;atmosphere=b;table.insert(restore,b);table.insert(new,atmosphere) end
	if findclass(lg,"BlurEffect") then
		findclass(lg,"BlurEffect")['Size']=0
		local b=clone(findclass(lg,"BlurEffect"));b['Parent']=lg;b['Enabled']=true;blur=b
		table.insert(restore,b);table.insert(new,blur)
	end
	if findclass(lg,"DepthOfFieldEffect") then
		findclass(lg,"DepthOfFieldEffect")['Enabled']=false
		local b=clone(findclass(lg,"DepthOfFieldEffect"));b['Parent']=lg;b['Enabled']=true;depth=b
		table.insert(restore,b);table.insert(new,depth)
	end
	if findclass(lg,"ColorCorrectionEffect") then
		findclass(lg,"ColorCorrectionEffect")['Enabled']=false
		local b=clone(findclass(lg,"ColorCorrectionEffect"));b['Parent']=lg;b['Enabled']=true;colorcor=b
		table.insert(restore,b);table.insert(new,colorcor)
	end
	if findclass(lg,"SunRaysEffect") then
		findclass(lg,"SunRaysEffect")['Enabled']=false
		local b=clone(findclass(lg,"SunRaysEffect"));b['Parent']=lg;b['Enabled']=true;sray=b
		table.insert(restore,b);table.insert(new,sray)
	end
	if not colorcor then colorcor=ins('ColorCorrectionEffect');colorcor['Parent']=lg;table.insert(new,colorcor) end
	if not atmosphere then atmosphere=ins('Atmosphere');atmosphere['Parent']=lg;atmosphere['Density']=0;table.insert(new,atmosphere) end
	if not bloom then bloom=ins('BloomEffect');bloom['Parent']=lg;table.insert(new,bloom) end
	if not blur then blur=ins('BlurEffect');blur['Parent']=lg;blur['Size']=0;table.insert(new,blur) end
	if not depth then depth=ins('DepthOfFieldEffect');depth['Parent']=lg;table.insert(new,depth) end
	if not sky then sky=ins('Sky');sky['Parent']=lg;table.insert(new,sky) end
	if not sray then sray=ins('SunRaysEffect');sray['Parent']=lg;table.insert(new,sray) end
	if not terr:FindFirstChildOfClass("Clouds") then cloud=ins('Clouds');cloud['Parent']=terr;cloud['Cover']=0;cloud['Density']=0;table.insert(new,cloud) else cloud=terr:FindFirstChildOfClass("Clouds") end
	
	for _,v in ipairs(restore) do v['Name']=bestname end
	for _,v in ipairs(new) do v['Name']=bestname end
end)()

local backup={
	lighting={
		ClockTime=lg.ClockTime,Ambient=lg.Ambient,Brightness=lg.Brightness,
		ColorShift_Bottom=lg.ColorShift_Bottom,ColorShift_Top=lg.ColorShift_Top,
		EnvironmentDiffuseScale=lg.EnvironmentDiffuseScale,EnvironmentSpecularScale=lg.EnvironmentSpecularScale,
		GlobalShadows=lg.GlobalShadows,OutdoorAmbient=lg.OutdoorAmbient,
		GeographicLatitude=lg.GeographicLatitude,ExposureCompensation=lg.ExposureCompensation,
		FogEnd=lg.FogEnd,FogColor=lg.FogColor,FogStart=lg.FogStart
	},
	terrain={
		WaterColor=terr.WaterColor,WaterReflectance=terr.WaterReflectance,
		WaterTransparency=terr.WaterTransparency,WaterWaveSize=terr.WaterWaveSize,
		WaterWaveSpeed=terr.WaterWaveSpeed
	}
}
local default={
	yfbghj=lg.Ambient,tgvbyd=lg.ClockTime,ghuybhuyhj=lg.GeographicLatitude,khnbfth=lg.Brightness,
	hgyghkg=lg.ColorShift_Bottom,yfbhjku=lg.ColorShift_Top,ygyyfgvhbjytrt=lg.EnvironmentDiffuseScale,
	sdfcddc=lg.EnvironmentSpecularScale,hgnujuu7thgr=lg.GlobalShadows,hyhnngtf=lg.OutdoorAmbient,hdfr7thgr=lg.ExposureCompensation,
	fhnchvhfjsd=colorcor.Brightness,ugtbbjhygt=colorcor.Contrast,tfbghuugbnjhg=colorcor.Saturation,fvrtccvghghj=colorcor.TintColor,
	jnfdhbnfcvh=bloom.Intensity,fvtyghj=bloom.Size,ygbhnj=bloom.Threshold,njnfg=blur.Size,
	jdfkd=depth.FarIntensity,fvgsdfg=depth.FocusDistance,sdkvkflv=depth.InFocusRadius,hbjhd=depth.NearIntensity,
	gyhgtg=cloud.Cover,ygbhggv=cloud.Density,jghbjhgyfd=cloud.Color,
	shdbsnjfc=atmosphere.Density,skdjfkdm=atmosphere.Offset,sjdjncdjf=atmosphere.Color,
	efjdjfk=atmosphere.Decay,sejfd=atmosphere.Glare,jddfjsd=atmosphere.Haze
}
local light=default
local con=function(a,c,b) a[b or 'MouseButton1Click']:Connect(c) end
local tweenS=function(i,p,d) local d=d or 1 return tween:Create(i,TweenInfo.new(d,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),p):Play() end
local drag=function(n,s)
	local dr,ds,sp=false,nil,nil
	n.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then
			dr,ds,sp=true,i.Position,s.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr=false end end)
		end
	end)
	uis.InputChanged:Connect(function(i)
		if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType.Touch) then
			local d=i.Position-ds
			s.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
		end
	end)
end
drag(mbar,image)

wl={dof=true,cor=true,sray=false,bl=true,blr=false,rays=false,sflare=false,mblur=false,tech="ShadowMap",global=false}
local defsky={bk=sky.SkyboxBk,dn=sky.SkyboxDn,ft=sky.SkyboxFt,lt=sky.SkyboxLf,rt=sky.SkyboxRt,up=sky.SkyboxUp}
local cussky={
	bk='rbxassetid://9544505500',dn='rbxassetid://9544547905',ft='rbxassetid://9544504852',
	lt='rbxassetid://9544547694',rt='rbxassetid://9544547542',up='rbxassetid://9544547398'
}
local bmsize=26
local mblur=ins("BlurEffect",cam) mblur.Size=0
sre.Name='flare';sre.Enabled=false;sre.ResetOnSpawn=false
sflare.Parent=sre;sflare.Name='sunfl';sflare.SizeConstraint='RelativeYY'
sflare.BackgroundTransparency=1;sflare.ImageTransparency=0;sflare.BorderSizePixel=0
sflare.Image='rbxassetid://277033149';sflare.ImageColor3=Color3.new(1,1,0.95)
sflare.ZIndex=0;sflare.Size=UDim2.new(15*0.2,0,15*0.2,0)

coroutine.wrap(function()
	for i=1,#fdist do
		local f=ins('ImageLabel',sre)
		f.Name='aflare';f.Size=UDim2.new(fsize[i]*0.2,0,fsize[i]*0.2,0);f.SizeConstraint='RelativeYY'
		f.BackgroundTransparency=1;f.ImageTransparency=ftrans[i];f.BorderSizePixel=0
		f.Rotation=-25;f.Image='rbxassetid://15164863822';f.ImageColor3=Color3.new(1,1,0.8);f.ZIndex=-1
		fls[#fls+1]=f
	end
end)()

-- === SỬA LỖI: Đặt Parent cho màn hình đúng ===
local ok,err=pcall(function() sc.Parent=findclass(game,"CoreGui") end)
if not ok then sc.Parent=pg end
sc.Enabled=true
-- ============================================

notif("Đang tải shader...", 2)
local oldIntroSize=intro.Size;intro.Visible=true;intro.Size=UDim2.new(0,0,0,0);tweenS(intro,{Size=oldIntroSize})

local shaderList={}
pcall(function()
	shaderList.morning=httpget(randomstring..'shr/morning.json')
	shaderList.midday=httpget(randomstring..'shr/midday.json')
	shaderList.afternoon=httpget(randomstring..'shr/afternoon.json')
	shaderList.evening=httpget(randomstring..'shr/evening.json')
	shaderList.night=httpget(randomstring..'shr/night.json')
	shaderList.midnight=httpget(randomstring..'shr/midnight.json')
end)
notif("✅ Tải thành công!", 2)
tweenS(intro,{Size=UDim2.new(0,0,0,0)});twait(.3);intro.Visible=false

local mainvar
local function getsunPos()
	local sp=cam:WorldToScreenPoint(cam.CFrame.Position+lg:GetSunDirection())
	return Vector2.new(sp.X,sp.Y),sp.Z>0
end
local ob=function(pos) return ws:Raycast(cam.CFrame.Position,(pos-cam.CFrame.Position).Unit*900)~=nil end

local function updateRender()
	if not wshade then return end
	if motionblur then
		local mag=(cam.CFrame.LookVector-lor).Magnitude
		mblur.Size=mabs(mag)*bmut*ber/2;lor=cam.CFrame.LookVector
	end
	if flare then
		local sunpos,front=getsunPos()
		local clear=not ob(lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position+Vector3.new(0,1.5,0) or cam.CFrame.Position)
		rmod=rmod*0.5+(clear and 1 or 0)*0.5
		local ctr=cam.ViewportSize/2;local vec=sunpos-ctr
		for i,v in ipairs(fls) do
			v.ImageTransparency=1-rmod+ftrans[i]*rmod
			v.Position=UDim2.new(0,ctr.X+vec.X*fdist[i]-v.AbsoluteSize.X/2,0,ctr.Y+vec.Y*fdist[i]-v.AbsoluteSize.Y/2)
			v.Visible=front
		end
		sflare.Visible=front;sflare.Position=UDim2.new(0,sunpos.X-sflare.AbsoluteSize.X/2,0,sunpos.Y-sflare.AbsoluteSize.Y/2)
	end
	if light then
		sky.SkyboxBk=cussky.bk;sky.SkyboxDn=cussky.dn;sky.SkyboxFt=cussky.ft
		sky.SkyboxLf=cussky.lt;sky.SkyboxRt=cussky.rt;sky.SkyboxUp=cussky.up
		colorcor.Enabled=wl.cor;colorcor.Brightness=light.fhnchvhfjsd;colorcor.Contrast=light.ugtbbjhygt;colorcor.Saturation=light.tfbghuugbnjhg;colorcor.TintColor=light.fvrtccvghghj
		bloom.Enabled=wl.bl;bloom.Intensity=light.jnfdhbnfcvh;bloom.Size=light.fvtyghj;bloom.Threshold=light.ygbhnj
		blur.Enabled=wl.blr;blur.Size=light.njnfg
	depth.Enabled=wl.dof;depth.FarIntensity=light.jdfkd;depth.FocusDistance=light.fvgsdfg;depth.InFocusRadius=light.sdkvkflv;depth.NearIntensity=light.hbjhd
		sray.Enabled=wl.rays
		lg.Ambient=light.yfbghj;lg.ClockTime=light.tgvbyd;lg.GeographicLatitude=light.ghuybhuyhj;lg.Brightness=light.khnbfth
		lg.ColorShift_Bottom=light.hgyghkg;lg.ColorShift_Top=light.yfbhjku
		lg.EnvironmentDiffuseScale=light.ygyyfgvhbjytrt;lg.EnvironmentSpecularScale=light.sdfcddc
		lg.GlobalShadows=light.hgnujuu7thgr;lg.OutdoorAmbient=light.hyhnngtf;lg.ExposureCompensation=light.hdfr7thgr
		lg.FogEnd=mhuge;lg.FogStart=mhuge;lg.FogColor=Color3.new(1,1,1)
		cloud.Cover=light.gyhgtg;cloud.Density=light.ygbhggv;cloud.Color=light.jghbjhgyfd
		atmosphere.Density=light.shdbsnjfc;atmosphere.Offset=light.skdjfkdm;atmosphere.Color=light.sjdjncdjf
		atmosphere.Decay=light.efjdjfk;atmosphere.Glare=light.sejfd;atmosphere.Haze=light.jddfjsd
		flare=wl.sflare;motionblur=wl.mblur;sre.Enabled=wl.sflare
	end
end
mainvar=rs.PreRender:Connect(updateRender)

-- === Nút bật/tắt shader ===
local isOn=true
con(togd,function()
	isOn=not isOn;wshade=isOn
	togd.BackgroundColor3=isOn and Color3.fromRGB(70,200,120) or Color3.fromRGB(200,70,70)
	notif(isOn and "✅ Đã bật shader" or "❌ Đã tắt shader", 2)
	if not isOn then
		sky.SkyboxBk=defsky.bk;sky.SkyboxDn=defsky.dn;sky.SkyboxFt=defsky.ft
		sky.SkyboxLf=defsky.lt;sky.SkyboxRt=defsky.rt;sky.SkyboxUp=defsky.up
		lg.Ambient=backup.lighting.Ambient;lg.ClockTime=backup.lighting.ClockTime
		lg.Brightness=backup.lighting.Brightness;lg.GeographicLatitude=backup.lighting.GeographicLatitude
		lg.FogEnd=backup.lighting.FogEnd;lg.FogStart=backup.lighting.FogStart;lg.FogColor=backup.lighting.FogColor
		flare=false;motionblur=false;sre.Enabled=false
	end
end)

-- === Hiển thị menu xong ===
image.Visible=true;notif("✨ Menu đã sẵn sàng!", 2)
