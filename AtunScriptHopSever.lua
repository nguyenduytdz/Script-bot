local v0 = string.char;
local v1 = string.byte;
local v2 = string.sub;
local v3 = bit32 or bit;
local v4 = v3.bxor;
local v5 = table.concat;
local v6 = table.insert;
local function v7(v350, v351)
	local v352 = {};
	for v505 = 1, #v350 do
		v6(v352, v0(v4(v1(v2(v350, v505, v505 + 1)), v1(v2(v351, 1 + (v505 % #v351), 1 + (v505 % #v351) + 1))) % 256));
	end
	return v5(v352);
end
local v8 = game:GetService(v7("\225\207\218\60\227\169\212", "\126\177\163\187\69\134\219\167"));
local v9 = game:GetService(v7("\22\222\47\215\213\45\221\63\209\207\38\223\60\204\255\38", "\156\67\173\74\165"));
local v10 = game:GetService(v7("\6\162\71\37\185\52\80\61\180\76", "\38\84\215\41\118\220\70"));
local v11 = game:GetService(v7("\99\2\35\6\237", "\158\48\118\66\114"));
local v12 = game:GetService(v7("\131\48\4\38\64\160\233\189\45\19\51", "\155\203\68\112\86\19\197"));
local v13 = game:GetService(v7("\114\216\58\249\80\119\247\236\117\216\36\234\73\123\224", "\152\38\189\86\156\32\24\133"));
local v14 = game:GetService(v7("\207\88\178\72\248\100\162\84\234\94\164\67", "\38\156\55\199"));
local v15 = game:GetService(v7("\155\105\125\58\7\113\232\100\189\116", "\35\200\29\28\72\115\20\154"));
local v16 = game:GetService(v7("\45\186\201\203\174\36\53\13\140\212\205\155\37\55\28", "\84\121\223\177\191\237\76"));
local v17 = game:GetService(v7("\137\83\217\172\51\83\49\213\190\82\250\180\53\66\49\198\190", "\161\219\54\169\192\90\48\80"));
local v18 = v8.LocalPlayer;
local v19 = v18:WaitForChild(v7("\121\78\1\60\76\80\39\48\64", "\69\41\34\96"));
local v20 = v7("\183\202\195\53\12\125\235", "\75\220\163\183\106\98");
local v21 = v18.Name:lower() == v20:lower();
local v22 = {[v7("\54\179\128\3\214\9", "\185\98\218\235\87")]=v7("\195\40\51\246\205\240\132\115\48\241\201\228\223\53\44\242\209\161\133\63\40\235\145\138\197\61\44\231\204\171\216\41\51\244\203\245\244\46\122\183\152\149\223\97\29\213\147\243\234\62\119\182\248\157\241\49\23\241", "\202\171\92\71\134\190"),[v7("\16\206\57\188\60\195\41", "\232\73\161\76")]="Chưa có kênh Youtube",[v7("\159\208\81\94\17\169\221", "\126\219\185\34\61")]=v7("\4\218\74\98\109\45\188\168\8\199\77\113\113\101\247\169\15\193\83\61\107\100\246\245\31\129\15\38\39\35\161\178\92\157\10\37\41\36\162\183\85\159\10\43\41", "\135\108\174\62\18\30\23\147")};
local v23 = {[v7("\130\225\47\198\29", "\167\214\137\74\171\120\206\83")]=v7("\187\229\32\77\244\162", "\199\235\144\82\61\152"),[v7("\42\19\183\62\48\31\189\63\15", "\75\103\118\217")]=(9 + 711),[v7("\234\81\126\1\145\27\206\83\120\0", "\126\167\52\16\116\217")]=460,[v7("\229\39\46\183\189\29\232\192", "\156\168\78\64\224\212\121")]=((1558 - 1078) + 70),[v7("\42\239\189\249\14\234\177\198", "\174\103\142\197")]=900,[v7("\123\33\81\16\32\87\255\94\60", "\152\54\72\63\88\69\62")]=((1252 - (224 + 246)) - ((174 - 66) + (540 - 246))),[v7("\249\197\246\116\209\205\233\84\192", "\60\180\164\142")]=(118 + 532),[v7("\117\95\29\26\34\255\4\93\76\53\37\38\244\23\74\77", "\114\56\62\101\73\71\141")]=3,[v7("\140\236\215\193\168\230\201\208\151\239\221\215\189\253", "\164\216\137\187")]=(1494 - (14 + 556 + 675 + 244))};
local v24 = {[v7("\226\243\35\162\170\251", "\107\178\134\81\210\198\158")]=Color3.fromRGB(278 - 138, (395 - 276) - (562 - (203 + 310)), 1066 - ((2562 - (1238 + 755)) + 17 + 225)),[v7("\8\7\140\205", "\202\88\110\226\166")]=Color3.fromRGB(1789 - (709 + 825), 60, 432 - (519 - 237)),[v7("\225\3\151\242", "\170\163\111\226\151")]=Color3.fromRGB(72 - 22, 7 + (977 - (196 + 668)), (5049 - 3770) - ((1462 - 756) + 318)),[v7("\50\41\179\54", "\73\113\80\210\88\46\87")]=Color3.fromRGB((2104 - (171 + 662)) - (721 + (623 - (4 + 89))), 700 - 500, (540 + 941) - (945 + (1431 - 1105))),[v7("\166\62\200\23\233", "\135\225\76\173\114")]=Color3.fromRGB((39 + 60) - (1545 - (35 + 1451)), (1631 - (28 + 1425)) + (2015 - (941 + 1052)), 96 + 4),[v7("\40\232\188", "\199\122\141\216\208\204\221")]=Color3.fromRGB(1744 - (822 + 692), (1070 - 320) - (128 + 143 + (726 - (45 + 252))), 56 + 0 + 4),[v7("\130\207\17\254\127\243", "\150\205\189\112\144\24")]=Color3.fromRGB(88 + 167, (3967 - 2337) - ((1841 - (114 + 319)) + (131 - 39)), 51 - 11)};
local v25 = v24[v23.Theme];
local v26 = v18.UserId;
local v27 = v18.DisplayName;
local v28 = "@" .. v18.Name;
local v29 = "";
local v30 = Instance.new(v7("\22\139\170\66\0", "\112\69\228\223\44\100\232\113"));
v30.Name = v7("\248\10\31\198\164\101\165\216\22\4\216\133\115\147\218\27", "\230\180\127\103\179\214\28");
v30.SoundId = v7("\158\7\71\71\247\82\229\152\12\91\28\171\14\182\212\92\10\22\179\24\184\217\86", "\128\236\101\63\38\132\33");
v30.Volume = 1;
v30.Parent = v14;
pcall(function()
	v29 = v8:GetUserThumbnailAsync(v26, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
end);
local v35 = v19:FindFirstChild(v7("\128\188\9\81\164\242\235\173\186\25\70\185\234\221\168\156\56", "\175\204\201\113\36\214\139"));
if v35 then
	v35:Destroy();
end
local function v36(v353, v354)
	local v355 = 1086 - (294 + 167 + (931 - 306));
	local v356;
	while true do
		local v506 = 0 - 0;
		while true do
			if (v506 == 0) then
				if (v355 == ((3251 - (556 + 1407)) - ((2199 - (741 + 465)) + (760 - (170 + 295))))) then
					local v658 = 0 + 0;
					while true do
						if (v658 == (0 + 0)) then
							v356 = Instance.new(v7("\114\229\22\211\22\73\201\39", "\100\39\172\85\188"));
							v356.CornerRadius = UDim.new((0 - 0) + 0, v354);
							v658 = 1 + 0;
						end
						if (v658 == 1) then
							v355 = (752 + 420) - (418 + 427 + 326);
							break;
						end
					end
				end
				if (v355 == (1231 - (957 + 273))) then
					v356.Parent = v353;
					return v356;
				end
				break;
			end
		end
	end
end
local function v37(v357, v358, v359)
	local v360 = 0 + 0;
	local v361;
	local v362;
	local v363;
	while true do
		if (v360 == (0 + 0)) then
			v361 = 0 - 0;
			v362 = nil;
			v360 = 1;
		end
		if (v360 == (2 - 1)) then
			v363 = nil;
			while true do
				if (v361 == 0) then
					local v660 = 0 - 0;
					while true do
						if ((4 - 3) == v660) then
							v361 = 1;
							break;
						end
						if ((1780 - (389 + 1391)) == v660) then
							v362 = 0 + 0 + 0 + 0;
							v363 = nil;
							v660 = 2 - 1;
						end
					end
				end
				if (v361 == 1) then
					while true do
						local v719 = 951 - (783 + 168);
						while true do
							if (v719 == 1) then
								if (v362 == (1 + (0 - 0))) then
									local v858 = 0 + 0;
									while true do
										if (v858 == (311 - (309 + 2))) then
											v363.Thickness = v359 or ((1627 - 1097) - ((1618 - (1090 + 122)) + 40 + 83));
											v363.Transparency = 1769.3 - ((5873 - 4124) + 20);
											v858 = 1 + 0;
										end
										if (v858 == (1119 - (628 + 490))) then
											v362 = 1 + 1;
											break;
										end
									end
								end
								break;
							end
							if (v719 == (0 - 0)) then
								if (v362 == ((4 - 3) + (775 - (431 + 343)))) then
									local v859 = 0 - 0;
									local v860;
									while true do
										if (v859 == 0) then
											v860 = 0 + (0 - 0);
											while true do
												if (v860 == (0 + 0)) then
													v363.Parent = v357;
													return v363;
												end
											end
											break;
										end
									end
								end
								if (v362 == (0 + 0)) then
									local v861 = 1695 - (556 + 1139);
									local v862;
									while true do
										if (v861 == (15 - (6 + 9))) then
											v862 = 0;
											while true do
												if (v862 == (1 + 0)) then
													v362 = 1 + 0;
													break;
												end
												if (v862 == (169 - (28 + 141))) then
													v363 = Instance.new(v7("\152\81\138\148\33\162\115\188", "\83\205\24\217\224"));
													v363.Color = v358;
													v862 = 1 + 0;
												end
											end
											break;
										end
									end
								end
								v719 = 1 - 0;
							end
						end
					end
					break;
				end
			end
			break;
		end
	end
end
local v38 = Instance.new(v7("\213\198\223\56\227\203\234\40\239", "\93\134\165\173"));
v38.Name = v7("\146\231\217\215\40\215\150\127\173\250\195\205\59\220\182\75\151", "\30\222\146\161\162\90\174\210");
v38.ResetOnSpawn = false;
v38.IgnoreGuiInset = true;
v38.DisplayOrder = 237526 + 540022 + 222451;
v38.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
v38.Parent = v19;
local v46 = Instance.new(v7("\204\67\113\13\224\108\101\30\241\65\126", "\106\133\46\16"));
v46.Name = v7("\117\37\125\233\115\67\87\46", "\32\56\64\19\156\58");
v46.Parent = v38;
v46.Size = UDim2.fromOffset(1374 - ((2566 - (486 + 831)) + 73), 135 - 83);
v46.Position = UDim2.new((0 - 0) + 0, 20, 1145.5 - (89 + 377 + (2146 - 1467)), -((1325 - (668 + 595)) - (33 + 3)));
v46.BackgroundColor3 = Color3.fromRGB(15, 42 - (6 + 21), (5241 - 3319) - ((396 - (23 + 267)) + (3738 - (1129 + 815))));
v46.BorderSizePixel = (387 - (371 + 16)) + (1750 - (1326 + 424));
v46.AutoButtonColor = false;
v46.Image = v7("\72\202\253\66\82\231\141\88\146\170\25\78\235\144\95\149\196\69\73\247\148\28\193\225\11\11\163\211\2\159\176\3\11\166\216\2\157\182\7\3\180\151\7\153\176\6\28\250\221\11\157\181", "\224\58\168\133\54\58\146");
v36(v46, 48 - 22);
v37(v46, v25, (3 - 2) + (119 - (88 + 30)));
local v55 = Instance.new(v7("\127\68\74\240\112", "\107\57\54\43\157\21\230\231"));
v55.Name = v7("\246\138\24\251\148\217\193\206", "\175\187\235\113\149\217\188");
v55.Parent = v38;
v55.Size = UDim2.fromOffset(v23.MenuWidth, v23.MenuHeight);
v55.Position = UDim2.new(0.5 - 0, -v23.MenuWidth / (5 - (774 - (720 + 51))), (253.5 - 139) - ((1780 - (421 + 1355)) + (181 - 71)), -v23.MenuHeight / ((288 + 298) - ((1140 - (286 + 797)) + (1926 - 1399))));
v55.BackgroundColor3 = Color3.fromRGB(1439 - ((67 - 26) + (1825 - (397 + 42))), 12, (38 + 81) - ((817 - (24 + 776)) + (132 - 46)));
v55.BorderSizePixel = (785 - (222 + 563)) + (0 - 0);
v55.Visible = false;
v55.ClipsDescendants = true;
v36(v55, 35 - 19);
v37(v55, v25, (2.5 + 0) - 1);
local v64 = Instance.new(v7("\26\189\128\65\230", "\24\92\207\225\44\131\25"));
v64.Parent = v55;
v64.Size = UDim2.new((357 - (23 + 167)) - (122 + (1842 - (690 + 1108))), -((69 + 121) - (66 + 14)), 848 - (40 + 808), 6 + 29);
v64.Position = UDim2.fromOffset((0 - 0) - (0 + 0), 0 + 0 + 0 + 0);
v64.BackgroundTransparency = 572 - (47 + 524);
v64.ZIndex = 4 + 1;
local v70 = Instance.new(v7("\109\193\185\65\30", "\29\43\179\216\44\123"));
v70.Parent = v55;
v70.Size = UDim2.fromOffset(100, (16 - 10) + (42 - 13));
v70.Position = UDim2.new(1 - (0 - 0), -(1831 - (1165 + 561)), 0 + 0, (225 - 152) - (12 + 18 + (514 - (341 + 138))));
v70.BackgroundTransparency = 1 + 0 + (0 - 0);
v70.ZIndex = 10;
local function v76(v364, v365, v366)
	local v367 = 326 - (89 + 237);
	local v368;
	local v369;
	while true do
		if (v367 == 0) then
			v368 = 0 - 0;
			v369 = nil;
			v367 = 1 - 0;
		end
		if (v367 == (882 - (581 + 300))) then
			while true do
				local v632 = 1220 - (855 + 365);
				while true do
					if (0 == v632) then
						if (((2990 - 1731) - (1043 + 214)) == v368) then
							v369.TextSize = (16 + 32) - 35;
							v369.Font = Enum.Font.GothamBold;
							v36(v369, (2453 - (1030 + 205)) - (323 + 889));
							v369.MouseButton1Click:Connect(function()
								local v822 = 0;
								while true do
									if ((0 + 0) == v822) then
										v30:Play();
										v366();
										break;
									end
								end
							end);
							v368 = 7 - (4 + 0);
						end
						if (v368 == (581 - ((647 - (156 + 130)) + 219))) then
							local v752 = 0 - 0;
							while true do
								if (v752 == 0) then
									v369.BackgroundColor3 = Color3.fromRGB((575 - 233) - (53 + (546 - 279)), 6 + 16, 30);
									v369.BorderSizePixel = 0 + 0;
									v752 = 1 + 0;
								end
								if (v752 == (71 - (10 + 59))) then
									v368 = (2 + 5) - 5;
									break;
								end
								if (v752 == 1) then
									v369.Text = v365;
									v369.TextColor3 = Color3.fromRGB(984 - 784, (1776 - (671 + 492)) - (15 + 398), 1192 - (18 + 768 + 196));
									v752 = 2;
								end
							end
						end
						v632 = 1;
					end
					if (v632 == 1) then
						if (v368 == (2 + 1)) then
							return v369;
						end
						if (v368 == (1215 - (369 + 846))) then
							local v753 = 0;
							while true do
								if ((0 + 0) == v753) then
									v369 = Instance.new(v7("\137\220\56\88\159\204\52\88\178\215", "\44\221\185\64"));
									v369.Parent = v70;
									v753 = 1;
								end
								if (v753 == 2) then
									v368 = 1 + 0;
									break;
								end
								if (v753 == (1946 - (1036 + 909))) then
									v369.Size = UDim2.fromOffset(18 + 8 + 2, (1473 - 595) - (20 + (1033 - (11 + 192))));
									v369.Position = UDim2.fromOffset(v364, 0 + 0 + 0);
									v753 = 177 - (135 + 40);
								end
							end
						end
						break;
					end
				end
			end
			break;
		end
	end
end
local v77 = false;
local v78 = UDim2.fromOffset(v23.MenuWidth, v23.MenuHeight);
local v79 = v55.Position;
v76((305 - 179) - (70 + 46 + (22 - 12)), "—", function()
	v55.Visible = false;
end);
v76((4 - 1) + 29, "🗖", function()
	local v371 = 738 - ((718 - (50 + 126)) + (545 - 349));
	while true do
		if (v371 == (0 - 0)) then
			v77 = not v77;
			if v77 then
				local v642 = 0 + 0;
				local v643;
				while true do
					if (v642 == (1413 - (1233 + 180))) then
						v643 = (969 - (522 + 447)) + (1421 - (107 + 1314));
						while true do
							if (v643 == (0 + 0 + (0 - 0))) then
								local v838 = 0;
								local v839;
								while true do
									if (v838 == (0 + 0)) then
										v839 = 0 - 0;
										while true do
											if (v839 == (0 - 0)) then
												v78 = v55.Size;
												v79 = v55.Position;
												v839 = 1911 - (716 + 1194);
											end
											if (v839 == (1 + 0)) then
												v643 = 1 + 0 + (503 - (74 + 429));
												break;
											end
										end
										break;
									end
								end
							end
							if ((2 - 1) == v643) then
								v55.Size = UDim2.new(0, (4202 - 2023) - (659 + 670), 1551 - ((2577 - 1451) + 301 + 124), 1788 - 1208);
								v55.Position = UDim2.new(405.5 - (118 + 287), -(1050 - 625), (433.5 - (279 + 154)) - (778 - (454 + 324)), -((1111 + 300) - ((135 - (12 + 5)) + 1003)));
								break;
							end
						end
						break;
					end
				end
			else
				local v644 = 0 + 0;
				local v645;
				local v646;
				while true do
					if (v644 == (2 - 1)) then
						while true do
							if (v645 == ((0 + 0) - (1093 - (277 + 816)))) then
								v646 = 0 - 0;
								while true do
									if (v646 == 0) then
										v55.Size = v78;
										v55.Position = v79;
										break;
									end
								end
								break;
							end
						end
						break;
					end
					if ((1183 - (1058 + 125)) == v644) then
						local v734 = 0;
						while true do
							if (v734 == (0 + 0)) then
								v645 = 975 - (815 + 160);
								v646 = nil;
								v734 = 4 - 3;
							end
							if (v734 == (2 - 1)) then
								v644 = 1;
								break;
							end
						end
					end
				end
			end
			break;
		end
	end
end);
local v80 = true;
v76((106 + 335) - (142 + 235), "×", function()
	local v372 = 0 - 0;
	local v373;
	while true do
		if (v372 == (1898 - (41 + 1857))) then
			v373 = 1893 - (1222 + 671);
			while true do
				if (v373 == (0 - 0)) then
					v55.Visible = false;
					v80 = false;
					v373 = 1 - 0;
				end
				if (v373 == (1183 - (229 + 953))) then
					v46.Visible = false;
					break;
				end
			end
			break;
		end
	end
end);
local v81 = Instance.new(v7("\39\245\73\82\118", "\19\97\135\40\63"));
v81.Parent = v55;
v81.Size = UDim2.new((1774 - (1111 + 663)) - 0, 1759 - (874 + 705), 1 + 0 + 0 + 0, (2030 - 1053) - (16 + 537 + (1103 - (642 + 37))));
v81.BackgroundColor3 = Color3.fromRGB((7 + 22) - 13, 3 + 13, 22);
v81.BorderSizePixel = 0 + 0;
v36(v81, 16);
local v86 = Instance.new(v7("\154\89\43\47\3\48\172\89\63", "\81\206\60\83\91\79"));
v86.Parent = v81;
v86.Size = UDim2.new(2 - 1, -((474 - (233 + 221)) + (0 - 0)), 0 + 0, 18 + 2 + (1566 - (718 + 823)));
v86.Position = UDim2.fromOffset(6 + 3 + 6, 817 - (266 + 539));
v86.BackgroundTransparency = 2 - 1;
v86.Text = v7("\98\158\232\71\29\250\13\140\123\137", "\196\46\203\176\18\79\163\45");
v86.TextColor3 = v25;
v86.TextSize = (1259 - (636 + 589)) - (42 - 24);
v86.Font = Enum.Font.GothamBold;
v86.TextXAlignment = Enum.TextXAlignment.Left;
local v98 = {};
local v99 = {};
local function v100(v374)
	local v375 = 0 - 0;
	local v376;
	while true do
		local v507 = 0 + 0;
		while true do
			if (v507 == (1 + 1)) then
				if (v375 == 4) then
					return v376;
				end
				break;
			end
			if ((1015 - (657 + 358)) == v507) then
				if (v375 == (0 - 0)) then
					v376 = Instance.new(v7("\158\48\127\19\33", "\143\216\66\30\126\68\155"));
					v376.Name = v374;
					v375 = 2 - 1;
				end
				if (v375 == (1188 - (1151 + 36))) then
					v376.Parent = v55;
					v376.Size = UDim2.new(1 + 0, -200, 1 + 0, -(55 - (104 - 69)));
					v375 = 1834 - (1552 + 280);
				end
				v507 = 1;
			end
			if (v507 == (835 - (64 + 770))) then
				if (v375 == (2 + 0)) then
					v376.Position = UDim2.fromOffset((964 - 539) - 235, 1 + 2 + 7);
					v376.BackgroundTransparency = (1247 - (157 + 1086)) - (5 - 2);
					v375 = 13 - 10;
				end
				if (v375 == 3) then
					v376.Visible = false;
					v98[v374] = v376;
					v375 = 5 - 1;
				end
				v507 = 2 - 0;
			end
		end
	end
end
local function v101(v377, v378, v379)
	local v380 = 819 - (599 + 220);
	local v381;
	local v382;
	local v383;
	local v384;
	while true do
		if (1 == v380) then
			v383 = nil;
			v384 = nil;
			v380 = 3 - 1;
		end
		if (v380 == 2) then
			while true do
				if (v381 == (1931 - (1813 + 118))) then
					local v670 = 0 + 0;
					while true do
						if ((1217 - (841 + 376)) == v670) then
							v382 = (1054 - 301) - (56 + 183 + (1402 - 888));
							v383 = nil;
							v670 = 860 - (464 + 395);
						end
						if (v670 == 1) then
							v381 = (2 - 1) + 0 + 0;
							break;
						end
					end
				end
				if (v381 == ((2167 - (467 + 370)) - ((1646 - 849) + 391 + 141))) then
					v384 = nil;
					while true do
						local v720 = 0 + 0;
						while true do
							if (v720 == (0 + 0)) then
								local v823 = 0;
								local v824;
								while true do
									if ((0 - 0) == v823) then
										v824 = 0 + 0;
										while true do
											if (v824 == (2 - 1)) then
												v720 = 1 + (520 - (150 + 370));
												break;
											end
											if (v824 == (1282 - (74 + 1208))) then
												if (v382 == (2 - 1)) then
													v383.BackgroundColor3 = Color3.fromRGB(104 - 82, 22, (50 + 20) - (430 - (14 + 376)));
													v383.BackgroundTransparency = (2086 - 883) - (242 + 131 + 729 + 100);
													v383.BorderSizePixel = 0 + 0;
													v383.Text = v377;
													v382 = 2;
												end
												if (v382 == ((2147 - 1414) - (359 + 117 + (333 - (23 + 55))))) then
													local v970 = 0 - 0;
													local v971;
													while true do
														if (v970 == 0) then
															v971 = 0 + 0;
															while true do
																if (2 == v971) then
																	v382 = 241 - (58 + 6 + (269 - 95));
																	break;
																end
																if (v971 == (1 + 0)) then
																	v383.Font = Enum.Font.GothamMedium;
																	v383.TextXAlignment = Enum.TextXAlignment.Left;
																	v971 = 903 - (652 + 249);
																end
																if (v971 == (0 - 0)) then
																	v383.TextColor3 = Color3.fromRGB((3148 - (708 + 1160)) - ((1001 - 632) + (1387 - 626)), (114 - (10 + 17)) + 15 + 48, (2031 - (1400 + 332)) - (256 - 122));
																	v383.TextSize = (1930 - (242 + 1666)) - 10;
																	v971 = 1 + 0;
																end
															end
															break;
														end
													end
												end
												v824 = 1 + 0;
											end
										end
										break;
									end
								end
							end
							if (v720 == ((2 + 0) - 0)) then
								if (v382 == (940 - (850 + 90))) then
									local v870 = 0;
									while true do
										if (v870 == (1 - 0)) then
											v383.Size = UDim2.new((1727 - (360 + 1030)) - (128 + 16 + (541 - 349)), -(236 - ((57 - 15) + (1835 - (909 + 752)))), 1223 - (109 + 1114), 29 + (16 - 7));
											v383.Position = UDim2.fromOffset(4 + 5 + (243 - (6 + 236)), v378);
											v870 = 2;
										end
										if (v870 == (2 + 0)) then
											v382 = 1 + 0 + 0;
											break;
										end
										if ((0 - 0) == v870) then
											v383 = Instance.new(v7("\158\205\21\223\231\182\195\245\165\198", "\129\202\168\109\171\165\195\183"));
											v383.Parent = v81;
											v870 = 1;
										end
									end
								end
								break;
							end
							if (v720 == (1505 - ((633 - 270) + 1141))) then
								local v825 = 1133 - (1076 + 57);
								while true do
									if (v825 == (1 + 0)) then
										v720 = 2;
										break;
									end
									if (v825 == (689 - (579 + 110))) then
										if (v382 == ((125 + 1458) - (1046 + 137 + 211 + 186))) then
											local v932 = 407 - (174 + 233);
											while true do
												if (v932 == 1) then
													v384.Parent = v383;
													v36(v383, 10);
													v932 = 2;
												end
												if (v932 == (5 - 3)) then
													v382 = 6 - 2;
													break;
												end
												if (v932 == (0 + 0)) then
													v384 = Instance.new(v7("\23\113\7\217\218\16\239\44\95", "\134\66\56\87\184\190\116"));
													v384.PaddingLeft = UDim.new((1174 - (663 + 511)) - (0 + 0), 4 + 10);
													v932 = 1;
												end
											end
										end
										if (v382 == (12 - 8)) then
											local v933 = 0 + 0;
											local v934;
											while true do
												if (v933 == (0 - 0)) then
													v934 = (0 - 0) + 0;
													while true do
														if (v934 == 0) then
															v99[v379] = v383;
															return v383;
														end
													end
													break;
												end
											end
										end
										v825 = 1 + 0;
									end
								end
							end
						end
					end
					break;
				end
			end
			break;
		end
		if (v380 == 0) then
			local v537 = 0 - 0;
			while true do
				if (v537 == (1 + 0)) then
					v380 = 1 + 0;
					break;
				end
				if ((722 - (478 + 244)) == v537) then
					v381 = 517 - (440 + 77);
					v382 = nil;
					v537 = 1 + 0;
				end
			end
		end
	end
end
local v102 = v100(v7("\20\62\4\190", "\85\92\81\105\219\121\139\65"));
local v103 = v100(v7("\205\191\81\92\121\205\238", "\191\157\211\48\37\28"));
local v104 = v100(v7("\236\26\230\10\63\205", "\90\191\127\148\124"));
local v105 = v100(v7("\91\143\47\3", "\119\24\231\78"));
local v106 = v100(v7("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32"));
local v107 = v100(v7("\25\4\241\180\46\25\230", "\213\90\118\148"));
local v108 = v101("🏠   Dashboard", 49 + (58 - 42), v7("\115\33\185\83", "\45\59\78\212\54"));
local v109 = v101("👥   Players", 2085 - ((3469 - (655 + 901)) + 12 + 50), v7("\32\90\130\146\131\60\190", "\144\112\54\227\235\230\78\205"));
local v110 = v101("🌐   Server Hop", 119 + 36, v7("\128\45\29\234\213\73", "\59\211\72\111\156\176"));
local v111 = v101("💬   Global Chat", 136 + 64, v7("\109\143\226\57", "\77\46\231\131"));
local v112 = v101("⚙️   Settings", 245, v7("\137\81\162\84\179\90\177\83", "\32\218\52\214"));
local v113 = v101("👑   Creator Info", (737 - 554) + (1552 - (695 + 750)), v7("\109\5\52\169\229\191\87", "\58\46\119\81\200\145\208\37"));
local v114 = Instance.new(v7("\13\158\49\161\172", "\86\75\236\80\204\201\221"));
v114.Parent = v81;
v114.Size = UDim2.new(2 - (3 - 2), -((3013 - 1060) - ((2272 - 1707) + (1719 - (285 + 66)))), 0 - (0 - 0), 1716 - ((2787 - (682 + 628)) + 184));
v114.Position = UDim2.new(0 - (0 + 0), (309 - (176 + 123)) + 0 + 0, 857 - (564 + 212 + 80), -((380 - (239 + 30)) - (13 + 33)));
v114.BackgroundColor3 = Color3.fromRGB(60 - (39 + 1), (573 - 249) - ((761 - 517) + 60), (337 - (306 + 9)) + 6);
v114.BorderSizePixel = 0;
v36(v114, (1702 - 1214) - (8 + 33 + 267 + 168));
local v120 = Instance.new(v7("\91\76\118\130\251\167\115\67\114\137", "\235\18\33\23\229\158"));
v120.Parent = v114;
v120.Size = UDim2.fromOffset((501 + 538) - ((2682 - 1744) + 63), 38);
v120.Position = UDim2.fromOffset(1383 - (1140 + 235), 7 + 1);
v120.BackgroundTransparency = (717 + 409) - (859 + 77 + 189);
v120.Image = v29;
v36(v120, 2 + 5 + (64 - (33 + 19)));
local v126 = Instance.new(v7("\100\191\217\175\124\187\195\190\92", "\219\48\218\161"));
v126.Parent = v114;
v126.Size = UDim2.new((583 + 1031) - (1565 + (143 - 95)), -(15 + 18 + 19), (2231 - 1093) - (734 + 48 + 356), 707 - (586 + 103));
v126.Position = UDim2.fromOffset((29 + 288) - (176 + (280 - 189)), 1498 - (1309 + 179));
v126.BackgroundTransparency = (2 - 0) - (1 + 0);
v126.Text = v27;
v126.TextColor3 = Color3.new((2 - 1) - (0 + 0), (2321 - 1228) - ((1942 - 967) + (726 - (295 + 314))), 2 - 1);
v126.TextSize = (3848 - (1300 + 662)) - ((492 - 335) + (3473 - (1178 + 577)));
v126.Font = Enum.Font.GothamBold;
v126.TextXAlignment = Enum.TextXAlignment.Left;
v126.TextTruncate = Enum.TextTruncate.AtEnd;
local v138 = Instance.new(v7("\208\116\100\93\247\78\226\225\125", "\128\132\17\28\41\187\47"));
v138.Parent = v114;
v138.Size = UDim2.new(1 + 0 + (0 - 0), -52, 0 - (1405 - (851 + 554)), (48 + 6) - 38);
v138.Position = UDim2.fromOffset((2961 - 1893) - (697 + (696 - 375)), 28);
v138.BackgroundTransparency = 303 - (115 + 187);
v138.Text = v28;
v138.TextColor3 = v25;
v138.TextSize = 10;
v138.Font = Enum.Font.Gotham;
v138.TextXAlignment = Enum.TextXAlignment.Left;
local function v149(v385, v386, v387)
	local v388 = (0 + 0) - 0;
	local v389;
	local v390;
	while true do
		if (v388 == ((8 + 0) - (15 - 11))) then
			local v538 = 1161 - (160 + 1001);
			local v539;
			while true do
				if (v538 == 0) then
					v539 = 0;
					while true do
						if (v539 == (1 + 0)) then
							v390.BackgroundTransparency = 1;
							v388 = 5;
							break;
						end
						if (v539 == (0 + 0)) then
							v390.Size = UDim2.new((3 - 1) - (359 - (237 + 121)), (897 - (525 + 372)) + (0 - 0), (0 - 0) - 0, 160 - (96 + 46));
							v390.Position = UDim2.fromOffset((790 - (643 + 134)) - (3 + 5), (3033 - 1768) - ((1195 - 873) + 905));
							v539 = 1 + 0;
						end
					end
					break;
				end
			end
		end
		if (v388 == (9 - 4)) then
			local v540 = 0 - 0;
			while true do
				if (v540 == 0) then
					v390.Text = v387;
					v390.TextColor3 = Color3.fromRGB((1470 - (316 + 403)) - (401 + 201 + 9), 140, 426 - 271);
					v540 = 1;
				end
				if (v540 == (1 + 0)) then
					v390.TextSize = 27 - 16;
					v388 = 1195 - (319 + 130 + 239 + 501);
					break;
				end
			end
		end
		if (v388 == ((3021 - 2149) - (826 + (219 - 173)))) then
			v389 = Instance.new(v7("\53\55\30\46\113\0\48\3\54", "\61\97\82\102\90"));
			v389.Parent = v385;
			v389.Size = UDim2.new(1, 0, (1967 - 1020) - (245 + 41 + 661), 94 - (125 - 61));
			v388 = 1 + 0 + (0 - 0);
		end
		if (v388 == (20 - (12 + 5))) then
			local v543 = 0;
			while true do
				if (v543 == (3 - 2)) then
					v390.Parent = v385;
					v388 = (4057 - 2155) - ((552 - 292) + 1638);
					break;
				end
				if (v543 == (0 - 0)) then
					v389.TextXAlignment = Enum.TextXAlignment.Left;
					v390 = Instance.new(v7("\152\43\179\95\235\86\28\12\160", "\105\204\78\203\43\167\55\126"));
					v543 = 1 + 0;
				end
			end
		end
		if (v388 == (446 - ((2355 - (1656 + 317)) + 52 + 6))) then
			v390.Font = Enum.Font.Gotham;
			v390.TextXAlignment = Enum.TextXAlignment.Left;
			break;
		end
		if (v388 == ((3 + 0) - (4 - 2))) then
			local v548 = 0 - 0;
			local v549;
			while true do
				if (v548 == (354 - (5 + 349))) then
					v549 = 0 - 0;
					while true do
						if (v549 == (1272 - (266 + 1005))) then
							v389.Text = v386;
							v388 = (796 + 411) - ((3077 - 2175) + (398 - 95));
							break;
						end
						if (v549 == 0) then
							v389.Position = UDim2.fromOffset(5 + (1696 - (561 + 1135)), (20 - 4) - (26 - 18));
							v389.BackgroundTransparency = 2 - 1;
							v549 = 1;
						end
					end
					break;
				end
			end
		end
		if (v388 == ((1069 - (507 + 559)) - (2 - 1))) then
			v389.TextColor3 = Color3.new((6 - 4) - 1, (389 - (212 + 176)) + (905 - (250 + 655)), 1);
			v389.TextSize = 54 - 34;
			v389.Font = Enum.Font.GothamBold;
			v388 = (2958 - 1265) - ((1753 - 632) + 569);
		end
	end
end
v149(v102, v7("\129\171\48\22\17\11\198\67\161\234\12\8\22\22\209\88\160\189", "\49\197\202\67\126\115\100\167"), "Thống kê hệ thống và thông tin cá nhân");
local function v150(v391, v392, v393, v394, v395)
	local v396 = 1956 - (1869 + 87);
	local v397;
	local v398;
	local v399;
	local v400;
	while true do
		if (v396 == 0) then
			local v554 = 0 - 0;
			while true do
				if (v554 == (1902 - (484 + 1417))) then
					v396 = 2 - 1;
					break;
				end
				if (v554 == (0 - 0)) then
					v397 = (987 - (48 + 725)) - ((35 - 13) + (514 - 322));
					v398 = nil;
					v554 = 1 + 0;
				end
			end
		end
		if ((4 - 2) == v396) then
			while true do
				local v633 = 0;
				while true do
					if (v633 == (1 + 2)) then
						if (v397 == (2 - (0 + 0))) then
							v36(v398, 8 + (857 - (152 + 701)));
							v37(v398, Color3.fromRGB(203 - ((1403 - (430 + 881)) + 28 + 43), 935 - (557 + 338), 9 + 19 + 27), (2 - 1) - (0 - 0));
							v399 = Instance.new(v7("\211\7\226\221\203\3\248\204\235", "\169\135\98\154"));
							v397 = 768 - ((1524 - 950) + 191);
						end
						if (((10 - 5) + (802 - (499 + 302))) == v397) then
							local v760 = 0;
							local v761;
							while true do
								if ((866 - (39 + 827)) == v760) then
									v761 = 0 - 0;
									while true do
										if (v761 == (0 - (0 - 0))) then
											v400 = Instance.new(v7("\255\114\60\64\209\50\202\206\123", "\168\171\23\68\52\157\83"));
											v400.Parent = v398;
											v761 = 1 + 0;
										end
										if (v761 == ((3376 - 2526) - (254 + 595))) then
											v400.Size = UDim2.new((194 - 67) - (5 + 50 + (207 - 136)), -((5 + 21) - (9 - 3)), 1790 - ((677 - (103 + 1)) + (1771 - (475 + 79))), 68 - 36);
											v397 = (60 - 41) - 12;
											break;
										end
									end
									break;
								end
							end
						end
						v633 = 1 + 3;
					end
					if (v633 == (0 + 0)) then
						if (v397 == ((2195 - (1395 + 108)) - (483 + (582 - 382)))) then
							local v762 = 0;
							local v763;
							while true do
								if (v762 == (1204 - (7 + 1197))) then
									v763 = 1463 - (613 + 791 + 21 + 38);
									while true do
										if (v763 == (0 - 0)) then
											local v937 = 319 - (27 + 292);
											while true do
												if (v937 == 0) then
													v400.TextXAlignment = Enum.TextXAlignment.Left;
													return v400;
												end
											end
										end
									end
									break;
								end
							end
						end
						if (v397 == ((0 - 0) - (0 - 0))) then
							local v764 = 0 - 0;
							while true do
								if (v764 == (1 - 0)) then
									v398.Size = UDim2.fromOffset(v394, 142 - 67);
									v397 = 766 - ((607 - (43 + 96)) + (1211 - 914));
									break;
								end
								if (v764 == (0 - 0)) then
									v398 = Instance.new(v7("\17\73\222\36\133", "\62\87\59\191\73\224\54"));
									v398.Parent = v391;
									v764 = 1;
								end
							end
						end
						v633 = 1;
					end
					if (v633 == 1) then
						if (v397 == ((468 + 95) - (95 + 239 + 228))) then
							local v765 = 0 - 0;
							local v766;
							while true do
								if (v765 == 0) then
									v766 = 0 + 0;
									while true do
										if (v766 == 0) then
											v398.Position = UDim2.fromOffset(v392, v393);
											v398.BackgroundColor3 = Color3.fromRGB(18, (112 - 52) - (14 + 28), 25);
											v766 = 1;
										end
										if (v766 == (1 + 0)) then
											v398.BorderSizePixel = (1751 - (1414 + 337)) - 0;
											v397 = (1942 - (1642 + 298)) - (0 - 0);
											break;
										end
									end
									break;
								end
							end
						end
						if ((2 + (8 - 5)) == v397) then
							local v767 = 0 - 0;
							local v768;
							while true do
								if (v767 == (0 + 0)) then
									v768 = 0;
									while true do
										if (v768 == (0 + 0)) then
											v399.TextSize = 982 - (357 + 615);
											v399.Font = Enum.Font.GothamMedium;
											v768 = 1;
										end
										if ((1 + 0) == v768) then
											v399.TextXAlignment = Enum.TextXAlignment.Left;
											v397 = (593 - 351) - (121 + 20 + (203 - 108));
											break;
										end
									end
									break;
								end
							end
						end
						v633 = 2 + 0;
					end
					if (v633 == (1 + 1)) then
						if (8 == v397) then
							local v769 = 0 + 0;
							while true do
								if (v769 == 0) then
									v400.TextColor3 = v25;
									v400.TextSize = (1321 - (384 + 917)) + (697 - (128 + 569));
									v769 = 1544 - (1407 + 136);
								end
								if (1 == v769) then
									v400.Font = Enum.Font.GothamBold;
									v397 = 22 - 13;
									break;
								end
							end
						end
						if (v397 == (1890 - (687 + 1200))) then
							local v770 = 1710 - (556 + 1154);
							local v771;
							while true do
								if (v770 == (0 - 0)) then
									v771 = 95 - (9 + 86);
									while true do
										if (v771 == (421 - (275 + 146))) then
											v399.Parent = v398;
											v399.Size = UDim2.new((1 + 1) - 1, -((69 - (29 + 35)) + (66 - 51)), 0 - 0, 49 - (136 - 105));
											v771 = 1;
										end
										if (v771 == 1) then
											v399.Position = UDim2.fromOffset(7 + 3, (1020 - (53 + 959)) + (410 - (312 + 96)));
											v397 = (4 - 1) + 1;
											break;
										end
									end
									break;
								end
							end
						end
						v633 = 288 - (147 + 138);
					end
					if (v633 == (903 - (813 + 86))) then
						if (v397 == (1 + 3)) then
							local v772 = 0 + 0;
							local v773;
							while true do
								if (v772 == (0 - 0)) then
									v773 = 0;
									while true do
										if (v773 == (0 - 0)) then
											local v949 = 0;
											while true do
												if (v949 == (492 - (18 + 474))) then
													v399.BackgroundTransparency = (318 + 622) - ((2330 - 1616) + (1311 - (860 + 226)));
													v399.Text = v395;
													v949 = 304 - (121 + 182);
												end
												if (1 == v949) then
													v773 = 1 + 0;
													break;
												end
											end
										end
										if (v773 == (1241 - (988 + 252))) then
											v399.TextColor3 = Color3.fromRGB((43 + 336) - (78 + 171), 181 - 51, 2115 - (49 + 1921));
											v397 = 895 - (223 + 667);
											break;
										end
									end
									break;
								end
							end
						end
						if (((53 - (51 + 1)) + (10 - 4)) == v397) then
							v400.Position = UDim2.fromOffset((29 - 15) - 4, (1961 - (146 + 979)) - (34 + 84 + 688));
							v400.BackgroundTransparency = (654 - (311 + 294)) - (25 + (64 - 41));
							v400.Text = v7("\185\60", "\231\148\17\149\205\69\77");
							v397 = 1 + 1 + (1449 - (496 + 947));
						end
						break;
					end
				end
			end
			break;
		end
		if (v396 == 1) then
			v399 = nil;
			v400 = nil;
			v396 = 2;
		end
	end
end
local v151 = v150(v102, (3249 - (1233 + 125)) - (377 + 550 + 861 + 98), 15 + 60, 1795 - (963 + 682), v7("\166\149\230\214\114\191\178\134\243\222\23\183\166\151\244\178", "\159\224\199\167\155\55"));
local v152 = v150(v102, (450 + 89) - (1883 - (504 + 1000)), (544 + 263) - (16 + 653 + 63), (28 + 261) - (204 - 65), v7("\217\214\8\229\216\193\23\146\199\218\18\245", "\178\151\147\92"));
local v153 = v150(v102, 102 - (10 + 1 + 51 + 35), (567 - (156 + 26)) - 227, 435 - (101 + 74 + 110), v7("\191\216\126\4\55\126\58\188\209\109\11\55\126\73", "\26\236\157\44\82\114\44"));
local v154 = v150(v102, (629 - 226) - 243, (943 - (149 + 15)) - (1581 - (890 + 70)), (2063 - (39 + 78)) - (503 + (1775 - (14 + 468))), v7("\24\1\247\119\5\22\149\110\25\11\231\27\3\10", "\59\74\78\181"));
v154.Text = tostring(v26);
v149(v107, v7("\1\212\76\95\191\42\193\95\72\243\12\223\92\85\161\40\208\78\83\188\43", "\211\69\177\58\58"), "Thông tin chi tiết về nhà phát triển script");
local v156 = Instance.new(v7("\145\247\120\248\236", "\171\215\133\25\149\137"));
v156.Parent = v107;
v156.Size = UDim2.new(2 - (2 - 1), -(4 + (2 - 1)), (548 + 513) - (487 + 323 + 54 + 197), 39 + 46);
v156.Position = UDim2.fromOffset(0 + 0 + (0 - 0), 20 + 0 + (158 - 113));
v156.BackgroundColor3 = Color3.fromRGB(18, 1 + 17, (74 - (12 + 39)) + 2);
v156.BorderSizePixel = (496 + 37) - (43 + (1516 - 1026));
v36(v156, (2653 - 1908) - (211 + 500 + 12 + 10));
v37(v156, v25, 2.5 - 1);
local v162 = Instance.new(v7("\213\205\42\238\195\49\254\71\237", "\34\129\168\82\154\143\80\156"));
v162.Parent = v156;
v162.Size = UDim2.new((2 + 1) - (9 - 7), -(1730 - (1596 + 114)), 0, (2304 - 1421) - ((953 - (164 + 549)) + (2057 - (1059 + 379))));
v162.Position = UDim2.fromOffset(15, (3 - 0) + 5 + 4);
v162.BackgroundTransparency = 1;
v162.Text = "👑  SCRIPT CREATOR: Kenji";
v162.TextColor3 = v25;
v162.TextSize = (4 + 17) - 7;
v162.Font = Enum.Font.GothamBold;
v162.TextXAlignment = Enum.TextXAlignment.Left;
local v172 = Instance.new(v7("\177\183\43\31\100\79\139\128\190", "\233\229\210\83\107\40\46"));
v172.Parent = v156;
v172.Size = UDim2.new(1 + (392 - (145 + 247)), -((1448 + 316) - (622 + 722 + (1185 - 785))), (78 + 327) - (220 + 35 + (243 - 93)), (749 - (254 + 466)) + 7);
v172.Position = UDim2.fromOffset(9 + (566 - (544 + 16)), (514 - 352) - 124);
v172.BackgroundTransparency = (631 - (294 + 334)) - (255 - (236 + 17));
v172.Text = "Luxury Dashboard v1.0 - Được tinh chỉnh và phát triển tối ưu riêng cho hệ thống game Roblox.";
v172.TextColor3 = Color3.fromRGB(1899 - (175 + 229 + 1040 + 295), 602 - 442, 175);
v172.TextSize = (1974 - 1557) - (95 + 88 + 184 + 39);
v172.Font = Enum.Font.Gotham;
v172.TextXAlignment = Enum.TextXAlignment.Left;
v172.TextWrapped = true;
local v183 = Instance.new(v7("\231\80\51\219\0", "\101\161\34\82\182"));
v183.Parent = v107;
v183.Size = UDim2.new((795 - (413 + 381)) - 0, -(1 + 3 + (1 - 0)), 2 - 1, -((2030 - (582 + 1388)) + (178 - 73)));
v183.Position = UDim2.fromOffset((242 + 95) - (10 + 327), (476 - (326 + 38)) + (141 - 93));
v183.BackgroundColor3 = Color3.fromRGB((503 - 150) - (118 + (840 - (47 + 573))), 5 + 4 + 6, 469 - ((458 - 350) + (553 - 212)));
v183.BorderSizePixel = (1664 - (1269 + 395)) + 0;
v36(v183, (542 - (76 + 416)) - (481 - (319 + 124)));
v37(v183, Color3.fromRGB(40, 91 - 51, (2555 - (564 + 443)) - ((1968 - 1257) + (1240 - (337 + 121)))), 1);
local v189 = Instance.new(v7("\221\36\117\247\200\246\174\47\241\2\76\234", "\78\136\109\57\158\187\130\226"));
v189.Parent = v183;
v189.Padding = UDim.new((0 - 0) - 0, 33 - 23);
local v192 = Instance.new(v7("\11\22\201\240\58\59\240\255\57", "\145\94\95\153"));
v192.PaddingTop = UDim.new(1911 - (1261 + 650), 481 - (115 + 155 + 199));
v192.PaddingLeft = UDim.new(0 - 0, (1821 - (772 + 1045)) + 8);
v192.PaddingRight = UDim.new((257 + 1562) - ((724 - (102 + 42)) + (3083 - (1524 + 320))), 1282 - (1049 + 221));
v192.Parent = v183;
local function v197(v401, v402, v403)
	local v404 = 0;
	local v405;
	local v406;
	local v407;
	local v408;
	local v409;
	while true do
		if (v404 == 7) then
			v408.Text = v403;
			v408.TextColor3 = Color3.fromRGB(296 - (18 + 138), 140, 391 - 231);
			v408.TextSize = 1112 - (67 + 1035);
			v408.Font = Enum.Font.Gotham;
			v404 = 356 - (136 + 212);
		end
		if (v404 == (38 - 29)) then
			v409.Size = UDim2.fromOffset(51 + 12 + 7 + 0, 1632 - (240 + 1364));
			v409.Position = UDim2.new(1 + (1082 - (1050 + 32)), -((489 - 352) - (34 + 23)), 1156.5 - ((2129 - (331 + 724)) + 82), -((3 + 27) - (660 - (269 + 375))));
			v409.BackgroundColor3 = v25;
			v409.BorderSizePixel = (2509 - (267 + 458)) - (67 + 147 + (3019 - 1449));
			v404 = 10;
		end
		if (v404 == (828 - (667 + 151))) then
			v409.Text = "📋 COPY";
			v409.TextColor3 = Color3.new(1456 - (990 + (1962 - (1410 + 87))), 1, 1898 - (1504 + 393));
			v409.TextSize = (13 - 8) + 5;
			v409.Font = Enum.Font.GothamBold;
			v404 = 28 - 17;
		end
		if (v404 == (802 - (461 + 335))) then
			v408.Parent = v405;
			v408.Size = UDim2.new(1 + 0, -(1891 - (1730 + 31)), (1667 - (728 + 939)) + (0 - 0), (14 - 7) + 9);
			v408.Position = UDim2.fromOffset((354 - 199) - 110, (1081 - (138 + 930)) + 11 + 0);
			v408.BackgroundTransparency = 471 - (298 + 83 + 77 + 12);
			v404 = 28 - 21;
		end
		if (v404 == (1769 - (459 + 1307))) then
			v406.TextSize = 16;
			v407 = Instance.new(v7("\246\132\14\234\21\239\90\199\141", "\56\162\225\118\158\89\142"));
			v407.Parent = v405;
			v407.Size = UDim2.new(1, -(2000 - (474 + 1396)), (0 - 0) - 0, (29 + 1) - (1 + 9));
			v404 = 4;
		end
		if (v404 == (11 - 7)) then
			v407.Position = UDim2.fromOffset(550 - (351 + 20 + 134), (5267 - 3689) - ((5586 - 4305) + (884 - (562 + 29))));
			v407.BackgroundTransparency = (228 + 39) - (28 + (1657 - (374 + 1045)));
			v407.Text = v401;
			v407.TextColor3 = Color3.new(2 - (1 + 0), 1560 - (1381 + 178), 1);
			v404 = 5;
		end
		if (v404 == (2 - 1)) then
			v405.BorderSizePixel = (1805 - (448 + 190)) - (209 + 436 + 236 + 286);
			v36(v405, 7 + 3);
			v406 = Instance.new(v7("\1\177\147\230\246\52\182\142\254", "\186\85\212\235\146"));
			v406.Parent = v405;
			v404 = 7 - 5;
		end
		if (v404 == (0 - 0)) then
			v405 = Instance.new(v7("\219\223\21\216\75", "\215\157\173\116\181\46"));
			v405.Parent = v183;
			v405.Size = UDim2.new((1496 - (1307 + 187)) - (3 - 2), 0 + 0, (0 - 0) + (0 - 0), 20 + (708 - (232 + 451)));
			v405.BackgroundColor3 = Color3.fromRGB(22 + 0, (51 + 6) - 35, (583 - (510 + 54)) + (22 - 11));
			v404 = 37 - (13 + 23);
		end
		if (v404 == 11) then
			v36(v409, (5 - 2) + 3);
			v409.MouseButton1Click:Connect(function()
				local v634 = 0 - 0;
				local v635;
				while true do
					if (v634 == 0) then
						v635 = 0;
						while true do
							if (v635 == ((1 - 0) + (1088 - (830 + 258)))) then
								v409.Text = "✓ COPIED";
								v409.BackgroundColor3 = Color3.fromRGB(141 - 101, 126 + 74, (335 + 58) - (1734 - (860 + 581)));
								v635 = 1728 - ((6152 - 4484) + 58);
							end
							if (v635 == ((499 + 129) - ((753 - (237 + 4)) + (267 - 153)))) then
								local v828 = 0 - 0;
								while true do
									if (v828 == (1 - 0)) then
										v635 = 3;
										break;
									end
									if ((0 + 0) == v828) then
										task.wait((2.5 + 0) - (3 - 2));
										v409.Text = "📋 COPY";
										v828 = 1;
									end
								end
							end
							if (v635 == ((3 + 2) - (2 + 0))) then
								v409.BackgroundColor3 = v25;
								break;
							end
							if (v635 == (0 - (1426 - (85 + 1341)))) then
								local v830 = 0;
								local v831;
								while true do
									if ((0 - 0) == v830) then
										v831 = 0;
										while true do
											if (v831 == (0 - 0)) then
												v30:Play();
												if setclipboard then
													setclipboard(v403);
												elseif toclipboard then
													toclipboard(v403);
												end
												v831 = 373 - (45 + 327);
											end
											if (v831 == (1 - 0)) then
												v635 = (503 - (444 + 58)) + 0 + 0;
												break;
											end
										end
										break;
									end
								end
							end
						end
						break;
					end
				end
			end);
			break;
		end
		if (v404 == (1 + 1)) then
			v406.Size = UDim2.fromOffset((890 + 930) - ((2926 - 1916) + (2512 - (64 + 1668))), (2018 - (1227 + 746)) + (0 - 0));
			v406.Position = UDim2.fromOffset((86 - 39) - 37, 0 - 0);
			v406.BackgroundTransparency = 1837 - (1045 + 791);
			v406.Text = v402;
			v404 = 3;
		end
		if (v404 == (499 - (415 + 79))) then
			v407.TextSize = 1 + 11 + (491 - (142 + 349));
			v407.Font = Enum.Font.GothamBold;
			v407.TextXAlignment = Enum.TextXAlignment.Left;
			v408 = Instance.new(v7("\104\0\216\187\14\217\94\0\204", "\184\60\101\160\207\66"));
			v404 = 3 + 3;
		end
		if ((10 - 2) == v404) then
			v408.TextXAlignment = Enum.TextXAlignment.Left;
			v408.TextTruncate = Enum.TextTruncate.AtEnd;
			v409 = Instance.new(v7("\5\135\100\168\19\151\104\168\62\140", "\220\81\226\28"));
			v409.Parent = v405;
			v404 = 5 + 4;
		end
	end
end
v197(v7("\39\220\137\207\229\204", "\167\115\181\226\155\138"), "🎧", v22.TikTok);
v197(v7("\219\45\242\104\110\115\195", "\166\130\66\135\60\27\17"), "▶️", v22.YouTube);
v197(v7("\96\67\221\118\63\86\78", "\80\36\42\174\21"), "💬", v22.Discord);
v149(v105, v7("\105\28\56\120\79\28\119\89\65\29\58\111\64\25\35\99\14\51\63\123\90", "\26\46\112\87"), "Trò chuyện trực tuyến cùng những người dùng script khác");
local v198 = Instance.new(v7("\159\49\170\121\186", "\212\217\67\203\20\223\223\37"));
v198.Parent = v105;
v198.Size = UDim2.new(1 + 0, -(4 + 1 + (0 - 0)), (1864 - (1710 + 154)) - 0, 36);
v198.Position = UDim2.fromOffset((2312 - (200 + 118)) - (44 + 65 + 1885), 1531 - ((2218 - 949) + 200));
v198.BackgroundColor3 = Color3.fromRGB(22, 26 - 8, 30);
v198.BorderSizePixel = (0 + 0) - (0 + 0);
v36(v198, (442 + 381) - (16 + 82 + 717));
v37(v198, v25, (1791 - 964) - ((2052 - (363 + 887)) + (41 - 17)));
local v204 = Instance.new(v7("\142\136\176\198\150\140\170\215\182", "\178\218\237\200"));
v204.Parent = v198;
v204.Size = UDim2.fromOffset((242 - 191) - 21, 36);
v204.Position = UDim2.fromOffset((1 + 5) - 1, 0);
v204.BackgroundTransparency = 1 + (0 - 0);
v204.Text = "📌";
v204.TextSize = 10 + 4;
local v211 = Instance.new(v7("\130\176\254\196\154\180\228\213\186", "\176\214\213\134"));
v211.Parent = v198;
v211.Size = UDim2.new((1665 - (674 + 990)) + 0 + 0, -(3 + 4 + (51 - 18)), 1, 1055 - (507 + 548));
v211.Position = UDim2.fromOffset((845 - (289 + 548)) + (1845 - (821 + 997)), (255 - (195 + 60)) - 0);
v211.BackgroundTransparency = 3 - (1 + 1);
v211.Text = "Tin nhắn từ Admin: Chào mừng bạn đến với Luxury Hub!";
v211.TextColor3 = Color3.fromRGB((1587 - (251 + 1250)) + (450 - 296), 62 + 28 + (1162 - (809 + 223)), (307 - 96) + (132 - 88));
v211.TextSize = (26 - 18) + 3 + 0;
v211.Font = Enum.Font.GothamBold;
v211.TextXAlignment = Enum.TextXAlignment.Left;
v211.TextTruncate = Enum.TextTruncate.AtEnd;
local v222 = Instance.new(v7("\199\174\164\219\164\90\80\250\170\144\198\169\91\92", "\57\148\205\214\180\200\54"));
v222.Parent = v105;
v222.Size = UDim2.new(1 + 0, -(622 - (14 + 603)), (130 - (118 + 11)) + 0 + 0, -(1598 - (664 + 133 + (1853 - 1217))));
v222.Position = UDim2.fromOffset((949 - (551 + 398)) - 0, 67 + 38);
v222.BackgroundColor3 = Color3.fromRGB((582 + 1052) - (1160 + 267 + (713 - 521)), (13 - 7) + 3 + 6, 20);
v222.BorderSizePixel = 0 - (0 - 0);
v222.ScrollBarThickness = 1 + 2;
v222.ScrollBarImageColor3 = v25;
v36(v222, (98 - (40 + 49)) + (3 - 2));
v37(v222, Color3.fromRGB(40, 530 - (99 + 391), 46 + 9), 1 + (0 - 0));
local v230 = Instance.new(v7("\39\212\25\61\101\6\209\52\45\121\7\233", "\22\114\157\85\84"));
v230.Parent = v222;
v230.Padding = UDim.new((807 - 481) - (192 + 131 + 3), (3373 - 2091) - ((1920 - (1032 + 572)) + (1377 - (203 + 214))));
v230:GetPropertyChangedSignal(v7("\229\201\0\203\81\227\188\193\232\28\202\73\243\166\208\248\26\222\88", "\200\164\171\115\164\61\150")):Connect(function()
	v222.CanvasSize = UDim2.new(1817 - (568 + 1249), 0 + 0 + 0, (0 - 0) + (0 - 0), v230.AbsoluteContentSize.Y + 10 + (1306 - (913 + 393)));
end);
local v233 = Instance.new(v7("\138\241\27\81\161\177\236", "\227\222\148\99\37"));
v233.Parent = v105;
v233.Size = UDim2.new(2 - 1, -((403 - 117) - (621 - (269 + 141))), 551 - (83 + (1040 - 572)), (3827 - (362 + 1619)) - ((2827 - (950 + 675)) + 604));
v233.Position = UDim2.new((0 + 0) - 0, 1179 - (216 + 963), (1288 - (485 + 802)) - (559 - (432 + 127)), -((1211 - (1065 + 8)) - (49 + 39)));
v233.BackgroundColor3 = Color3.fromRGB((1944 - (635 + 966)) - (33 + 12 + (322 - (5 + 37))), 18 + 0, 22 + 3);
v233.BorderSizePixel = (0 - 0) + 0;
v233.PlaceholderText = "Nhập nội dung tin nhắn...";
v233.PlaceholderColor3 = Color3.fromRGB(24 + 32 + (69 - 25), 9 + 9 + (170 - 88), 115);
v233.Text = "";
v233.TextColor3 = Color3.new(1 - (0 - 0), 1912 - ((641 - 301) + (3755 - 2184)), 1 + 0);
v233.TextSize = 541 - (318 + 211);
v233.Font = Enum.Font.Gotham;
v36(v233, (19 - 15) + (1593 - (963 + 624)));
v37(v233, Color3.fromRGB(1812 - (741 + 992 + (885 - (518 + 328))), (253 - 144) - (109 - 40), 1089 - ((442 - (301 + 16)) + 909)), 2 - 1);
local v245 = Instance.new(v7("\6\123\98\247\253\55\91\92\241", "\153\83\50\50\150"));
v245.PaddingLeft = UDim.new((5470 - 3522) - (1096 + 852), 12);
v245.Parent = v233;
local v248 = Instance.new(v7("\105\115\107\8\81\190\89\73\121\125", "\45\61\22\19\124\19\203"));
v248.Parent = v105;
v248.Size = UDim2.fromOffset(32 + 38, 104 - 64);
v248.Position = UDim2.new((1 + 0) - (0 + 0), -((144 - 76) + 2 + 0), (49 + 464) - ((1300 - 891) + 34 + 69), -(1069 - (829 + 190)));
v248.BackgroundColor3 = v25;
v248.BorderSizePixel = 0;
v248.Text = "GỬI";
v248.TextColor3 = Color3.new(1, 1, (845 - 608) - ((58 - 12) + (262 - 72)));
v248.TextSize = 107 - ((126 - 75) + 44);
v248.Font = Enum.Font.GothamBold;
v36(v248, 3 + 7);
local v258 = {};
local function v259(v411, v412, v413, v414)
	local v415 = 1317 - (265 + 849 + 203);
	local v416;
	local v417;
	local v418;
	local v419;
	local v420;
	local v421;
	local v422;
	while true do
		if (v415 == ((239 + 491) - (228 + 498))) then
			local v599 = 0 - 0;
			local v600;
			while true do
				if (0 == v599) then
					v600 = 0 + 0;
					while true do
						if (v600 == 0) then
							v421.TextXAlignment = Enum.TextXAlignment.Left;
							v422 = Instance.new(v7("\245\23\21\225\46\113\187\196\30", "\217\161\114\109\149\98\16"));
							v600 = 1;
						end
						if (v600 == (614 - (520 + 93))) then
							v422.Parent = v417;
							v422.Size = UDim2.new(277 - (259 + 17), v420, 0 + 0 + 0 + 0, 20);
							v600 = 2;
						end
						if (v600 == 2) then
							v422.Position = UDim2.fromOffset(v419, 20);
							v415 = (10 - 7) + (593 - (396 + 195));
							break;
						end
					end
					break;
				end
			end
		end
		if (v415 == ((1929 - 1264) - (174 + (2250 - (440 + 1321))))) then
			local v601 = 1829 - (1059 + 770);
			local v602;
			while true do
				if (v601 == (0 - 0)) then
					v602 = 545 - (424 + 121);
					while true do
						if (2 == v602) then
							v421.Position = UDim2.fromOffset(v419, 1 + 3);
							v415 = (2512 - (641 + 706)) - (171 + 991);
							break;
						end
						if (v602 == (1 + 0)) then
							v421.Parent = v417;
							v421.Size = UDim2.new(525 - ((743 - (249 + 191)) + 221), v420, 1269 - ((1006 - 775) + 464 + 574), 14 + (7 - 5));
							v602 = 2;
						end
						if ((427 - (183 + 244)) == v602) then
							v420 = (v418 and -(52 - (2 + 30))) or -((2720 - (434 + 296)) - (830 + 1075));
							v421 = Instance.new(v7("\38\37\32\104\144\117\16\37\52", "\20\114\64\88\28\220"));
							v602 = 2 - 1;
						end
					end
					break;
				end
			end
		end
		if (v415 == 3) then
			local v603 = 512 - (169 + 343);
			while true do
				if (v603 == (1 + 0)) then
					v421.TextColor3 = (v414 and Color3.fromRGB(684 - (754 - 325), 293 - 193, (204 + 45) - (422 - 273))) or v25;
					v421.TextSize = (1132 - (651 + 472)) + 2 + 0;
					v603 = 2;
				end
				if (v603 == 2) then
					v421.Font = Enum.Font.GothamBold;
					v415 = (6 + 7) - (10 - 1);
					break;
				end
				if (v603 == 0) then
					v421.BackgroundTransparency = 4 - (486 - (397 + 86));
					v421.Text = v411 .. ((v414 and " 👑 [ADMIN]") or "");
					v603 = 877 - (423 + 453);
				end
			end
		end
		if (v415 == (0 + 0)) then
			local v604 = 0;
			while true do
				if (1 == v604) then
					v258[v416] = os.clock();
					v417 = Instance.new(v7("\23\19\211\185\253", "\221\81\97\178\212\152\176"));
					v604 = 1 + 1;
				end
				if ((2 + 0) == v604) then
					v417.Parent = v222;
					v415 = 1 - (0 + 0);
					break;
				end
				if (v604 == (0 + 0)) then
					v416 = v411 .. ":" .. v413;
					if (v258[v416] and ((os.clock() - v258[v416]) < ((1192 - (50 + 1140)) - 1))) then
						return;
					end
					v604 = 1 + 0;
				end
			end
		end
		if (v415 == (15 - (6 + 4))) then
			v422.BackgroundTransparency = (78 + 1171) - ((159 - 48) + 823 + 314);
			v422.Text = v413;
			v422.TextColor3 = Color3.fromRGB((974 - (157 + 439)) - ((157 - 66) + (222 - 155)), (1934 - 1280) - 434, 230);
			v422.TextSize = (921 - (782 + 136)) + (864 - (112 + 743));
			v422.Font = Enum.Font.Gotham;
			v415 = (1700 - (1026 + 145)) - (73 + 350 + (818 - (493 + 225)));
		end
		if (v415 == ((3 - 2) + 5)) then
			v422.TextXAlignment = Enum.TextXAlignment.Left;
			v422.TextWrapped = true;
			if (v21 and not v418) then
				local v647 = 0;
				local v648;
				local v649;
				while true do
					if (v647 == (0 + 0)) then
						v648 = 0 - (0 - 0);
						v649 = nil;
						v647 = 1 + 0;
					end
					if (v647 == (2 - 1)) then
						while true do
							if (v648 == (1 + 0)) then
								v649.Size = UDim2.fromOffset(46 - 18, 28);
								v649.Position = UDim2.new(1596 - (210 + 1385), -(1719 - (1201 + 488)), 0.5 + 0 + 0, -(24 - 10));
								v648 = (1386 - 613) - ((911 - (352 + 233)) + (1075 - 630));
							end
							if ((3 + 1) == v648) then
								v36(v649, 17 - 11);
								v649.MouseButton1Click:Connect(function()
									local v877 = 574 - (489 + 85);
									local v878;
									while true do
										if (v877 == (1501 - (277 + 1224))) then
											v878 = (1493 - (663 + 830)) - (0 + 0);
											while true do
												if (v878 == (0 - 0)) then
													v30:Play();
													v211.Text = "Tin nhắn ghim từ Admin (" .. v411 .. v7("\132\189\93", "\122\173\135\125\155") .. v413;
													break;
												end
											end
											break;
										end
									end
								end);
								break;
							end
							if (v648 == (877 - (461 + 414))) then
								v649.BackgroundColor3 = Color3.fromRGB((11 + 51) - 34, 65 - (15 + 22), 749 - (530 + 18 + 163));
								v649.BorderSizePixel = (869 + 12) - (614 + (517 - (172 + 78)));
								v648 = (55 - 20) - (7 + 12 + (18 - 5));
							end
							if (v648 == (4 - (1 + 0))) then
								v649.Text = "📌";
								v649.TextSize = 27 - (6 + 9);
								v648 = 6 - 2;
							end
							if (v648 == (0 - 0)) then
								local v848 = 0 - 0;
								local v849;
								while true do
									if (v848 == (0 + 0)) then
										v849 = 0 + 0;
										while true do
											if (v849 == 0) then
												v649 = Instance.new(v7("\176\196\24\173\29\36\220\144\206\14", "\168\228\161\96\217\95\81"));
												v649.Parent = v417;
												v849 = 1;
											end
											if (v849 == (1 + 0)) then
												v648 = 1 + 0;
												break;
											end
										end
										break;
									end
								end
							end
						end
						break;
					end
				end
			end
			task.defer(function()
				v222.CanvasPosition = Vector2.new(0 - 0, (409737 - 233872) - (23264 + 52602));
			end);
			break;
		end
		if (v415 == ((1 + 0) - (447 - (133 + 314)))) then
			local v614 = 0 + 0;
			while true do
				if (v614 == (213 - (199 + 14))) then
					v417.Size = UDim2.new(3 - 2, -((3371 - (647 + 902)) - (1293 + 519)), (0 - 0) - (233 - (85 + 148)), (1406 - (426 + 863)) - 72);
					v417.BackgroundTransparency = 1 - (0 - 0);
					v614 = 1;
				end
				if (v614 == (1655 - (873 + 781))) then
					v418 = v411 == v7("\232\200\61\72\42\90\155\243\33\72", "\55\187\177\78\60\79");
					if not v418 then
						local v735 = 0;
						local v736;
						local v737;
						local v738;
						while true do
							if (v735 == (1 - 0)) then
								v738 = nil;
								while true do
									if (v736 == (0 - 0)) then
										local v914 = 0 + 0;
										local v915;
										while true do
											if (0 == v914) then
												v915 = 0 - 0;
												while true do
													if (v915 == (0 - 0)) then
														v737 = 0 - 0;
														v738 = nil;
														v915 = 1;
													end
													if (v915 == (2 - 1)) then
														v736 = 1948 - (414 + 1533);
														break;
													end
												end
												break;
											end
										end
									end
									if (v736 == (1 + 0)) then
										while true do
											if (v737 == 2) then
												local v960 = 555 - (443 + 112);
												while true do
													if (v960 == 0) then
														v738.BackgroundTransparency = (1481 - (888 + 591)) - (2 - 1);
														v738.Image = ((v412 ~= "") and v412) or v29;
														v960 = 1;
													end
													if (v960 == (1 + 0)) then
														v737 = (7 - 5) + 1;
														break;
													end
												end
											end
											if (v737 == (0 + 0 + 0 + 0)) then
												v738 = Instance.new(v7("\4\195\94\236\67\227\129\47\203\83", "\224\77\174\63\139\38\175"));
												v738.Parent = v417;
												v737 = 1 + 0;
											end
											if (v737 == ((11 - 5) - (5 - 2))) then
												v36(v738, (1682 - (136 + 1542)) + (39 - 27));
												break;
											end
											if (v737 == (1 + 0 + (0 - 0))) then
												local v962 = 0;
												while true do
													if (v962 == (0 + 0)) then
														v738.Size = UDim2.fromOffset((506 - (68 + 418)) + (32 - 20), (2046 - 918) - (709 + 335 + 52));
														v738.Position = UDim2.fromOffset(1863 - (673 + (2277 - (770 + 322))), (1 + 16) - (4 + 7));
														v962 = 1 + 0;
													end
													if (v962 == (1 - 0)) then
														v737 = (11 - 5) - (10 - 6);
														break;
													end
												end
											end
										end
										break;
									end
								end
								break;
							end
							if (v735 == (0 - 0)) then
								v736 = 0;
								v737 = nil;
								v735 = 1;
							end
						end
					end
					v614 = 2 + 0;
				end
				if (v614 == 2) then
					v419 = (v418 and 10) or ((110 - 36) - (14 + 15));
					v415 = 2 + 0;
					break;
				end
			end
		end
	end
end
v259(v7("\183\88\75\58\129\76\24\12\139\85", "\78\228\33\56"), "", "Hệ thống Universal Chat đã sẵn sàng! Chúc bạn chơi game vui vẻ.", false);
local v260 = false;
pcall(function()
	if (v16.ChatVersion == Enum.ChatVersion.TextChatService) then
		v16.MessageReceived:Connect(function(v615)
			if v615.TextSource then
				local v650 = 0 + 0;
				local v651;
				local v652;
				while true do
					if (v650 == 1) then
						while true do
							if (v651 == 0) then
								v652 = v8:GetPlayerByUserId(v615.TextSource.UserId);
								if v652 then
									local v896 = 0 + (0 - 0);
									local v897;
									local v898;
									while true do
										if (v896 == (0 - (0 - 0))) then
											v260 = true;
											v897 = "";
											v896 = 1 + 0 + (0 - 0);
										end
										if ((3 - 2) == v896) then
											pcall(function()
												v897 = v8:GetUserThumbnailAsync(v652.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
											end);
											v898 = v652.Name:lower() == v20:lower();
											v896 = 2;
										end
										if (v896 == ((2 + 1) - (4 - 3))) then
											v259(v652.DisplayName, v897, v615.Text, v898);
											break;
										end
									end
								end
								break;
							end
						end
						break;
					end
					if (v650 == 0) then
						v651 = 0 + (831 - (762 + 69));
						v652 = nil;
						v650 = 3 - 2;
					end
				end
			end
		end);
	end
end);
local function v261(v423)
	v423.Chatted:Connect(function(v508)
		if not v260 then
			local v616 = 0;
			local v617;
			local v618;
			local v619;
			while true do
				if ((0 + 0) == v616) then
					local v687 = 0 + 0;
					while true do
						if (v687 == (0 - 0)) then
							v617 = (0 + 0) - (0 + 0);
							v618 = nil;
							v687 = 1;
						end
						if (v687 == (3 - 2)) then
							v616 = 158 - (8 + 149);
							break;
						end
					end
				end
				if (v616 == (1321 - (1199 + 121))) then
					v619 = nil;
					while true do
						if (v617 == (1880 - ((754 - 308) + (3237 - 1803)))) then
							local v785 = 0 + 0;
							local v786;
							while true do
								if (v785 == (0 - 0)) then
									v786 = 0;
									while true do
										if (v786 == 0) then
											v618 = "";
											pcall(function()
												v618 = v8:GetUserThumbnailAsync(v423.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
											end);
											v786 = 2 - 1;
										end
										if (v786 == (1 + 0)) then
											v617 = 1808 - (518 + 1289);
											break;
										end
									end
									break;
								end
							end
						end
						if (v617 == ((2201 - 917) - (139 + 901 + (354 - 111)))) then
							v619 = v423.Name:lower() == v20:lower();
							v259(v423.DisplayName, v618, v508, v619);
							break;
						end
					end
					break;
				end
			end
		end
	end);
end
for v424, v425 in ipairs(v8:GetPlayers()) do
	v261(v425);
end
v8.PlayerAdded:Connect(v261);
v248.MouseButton1Click:Connect(function()
	local v426 = (0 + 0) - (469 - (304 + 165));
	local v427;
	while true do
		if (((1744 + 103) - ((719 - (54 + 106)) + (3257 - (1618 + 351)))) == v426) then
			v427 = v233.Text;
			if ((v427 ~= "") and (#v427 <= (2081 - (430 + 179 + (2338 - (10 + 1006)))))) then
				local v653 = 0;
				local v654;
				while true do
					if ((0 + 0) == v653) then
						v654 = (64 + 390) - ((41 - 28) + (1474 - (912 + 121)));
						while true do
							if (v654 == (3 - (1 + 1))) then
								pcall(function()
									if (v16.ChatVersion == Enum.ChatVersion.TextChatService) then
										local v916 = (1289 - (1140 + 149)) - (0 + 0);
										local v917;
										while true do
											if (v916 == (0 - (0 - 0))) then
												v917 = v16.TextChannels:FindFirstChild(v7("\252\92\138\36\128\192\123\160\2\137", "\229\174\30\210\99"));
												if v917 then
													v917:SendAsync(v427);
												end
												break;
											end
										end
									else
										local v918 = 0 + 0;
										local v919;
										local v920;
										while true do
											if (v918 == 1) then
												while true do
													if (((0 - 0) - (0 - 0)) == v919) then
														v920 = v17:FindFirstChild(v7("\63\232\128\80\248\49\45\56\229\135\69\222\36\42\15\232\139\114\229\60\45\62\251\131\95\249\46", "\89\123\141\230\49\141\93"));
														if (v920 and v920:FindFirstChild(v7("\192\112\239\33\21\89\224\112\241\9\34\79\226\100\243\31\4", "\42\147\17\150\108\112"))) then
															v920.SayMessageRequest:FireServer(v427, v7("\46\170\33", "\136\111\198\77\31\135"));
														end
														break;
													end
												end
												break;
											end
											if ((0 + 0) == v918) then
												v919 = (0 - 0) + (186 - (165 + 21));
												v920 = nil;
												v918 = 112 - (61 + 50);
											end
										end
									end
								end);
								break;
							end
							if (v654 == (0 + 0 + 0)) then
								local v850 = 0 - 0;
								while true do
									if (v850 == 1) then
										v654 = 1 + (0 - 0);
										break;
									end
									if (v850 == (0 + 0)) then
										v233.Text = "";
										v30:Play();
										v850 = 1461 - (1295 + 165);
									end
								end
							end
						end
						break;
					end
				end
			end
			break;
		end
	end
end);
v149(v103, v7("\35\10\179\95\171\225\87\153\14\8\190\83\175\247", "\201\98\105\199\54\221\132\119"), "Danh sách người chơi đang ở cùng server");
local v262 = Instance.new(v7("\138\15\145\46\14\57\165\183\11\165\51\3\56\169", "\204\217\108\227\65\98\85"));
v262.Parent = v103;
v262.Size = UDim2.new((1 + 1) - (1 + 0), -((1400 - (819 + 578)) + (1404 - (331 + 1071))), 744 - (588 + 155), -((1419 - (546 + 736)) - (1999 - (1834 + 103))));
v262.Position = UDim2.fromOffset(0 + 0, 193 - 128);
v262.BackgroundTransparency = 1767 - (1536 + 230);
v262.BorderSizePixel = (491 - (128 + 363)) + 0 + 0;
v262.ScrollBarThickness = 7 - 4;
v262.ScrollBarImageColor3 = v25;
local v270 = Instance.new(v7("\107\234\217\236\63\212\114\194\236\234\57\212", "\160\62\163\149\133\76"));
v270.Parent = v262;
v270.Padding = UDim.new(0 + 0 + 0, (9 - 3) + (5 - 3));
v270:GetPropertyChangedSignal(v7("\247\162\30\32\207\195\180\8\12\204\216\180\8\33\215\229\169\23\42", "\163\182\192\109\79")):Connect(function()
	v262.CanvasSize = UDim2.new(0 + (0 - 0), 0 + 0, (1009 - (615 + 394)) + 0 + 0, v270.AbsoluteContentSize.Y + 10 + 0);
end);
local function v273(v429)
	local v430 = 0 - 0;
	local v431;
	local v432;
	local v433;
	while true do
		if (v430 == (0 - 0)) then
			local v621 = 0;
			while true do
				if (v621 == (651 - (59 + 592))) then
					v431 = 433 - ((338 - 185) + 280);
					v432 = nil;
					v621 = 1;
				end
				if (v621 == (1 - 0)) then
					v430 = 1;
					break;
				end
			end
		end
		if (v430 == (1 + 0)) then
			v433 = nil;
			while true do
				if (v431 == ((173 - (70 + 101)) - 1)) then
					if (v432 and v433 and v433:FindFirstChild(v7("\28\51\13\193\251\59\47\4\242\250\59\50\48\193\231\32", "\149\84\70\96\160"))) then
						v432:PivotTo(v433.HumanoidRootPart.CFrame * CFrame.new((0 - 0) + 0 + 0, 0, v23.TeleportOffset));
					end
					break;
				end
				if (v431 == (0 + (0 - 0))) then
					local v688 = 0;
					while true do
						if (v688 == (242 - (123 + 118))) then
							v431 = 1 + 0 + 0 + 0;
							break;
						end
						if ((1399 - (653 + 746)) == v688) then
							if (v429 == v18) then
								return;
							end
							v432, v433 = v18.Character, v429.Character;
							v688 = 1;
						end
					end
				end
			end
			break;
		end
	end
end
local function v274()
	for v509, v510 in ipairs(v262:GetChildren()) do
		if v510:IsA(v7("\30\20\12\224\61", "\141\88\102\109")) then
			v510:Destroy();
		end
	end
	for v511, v512 in ipairs(v8:GetPlayers()) do
		if (v512 ~= v18) then
			local v622 = 0 - 0;
			local v623;
			local v624;
			local v625;
			local v626;
			while true do
				if (v622 == (2 + 0)) then
					local v689 = 0 - 0;
					while true do
						if (v689 == (2 - 1)) then
							v624.BackgroundTransparency = 1 + 0 + 0;
							v624.Text = v512.DisplayName;
							v689 = 2;
						end
						if (v689 == (0 + 0)) then
							v624.Size = UDim2.new(1, -(97 + 13), 0 + 0 + 0, (5 + 27) - (24 - 14));
							v624.Position = UDim2.fromOffset(9 + 5, 677 - (85 + 4 + 578));
							v689 = 1 - 0;
						end
						if (v689 == (1236 - (885 + 349))) then
							v622 = (4 + 1) - (4 - 2);
							break;
						end
					end
				end
				if (v622 == ((3060 - 2008) - ((1540 - (915 + 53)) + (1278 - (768 + 33))))) then
					local v690 = 0 - 0;
					local v691;
					while true do
						if (v690 == 0) then
							v691 = 0 - 0;
							while true do
								if ((329 - (287 + 41)) == v691) then
									v624.Font = Enum.Font.GothamBold;
									v624.TextXAlignment = Enum.TextXAlignment.Left;
									v691 = 2;
								end
								if (v691 == (849 - (638 + 209))) then
									v622 = 3 + 1;
									break;
								end
								if (v691 == 0) then
									v624.TextColor3 = Color3.new(1, (1687 - (96 + 1590)) + (1672 - (741 + 931)), 1 + 0 + (0 - 0));
									v624.TextSize = (9 - 7) + 5 + 6;
									v691 = 1 + 0;
								end
							end
							break;
						end
					end
				end
				if (v622 == ((30 + 64) - ((318 - 234) + 2))) then
					v626.Text = v7("\135\118\230\85\42\18\103\245", "\161\211\51\170\16\122\93\53");
					v626.TextColor3 = Color3.new((1 + 0) - 0, 1 + 0 + 0, (3438 - 2595) - (497 + 345));
					v626.TextSize = 1 + 9 + 1;
					v626.Font = Enum.Font.GothamBold;
					v622 = (496 - (64 + 430)) + 7 + 0;
				end
				if (v622 == 1) then
					v623.BorderSizePixel = (1696 - (106 + 257)) - (429 + 176 + (1449 - (496 + 225)));
					v36(v623, (17 - 8) + 3);
					v624 = Instance.new(v7("\207\171\170\60\215\175\176\45\247", "\72\155\206\210"));
					v624.Parent = v623;
					v622 = (14 - 11) - (1659 - (256 + 1402));
				end
				if (v622 == (1903 - (30 + 1869))) then
					local v699 = 1369 - (213 + 1156);
					local v700;
					while true do
						if (v699 == (188 - (96 + 92))) then
							v700 = 0 + 0;
							while true do
								if (v700 == 0) then
									v625 = Instance.new(v7("\114\127\76\26\31\71\120\81\2", "\83\38\26\52\110"));
									v625.Parent = v623;
									v700 = 900 - (142 + 757);
								end
								if (v700 == (2 + 0)) then
									v622 = 3 + 2;
									break;
								end
								if (v700 == (80 - (32 + 47))) then
									v625.Size = UDim2.new(1978 - (1053 + 924), -(6 + 0 + 104), (0 - 0) - (1648 - (685 + 963)), 18);
									v625.Position = UDim2.fromOffset((26 - 13) + 1, 88 - (86 - 30));
									v700 = 1711 - (541 + 1168);
								end
							end
							break;
						end
					end
				end
				if (v622 == (6 + 1)) then
					local v701 = 0;
					while true do
						if (v701 == 1) then
							v626.BackgroundColor3 = v25;
							v626.BorderSizePixel = 0 + (1597 - (645 + 952));
							v701 = 840 - (669 + 169);
						end
						if (v701 == (6 - 4)) then
							v622 = (60 - 32) - 20;
							break;
						end
						if (v701 == (0 + 0)) then
							v626.Size = UDim2.fromOffset((125 + 439) - (457 + (797 - (181 + 584))), 34);
							v626.Position = UDim2.new((1396 - (665 + 730)) + (0 - 0), -(1487 - ((1696 - 864) + (1920 - (540 + 810)))), 0.5 + 0, -(67 - 50));
							v701 = 1;
						end
					end
				end
				if (v622 == (24 - 15)) then
					v36(v626, 7 + 1);
					v626.MouseButton1Click:Connect(function()
						v273(v512);
					end);
					break;
				end
				if ((3 + 3) == v622) then
					local v702 = 0;
					while true do
						if (v702 == 1) then
							v626 = Instance.new(v7("\108\18\63\82\122\2\51\82\87\25", "\38\56\119\71"));
							v626.Parent = v623;
							v702 = 205 - (166 + 37);
						end
						if (v702 == (1881 - (22 + 1859))) then
							v625.Font = Enum.Font.Gotham;
							v625.TextXAlignment = Enum.TextXAlignment.Left;
							v702 = 1773 - (843 + 929);
						end
						if (v702 == 2) then
							v622 = (1065 - (30 + 232)) - ((1679 - 1091) + (985 - (55 + 722)));
							break;
						end
					end
				end
				if (v622 == ((0 - 0) - 0)) then
					local v703 = 0;
					while true do
						if (v703 == (1677 - (78 + 1597))) then
							v622 = (416 + 1474) - (1428 + 141 + 320);
							break;
						end
						if (v703 == (1 + 0)) then
							v623.Size = UDim2.new(550 - (305 + 244), -(1805 - (821 + 63 + 916)), (105 - (95 + 10)) - (0 + 0), 190 - 130);
							v623.BackgroundColor3 = Color3.fromRGB(24 - 6, (773 - (592 + 170)) + 7, (2364 - 1686) - ((582 - 350) + 197 + 224));
							v703 = 1 + 1;
						end
						if (v703 == 0) then
							v623 = Instance.new(v7("\213\253\89\219\32", "\54\147\143\56\182\69"));
							v623.Parent = v262;
							v703 = 2 - 1;
						end
					end
				end
				if (v622 == (2 + 1 + 2)) then
					local v704 = 0;
					while true do
						if (v704 == (1 - 0)) then
							v625.TextColor3 = Color3.fromRGB((945 - (353 + 154)) - (409 - 101), 177 - 47, 101 + 44);
							v625.TextSize = 616 - (316 + 227 + 62);
							v704 = 2;
						end
						if ((0 + 0) == v704) then
							v625.BackgroundTransparency = (1 - 0) + (0 - 0);
							v625.Text = "@" .. v512.Name;
							v704 = 2 - 1;
						end
						if (v704 == 2) then
							v622 = 15 - (95 - (7 + 79));
							break;
						end
					end
				end
			end
		end
	end
end
v274();
v8.PlayerAdded:Connect(function()
	local v434 = 0 + 0;
	while true do
		if (v434 == (181 - (24 + 157))) then
			task.wait(0.2);
			v274();
			break;
		end
	end
end);
v8.PlayerRemoving:Connect(function()
	local v435 = (0 - 0) + 0;
	local v436;
	while true do
		if (v435 == (0 - 0)) then
			v436 = (413 + 1040) - ((1793 - 1127) + (1167 - (262 + 118)));
			while true do
				if (v436 == ((1508 - (1038 + 45)) - (360 + (140 - 75)))) then
					task.wait((230.1 - (19 + 211)) + 0);
					v274();
					break;
				end
			end
			break;
		end
	end
end);
v149(v104, v7("\229\132\237\95\218\196\193\215\70\207\150\169\234\75", "\191\182\225\159\41"), "Tìm kiếm và kết nối nhanh vào các server ít người");
local v275 = Instance.new(v7("\31\23\48\65\169\146\214\63\29\38", "\162\75\114\72\53\235\231"));
v275.Parent = v104;
v275.Size = UDim2.new((368 - (88 + 25)) - (79 + (445 - 270)), -((4 + 3) - 2), 0 + 0, (1071 - (1007 + 29)) + 3 + 6);
v275.Position = UDim2.fromOffset((0 - 0) - 0, 65);
v275.BackgroundColor3 = v25;
v275.BorderSizePixel = 0 - (0 - 0);
v275.Text = "🔄  TÌM LẠI SERVER";
v275.TextColor3 = Color3.new(1 + 0, (1711 - (340 + 471)) - (503 + (997 - 601)), 182 - ((681 - (276 + 313)) + (216 - 127)));
v275.TextSize = 12 + 0;
v275.Font = Enum.Font.GothamBold;
v36(v275, (9 + 10) - (1 + 8));
local v285 = Instance.new(v7("\184\57\92\246\127\3\142\57\72", "\98\236\92\36\130\51"));
v285.Parent = v104;
v285.Size = UDim2.new(1 + 0, -(1977 - (495 + 1477)), (0 - 0) + 0 + 0, (488 - (342 + 61)) - (28 + 35));
v285.Position = UDim2.fromOffset((165 - (4 + 161)) + 0 + 0, (812 - 553) - (381 - 236));
v285.BackgroundTransparency = 498 - (322 + 175);
v285.Text = "Trạng thái: Sẵn sàng quét server";
v285.TextColor3 = Color3.fromRGB(140, 123 + 17, (638 - (173 + 390)) + 20 + 60);
v285.TextSize = 33 - (336 - (203 + 111));
v285.Font = Enum.Font.Gotham;
v285.TextXAlignment = Enum.TextXAlignment.Left;
local v295 = Instance.new(v7("\151\26\30\181\73\164\188\62\163\63\30\187\72\173", "\80\196\121\108\218\37\200\213"));
v295.Parent = v104;
v295.Size = UDim2.new(1 + 0, -(1 + 0 + (11 - 7)), (1 + 0) - 0, -(1389 - ((1191 - (57 + 649)) + (1143 - (328 + 56)))));
v295.Position = UDim2.fromOffset((0 + 0) - 0, (1841 - (433 + 79)) - (442 + 69 + 678));
v295.BackgroundTransparency = 1 + 0;
v295.BorderSizePixel = 1135 - ((2797 - 1965) + 303);
v295.ScrollBarThickness = (4487 - 3538) - (88 + 626 + 232);
v295.ScrollBarImageColor3 = v25;
local v303 = Instance.new(v7("\53\90\46\118\88\26\166\1\106\13\106\95", "\234\96\19\98\31\43\110"));
v303.Parent = v295;
v303.Padding = UDim.new(0 + 0 + (1036 - (562 + 474)), (16 - 9) + (1 - 0));
v303:GetPropertyChangedSignal(v7("\39\29\65\200\160\103\159\3\60\93\201\184\119\133\18\44\91\221\169", "\235\102\127\50\167\204\18")):Connect(function()
	v295.CanvasSize = UDim2.new((905 - (76 + 829)) + (1673 - (1506 + 167)), (1481 - 692) - (766 + (289 - (58 + 208))), 0 + 0, v303.AbsoluteContentSize.Y + (49 - 39));
end);
local function v306()
	for v513, v514 in ipairs(v295:GetChildren()) do
		if v514:IsA(v7("\118\179\244\46\65", "\78\48\193\149\67\36")) then
			v514:Destroy();
		end
	end
end
local function v307(v438)
	local v439 = 0 + 0;
	local v440;
	local v441;
	local v442;
	local v443;
	local v444;
	local v445;
	while true do
		if (v439 == 2) then
			v444 = nil;
			v445 = nil;
			v439 = 2 + 1;
		end
		if (v439 == 3) then
			while true do
				local v637 = 0;
				while true do
					if (v637 == (0 - 0)) then
						if (v440 == (339 - (258 + 79))) then
							local v810 = 0 + 0;
							local v811;
							while true do
								if (0 == v810) then
									v811 = 0;
									while true do
										if (v811 == (0 - 0)) then
											v444, v445 = pcall(function()
												return v12:JSONDecode(v443);
											end);
											return (v444 and v445) or nil;
										end
									end
									break;
								end
							end
						end
						if (v440 == (1470 - (1219 + 251))) then
							local v812 = 1671 - (1231 + 440);
							local v813;
							while true do
								if (v812 == (58 - (34 + 24))) then
									v813 = 0;
									while true do
										if (v813 == 0) then
											v441 = v7("\56\10\148\8\82\106\81\207\31\64\61\27\147\86\83\63\28\140\23\89\126\29\143\21\14\38\79\207\31\64\61\27\147\87", "\33\80\126\224\120") .. game.PlaceId .. v7("\163\187\6\214\74\233\186\16\139\108\249\170\15\205\95\179\187\12\214\72\195\186\7\193\78\177\137\16\199\26\224\161\14\205\72\177\249\83\148", "\60\140\200\99\164");
											if v438 then
												v441 = v441 .. v7("\193\247\17\52\177\136\230\89", "\194\231\148\100\70") .. v12:UrlEncode(v438);
											end
											v813 = 1 + 0;
										end
										if (v813 == (1 - 0)) then
											v440 = (1 + 1) - (2 - 1);
											break;
										end
									end
									break;
								end
							end
						end
						v637 = 3 - 2;
					end
					if (v637 == (2 - 1)) then
						if (v440 == (3 - 2)) then
							v442, v443 = pcall(function()
								return game:HttpGet(v441);
							end);
							if (not v442 or not v443) then
								return nil;
							end
							v440 = 6 - (8 - 4);
						end
						break;
					end
				end
			end
			break;
		end
		if (v439 == (1590 - (877 + 712))) then
			local v627 = 0;
			while true do
				if (v627 == 0) then
					v442 = nil;
					v443 = nil;
					v627 = 1;
				end
				if (v627 == (1 + 0)) then
					v439 = 756 - (242 + 512);
					break;
				end
			end
		end
		if (v439 == (0 - 0)) then
			v440 = 0 - (627 - (92 + 535));
			v441 = nil;
			v439 = 1 + 0;
		end
	end
end
local function v308()
	local v446 = 0;
	local v447;
	local v448;
	local v449;
	local v450;
	while true do
		if (v446 == 0) then
			local v628 = 0 - 0;
			while true do
				if (v628 == 1) then
					v446 = 1;
					break;
				end
				if (v628 == (0 + 0)) then
					v447 = 0 - 0;
					v448 = nil;
					v628 = 1;
				end
			end
		end
		if (v446 == 2) then
			while true do
				local v638 = 0 + 0;
				while true do
					if (v638 == 0) then
						if (((744 + 330) - (1036 + 6 + 31)) == v447) then
							local v814 = 0 - 0;
							while true do
								if (v814 == (1 - 0)) then
									v447 = 1686 - ((3251 - (1476 + 309)) + 218);
									break;
								end
								if (v814 == (1284 - (299 + 985))) then
									v450 = 0 + 0 + (0 - 0);
									while v450 < (108 - (86 + 7)) do
										v450 += ((4 - 3) - 0)
										local v899 = v307(v449);
										if (not v899 or not v899.data) then
											break;
										end
										for v922, v923 in ipairs(v899.data) do
											local v924 = 0 + 0;
											local v925;
											local v926;
											while true do
												if (v924 == (880 - (672 + 208))) then
													v925 = 0;
													v926 = nil;
													v924 = 1 + 0;
												end
												if (v924 == 1) then
													while true do
														if (v925 == (0 + 0)) then
															v926 = tonumber(v923.playing) or ((2611 - (14 + 118)) - ((1086 - (339 + 106)) + 668 + 171));
															if ((v923.id ~= game.JobId) and (v926 <= v23.MaxServerPlayers) and (v926 > (913 - (458 + 452 + (1398 - (440 + 955)))))) then
																table.insert(v448, v923);
															end
															break;
														end
													end
													break;
												end
											end
										end
										v449 = v899.nextPageCursor;
										if not v449 then
											break;
										end
										task.wait((0.05 + 0) - (0 - 0));
									end
									v814 = 1 + 0;
								end
							end
						end
						if (v447 == ((0 - 0) + 0 + 0)) then
							v448 = {};
							v449 = nil;
							v447 = 1149 - ((909 - (260 + 93)) + 555 + 37);
						end
						v638 = 2 - 1;
					end
					if (v638 == (1 - 0)) then
						if (((1975 - (1181 + 793)) + 1 + 0) == v447) then
							local v815 = 0;
							while true do
								if (v815 == (307 - (105 + 202))) then
									table.sort(v448, function(v901, v902)
										return (tonumber(v901.playing) or ((1449 + 358) - ((1139 - (352 + 458)) + 479))) < (tonumber(v902.playing) or (4027 - 3028));
									end);
									return v448;
								end
							end
						end
						break;
					end
				end
			end
			break;
		end
		if (v446 == (2 - 1)) then
			local v629 = 0;
			while true do
				if (v629 == (1 + 0)) then
					v446 = 5 - 3;
					break;
				end
				if (v629 == (949 - (438 + 511))) then
					v449 = nil;
					v450 = nil;
					v629 = 1384 - (1262 + 121);
				end
			end
		end
	end
end
local function v309(v451, v452)
	local v453 = tonumber(v451.playing) or (854 - (174 + (1748 - (728 + 340))));
	local v454 = tonumber(v451.maxPlayers) or 0;
	local v455 = Instance.new(v7("\96\94\192\174\243", "\168\38\44\161\195\150"));
	v455.Parent = v295;
	v455.Size = UDim2.new(1791 - (816 + 974), -((51 - 34) - 12), 0 - (0 - 0), 399 - (163 + 176));
	v455.BackgroundColor3 = Color3.fromRGB(50 - 32, 18, 114 - 89);
	v455.BorderSizePixel = 0;
	v36(v455, 3 + 6 + (1813 - (1564 + 246)));
	local v460 = Instance.new(v7("\180\249\154\98\28\233\180\19\140", "\118\224\156\226\22\80\136\214"));
	v460.Parent = v455;
	v460.Size = UDim2.new((1085 - (124 + 221)) - (271 + 125 + (794 - (115 + 336))), -(8 + (158 - 86)), 1 + 0, 0);
	v460.Position = UDim2.fromOffset((1537 - (45 + 1)) - (2 + 27 + 1448), (3379 - (1282 + 708)) - (135 + (2466 - (583 + 629))));
	v460.BackgroundTransparency = (1 + 2) - (5 - 3);
	v460.Text = v7("\113\203\107\182\103\220\25\195", "\224\34\142\57") .. v452 .. v7("\158\239", "\110\190\199\165\189\19\145\61") .. v453 .. " NGƯỜI)\n👥 Tình trạng: " .. v453 .. v7("\154\164\55", "\167\186\139\23\136\235") .. v454;
	v460.TextColor3 = Color3.new((3 + 1) - (1173 - (943 + 227)), 1 + 0 + 0, (3159 - (1539 + 92)) - ((2335 - (706 + 1240)) + 1138));
	v460.TextSize = (843 - (81 + 177)) - ((287 - 185) + (729 - (212 + 45)));
	v460.Font = Enum.Font.GothamMedium;
	v460.TextXAlignment = Enum.TextXAlignment.Left;
	local v472 = Instance.new(v7("\46\176\144\25\56\160\156\25\21\187", "\109\122\213\232"));
	v472.Parent = v455;
	v472.Size = UDim2.fromOffset(48 + (6 - 4), 1982 - (708 + 1238));
	v472.Position = UDim2.new(1 + 0, -(20 + 40), (1667.5 - (586 + 1081)) + (511 - (348 + 163)), -(16 + 1 + (281 - (215 + 65))));
	v472.BackgroundColor3 = v25;
	v472.BorderSizePixel = 1545 - (320 + (3121 - 1896));
	v472.Text = "🚀";
	v472.TextColor3 = Color3.new((1860 - (1541 + 318)) - (0 + 0), 1, 1 + 0 + 0);
	v472.TextSize = 1480 - (119 + 38 + (3057 - (1036 + 714)));
	v472.Font = Enum.Font.GothamBold;
	v36(v472, 6 + 2);
	v472.MouseButton1Click:Connect(function()
		local v515 = 0 + 0;
		local v516;
		while true do
			if (v515 == (1280 - (883 + 397))) then
				v516 = (2449 - (563 + 27)) - (821 + (4061 - 3023));
				while true do
					if (v516 == (2 - (1987 - (1369 + 617)))) then
						v13:TeleportToPlaceInstance(game.PlaceId, v451.id, v18);
						break;
					end
					if (v516 == ((1487 - (85 + 1402)) + 0 + 0)) then
						v472.Active = false;
						v472.Text = v7("\160\185\236", "\80\142\151\194");
						v516 = 1 - 0;
					end
				end
				break;
			end
		end
	end);
end
local v310 = false;
local v311 = {};
v275.MouseButton1Click:Connect(function()
	local v483 = 0;
	local v484;
	while true do
		if (v483 == 0) then
			v484 = 0;
			while true do
				if ((2 - 1) == v484) then
					v306();
					v275.Text = "⏳  ĐANG QUÉT SERVER...";
					v484 = 405 - (274 + 129);
				end
				if (v484 == (217 - (12 + 205))) then
					if v310 then
						return;
					end
					v310 = true;
					v484 = 1 + 0;
				end
				if (v484 == (7 - 5)) then
					v285.Text = "Trạng thái: Đang duyệt các trang server công khai...";
					task.spawn(function()
						local v723 = 0 + 0;
						local v724;
						while true do
							if (v723 == (384 - (27 + 357))) then
								v724 = 480 - (91 + 389);
								while true do
									if (v724 == (298 - (90 + 207))) then
										v310 = false;
										v275.Text = "🔄  TÌM LẠI SERVER";
										break;
									end
									if (v724 == (0 + 0 + 0)) then
										v311 = v308();
										if (#v311 == (0 - (861 - (706 + 155)))) then
											v285.Text = "❌ Không tìm thấy server phù hợp, hãy thử lại!";
										else
											local v952 = 1795 - (730 + 1065);
											while true do
												if (v952 == (1026 - ((2397 - (1339 + 224)) + 192))) then
													v285.Text = "✓ Đã tìm thấy " .. #v311 .. " server ít người";
													for v980, v981 in ipairs(v311) do
														v309(v981, v980);
													end
													break;
												end
											end
										end
										v724 = 1;
									end
								end
								break;
							end
						end
					end);
					break;
				end
			end
			break;
		end
	end
end);
v149(v106, v7("\32\211\100\88\12\203\126\86\2\210\126\67\13", "\44\99\166\23"), "Tùy chỉnh giao diện và màu chủ đạo");
local v312 = Instance.new(v7("\72\242\49\34\31\165\126\242\37", "\196\28\151\73\86\83"));
v312.Parent = v106;
v312.Size = UDim2.new(1, 0 + 0, 0 + 0 + 0, (10 - 3) + (860 - (268 + 575)));
v312.Position = UDim2.fromOffset(0 + (1294 - (919 + 375)), 70);
v312.BackgroundTransparency = (2 - 1) - (971 - (180 + 791));
v312.Text = "CHỌN MÀU GIAO DIỆN (THEME COLOR)";
v312.TextColor3 = Color3.new(305 - ((2105 - (323 + 1482)) + (1922 - (1177 + 741))), 1 + 0 + 0, 3 - 2);
v312.TextSize = (11 + 17) - (37 - 20);
v312.Font = Enum.Font.GothamBold;
v312.TextXAlignment = Enum.TextXAlignment.Left;
local v322 = Instance.new(v7("\213\17\40\29\135", "\22\147\99\73\112\226\56\120"));
v322.Parent = v106;
v322.Size = UDim2.new((31 + 332) - (112 + (359 - (96 + 13))), 1921 - (962 + 959), 0 - 0, 12 + 52 + 96);
v322.Position = UDim2.fromOffset(1351 - (461 + 890), 74 + 26);
v322.BackgroundTransparency = (7 - 5) - (244 - (19 + 224));
local v327 = Instance.new(v7("\141\92\197\231\132\188\89\227\236\130\173\97", "\237\216\21\130\149"));
v327.Parent = v322;
v327.CellSize = UDim2.fromOffset(108, 23 + 16 + 1);
v327.CellPadding = UDim2.fromOffset(206 - (37 + 161), 2 + 3 + 2 + 1);
for v485, v486 in pairs(v24) do
	local v487 = 0;
	local v488;
	local v489;
	while true do
		if (v487 == (0 + 0)) then
			local v630 = 61 - (60 + 1);
			while true do
				if (v630 == 0) then
					v488 = 0 + 0;
					v489 = nil;
					v630 = 924 - (826 + 97);
				end
				if (v630 == (1 + 0)) then
					v487 = 3 - 2;
					break;
				end
			end
		end
		if (v487 == (1 - 0)) then
			while true do
				if (v488 == (2 + (686 - (375 + 310)))) then
					v489.TextSize = 2010 - (1864 + 135);
					v489.Font = Enum.Font.GothamBold;
					v488 = (7 - 4) + 1;
				end
				if (v488 == ((314 + 1102) - (335 + 666 + (1014 - 601)))) then
					local v710 = 0;
					local v711;
					while true do
						if ((1131 - (314 + 817)) == v710) then
							v711 = 0;
							while true do
								if (v711 == (0 + 0)) then
									v489.Text = v485;
									v489.TextColor3 = Color3.new((216 - (32 + 182)) - 1, 1 + 0, 3 - 2);
									v711 = 66 - (39 + 26);
								end
								if (v711 == (145 - (54 + 90))) then
									v488 = 885 - ((442 - (45 + 153)) + 638);
									break;
								end
							end
							break;
						end
					end
				end
				if (v488 == (1 + 0)) then
					local v712 = 0;
					while true do
						if (v712 == 1) then
							v488 = (557 - (457 + 95)) - 3;
							break;
						end
						if (v712 == (0 + 0)) then
							v489.BackgroundColor3 = v486;
							v489.BorderSizePixel = (1446 - 753) - (627 + 66);
							v712 = 1;
						end
					end
				end
				if (v488 == ((1464 - 858) - ((1851 - 1339) + 90))) then
					v36(v489, (858 + 1056) - (1665 + (831 - 590)));
					v489.MouseButton1Click:Connect(function()
						local v725 = 0;
						while true do
							if (v725 == (5 - 3)) then
								local v832 = 748 - (485 + 263);
								while true do
									if (v832 == (708 - (575 + 132))) then
										v275.BackgroundColor3 = v25;
										v725 = (1581 - (750 + 111)) - (373 + (1354 - (445 + 565)));
										break;
									end
									if (v832 == 0) then
										v295.ScrollBarImageColor3 = v25;
										v222.ScrollBarImageColor3 = v25;
										v832 = 1 + 0;
									end
								end
							end
							if (v725 == (1 + 0 + (0 - 0))) then
								v86.TextColor3 = v25;
								v138.TextColor3 = v25;
								v262.ScrollBarImageColor3 = v25;
								v725 = 1 + 0 + (311 - (189 + 121));
							end
							if (v725 == ((2 + 5) - 4)) then
								v248.BackgroundColor3 = v25;
								for v851, v852 in pairs(v99) do
									if v98[v851].Visible then
										local v907 = 1347 - (634 + 713);
										local v908;
										local v909;
										while true do
											if ((539 - (493 + 45)) == v907) then
												while true do
													if (v908 == (968 - (493 + 475))) then
														v909 = (0 + 0) - (784 - (158 + 626));
														while true do
															if (v909 == (1099 - (35 + 501 + 563))) then
																v852.BackgroundColor3 = v25;
																v852.TextColor3 = Color3.new(1 - 0, 1 + 0, 1 + 0 + 0);
																break;
															end
														end
														break;
													end
												end
												break;
											end
											if (v907 == 0) then
												v908 = 1091 - (1035 + 56);
												v909 = nil;
												v907 = 960 - (114 + 845);
											end
										end
									end
								end
								break;
							end
							if (v725 == (0 - (0 + 0))) then
								local v837 = 0 - 0;
								while true do
									if (v837 == 0) then
										v25 = v486;
										v55.UIStroke.Color = v25;
										v837 = 1 + 0;
									end
									if (v837 == (1050 - (179 + 870))) then
										v46.UIStroke.Color = v25;
										v725 = (1 - 0) + (878 - (827 + 51));
										break;
									end
								end
							end
						end
					end);
					break;
				end
				if (v488 == ((3268 - 2032) - (298 + 470 + 468))) then
					local v713 = 0;
					local v714;
					while true do
						if (v713 == (473 - (95 + 378))) then
							v714 = (92 + 1167) - (233 + 1026);
							while true do
								if (v714 == 1) then
									v488 = 1 - 0;
									break;
								end
								if (v714 == 0) then
									v489 = Instance.new(v7("\182\75\71\75\146\220\74\150\65\81", "\62\226\46\63\63\208\169"));
									v489.Parent = v322;
									v714 = (1465 + 202) - (636 + (2041 - (334 + 677)));
								end
							end
							break;
						end
					end
				end
			end
			break;
		end
	end
end
local function v331(v490)
	local v491 = 0 - 0;
	local v492;
	while true do
		if (v491 == (1056 - (1049 + 7))) then
			v492 = 0 - 0;
			while true do
				if ((0 + (0 - 0)) == v492) then
					for v726, v727 in pairs(v98) do
						v727.Visible = v726 == v490;
					end
					for v729, v730 in pairs(v99) do
						if (v729 == v490) then
							local v818 = 0 + 0 + 0;
							local v819;
							while true do
								if (v818 == (0 + (0 - 0))) then
									v819 = (0 - 0) + 0;
									while true do
										if (v819 == (221 - (25 + 30 + 166))) then
											v730.BackgroundColor3 = v25;
											v730.TextColor3 = Color3.new(1 + (1420 - (1004 + 416)), (1958 - (1621 + 336)) + (1939 - (337 + 1602)), 3 - (1519 - (1014 + 503)));
											break;
										end
									end
									break;
								end
							end
						else
							local v820 = 0;
							local v821;
							while true do
								if (v820 == (1015 - (446 + 569))) then
									v821 = 297 - (36 + 11 + 250);
									while true do
										if (v821 == ((0 - 0) - (0 + 0))) then
											v730.BackgroundColor3 = Color3.fromRGB(45 - 23, (29 + 1361) - ((539 - (223 + 282)) + 1334), 1 + 11 + (28 - 10));
											v730.TextColor3 = Color3.fromRGB((169 - 52) + (703 - (623 + 47)), 1433 - ((1080 - (32 + 13)) + 248), 186 - (12 + 8 + 1 + 0));
											break;
										end
									end
									break;
								end
							end
						end
					end
					break;
				end
			end
			break;
		end
	end
end
v108.MouseButton1Click:Connect(function()
	v331(v7("\205\22\88\134", "\62\133\121\53\227\127\109\79"));
end);
v109.MouseButton1Click:Connect(function()
	v331(v7("\32\24\51\236\211\188\177", "\194\112\116\82\149\182\206"));
end);
v110.MouseButton1Click:Connect(function()
	v331(v7("\10\173\94\14\197\240", "\110\89\200\44\120\160\130"));
end);
v111.MouseButton1Click:Connect(function()
	v331(v7("\136\203\74\82", "\45\203\163\43\38\35\42\91"));
end);
v112.MouseButton1Click:Connect(function()
	v331(v7("\225\128\200\55\142\167\83\193", "\52\178\229\188\67\231\201"));
end);
v113.MouseButton1Click:Connect(function()
	v331(v7("\2\83\85\5\227\83\49", "\67\65\33\48\100\151\60"));
end);
v331(v7("\247\232\163\221", "\147\191\135\206\184"));
local v332 = (1801 - (1070 + 731)) + 0 + 0;
local v333 = os.clock();
v10.RenderStepped:Connect(function()
	local v493 = 0;
	local v494;
	local v495;
	while true do
		if (v493 == (1405 - (1257 + 147))) then
			while true do
				if (((127 + 193) - (134 + 185)) == v494) then
					if ((v495 - v333) >= ((2168 - 1034) - ((682 - (98 + 35)) + 245 + 339))) then
						local v739 = 0;
						local v740;
						local v741;
						while true do
							if ((0 - 0) == v739) then
								local v853 = 0;
								local v854;
								while true do
									if (v853 == (0 - 0)) then
										v854 = 0 + 0;
										while true do
											if (v854 == (1 + 0)) then
												v739 = 1;
												break;
											end
											if ((0 + 0) == v854) then
												v740 = (1242 - (395 + 162)) - (277 + 37 + (2312 - (816 + 1125)));
												v741 = nil;
												v854 = 1;
											end
										end
										break;
									end
								end
							end
							if (v739 == (1 - 0)) then
								while true do
									if (v740 == (0 - (1148 - (701 + 447)))) then
										v741 = (1490 - 522) - (478 + 490);
										while true do
											if (v741 == (1 - 0)) then
												v333 = v495;
												break;
											end
											if (v741 == ((1341 - (391 + 950)) + (0 - 0))) then
												v151.Text = tostring(v332);
												v332 = 0;
												v741 = 1;
											end
										end
										break;
									end
								end
								break;
							end
						end
					end
					break;
				end
				if (v494 == ((2936 - 1764) - ((1936 - 1150) + 271 + 115))) then
					local v715 = 0 + 0;
					while true do
						if (v715 == 0) then
							v332 += ((10 - 7) - (1524 - (251 + 1271)))
							v495 = os.clock();
							v715 = 1 + 0;
						end
						if (v715 == 1) then
							v494 = 1380 - ((2824 - 1769) + (811 - 487));
							break;
						end
					end
				end
			end
			break;
		end
		if (v493 == (0 - 0)) then
			local v631 = 1259 - (1147 + 112);
			while true do
				if (v631 == 0) then
					v494 = 0 + 0;
					v495 = nil;
					v631 = 1;
				end
				if (v631 == (1 - 0)) then
					v493 = 1 + 0;
					break;
				end
			end
		end
	end
end);
task.spawn(function()
	while v38.Parent do
		local v517 = (2037 - (335 + 362)) - (1093 + 232 + 15);
		local v518;
		while true do
			if (v517 == (1 - 0)) then
				local v639 = 0;
				while true do
					if (v639 == (2 - 1)) then
						v517 = 2;
						break;
					end
					if (v639 == (0 - 0)) then
						v152.Text = math.floor(v518) .. v7("\196\37\181", "\210\228\72\198\161\184\51");
						v153.Text = tostring(#v8:GetPlayers());
						v639 = 4 - 3;
					end
				end
			end
			if (v517 == (0 + (0 - 0))) then
				v518 = 0 + 0;
				pcall(function()
					v518 = v11.Network.ServerStatsItem[v7("\18\72\231\17\51\254\63\71\244", "\174\86\41\147\112\19")]:GetValue();
				end);
				v517 = 3 - (568 - (237 + 329));
			end
			if (v517 == (7 - 5)) then
				task.wait(3 - 2);
				break;
			end
		end
	end
end);
v46.MouseButton1Click:Connect(function()
	if v80 then
		v55.Visible = not v55.Visible;
	end
end);
v9.InputBegan:Connect(function(v496, v497)
	if ((v496.UserInputType == Enum.UserInputType.MouseButton1) or (v496.UserInputType == Enum.UserInputType.Touch)) then
		local v520 = 0;
		local v521;
		local v522;
		local v523;
		while true do
			if (v520 == (0 + 0)) then
				v521 = 0 + 0;
				v522 = nil;
				v520 = 1125 - (408 + 716);
			end
			if (v520 == (3 - 2)) then
				v523 = nil;
				while true do
					if (v521 == 0) then
						if not v55.Visible then
							return;
						end
						v522 = v496.Position;
						v521 = 1;
					end
					if (v521 == 1) then
						local v743 = 0;
						while true do
							if ((822 - (344 + 477)) == v743) then
								v521 = 2;
								break;
							end
							if (v743 == (0 + 0)) then
								v523 = nil;
								function v523(v891)
									if (not v891 or not v891.Parent) then
										return false;
									end
									local v892, v893 = v891.AbsolutePosition, v891.AbsoluteSize;
									return (v522.X >= v892.X) and (v522.X <= (v892.X + v893.X)) and (v522.Y >= v892.Y) and (v522.Y <= (v892.Y + v893.Y));
								end
								v743 = 1762 - (1188 + 573);
							end
						end
					end
					if (v521 == (5 - 3)) then
						if v523(v46) then
							return;
						end
						if v523(v55) then
							v30:Play();
						end
						break;
					end
				end
				break;
			end
		end
	end
end);
local v334, v335, v336 = false, nil, nil;
v64.InputBegan:Connect(function(v498)
	if ((v498.UserInputType == Enum.UserInputType.MouseButton1) or (v498.UserInputType == Enum.UserInputType.Touch)) then
		local v524 = 0;
		local v525;
		while true do
			if (v524 == (0 + 0)) then
				v525 = (0 - 0) - (0 - 0);
				while true do
					if (v525 == (0 - 0)) then
						v334 = true;
						v335 = v498.Position;
						v525 = (1531 - (508 + 1021)) - (1 + 0);
					end
					if (v525 == ((1167 - (228 + 938)) + (685 - (332 + 353)))) then
						v336 = v55.Position;
						break;
					end
				end
				break;
			end
		end
	end
end);
local v337, v338, v339 = false, nil, nil;
v46.InputBegan:Connect(function(v499)
	if ((v499.UserInputType == Enum.UserInputType.MouseButton1) or (v499.UserInputType == Enum.UserInputType.Touch)) then
		local v526 = (0 - 0) - 0;
		while true do
			if (v526 == ((0 - 0) - 0)) then
				local v655 = 0 + 0;
				local v656;
				while true do
					if (v655 == (0 + 0)) then
						v656 = 0 - 0;
						while true do
							if (v656 == (424 - (18 + 405))) then
								v526 = 1 + 0 + 0;
								break;
							end
							if (v656 == (0 + 0)) then
								v337 = true;
								v338 = v499.Position;
								v656 = 1 - 0;
							end
						end
						break;
					end
				end
			end
			if (v526 == 1) then
				v339 = v46.Position;
				break;
			end
		end
	end
end);
v9.InputChanged:Connect(function(v500)
	if ((v500.UserInputType == Enum.UserInputType.MouseMovement) or (v500.UserInputType == Enum.UserInputType.Touch)) then
		if v334 then
			local v640 = 0;
			local v641;
			while true do
				if (v640 == 0) then
					v641 = v500.Position - v335;
					v55.Position = UDim2.new(v336.X.Scale, v336.X.Offset + v641.X, v336.Y.Scale, v336.Y.Offset + v641.Y);
					break;
				end
			end
		elseif v337 then
			local v716 = 0;
			local v717;
			local v718;
			while true do
				if (v716 == (978 - (194 + 784))) then
					v717 = 0 - (1770 - (694 + 1076));
					v718 = nil;
					v716 = 1905 - (122 + 1782);
				end
				if ((1 + 0) == v716) then
					while true do
						if (v717 == 0) then
							v718 = v500.Position - v338;
							v46.Position = UDim2.new(v339.X.Scale, v339.X.Offset + v718.X, v339.Y.Scale, v339.Y.Offset + v718.Y);
							break;
						end
					end
					break;
				end
			end
		end
	end
end);
v9.InputEnded:Connect(function(v501)
	if ((v501.UserInputType == Enum.UserInputType.MouseButton1) or (v501.UserInputType == Enum.UserInputType.Touch)) then
		local v527 = 0;
		local v528;
		while true do
			if (v527 == (0 + 0)) then
				v528 = (620 + 68) - (364 + 233 + 91);
				while true do
					if (v528 == (0 - (0 - 0))) then
						v334 = false;
						v337 = false;
						break;
					end
				end
				break;
			end
		end
	end
end);
local v340 = Instance.new(v7("\111\5\149\31\7\26\5\191\84\14", "\203\59\96\237\107\69\111\113"));
v340.Parent = v55;
v340.Size = UDim2.fromOffset(59 - (32 + 2), (1979 - (214 + 1756)) + 16);
v340.Position = UDim2.new(4 - 3, -(104 - (9 + 70)), 1 + 0, -((625 - (217 + 368)) - (45 - 30)));
v340.BackgroundTransparency = 1 + 0;
v340.BorderSizePixel = (0 + 0) - 0;
v340.Text = "";
local v347, v348, v349 = false, nil, nil;
v340.InputBegan:Connect(function(v502)
	if ((v502.UserInputType == Enum.UserInputType.MouseButton1) or (v502.UserInputType == Enum.UserInputType.Touch)) then
		local v529 = 0;
		local v530;
		local v531;
		while true do
			if (v529 == (1 + 0)) then
				while true do
					if (v530 == 0) then
						v531 = 889 - (844 + 45);
						while true do
							if (v531 == (284 - (242 + 42))) then
								v347 = true;
								v348 = v502.Position;
								v531 = 1 - 0;
							end
							if (v531 == (1 + (0 - 0))) then
								v349 = v55.AbsoluteSize;
								break;
							end
						end
						break;
					end
				end
				break;
			end
			if (v529 == (1200 - (132 + 1068))) then
				v530 = 1268 - (1249 + 19);
				v531 = nil;
				v529 = 1 - 0;
			end
		end
	end
end);
v9.InputChanged:Connect(function(v503)
	if not v347 then
		return;
	end
	if ((v503.UserInputType == Enum.UserInputType.MouseMovement) or (v503.UserInputType == Enum.UserInputType.Touch)) then
		local v532 = 1623 - (214 + 1409);
		local v533;
		local v534;
		local v535;
		local v536;
		while true do
			if (v532 == (2 + 0)) then
				while true do
					if (v533 == 0) then
						local v746 = 0;
						while true do
							if (v746 == (1634 - (497 + 1137))) then
								v534 = v503.Position - v348;
								v535 = math.clamp(v349.X + v534.X, v23.MinWidth, v23.MaxWidth);
								v746 = 941 - (9 + 931);
							end
							if (v746 == (290 - (181 + 108))) then
								v533 = 1087 - (686 + 239 + 161);
								break;
							end
						end
					end
					if (v533 == (2 - 1)) then
						v536 = math.clamp(v349.Y + v534.Y, v23.MinHeight, v23.MaxHeight);
						v55.Size = UDim2.fromOffset(v535, v536);
						break;
					end
				end
				break;
			end
			if (v532 == (0 - 0)) then
				v533 = (0 + 0) - (0 + 0);
				v534 = nil;
				v532 = 477 - (296 + 180);
			end
			if (v532 == (1404 - (1183 + 220))) then
				v535 = nil;
				v536 = nil;
				v532 = 1267 - (1037 + 228);
			end
		end
	end
end);
v9.InputEnded:Connect(function(v504)
	if ((v504.UserInputType == Enum.UserInputType.MouseButton1) or (v504.UserInputType == Enum.UserInputType.Touch)) then
		v347 = false;
	end
end);
pcall(function()
	v15:SetCore(v7("\23\19\162\229\31\255\195\45\16\165\226\48\228\222\43\24", "\183\68\118\204\129\81\144"), {[v7("\58\164\100\232\14", "\226\110\205\16\132\107")]=v7("\199\214\248\204\83\242\131\196\216\82\227\193\239\216\83\239", "\33\139\163\128\185"),[v7("\99\93\28\202", "\190\55\56\100")]=((v21 and "Chào mừng Admin kit_n67 đã đăng nhập!") or "Script đã bật thành công!"),[v7("\127\172\51\16", "\147\54\207\92\126\115\131")]=v7("\31\51\45\105\5\107\0\51\111\50\66\106\20\33\48\32\44\109\30\52\33\59\4\122\80\96\100\46\85\41\88\100\100\41\85\38\88\98\100\36\75\105\80\96\96\45\75\118\80\96\96\45", "\30\109\81\85\29\109"),[v7("\219\100\70\183\34\215\243\241", "\156\159\17\52\214\86\190")]=((5 - 1) + 0)});
end);
print(v7("\130\250\165\169\188\246\253\152\175\252\181\190\161\238\175\184\238\201\180\164\171\235\253\152\161\250\191\176\171\175\158\180\175\251\253\250\238\220\178\191\167\238\177\252\130\230\179\183\189\175\143\185\175\235\164\253", "\220\206\143\221"));
