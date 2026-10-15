--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0 = string.char;
local v1 = string.byte;
local v2 = string.sub;
local v3 = bit32 or bit;
local v4 = v3.bxor;
local v5 = table.concat;
local v6 = table.insert;
local function v7(v257, v258)
	local FlatIdent_95CAC = 0;
	local v259;
	while true do
		if (FlatIdent_95CAC == 1) then
			return v5(v259);
		end
		if (FlatIdent_95CAC == 0) then
			v259 = {};
			for v361 = 1, #v257 do
				v6(v259, v0(v4(v1(v2(v257, v361, v361 + 1)), v1(v2(v258, 1 + (v361 % #v258), 1 + (v361 % #v258) + 1))) % 256));
			end
			FlatIdent_95CAC = 1;
		end
	end
end
local v8 = game:GetService(v7("\225\207\218\60\227\169\212", "\126\177\163\187\69\134\219\167"));
local v9 = game:GetService(v7("\22\222\47\215\213\45\221\63\209\207\38\223\60\204\255\38", "\156\67\173\74\165"));
local v10 = game:GetService(v7("\6\162\71\37\185\52\80\61\180\76", "\38\84\215\41\118\220\70"));
local v11 = game:GetService(v7("\99\2\35\6\237", "\158\48\118\66\114"));
local v12 = game:GetService(v7("\131\48\4\38\64\160\233\189\45\19\51", "\155\203\68\112\86\19\197"));
local v13 = game:GetService(v7("\114\216\58\249\80\119\247\236\117\216\36\234\73\123\224", "\152\38\189\86\156\32\24\133"));
local v14 = game:GetService(v7("\207\88\178\72\248\100\162\84\234\94\164\67", "\38\156\55\199"));
local v15 = game:GetService(v7("\155\105\125\58\7\113\232\100\189\116", "\35\200\29\28\72\115\20\154"));
local v16 = v8.LocalPlayer;
local v17 = v16:WaitForChild(v7("\41\179\208\198\136\62\19\12\182", "\84\121\223\177\191\237\76"));
local v18 = {[v7("\143\94\204\173\63", "\161\219\54\169\192\90\48\80")]=v7("\121\87\18\53\69\71", "\69\41\34\96"),[v7("\145\198\217\31\53\34\184\215\223", "\75\220\163\183\106\98")]=(628 + (303 - 211)),[v7("\47\191\133\34\241\7\179\140\63\205", "\185\98\218\235\87")]=(1346 - (283 + 603)),[v7("\230\53\41\209\215\174\223\52", "\202\171\92\71\134\190")]=((630 + 322) - (61 + 47 + 212 + 82)),[v7("\4\192\52\191\32\197\56\128", "\232\73\161\76")]=((2006 + 383) - (570 + 919)),[v7("\150\208\76\117\27\178\222\74\73", "\126\219\185\34\61")]=((634 + 14) - (701 - (153 + 280))),[v7("\33\207\70\90\123\126\244\239\24", "\135\108\174\62\18\30\23\147")]=((4218 - 2757) - (511 + 58 + 96 + 146)),[v7("\155\232\50\248\29\188\37\194\164\217\38\202\1\171\33\212", "\167\214\137\74\171\120\206\83")]=3,[v7("\191\245\62\88\232\168\153\228\29\91\254\180\142\228", "\199\235\144\82\61\152")]=((8 + 6) - 9)};
local v19 = {[v7("\55\3\171\59\11\19", "\75\103\118\217")]=Color3.fromRGB(9 + 0 + 131, 1094 - (706 + 231 + 87), 1506 - (721 + (807 - 277))),[v7("\247\93\126\31", "\126\167\52\16\116\217")]=Color3.fromRGB((944 + 582) - (945 + (993 - (89 + 578))), (107 + 42) - (184 - 95), 134 + 16),[v7("\234\34\53\133", "\156\168\78\64\224\212\121")]=Color3.fromRGB((1799 - (572 + 477)) - (37 + 234 + 429), 73 + 47, 255),[v7("\36\247\164\192", "\174\103\142\197")]=Color3.fromRGB(3 + 17, 286 - (84 + 2), 346 - 136),[v7("\113\58\90\61\43", "\152\54\72\63\88\69\62")]=Color3.fromRGB(27 + 10 + (845 - (497 + 345)), 1700 - (37 + 1371 + 16 + 76), 1186 - ((1794 - (605 + 728)) + 625)),[v7("\230\193\234", "\60\180\164\142")]=Color3.fromRGB(230, 50, 43 + 17),[v7("\119\76\4\39\32\232", "\114\56\62\101\73\71\141")]=Color3.fromRGB((3430 - 1887) - (46 + 947 + (1090 - 795)), 7 + 0 + (340 - 217), 31 + 9)};
local v20 = v19[v18.Theme];
local v21 = v16.UserId;
local v22 = v16.DisplayName;
local v23 = "@" .. v16.Name;
local v24 = "";
local v25 = Instance.new(v7("\139\230\206\202\188", "\164\216\137\187"));
v25.Name = v7("\254\243\41\167\180\231\40\222\239\50\185\149\241\30\220\226", "\107\178\134\81\210\198\158");
v25.SoundId = v7("\42\12\154\199\185\43\11\150\207\174\98\65\205\144\242\97\91\210\145\243\96\91\209", "\202\88\110\226\166");
v25.Volume = 1172 - (418 + 753);
v25.Parent = v14;
pcall(function()
	v24 = v8:GetUserThumbnailAsync(v21, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
end);
local v30 = v17:FindFirstChild(v7("\239\26\154\226\216\218\43\131\228\194\193\0\131\229\206\246\38", "\170\163\111\226\151"));
if v30 then
	v30:Destroy();
end
local function v31(v260, v261)
	local FlatIdent_8D327 = 0;
	local v262;
	local v263;
	local v264;
	while true do
		if (FlatIdent_8D327 == 0) then
			v262 = 489 - (457 + 32);
			v263 = nil;
			FlatIdent_8D327 = 1;
		end
		if (FlatIdent_8D327 == 1) then
			v264 = nil;
			while true do
				if (v262 == (1 + 0)) then
					while true do
						local v395 = 1402 - (832 + 570);
						while true do
							if (v395 == (0 + 0)) then
								if (v263 == (1 + 0)) then
									local v498 = 0 - 0;
									local v499;
									while true do
										if (v498 == (0 + 0)) then
											v499 = (796 - (588 + 208)) + (0 - 0);
											while true do
												if ((1800 - (884 + 916)) == v499) then
													local FlatIdent_10BCC = 0;
													local v676;
													while true do
														if (0 == FlatIdent_10BCC) then
															v676 = 0;
															while true do
																if (v676 == (0 - 0)) then
																	local FlatIdent_47A9C = 0;
																	while true do
																		if (FlatIdent_47A9C == 0) then
																			v264.Parent = v260;
																			return v264;
																		end
																	end
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
								if (v263 == (0 + 0 + 0)) then
									local FlatIdent_63487 = 0;
									local v500;
									while true do
										if (FlatIdent_63487 == 0) then
											v500 = 0;
											while true do
												if (v500 == 0) then
													local FlatIdent_44839 = 0;
													while true do
														if (FlatIdent_44839 == 1) then
															v500 = 1890 - (1569 + 320);
															break;
														end
														if (FlatIdent_44839 == 0) then
															v264 = Instance.new(v7("\36\25\145\55\92\57\44\3", "\73\113\80\210\88\46\87"));
															v264.CornerRadius = UDim.new(0 + (653 - (232 + 421)), v261);
															FlatIdent_44839 = 1;
														end
													end
												end
												if (v500 == (1 + 0)) then
													v263 = 1 + 0;
													break;
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
					break;
				end
				if (v262 == 0) then
					local FlatIdent_3CB60 = 0;
					while true do
						if (FlatIdent_3CB60 == 1) then
							v262 = 1;
							break;
						end
						if (FlatIdent_3CB60 == 0) then
							v263 = (0 - 0) + (605 - (316 + 289));
							v264 = nil;
							FlatIdent_3CB60 = 1;
						end
					end
				end
			end
			break;
		end
	end
end
local function v32(v265, v266, v267)
	local v268 = 0 - 0;
	local v269;
	local v270;
	while true do
		if (v268 == (1 + 0)) then
			while true do
				local FlatIdent_8F047 = 0;
				local v396;
				local v397;
				while true do
					if (FlatIdent_8F047 == 0) then
						v396 = 0;
						v397 = nil;
						FlatIdent_8F047 = 1;
					end
					if (FlatIdent_8F047 == 1) then
						while true do
							if (v396 == (1453 - (666 + 787))) then
								v397 = 425 - (360 + 65);
								while true do
									if (v397 == ((496 + 34) - (406 + (377 - (79 + 175))))) then
										if (v269 == (1771 - ((2757 - 1008) + 16 + 4))) then
											local FlatIdent_104D4 = 0;
											local v596;
											while true do
												if (FlatIdent_104D4 == 0) then
													v596 = (0 - 0) + (0 - 0);
													while true do
														if (v596 == ((2221 - (503 + 396)) - (1249 + 73))) then
															local FlatIdent_940A0 = 0;
															local v677;
															while true do
																if (FlatIdent_940A0 == 0) then
																	v677 = 181 - (92 + 89);
																	while true do
																		if (v677 == (0 - 0)) then
																			local FlatIdent_8BBE3 = 0;
																			while true do
																				if (0 == FlatIdent_8BBE3) then
																					v270.Parent = v265;
																					return v270;
																				end
																			end
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
										break;
									end
									if (v397 == (0 + 0)) then
										local FlatIdent_946F = 0;
										local v577;
										local v578;
										while true do
											if (FlatIdent_946F == 0) then
												v577 = 0 + 0;
												v578 = nil;
												FlatIdent_946F = 1;
											end
											if (FlatIdent_946F == 1) then
												while true do
													if (v577 == (0 - 0)) then
														v578 = 0;
														while true do
															if (v578 == 1) then
																v397 = 1 + 0;
																break;
															end
															if (v578 == (0 - 0)) then
																if (v269 == (1 + 0 + 0)) then
																	local FlatIdent_703C8 = 0;
																	local v703;
																	local v704;
																	while true do
																		if (FlatIdent_703C8 == 0) then
																			v703 = 0 + 0;
																			v704 = nil;
																			FlatIdent_703C8 = 1;
																		end
																		if (FlatIdent_703C8 == 1) then
																			while true do
																				if (v703 == (0 - 0)) then
																					v704 = 0 + 0;
																					while true do
																						if (v704 == 0) then
																							v270.Thickness = v267 or (1146 - ((710 - 244) + (1923 - (485 + 759))));
																							v270.Transparency = (0.3 - 0) - (1189 - (442 + 747));
																							v704 = 1136 - (832 + 303);
																						end
																						if (v704 == 1) then
																							v269 = 5 - (949 - (88 + 858));
																							break;
																						end
																					end
																					break;
																				end
																			end
																			break;
																		end
																	end
																end
																if (v269 == 0) then
																	local v705 = (580 + 1320) - (88 + 18 + 74 + 1720);
																	while true do
																		if (v705 == (1 + 0)) then
																			v269 = 1 + (789 - (766 + 23));
																			break;
																		end
																		if (v705 == ((0 - 0) - (0 - 0))) then
																			local FlatIdent_2D2B8 = 0;
																			local v729;
																			local v730;
																			while true do
																				if (FlatIdent_2D2B8 == 1) then
																					while true do
																						if (v729 == 0) then
																							v730 = 0 - 0;
																							while true do
																								if (v730 == (1074 - (1036 + 37))) then
																									v705 = 2 - (1 + 0);
																									break;
																								end
																								if (v730 == 0) then
																									v270 = Instance.new(v7("\180\5\254\6\245\142\39\200", "\135\225\76\173\114"));
																									v270.Color = v266;
																									v730 = 1;
																								end
																							end
																							break;
																						end
																					end
																					break;
																				end
																				if (FlatIdent_2D2B8 == 0) then
																					v729 = 0 - 0;
																					v730 = nil;
																					FlatIdent_2D2B8 = 1;
																				end
																			end
																		end
																	end
																end
																v578 = 1 - 0;
															end
														end
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
			break;
		end
		if (v268 == 0) then
			local FlatIdent_66799 = 0;
			while true do
				if (FlatIdent_66799 == 0) then
					v269 = 0;
					v270 = nil;
					FlatIdent_66799 = 1;
				end
				if (FlatIdent_66799 == 1) then
					v268 = 1 + 0;
					break;
				end
			end
		end
	end
end
local v33 = Instance.new(v7("\41\238\170\181\169\179\128\15\228", "\199\122\141\216\208\204\221"));
v33.Name = v7("\129\200\8\229\106\239\137\220\3\248\122\249\172\207\20\197\81", "\150\205\189\112\144\24");
v33.ResetOnSpawn = false;
v33.IgnoreGuiInset = true;
v33.DisplayOrder = 1000113 - ((1484 - (641 + 839)) + (1023 - (910 + 3)));
v33.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
v33.Parent = v17;
local v41 = Instance.new(v7("\12\137\190\75\1\170\4\4\49\139\177", "\112\69\228\223\44\100\232\113"));
v41.Name = v7("\249\26\9\198\159\127\137\218", "\230\180\127\103\179\214\28");
v41.Parent = v33;
v41.Size = UDim2.fromOffset(52, 132 - 80);
v41.Position = UDim2.new(1684 - (1466 + 218), 10 + 10, 584.5 - ((1205 - (556 + 592)) + 188 + 339), -((2261 - (329 + 479)) - ((895 - (174 + 680)) + 1386)));
v41.BackgroundColor3 = Color3.fromRGB(15, (405 - 287) - (17 + (177 - 91)), 11 + 4 + (746 - (396 + 343)));
v41.BorderSizePixel = 0 - 0;
v41.AutoButtonColor = false;
v41.Image = v7("\158\7\71\82\236\84\237\142\95\16\9\240\88\240\137\88\126\85\247\68\244\202\12\91\27\181\16\179\212\82\10\19\181\21\184\212\80\12\23\189\7\247\209\84\10\22\162\73\189\221\80\15", "\128\236\101\63\38\132\33");
v31(v41, 3 + 23);
v32(v41, v20, 1479 - (29 + 1448));
local v50 = Instance.new(v7("\138\187\16\73\179", "\175\204\201\113\36\214\139"));
v50.Name = v7("\106\205\60\210\41\66\194\32", "\100\39\172\85\188");
v50.Parent = v33;
v50.Size = UDim2.fromOffset(v18.MenuWidth, v18.MenuHeight);
v50.Position = UDim2.new(1389.5 - (135 + 1254), -v18.MenuWidth / ((18 - 13) - (13 - 10)), (111.5 + 55) - ((1649 - (389 + 1138)) + 44), -v18.MenuHeight / (2 - 0));
v50.BackgroundColor3 = Color3.fromRGB(586 - (102 + 472), 12 + 0, 52 - (20 + 16));
v50.BorderSizePixel = 0 + 0;
v50.Visible = false;
v50.ClipsDescendants = true;
v31(v50, 16);
v32(v50, v20, 1.5 + 0 + 0);
local v59 = Instance.new(v7("\139\106\184\141\54", "\83\205\24\217\224"));
v59.Parent = v50;
v59.Size = UDim2.fromOffset(1645 - (320 + 1225), 70 - (62 - 27));
v59.Position = UDim2.new(1 + 0, -(1569 - (157 + 1307)), (1924 - (821 + 1038)) - ((74 - 44) + 35), 1 + 7);
v59.BackgroundTransparency = (1 - 0) + 0 + 0;
v59.ZIndex = (3140 - 1873) - ((2069 - (834 + 192)) + 14 + 200);
local function v65(v271, v272, v273)
	local v274 = 0 + 0;
	local v275;
	local v276;
	while true do
		if (v274 == (0 + 0)) then
			local v379 = 0 - 0;
			while true do
				if (0 == v379) then
					local FlatIdent_35A31 = 0;
					while true do
						if (FlatIdent_35A31 == 0) then
							v275 = (304 - (300 + 4)) - (0 + 0);
							v276 = nil;
							FlatIdent_35A31 = 1;
						end
						if (FlatIdent_35A31 == 1) then
							v379 = 2 - 1;
							break;
						end
					end
				end
				if (v379 == (363 - (112 + 250))) then
					v274 = 1 + 0;
					break;
				end
			end
		end
		if (v274 == (2 - 1)) then
			while true do
				local v398 = 0;
				while true do
					if ((0 + 0) == v398) then
						local FlatIdent_2D88C = 0;
						while true do
							if (1 == FlatIdent_2D88C) then
								v398 = 1907 - (1665 + 241);
								break;
							end
							if (FlatIdent_2D88C == 0) then
								if (v275 == ((629 + 587) - (242 + 81 + 441 + 448))) then
									return v276;
								end
								if (v275 == (0 + 0)) then
									local FlatIdent_5346B = 0;
									while true do
										if (1 == FlatIdent_5346B) then
											v276.Size = UDim2.fromOffset((1489 - (1001 + 413)) - (104 - 57), 910 - (244 + 638));
											v275 = (1274 - (627 + 66)) - ((1075 - 714) + (821 - (512 + 90)));
											break;
										end
										if (FlatIdent_5346B == 0) then
											v276 = Instance.new(v7("\210\192\213\41\196\208\217\41\233\203", "\93\134\165\173"));
											v276.Parent = v59;
											FlatIdent_5346B = 1;
										end
									end
								end
								FlatIdent_2D88C = 1;
							end
						end
					end
					if (v398 == (719 - (373 + 344))) then
						if (v275 == (1 + 0 + 0 + 0)) then
							local FlatIdent_8A742 = 0;
							while true do
								if (0 == FlatIdent_8A742) then
									v276.Position = UDim2.fromOffset(v271, 126 - ((305 - 189) + 10));
									v276.BackgroundColor3 = Color3.fromRGB(2 + (33 - 13), 760 - ((1641 - (35 + 1064)) + 143 + 53), (136 - 72) - (1 + 33));
									FlatIdent_8A742 = 1;
								end
								if (FlatIdent_8A742 == 1) then
									v276.BorderSizePixel = (1236 - (298 + 938)) + (1259 - (233 + 1026));
									v275 = (1668 - (636 + 1030)) + 0 + 0;
									break;
								end
							end
						end
						break;
					end
					if (v398 == (1 + 0)) then
						if (v275 == ((96 + 226) - (4 + 49 + (488 - (55 + 166))))) then
							local FlatIdent_5B2CE = 0;
							while true do
								if (FlatIdent_5B2CE == 1) then
									v276.TextSize = 995 - (18 + (2332 - (34 + 1334)));
									v275 = (5 + 6) - (7 + 1);
									break;
								end
								if (FlatIdent_5B2CE == 0) then
									v276.Text = v272;
									v276.TextColor3 = Color3.fromRGB(39 + 161, 5 + 41 + (588 - 434), (920 - (36 + 261)) - (15 + (695 - 297)));
									FlatIdent_5B2CE = 1;
								end
							end
						end
						if (v275 == (1286 - (1035 + 248))) then
							local FlatIdent_2388 = 0;
							local v509;
							while true do
								if (FlatIdent_2388 == 0) then
									v509 = 0;
									while true do
										if (v509 == 1) then
											v276.MouseButton1Click:Connect(function()
												local FlatIdent_8918D = 0;
												local v662;
												while true do
													if (FlatIdent_8918D == 0) then
														v662 = (21 - (20 + 1)) + 0;
														while true do
															if (v662 == (850 - (11 + 9 + (1149 - (134 + 185))))) then
																v25:Play();
																v273();
																break;
															end
														end
														break;
													end
												end
											end);
											v275 = 4;
											break;
										end
										if ((1133 - (549 + 584)) == v509) then
											local FlatIdent_4A183 = 0;
											while true do
												if (FlatIdent_4A183 == 1) then
													v509 = 969 - (478 + 490);
													break;
												end
												if (FlatIdent_4A183 == 0) then
													v276.Font = Enum.Font.GothamBold;
													v31(v276, (689 - (314 + 371)) + (6 - 4));
													FlatIdent_4A183 = 1;
												end
											end
										end
									end
									break;
								end
							end
						end
						v398 = 2 + 0;
					end
				end
			end
			break;
		end
	end
end
local v66 = false;
local v67 = UDim2.fromOffset(v18.MenuWidth, v18.MenuHeight);
local v68 = v50.Position;
v65((1172 - (786 + 386)) + 0, "—", function()
	v50.Visible = false;
end);
v65(103 - 71, "🗖", function()
	local v278 = 1379 - (1055 + 324);
	local v279;
	local v280;
	while true do
		if (v278 == 1) then
			while true do
				if (v279 == (0 - (1340 - (1093 + 247)))) then
					v280 = (1379 + 172) - (1126 + 45 + 380);
					while true do
						if (v280 == ((1607 - 1202) - ((400 - 282) + 287))) then
							v66 = not v66;
							if v66 then
								local FlatIdent_75224 = 0;
								local v587;
								local v588;
								while true do
									if (FlatIdent_75224 == 0) then
										v587 = 0;
										v588 = nil;
										FlatIdent_75224 = 1;
									end
									if (FlatIdent_75224 == 1) then
										while true do
											if (v587 == 0) then
												v588 = (0 - 0) - (0 - 0);
												while true do
													if (1 == v588) then
														v50.Size = UDim2.new(0, 1971 - (42 + 76 + 1003), (0 - 0) - (0 - 0), (722 + 235) - (142 + 235));
														v50.Position = UDim2.new(0.5 - 0, -((2616 - (364 + 324)) - (4119 - 2616)), 0.5 + (0 - 0), -(1267 - (553 + 424)));
														break;
													end
													if ((0 - (0 + 0)) == v588) then
														local FlatIdent_6D9D2 = 0;
														local v698;
														while true do
															if (FlatIdent_6D9D2 == 0) then
																v698 = 0;
																while true do
																	if (v698 == 1) then
																		v588 = 4 - 3;
																		break;
																	end
																	if (v698 == (0 - 0)) then
																		local FlatIdent_5EE26 = 0;
																		while true do
																			if (FlatIdent_5EE26 == 1) then
																				v698 = 2 - 1;
																				break;
																			end
																			if (FlatIdent_5EE26 == 0) then
																				v67 = v50.Size;
																				v68 = v50.Position;
																				FlatIdent_5EE26 = 1;
																			end
																		end
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
							else
								local FlatIdent_FA88 = 0;
								local v589;
								local v590;
								while true do
									if (FlatIdent_FA88 == 0) then
										v589 = 1268 - (1249 + 19);
										v590 = nil;
										FlatIdent_FA88 = 1;
									end
									if (FlatIdent_FA88 == 1) then
										while true do
											if (v589 == (0 + 0)) then
												v590 = 0 + 0;
												while true do
													if ((0 - 0) == v590) then
														v50.Size = v67;
														v50.Position = v68;
														break;
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
					end
					break;
				end
			end
			break;
		end
		if (v278 == (1086 - (686 + 400))) then
			local FlatIdent_6395 = 0;
			while true do
				if (FlatIdent_6395 == 1) then
					v278 = 1;
					break;
				end
				if (FlatIdent_6395 == 0) then
					v279 = (0 + 0) - 0;
					v280 = nil;
					FlatIdent_6395 = 1;
				end
			end
		end
	end
end);
local v69 = true;
v65((293 - (73 + 156)) + 0 + 0, "×", function()
	local FlatIdent_3B7E2 = 0;
	local v281;
	while true do
		if (FlatIdent_3B7E2 == 0) then
			v281 = 0 + (811 - (721 + 90));
			while true do
				if (v281 == (1 + 0)) then
					v41.Visible = false;
					break;
				end
				if (v281 == (0 - 0)) then
					local FlatIdent_8ABD6 = 0;
					while true do
						if (FlatIdent_8ABD6 == 0) then
							v50.Visible = false;
							v69 = false;
							FlatIdent_8ABD6 = 1;
						end
						if (FlatIdent_8ABD6 == 1) then
							v281 = (471 - (224 + 246)) + (0 - 0);
							break;
						end
					end
				end
			end
			break;
		end
	end
end);
local v70 = Instance.new(v7("\152\224\192\207\63", "\30\222\146\161\162\90\174\210"));
v70.Parent = v50;
v70.Size = UDim2.new(0 + (0 - 0), (71 + 319) - (5 + 205), (2 + 0) - (1 - 0), (0 - 0) - (513 - (203 + 310)));
v70.BackgroundColor3 = Color3.fromRGB(2009 - (1238 + 755), 1 + 4 + 11, 1556 - (709 + 825));
v70.BorderSizePixel = (0 - 0) - (0 - 0);
v31(v70, (1633 - (196 + 668)) - ((943 - 704) + 514));
local v75 = Instance.new(v7("\209\75\104\30\201\79\114\15\233", "\106\133\46\16"));
v75.Parent = v70;
v75.Size = UDim2.new(1 + (0 - 0), -((2182 - (171 + 662)) - ((890 - (4 + 89)) + (1864 - 1332))), 0 + 0 + 0, 197 - 152);
v75.Position = UDim2.fromOffset(6 + 9, (1491 - (35 + 1451)) + 7);
v75.BackgroundTransparency = (1455 - (28 + 1425)) - (1994 - (941 + 1052));
v75.Text = v7("\112\15\67\188\105\101\110\5\65", "\32\56\64\19\156\58");
v75.TextColor3 = v20;
v75.TextSize = 16;
v75.Font = Enum.Font.GothamBold;
v75.TextXAlignment = Enum.TextXAlignment.Left;
local v87 = {};
local v88 = {};
local function v89(v282)
	local v283 = 0 + 0;
	local v284;
	local v285;
	while true do
		if (v283 == (1514 - (822 + 692))) then
			local FlatIdent_2E34E = 0;
			while true do
				if (FlatIdent_2E34E == 0) then
					v284 = 0 - 0;
					v285 = nil;
					FlatIdent_2E34E = 1;
				end
				if (FlatIdent_2E34E == 1) then
					v283 = 1;
					break;
				end
			end
		end
		if (v283 == (1 + 0)) then
			while true do
				local v399 = 297 - (45 + 252);
				while true do
					if (v399 == (1203 - (373 + 821 + 8))) then
						local v478 = 0;
						local v479;
						while true do
							if (v478 == (0 + 0)) then
								v479 = 0 - 0;
								while true do
									if (v479 == (433 - (114 + 319))) then
										local FlatIdent_21297 = 0;
										while true do
											if (FlatIdent_21297 == 0) then
												if (v284 == ((1054 - 319) - ((609 - 133) + 255))) then
													return v285;
												end
												if (v284 == (2 + 1)) then
													local FlatIdent_28855 = 0;
													local v678;
													while true do
														if (FlatIdent_28855 == 0) then
															v678 = 0;
															while true do
																if (v678 == 1) then
																	v284 = 1134 - ((549 - 180) + 761);
																	break;
																end
																if (v678 == 0) then
																	local FlatIdent_55B85 = 0;
																	while true do
																		if (FlatIdent_55B85 == 1) then
																			v678 = 1;
																			break;
																		end
																		if (0 == FlatIdent_55B85) then
																			v285.Visible = false;
																			v87[v282] = v285;
																			FlatIdent_55B85 = 1;
																		end
																	end
																end
															end
															break;
														end
													end
												end
												FlatIdent_21297 = 1;
											end
											if (FlatIdent_21297 == 1) then
												v479 = 1 - 0;
												break;
											end
										end
									end
									if (1 == v479) then
										v399 = (1965 - (556 + 1407)) + (1206 - (741 + 465));
										break;
									end
								end
								break;
							end
						end
					end
					if (v399 == (467 - (170 + 295))) then
						if (v284 == ((1 + 0) - (0 + 0))) then
							local FlatIdent_53124 = 0;
							local v510;
							local v511;
							while true do
								if (FlatIdent_53124 == 0) then
									v510 = 0;
									v511 = nil;
									FlatIdent_53124 = 1;
								end
								if (FlatIdent_53124 == 1) then
									while true do
										if (v510 == 0) then
											v511 = 0 - 0;
											while true do
												if (v511 == (0 + 0)) then
													local FlatIdent_8B272 = 0;
													while true do
														if (0 == FlatIdent_8B272) then
															v285.Parent = v50;
															v285.Size = UDim2.new((1 + 0) - (0 + 0), -((1668 - (957 + 273)) - (18 + 46 + 70 + 104)), (3 - 2) + (0 - 0), -((88 - 59) - (44 - 35)));
															FlatIdent_8B272 = 1;
														end
														if (FlatIdent_8B272 == 1) then
															v511 = 1;
															break;
														end
													end
												end
												if (v511 == (1781 - (389 + 1391))) then
													v284 = (213 + 125) - (15 + 129 + 192);
													break;
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
					if (v399 == 0) then
						local FlatIdent_43626 = 0;
						while true do
							if (FlatIdent_43626 == 1) then
								v399 = (6877 - 5372) - (363 + 1141);
								break;
							end
							if (0 == FlatIdent_43626) then
								if ((0 - 0) == v284) then
									local FlatIdent_8FBAE = 0;
									local v512;
									while true do
										if (FlatIdent_8FBAE == 0) then
											v512 = 0;
											while true do
												if (v512 == 0) then
													local FlatIdent_651C5 = 0;
													while true do
														if (FlatIdent_651C5 == 0) then
															v285 = Instance.new(v7("\124\218\228\91\95", "\224\58\168\133\54\58\146"));
															v285.Name = v282;
															FlatIdent_651C5 = 1;
														end
														if (FlatIdent_651C5 == 1) then
															v512 = 1;
															break;
														end
													end
												end
												if (v512 == 1) then
													v284 = (1168 - (783 + 168)) - ((140 - 98) + 172 + 2);
													break;
												end
											end
											break;
										end
									end
								end
								if (v284 == (313 - (309 + 2))) then
									local FlatIdent_1FC72 = 0;
									local v513;
									while true do
										if (FlatIdent_1FC72 == 0) then
											v513 = 0 - 0;
											while true do
												if (v513 == (1212 - (1090 + 122))) then
													local FlatIdent_4E551 = 0;
													while true do
														if (FlatIdent_4E551 == 0) then
															v285.Position = UDim2.fromOffset(143 + 16 + 31, (30 - 21) + 1 + 0);
															v285.BackgroundTransparency = 1119 - (628 + 490);
															FlatIdent_4E551 = 1;
														end
														if (FlatIdent_4E551 == 1) then
															v513 = 1;
															break;
														end
													end
												end
												if (v513 == (1 + 0)) then
													v284 = 2 + (2 - 1);
													break;
												end
											end
											break;
										end
									end
								end
								FlatIdent_43626 = 1;
							end
						end
					end
				end
			end
			break;
		end
	end
end
local function v90(v286, v287, v288)
	local v289 = 774 - (431 + 343);
	local v290;
	local v291;
	local v292;
	while true do
		if (v289 == (1581 - ((2389 - 1206) + 397))) then
			v292 = nil;
			while true do
				local v400 = 0 - 0;
				while true do
					if (v400 == (0 + 0)) then
						if (v290 == ((1 + 1) - (1696 - (556 + 1139)))) then
							local FlatIdent_43BEE = 0;
							local v514;
							while true do
								if (0 == FlatIdent_43BEE) then
									v514 = 15 - (6 + 9);
									while true do
										if (v514 == 1) then
											local FlatIdent_3ACCC = 0;
											while true do
												if (FlatIdent_3ACCC == 1) then
													v514 = 1 + 1;
													break;
												end
												if (FlatIdent_3ACCC == 0) then
													v291.BorderSizePixel = 0;
													v291.Text = v286;
													FlatIdent_3ACCC = 1;
												end
											end
										end
										if (v514 == (0 + 0)) then
											local FlatIdent_835BC = 0;
											while true do
												if (FlatIdent_835BC == 1) then
													v514 = 1 - 0;
													break;
												end
												if (0 == FlatIdent_835BC) then
													v291.BackgroundColor3 = Color3.fromRGB(17 + 5, 17 + 5, 2005 - ((2082 - (28 + 141)) + 62));
													v291.BackgroundTransparency = 1 + 0;
													FlatIdent_835BC = 1;
												end
											end
										end
										if (v514 == (2 + 0)) then
											v290 = 2 + (1317 - (486 + 831));
											break;
										end
									end
									break;
								end
							end
						end
						if (v290 == ((0 - 0) - (0 - 0))) then
							local FlatIdent_67F21 = 0;
							local v515;
							local v516;
							while true do
								if (FlatIdent_67F21 == 0) then
									v515 = 0 + 0;
									v516 = nil;
									FlatIdent_67F21 = 1;
								end
								if (FlatIdent_67F21 == 1) then
									while true do
										if (v515 == (0 - 0)) then
											v516 = 0;
											while true do
												if (v516 == (1263 - (668 + 595))) then
													local FlatIdent_6DFD9 = 0;
													while true do
														if (FlatIdent_6DFD9 == 1) then
															v516 = 1 + 0;
															break;
														end
														if (FlatIdent_6DFD9 == 0) then
															v291 = Instance.new(v7("\109\83\83\233\87\147\147\31\86\88", "\107\57\54\43\157\21\230\231"));
															v291.Parent = v70;
															FlatIdent_6DFD9 = 1;
														end
													end
												end
												if ((1 + 0) == v516) then
													local FlatIdent_1DF4C = 0;
													while true do
														if (FlatIdent_1DF4C == 1) then
															v516 = 2;
															break;
														end
														if (FlatIdent_1DF4C == 0) then
															v291.Size = UDim2.new((5274 - 3340) - ((855 - (23 + 267)) + (3312 - (1129 + 815))), -(407 - (371 + 16)), 1750 - (1326 + 424), (297 - 140) - 115);
															v291.Position = UDim2.fromOffset(10, v287);
															FlatIdent_1DF4C = 1;
														end
													end
												end
												if (v516 == (7 - 5)) then
													v290 = (1780 - (88 + 30)) - ((2248 - (720 + 51)) + (408 - 224));
													break;
												end
											end
											break;
										end
									end
									break;
								end
							end
						end
						v400 = 1777 - (421 + 1355);
					end
					if (v400 == (1 - 0)) then
						if (v290 == ((2 + 1) - (1083 - (286 + 797)))) then
							local FlatIdent_229D1 = 0;
							local v517;
							local v518;
							while true do
								if (FlatIdent_229D1 == 0) then
									v517 = 0 - 0;
									v518 = nil;
									FlatIdent_229D1 = 1;
								end
								if (FlatIdent_229D1 == 1) then
									while true do
										if (v517 == (0 - 0)) then
											v518 = 439 - (397 + 42);
											while true do
												if (v518 == (1 + 1)) then
													v290 = 4;
													break;
												end
												if (v518 == 1) then
													local FlatIdent_1BB5D = 0;
													while true do
														if (FlatIdent_1BB5D == 1) then
															v518 = 787 - (222 + 563);
															break;
														end
														if (FlatIdent_1BB5D == 0) then
															v292.Parent = v291;
															v31(v291, (817 - (24 + 776)) - (10 - 3));
															FlatIdent_1BB5D = 1;
														end
													end
												end
												if (v518 == (0 - 0)) then
													local FlatIdent_5969 = 0;
													while true do
														if (FlatIdent_5969 == 1) then
															v518 = 1 + 0;
															break;
														end
														if (FlatIdent_5969 == 0) then
															v292 = Instance.new(v7("\238\162\33\244\189\216\198\213\140", "\175\187\235\113\149\217\188"));
															v292.PaddingLeft = UDim.new(0 + 0 + 0, (1060 - (23 + 167)) - (564 + (2090 - (690 + 1108))));
															FlatIdent_5969 = 1;
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
						if (v290 == (5 - (3 + 0))) then
							local FlatIdent_2A976 = 0;
							while true do
								if (FlatIdent_2A976 == 1) then
									v291.Font = Enum.Font.GothamMedium;
									v291.TextXAlignment = Enum.TextXAlignment.Left;
									FlatIdent_2A976 = 2;
								end
								if (FlatIdent_2A976 == 0) then
									v291.TextColor3 = Color3.fromRGB((1302 - (40 + 808)) - (244 + 10 + 50), 573 - 423, 127 + 37 + 1);
									v291.TextSize = (259 + 230) - (41 + 435);
									FlatIdent_2A976 = 1;
								end
								if (FlatIdent_2A976 == 2) then
									v290 = 1004 - (515 + 423 + (634 - (47 + 524)));
									break;
								end
							end
						end
						v400 = 2 + 0;
					end
					if (v400 == 2) then
						if (v290 == (4 + (0 - 0))) then
							local FlatIdent_13B77 = 0;
							local v525;
							while true do
								if (0 == FlatIdent_13B77) then
									v525 = 0 - 0;
									while true do
										if (v525 == 0) then
											local FlatIdent_94CF9 = 0;
											while true do
												if (FlatIdent_94CF9 == 0) then
													v88[v288] = v291;
													return v291;
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
			end
			break;
		end
		if (v289 == (0 - 0)) then
			v290 = 0;
			v291 = nil;
			v289 = 1;
		end
	end
end
local v91 = v89(v7("\20\160\140\73", "\24\92\207\225\44\131\25"));
local v92 = v89(v7("\123\223\185\85\30\111\88", "\29\43\179\216\44\123"));
local v93 = v89(v7("\142\220\50\90\184\203", "\44\221\185\64"));
local v94 = v89(v7("\50\226\92\75\122\15\224\91", "\19\97\135\40\63"));
local v95 = v89(v7("\141\78\54\58\59\62\188", "\81\206\60\83\91\79"));
local v96 = v90("🏠   Home Dashboard", (2926 - (1165 + 561)) - (936 + 189), v7("\102\164\221\119", "\196\46\203\176\18\79\163\45"));
local v97 = v90("👥   Online Players", 2 + 40 + (256 - 173), v7("\136\46\127\7\33\233\252", "\143\216\66\30\126\68\155"));
local v98 = v90("🌐   Server Hop", 1788 - (598 + 967 + 48), v7("\153\205\31\221\192\177", "\129\202\168\109\171\165\195\183"));
local v99 = v90("⚙️   UI Settings", (618 - (341 + 138)) + 24 + 62, v7("\17\93\35\204\215\26\225\49", "\134\66\56\87\184\190\116"));
local v100 = v90("👑   Creator Info", (2915 - 1502) - (782 + (682 - (89 + 237))), v7("\31\35\12\186\13\228\51", "\85\92\81\105\219\121\139\65"));
local v101 = Instance.new(v7("\219\161\81\72\121", "\191\157\211\48\37\28"));
v101.Parent = v70;
v101.Size = UDim2.new((861 - 593) - (176 + 91), -((109 - 57) - 32), (881 - (581 + 300)) - (1220 - (855 + 365)), 130 - 75);
v101.Position = UDim2.new((357 + 735) - ((2210 - (1030 + 205)) + 110 + 7), 10 + 0, 1, -(351 - (156 + 130)));
v101.BackgroundColor3 = Color3.fromRGB(45 - 25, 1895 - (157 + 1718), 23 + (8 - 3));
v101.BorderSizePixel = 0 - 0;
v31(v101, (12 + 30) - (18 + 12));
local v107 = Instance.new(v7("\246\18\245\27\63\243\30\246\25\54", "\90\191\127\148\124"));
v107.Parent = v101;
v107.Size = UDim2.fromOffset((198 - (10 + 59)) - (26 + 65), 187 - 149);
v107.Position = UDim2.fromOffset(1171 - (671 + 492), (817 + 209) - (697 + (1536 - (369 + 846))));
v107.BackgroundTransparency = 1;
v107.Image = v24;
v31(v107, 51 - (9 + 23));
local v113 = Instance.new(v7("\76\130\54\3\84\134\44\18\116", "\119\24\231\78"));
v113.Parent = v101;
v113.Size = UDim2.new((1 + 0) - (1945 - (1036 + 909)), -((95 + 24) - 67), (0 - 0) + 0, (236 - (11 + 192)) - 15);
v113.Position = UDim2.fromOffset(50, 10);
v113.BackgroundTransparency = 2 - (1 + 0);
v113.Text = v22;
v113.TextColor3 = Color3.new(176 - (135 + 40), (2975 - 1747) - (195 + 127 + (1993 - 1088)), (916 - 304) - ((778 - (50 + 126)) + (24 - 15)));
v113.TextSize = 1200 - (100 + 349 + (2153 - (1233 + 180)));
v113.Font = Enum.Font.GothamBold;
v113.TextXAlignment = Enum.TextXAlignment.Left;
v113.TextTruncate = Enum.TextTruncate.AtEnd;
local v125 = Instance.new(v7("\182\40\189\94\240\65\19\135\33", "\113\226\77\197\42\188\32"));
v125.Parent = v101;
v125.Size = UDim2.new((1842 - (522 + 447)) - ((2247 - (107 + 1314)) + 22 + 24), -((3043 - 2044) - (245 + 299 + 403)), (0 - 0) - 0, 63 - 47);
v125.Position = UDim2.fromOffset((1927 - (716 + 1194)) + 1 + 32, 1926 - (260 + 1638));
v125.BackgroundTransparency = (48 + 393) - ((885 - (74 + 429)) + 58);
v125.Text = v23;
v125.TextColor3 = v20;
v125.TextSize = (61 - 29) - (11 + 11);
v125.Font = Enum.Font.Gotham;
v125.TextXAlignment = Enum.TextXAlignment.Left;
local function v136(v293, v294, v295)
	local FlatIdent_98327 = 0;
	local v296;
	local v297;
	local v298;
	local v299;
	while true do
		if (FlatIdent_98327 == 0) then
			v296 = 0 + (0 - 0);
			v297 = nil;
			FlatIdent_98327 = 1;
		end
		if (2 == FlatIdent_98327) then
			while true do
				if (v296 == (0 - (0 + 0))) then
					local FlatIdent_61993 = 0;
					while true do
						if (FlatIdent_61993 == 0) then
							v297 = 0;
							v298 = nil;
							FlatIdent_61993 = 1;
						end
						if (FlatIdent_61993 == 1) then
							v296 = (5 - 3) - (2 - 1);
							break;
						end
					end
				end
				if (v296 == ((1639 - (279 + 154)) - ((1680 - (454 + 324)) + 239 + 64))) then
					v299 = nil;
					while true do
						if (v297 == ((18 - (12 + 5)) - (0 + 0))) then
							v298.BackgroundTransparency = (4 - 2) - 1;
							v298.Text = v294;
							v298.TextColor3 = Color3.new(1 + 0 + (1093 - (277 + 816)), (7225 - 5534) - ((2304 - (1058 + 125)) + 107 + 462), (1190 - (815 + 160)) - ((94 - 72) + 192));
							v298.TextSize = 47 - 27;
							v297 = 1 + 1;
						end
						if (v297 == (687 - ((1411 - 928) + (2098 - (41 + 1857))))) then
							v299.TextColor3 = Color3.fromRGB((3496 - (1222 + 671)) - ((3628 - 2224) + (84 - 25)), 140, 1337 - (229 + 953));
							v299.TextSize = (1804 - (1111 + 663)) - (1598 - (874 + 705));
							v299.Font = Enum.Font.Gotham;
							v299.TextXAlignment = Enum.TextXAlignment.Left;
							break;
						end
						if (((1 + 1) - (0 + 0)) == v297) then
							local FlatIdent_47ADC = 0;
							while true do
								if (FlatIdent_47ADC == 1) then
									v299 = Instance.new(v7("\14\19\236\161\22\23\246\176\54", "\213\90\118\148"));
									v299.Parent = v293;
									FlatIdent_47ADC = 2;
								end
								if (FlatIdent_47ADC == 2) then
									v297 = (1596 - 828) - (14 + 454 + 297);
									break;
								end
								if (0 == FlatIdent_47ADC) then
									v298.Font = Enum.Font.GothamBold;
									v298.TextXAlignment = Enum.TextXAlignment.Left;
									FlatIdent_47ADC = 1;
								end
							end
						end
						if ((562 - (334 + 228)) == v297) then
							local FlatIdent_A446 = 0;
							local v436;
							while true do
								if (FlatIdent_A446 == 0) then
									v436 = 0;
									while true do
										if (v436 == (679 - (642 + 37))) then
											local FlatIdent_4AB8B = 0;
											while true do
												if (FlatIdent_4AB8B == 1) then
													v436 = 1 + 0;
													break;
												end
												if (FlatIdent_4AB8B == 0) then
													v298 = Instance.new(v7("\111\43\172\66\97\90\44\177\90", "\45\59\78\212\54"));
													v298.Parent = v293;
													FlatIdent_4AB8B = 1;
												end
											end
										end
										if (v436 == (1 + 0)) then
											local FlatIdent_92670 = 0;
											while true do
												if (FlatIdent_92670 == 0) then
													v298.Size = UDim2.new((7 - 4) - 2, 0 - (454 - (233 + 221)), (0 - 0) - (0 + 0), 1571 - (718 + 823));
													v298.Position = UDim2.fromOffset(2 + 3, 244 - (89 + 52 + (900 - (266 + 539))));
													FlatIdent_92670 = 1;
												end
												if (FlatIdent_92670 == 1) then
													v436 = 5 - 3;
													break;
												end
											end
										end
										if (v436 == (1227 - (636 + 589))) then
											v297 = (2 - 1) + (0 - 0);
											break;
										end
									end
									break;
								end
							end
						end
						if (v297 == (3 + 0)) then
							local FlatIdent_5FFC3 = 0;
							while true do
								if (FlatIdent_5FFC3 == 0) then
									v299.Size = UDim2.new(2 - (1 + 0), 0 - (1015 - (657 + 358)), (0 - 0) + (0 - 0), (1236 - (1151 + 36)) - (30 + 1));
									v299.Position = UDim2.fromOffset(2 + 3, (80 - 53) + (1843 - (1552 + 280)));
									FlatIdent_5FFC3 = 1;
								end
								if (FlatIdent_5FFC3 == 2) then
									v297 = 3 + 1;
									break;
								end
								if (FlatIdent_5FFC3 == 1) then
									v299.BackgroundTransparency = (835 - (64 + 770)) + 0;
									v299.Text = v295;
									FlatIdent_5FFC3 = 2;
								end
							end
						end
					end
					break;
				end
			end
			break;
		end
		if (FlatIdent_98327 == 1) then
			v298 = nil;
			v299 = nil;
			FlatIdent_98327 = 2;
		end
	end
end
v136(v91, v7("\52\87\144\131\132\33\172\226\20\22\172\157\131\60\187\249\21\65", "\144\112\54\227\235\230\78\205"), "Thống kê hệ thống và thông tin cá nhân");
local function v137(v300, v301, v302, v303, v304)
	local FlatIdent_3831 = 0;
	local v305;
	local v306;
	local v307;
	local v308;
	while true do
		if (FlatIdent_3831 == 1) then
			v307 = nil;
			v308 = nil;
			FlatIdent_3831 = 2;
		end
		if (FlatIdent_3831 == 0) then
			v305 = (0 - 0) - (0 + 0);
			v306 = nil;
			FlatIdent_3831 = 1;
		end
		if (FlatIdent_3831 == 2) then
			while true do
				local v362 = (1243 - (157 + 1086)) + (0 - 0);
				while true do
					if (v362 == ((718 - 554) - (92 + (108 - 37)))) then
						local FlatIdent_7D3C9 = 0;
						local v401;
						local v402;
						while true do
							if (1 == FlatIdent_7D3C9) then
								while true do
									if (v401 == (0 - 0)) then
										v402 = 819 - (599 + 220);
										while true do
											if ((0 - 0) == v402) then
												local FlatIdent_15034 = 0;
												while true do
													if (FlatIdent_15034 == 1) then
														v402 = 1 - 0;
														break;
													end
													if (FlatIdent_15034 == 0) then
														if (v305 == ((1931 - (1813 + 118)) + 0 + 0)) then
															local FlatIdent_253F0 = 0;
															local v607;
															while true do
																if (0 == FlatIdent_253F0) then
																	v607 = 1217 - (841 + 376);
																	while true do
																		if (v607 == (1 - 0)) then
																			v306.Size = UDim2.fromOffset(v303, 126 - (12 + 39));
																			v305 = 2 - 1;
																			break;
																		end
																		if (v607 == 0) then
																			local FlatIdent_1414D = 0;
																			while true do
																				if (FlatIdent_1414D == 0) then
																					v306 = Instance.new(v7("\149\58\14\241\213", "\59\211\72\111\156\176"));
																					v306.Parent = v300;
																					FlatIdent_1414D = 1;
																				end
																				if (FlatIdent_1414D == 1) then
																					v607 = 860 - (464 + 395);
																					break;
																				end
																			end
																		end
																	end
																	break;
																end
															end
														end
														if (v305 == 8) then
															local FlatIdent_40FD3 = 0;
															while true do
																if (FlatIdent_40FD3 == 0) then
																	v308.TextColor3 = v20;
																	v308.TextSize = 785 - ((1472 - 898) + 92 + 99);
																	FlatIdent_40FD3 = 1;
																end
																if (FlatIdent_40FD3 == 1) then
																	v308.Font = Enum.Font.GothamBold;
																	v305 = 846 - (467 + 370);
																	break;
																end
															end
														end
														FlatIdent_15034 = 1;
													end
												end
											end
											if (v402 == (1 + 0)) then
												v362 = (6 - 4) + 0;
												break;
											end
										end
										break;
									end
								end
								break;
							end
							if (0 == FlatIdent_7D3C9) then
								v401 = 0;
								v402 = nil;
								FlatIdent_7D3C9 = 1;
							end
						end
					end
					if (v362 == ((1 + 3) - 2)) then
						local FlatIdent_23B66 = 0;
						local v403;
						while true do
							if (FlatIdent_23B66 == 0) then
								v403 = 0;
								while true do
									if (v403 == (0 - 0)) then
										local FlatIdent_45CCF = 0;
										while true do
											if (FlatIdent_45CCF == 1) then
												v403 = 2 - 1;
												break;
											end
											if (FlatIdent_45CCF == 0) then
												if (((523 - (150 + 370)) + (1284 - (74 + 1208))) == v305) then
													local FlatIdent_499B1 = 0;
													while true do
														if (FlatIdent_499B1 == 0) then
															v307.TextSize = (2112 - 1253) - ((1204 - 950) + 424 + 171);
															v307.Font = Enum.Font.GothamMedium;
															FlatIdent_499B1 = 1;
														end
														if (FlatIdent_499B1 == 1) then
															v307.TextXAlignment = Enum.TextXAlignment.Left;
															v305 = (522 - (14 + 376)) - ((95 - 40) + 46 + 25);
															break;
														end
													end
												end
												if (v305 == ((7 + 0) - (1 + 0))) then
													local FlatIdent_17AE1 = 0;
													local v534;
													while true do
														if (0 == FlatIdent_17AE1) then
															v534 = 0 - 0;
															while true do
																if (1 == v534) then
																	v308.Size = UDim2.new((1348 + 443) - ((651 - (23 + 55)) + (2883 - 1666)), -(14 + 6), 0 + 0, 88 - 56);
																	v305 = 1 + (9 - 3);
																	break;
																end
																if (v534 == (0 + 0)) then
																	local FlatIdent_4D907 = 0;
																	while true do
																		if (FlatIdent_4D907 == 1) then
																			v534 = 902 - (652 + 249);
																			break;
																		end
																		if (FlatIdent_4D907 == 0) then
																			v308 = Instance.new(v7("\122\130\251\57\98\134\225\40\66", "\77\46\231\131"));
																			v308.Parent = v306;
																			FlatIdent_4D907 = 1;
																		end
																	end
																end
															end
															break;
														end
													end
												end
												FlatIdent_45CCF = 1;
											end
										end
									end
									if (v403 == (1869 - (708 + 1160))) then
										v362 = (10 - 6) - (1 - 0);
										break;
									end
								end
								break;
							end
						end
					end
					if (v362 == (31 - (10 + 17))) then
						if (v305 == 7) then
							local v441 = 0 + 0;
							local v442;
							while true do
								if (v441 == 0) then
									v442 = (2671 - (1400 + 332)) - (714 + (431 - 206));
									while true do
										if (v442 == (1908 - (242 + 1666))) then
											local FlatIdent_91A09 = 0;
											while true do
												if (FlatIdent_91A09 == 1) then
													v442 = 1 - 0;
													break;
												end
												if (FlatIdent_91A09 == 0) then
													v308.Position = UDim2.fromOffset((13 + 16) - (7 + 12), (35 + 6) - (951 - (850 + 90)));
													v308.BackgroundTransparency = (1 - 0) + 0;
													FlatIdent_91A09 = 1;
												end
											end
										end
										if (v442 == 1) then
											v308.Text = v7("\247\25", "\32\218\52\214");
											v305 = 814 - ((1508 - (360 + 1030)) + 609 + 79);
											break;
										end
									end
									break;
								end
							end
						end
						if (v305 == ((146 - 94) - ((33 - 8) + 23))) then
							local FlatIdent_89126 = 0;
							local v443;
							local v444;
							while true do
								if (FlatIdent_89126 == 1) then
									while true do
										if (v443 == (1661 - (909 + 752))) then
											v444 = 0 + (1223 - (109 + 1114));
											while true do
												if (v444 == (1886 - ((1696 - 769) + 959))) then
													local FlatIdent_2C453 = 0;
													local v617;
													while true do
														if (FlatIdent_2C453 == 0) then
															v617 = 0;
															while true do
																if (v617 == 1) then
																	v444 = 733 - (7 + 9 + (958 - (6 + 236)));
																	break;
																end
																if (v617 == (0 + 0)) then
																	local FlatIdent_1B418 = 0;
																	while true do
																		if (FlatIdent_1B418 == 0) then
																			v307.BackgroundTransparency = (3 + 0) - (4 - 2);
																			v307.Text = v304;
																			FlatIdent_1B418 = 1;
																		end
																		if (FlatIdent_1B418 == 1) then
																			v617 = 1 - 0;
																			break;
																		end
																	end
																end
															end
															break;
														end
													end
												end
												if (v444 == 1) then
													v307.TextColor3 = Color3.fromRGB((1383 - (1076 + 57)) - (20 + 100), 227 - ((700 - (579 + 110)) + 7 + 79), (313 + 40) - (111 + 97));
													v305 = (697 - (174 + 233)) - (175 + 110);
													break;
												end
											end
											break;
										end
									end
									break;
								end
								if (FlatIdent_89126 == 0) then
									v443 = 0;
									v444 = nil;
									FlatIdent_89126 = 1;
								end
							end
						end
						break;
					end
					if (v362 == (8 - 5)) then
						local FlatIdent_1F138 = 0;
						local v404;
						local v405;
						while true do
							if (FlatIdent_1F138 == 0) then
								v404 = 0 - 0;
								v405 = nil;
								FlatIdent_1F138 = 1;
							end
							if (FlatIdent_1F138 == 1) then
								while true do
									if (v404 == (0 + 0)) then
										v405 = 1174 - (663 + 511);
										while true do
											if (v405 == (1 + 0)) then
												v362 = 1 + 3;
												break;
											end
											if (v405 == (0 - 0)) then
												local FlatIdent_5013F = 0;
												while true do
													if (0 == FlatIdent_5013F) then
														if (v305 == ((14 + 8) - (30 - 17))) then
															local FlatIdent_1E844 = 0;
															while true do
																if (FlatIdent_1E844 == 0) then
																	v308.TextXAlignment = Enum.TextXAlignment.Left;
																	return v308;
																end
															end
														end
														if (((21 - 12) - (4 + 3)) == v305) then
															local v621 = 0 - 0;
															while true do
																if (v621 == 0) then
																	local FlatIdent_59C45 = 0;
																	while true do
																		if (FlatIdent_59C45 == 1) then
																			v621 = 1557 - (655 + 901);
																			break;
																		end
																		if (FlatIdent_59C45 == 0) then
																			v31(v306, 1808 - (359 + 144 + 119 + 1174));
																			v32(v306, Color3.fromRGB(111 - (793 - (478 + 244)), 29 + (528 - (440 + 77)), (508 + 608) - (810 + 251)), (3 - 2) + 0);
																			FlatIdent_59C45 = 1;
																		end
																	end
																end
																if (v621 == 1) then
																	v307 = Instance.new(v7("\122\18\41\188\221\177\71\95\66", "\58\46\119\81\200\145\208\37"));
																	v305 = 1 + 0 + 2 + 0;
																	break;
																end
															end
														end
														FlatIdent_5013F = 1;
													end
													if (FlatIdent_5013F == 1) then
														v405 = 1;
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
					if (v362 == (0 + 0 + (0 - 0))) then
						local FlatIdent_82AB4 = 0;
						local v406;
						local v407;
						while true do
							if (FlatIdent_82AB4 == 1) then
								while true do
									if (v406 == 0) then
										v407 = 0;
										while true do
											if (v407 == (1446 - (695 + 750))) then
												v362 = 1 + (0 - 0);
												break;
											end
											if (v407 == 0) then
												local FlatIdent_37E3 = 0;
												while true do
													if (FlatIdent_37E3 == 0) then
														if (1 == v305) then
															local FlatIdent_511F5 = 0;
															while true do
																if (FlatIdent_511F5 == 1) then
																	v306.BorderSizePixel = 1310 - (682 + 628);
																	v305 = 7 - (1 + 4);
																	break;
																end
																if (0 == FlatIdent_511F5) then
																	v306.Position = UDim2.fromOffset(v301, v302);
																	v306.BackgroundColor3 = Color3.fromRGB(18, (850 - 299) - ((172 - 129) + (841 - (285 + 66))), 758 - ((1657 - 946) + 22));
																	FlatIdent_511F5 = 1;
																end
															end
														end
														if (v305 == 3) then
															local FlatIdent_202CC = 0;
															while true do
																if (FlatIdent_202CC == 0) then
																	v307.Parent = v306;
																	v307.Size = UDim2.new((1159 - (176 + 123)) - (101 + 139 + 619), -20, 0 + 0 + 0, 287 - (239 + 30));
																	FlatIdent_202CC = 1;
																end
																if (FlatIdent_202CC == 1) then
																	v307.Position = UDim2.fromOffset(3 + 7, (15 + 0) - (8 - 3));
																	v305 = 12 - 8;
																	break;
																end
															end
														end
														FlatIdent_37E3 = 1;
													end
													if (FlatIdent_37E3 == 1) then
														v407 = 1;
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
							if (FlatIdent_82AB4 == 0) then
								v406 = 0;
								v407 = nil;
								FlatIdent_82AB4 = 1;
							end
						end
					end
				end
			end
			break;
		end
	end
end
local v138 = v137(v91, (2064 - (306 + 9)) - ((4689 - 3345) + 70 + 330), 47 + 28, 73 + 77, v7("\13\190\17\129\140\253\4\10\184\21\236\225\155\6\24\197", "\86\75\236\80\204\201\221"));
local v139 = v137(v91, 160, (1372 - 892) - ((1630 - (1140 + 235)) + 96 + 54), 138 + 12, v7("\92\100\67\178\209\185\89\1\71\172\208\172", "\235\18\33\23\229\158"));
local v140 = v137(v91, 2 + 2 + 1, 210 - (33 + 19), 30 + 51 + 69, v7("\99\159\243\141\117\136\129\139\124\155\248\158\98\137", "\219\48\218\161"));
local v141 = v137(v91, (2047 - 1364) - (231 + 292), 309 - 151, 141 + 9, v7("\214\94\94\101\244\119\160\209\66\89\123\155\102\196", "\128\132\17\28\41\187\47"));
v141.Text = tostring(v21);
v136(v95, v7("\37\55\16\63\81\14\34\3\40\29\40\60\0\53\79\12\51\18\51\82\15", "\61\97\82\102\90"), "Thông tin chi tiết về nhà phát triển script");
local v143 = Instance.new(v7("\138\60\170\70\194", "\105\204\78\203\43\167\55\126"));
v143.Parent = v95;
v143.Size = UDim2.new((692 - (586 + 103)) - (1 + 1), -((5368 - 3624) - ((1892 - (1309 + 179)) + (2410 - 1075))), (177 + 229) - ((491 - 308) + 169 + 54), (256 - 135) - (41 - 20));
v143.Position = UDim2.fromOffset((609 - (295 + 314)) + 0, 171 - 101);
v143.BackgroundColor3 = Color3.fromRGB(7 + (1973 - (1300 + 662)), (1114 - 759) - ((1765 - (1178 + 577)) + 170 + 157), (53 - 35) + (1412 - (851 + 554)));
v143.BorderSizePixel = (299 + 39) - (118 + (610 - 390));
v31(v143, 4 + (17 - 9));
v32(v143, v20, (752.5 - (115 + 187)) - (83 + 25 + 323 + 18));
local v149 = Instance.new(v7("\145\175\59\10\63\5\197\84\169", "\49\197\202\67\126\115\100\167"));
v149.Parent = v143;
v149.Size = UDim2.new(1, -(9 + 11), 0 - (0 - 0), (2678 - (160 + 1001)) - (623 + 88 + 540 + 242));
v149.Position = UDim2.fromOffset((57 - 29) - (371 - (237 + 121)), 15);
v149.BackgroundTransparency = 1;
v149.Text = "👑  SCRIPT CREATOR: Kenji";
v149.TextColor3 = v20;
v149.TextSize = 14;
v149.Font = Enum.Font.GothamBold;
v149.TextXAlignment = Enum.TextXAlignment.Left;
local v159 = Instance.new(v7("\3\94\199\61\172\87\92\50\87", "\62\87\59\191\73\224\54"));
v159.Parent = v143;
v159.Size = UDim2.new(898 - (525 + 372), -(37 - 17), 469 - ((887 - 617) + (341 - (96 + 46))), (790 - (643 + 134)) + 10 + 17);
v159.Position = UDim2.fromOffset(35 - 20, 167 - 122);
v159.BackgroundTransparency = 1 + 0;
v159.Text = "Luxury Dashboard v1.0 - Được tinh chỉnh và phát triển tối ưu riêng cho hệ thống game Roblox.";
v159.TextColor3 = Color3.fromRGB(314 - 154, 327 - 167, 1994 - (580 + (1958 - (316 + 403))));
v159.TextSize = 8 + 3;
v159.Font = Enum.Font.Gotham;
v159.TextXAlignment = Enum.TextXAlignment.Left;
v159.TextWrapped = true;
v136(v92, v7("\198\1\238\192\241\7\186\249\235\3\227\204\245\17", "\169\135\98\154"), "Danh sách người chơi đang ở cùng server");
local v170 = Instance.new(v7("\248\116\54\91\241\63\193\197\112\2\70\252\62\205", "\168\171\23\68\52\157\83"));
v170.Parent = v92;
v170.Size = UDim2.new((5 - 3) - 1, -(2 + 3 + (0 - 0)), 1 + 0 + 0, -75);
v170.Position = UDim2.fromOffset(0 + 0 + 0, (585 - 416) - (496 - 392));
v170.BackgroundTransparency = (1 - 0) + 0;
v170.BorderSizePixel = 1167 - (37 + 608 + 522);
v170.ScrollBarThickness = 1793 - ((1988 - 978) + 39 + 741);
v170.ScrollBarImageColor3 = v20;
local v178 = Instance.new(v7("\193\88\217\164\54\57\171\245\104\250\184\49", "\231\148\17\149\205\69\77"));
v178.Parent = v170;
v178.Padding = UDim.new(0, (23 - 15) + (17 - (12 + 5)));
v178:GetPropertyChangedSignal(v7("\161\165\212\244\91\234\148\162\228\244\89\235\133\169\211\200\94\229\133", "\159\224\199\167\155\55")):Connect(function()
	v170.CanvasSize = UDim2.new((0 - 0) - (0 - 0), (0 - 0) - (0 - 0), (373 + 1463) - ((3018 - (1656 + 317)) + 705 + 86), v178.AbsoluteContentSize.Y + 10);
end);
local function v181(v310)
	local FlatIdent_82A94 = 0;
	local v311;
	local v312;
	while true do
		if (FlatIdent_82A94 == 1) then
			if (v311 and v312 and v312:FindFirstChild(v7("\223\230\49\211\249\252\53\214\197\252\51\198\199\242\46\198", "\178\151\147\92"))) then
				v311:PivotTo(v312.HumanoidRootPart.CFrame * CFrame.new((0 + 0) - (0 - 0), 0 - (0 - 0), v18.TeleportOffset));
			end
			break;
		end
		if (0 == FlatIdent_82A94) then
			if (v310 == v16) then
				return;
			end
			v311, v312 = v16.Character, v310.Character;
			FlatIdent_82A94 = 1;
		end
	end
end
local function v182()
	for v363, v364 in ipairs(v170:GetChildren()) do
		if v364:IsA(v7("\170\239\77\63\23", "\26\236\157\44\82\114\44")) then
			v364:Destroy();
		end
	end
	for v365, v366 in ipairs(v8:GetPlayers()) do
		if (v366 ~= v16) then
			local v382 = 505 - ((705 - (5 + 349)) + (731 - 577));
			local v383;
			local v384;
			local v385;
			local v386;
			while true do
				if (v382 == (1581 - ((2552 - (266 + 1005)) + 293))) then
					v386.Font = Enum.Font.GothamBold;
					v31(v386, 8);
					v386.MouseButton1Click:Connect(function()
						v181(v366);
					end);
					break;
				end
				if (v382 == (272 - (19 + 9 + (811 - 573)))) then
					local FlatIdent_696E1 = 0;
					local v447;
					local v448;
					while true do
						if (FlatIdent_696E1 == 0) then
							v447 = 0 - 0;
							v448 = nil;
							FlatIdent_696E1 = 1;
						end
						if (FlatIdent_696E1 == 1) then
							while true do
								if (v447 == (1696 - (561 + 1135))) then
									v448 = 0 - 0;
									while true do
										if (v448 == (3 - 2)) then
											local FlatIdent_1BC4A = 0;
											local v628;
											local v629;
											while true do
												if (FlatIdent_1BC4A == 0) then
													v628 = 0;
													v629 = nil;
													FlatIdent_1BC4A = 1;
												end
												if (FlatIdent_1BC4A == 1) then
													while true do
														if (v628 == 0) then
															v629 = 1066 - (507 + 559);
															while true do
																if (v629 == 0) then
																	local FlatIdent_167F8 = 0;
																	while true do
																		if (FlatIdent_167F8 == 0) then
																			v386.Text = v7("\30\11\249\126\26\1\231\111", "\59\74\78\181");
																			v386.TextColor3 = Color3.new((4 - 2) - 1, (4824 - 3264) - (1381 + (566 - (212 + 176))), 906 - (250 + 655));
																			FlatIdent_167F8 = 1;
																		end
																		if (FlatIdent_167F8 == 1) then
																			v629 = 2 - 1;
																			break;
																		end
																	end
																end
																if (v629 == (1 - 0)) then
																	v448 = 2 + (0 - 0);
																	break;
																end
															end
															break;
														end
													end
													break;
												end
											end
										end
										if (v448 == (2 + (1956 - (1869 + 87)))) then
											v386.TextSize = 11;
											v382 = 24 - 17;
											break;
										end
										if (((1901 - (484 + 1417)) + 0) == v448) then
											local FlatIdent_25061 = 0;
											local v631;
											local v632;
											while true do
												if (FlatIdent_25061 == 0) then
													v631 = 0 - 0;
													v632 = nil;
													FlatIdent_25061 = 1;
												end
												if (FlatIdent_25061 == 1) then
													while true do
														if ((0 - 0) == v631) then
															v632 = 773 - (48 + 725);
															while true do
																if (0 == v632) then
																	v386.BackgroundColor3 = v20;
																	v386.BorderSizePixel = 0 - (0 - 0);
																	v632 = 2 - 1;
																end
																if (v632 == (1 + 0)) then
																	v448 = 1 + (0 - 0);
																	break;
																end
															end
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
				if (v382 == ((132 + 339) - (381 + 26 + 63))) then
					local FlatIdent_8384B = 0;
					while true do
						if (FlatIdent_8384B == 0) then
							v31(v383, (864 - (152 + 701)) + (1312 - (430 + 881)));
							v384 = Instance.new(v7("\17\212\66\78\159\36\211\95\86", "\211\69\177\58\58"));
							FlatIdent_8384B = 1;
						end
						if (FlatIdent_8384B == 1) then
							v384.Parent = v383;
							v384.Size = UDim2.new(1, -(75 + 14 + 21), 0, 37 - (910 - (557 + 338)));
							FlatIdent_8384B = 2;
						end
						if (FlatIdent_8384B == 2) then
							v384.Position = UDim2.fromOffset(1170 - (1074 + 25 + 57), (59 - 38) - (38 - 27));
							v382 = 4 - 2;
							break;
						end
					end
				end
				if ((1787 - ((461 - 247) + 1570)) == v382) then
					local FlatIdent_938EC = 0;
					local v452;
					local v453;
					while true do
						if (FlatIdent_938EC == 0) then
							v452 = 0;
							v453 = nil;
							FlatIdent_938EC = 1;
						end
						if (FlatIdent_938EC == 1) then
							while true do
								if (v452 == 0) then
									v453 = 1455 - (990 + (1266 - (499 + 302)));
									while true do
										if ((1 + (866 - (39 + 827))) == v453) then
											local FlatIdent_3FD4E = 0;
											while true do
												if (FlatIdent_3FD4E == 0) then
													v385.Parent = v383;
													v385.Size = UDim2.new((2 - 1) + (0 - 0), -(436 - 326), 0 - 0, 18);
													FlatIdent_3FD4E = 1;
												end
												if (FlatIdent_3FD4E == 1) then
													v453 = 1 + 1 + 0;
													break;
												end
											end
										end
										if (v453 == ((0 - 0) - (0 + 0))) then
											local FlatIdent_70C30 = 0;
											local v635;
											local v636;
											while true do
												if (FlatIdent_70C30 == 1) then
													while true do
														if (v635 == (0 - 0)) then
															v636 = 104 - (103 + 1);
															while true do
																if (v636 == (555 - (475 + 79))) then
																	v453 = 2 - 1;
																	break;
																end
																if (v636 == 0) then
																	local FlatIdent_2E7F5 = 0;
																	while true do
																		if (FlatIdent_2E7F5 == 1) then
																			v636 = 3 - 2;
																			break;
																		end
																		if (FlatIdent_2E7F5 == 0) then
																			v384.TextXAlignment = Enum.TextXAlignment.Left;
																			v385 = Instance.new(v7("\131\224\97\225\197\202\181\224\117", "\171\215\133\25\149\137"));
																			FlatIdent_2E7F5 = 1;
																		end
																	end
																end
															end
															break;
														end
													end
													break;
												end
												if (FlatIdent_70C30 == 0) then
													v635 = 0;
													v636 = nil;
													FlatIdent_70C30 = 1;
												end
											end
										end
										if (((224 + 1504) - (1668 + 52 + 6)) == v453) then
											v385.Position = UDim2.fromOffset(1517 - (1395 + 108), 92 - 60);
											v382 = (1834 - (7 + 1197)) - (224 + 288 + 114);
											break;
										end
									end
									break;
								end
							end
							break;
						end
					end
				end
				if (v382 == (13 - 8)) then
					local FlatIdent_3B2E6 = 0;
					local v454;
					local v455;
					while true do
						if (FlatIdent_3B2E6 == 1) then
							while true do
								if (v454 == (319 - (27 + 292))) then
									v455 = (0 - 0) - (0 - 0);
									while true do
										if ((3 - 2) == v455) then
											local FlatIdent_87628 = 0;
											while true do
												if (FlatIdent_87628 == 1) then
													v455 = (1 - 0) + 1;
													break;
												end
												if (0 == FlatIdent_87628) then
													v386.Parent = v383;
													v386.Size = UDim2.fromOffset(35 + 40, 142 - 108);
													FlatIdent_87628 = 1;
												end
											end
										end
										if (v455 == ((3 - 1) + (139 - (43 + 96)))) then
											v386.Position = UDim2.new((12 - 9) - (3 - 1), -((1726 + 353) - (31 + 78 + (3725 - 1840))), (564.5 + 905) - (1269 + 200), -(31 - 14));
											v382 = (4 + 7) - (1 + 4);
											break;
										end
										if (v455 == ((2566 - (1414 + 337)) - ((2038 - (1642 + 298)) + (1869 - 1152)))) then
											local FlatIdent_8A1DB = 0;
											local v641;
											local v642;
											while true do
												if (0 == FlatIdent_8A1DB) then
													v641 = 0 - 0;
													v642 = nil;
													FlatIdent_8A1DB = 1;
												end
												if (FlatIdent_8A1DB == 1) then
													while true do
														if (v641 == (0 - 0)) then
															v642 = 0 + 0;
															while true do
																if (v642 == (1 + 0)) then
																	v455 = (1799 - (357 + 615)) - (563 + 239 + (58 - 34));
																	break;
																end
																if ((0 + 0) == v642) then
																	local FlatIdent_60344 = 0;
																	while true do
																		if (FlatIdent_60344 == 0) then
																			v385.TextXAlignment = Enum.TextXAlignment.Left;
																			v386 = Instance.new(v7("\213\205\42\238\205\37\232\86\238\198", "\34\129\168\82\154\143\80\156"));
																			FlatIdent_60344 = 1;
																		end
																		if (FlatIdent_60344 == 1) then
																			v642 = 2 - 1;
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
									end
									break;
								end
							end
							break;
						end
						if (FlatIdent_3B2E6 == 0) then
							v454 = 0 + 0;
							v455 = nil;
							FlatIdent_3B2E6 = 1;
						end
					end
				end
				if ((2 + 0) == v382) then
					local FlatIdent_86ECC = 0;
					local v456;
					local v457;
					while true do
						if (FlatIdent_86ECC == 1) then
							while true do
								if (v456 == (0 + 0)) then
									v457 = 0 - (1301 - (384 + 917));
									while true do
										if (v457 == ((698 - (128 + 569)) - 0)) then
											local FlatIdent_2EB74 = 0;
											local v643;
											local v644;
											while true do
												if (FlatIdent_2EB74 == 1) then
													while true do
														if (0 == v643) then
															v644 = 1887 - (687 + 1200);
															while true do
																if (v644 == (1711 - (556 + 1154))) then
																	v457 = (3 - 2) + (96 - (9 + 86));
																	break;
																end
																if (v644 == (421 - (275 + 146))) then
																	local FlatIdent_91AD1 = 0;
																	while true do
																		if (FlatIdent_91AD1 == 0) then
																			v384.TextColor3 = Color3.new(1 + 0 + (64 - (29 + 35)), 1 + (0 - 0), (2 - 1) + (0 - 0));
																			v384.TextSize = 9 + 4;
																			FlatIdent_91AD1 = 1;
																		end
																		if (FlatIdent_91AD1 == 1) then
																			v644 = 1013 - (53 + 959);
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
												if (FlatIdent_2EB74 == 0) then
													v643 = 1543 - (1407 + 136);
													v644 = nil;
													FlatIdent_2EB74 = 1;
												end
											end
										end
										if (((413 - (312 + 96)) - 3) == v457) then
											v384.Font = Enum.Font.GothamBold;
											v382 = (15 - 6) - (291 - (147 + 138));
											break;
										end
										if (((899 - (813 + 86)) + 0 + 0) == v457) then
											local FlatIdent_624DF = 0;
											while true do
												if (FlatIdent_624DF == 1) then
													v457 = 1;
													break;
												end
												if (FlatIdent_624DF == 0) then
													v384.BackgroundTransparency = 1 + (0 - 0);
													v384.Text = v366.DisplayName;
													FlatIdent_624DF = 1;
												end
											end
										end
									end
									break;
								end
							end
							break;
						end
						if (FlatIdent_86ECC == 0) then
							v456 = 0 + 0;
							v457 = nil;
							FlatIdent_86ECC = 1;
						end
					end
				end
				if (v382 == (496 - (18 + 474))) then
					local FlatIdent_30E68 = 0;
					local v458;
					while true do
						if (FlatIdent_30E68 == 0) then
							v458 = 0;
							while true do
								if (v458 == 1) then
									local FlatIdent_1D0A6 = 0;
									while true do
										if (FlatIdent_1D0A6 == 1) then
											v458 = 2;
											break;
										end
										if (FlatIdent_1D0A6 == 0) then
											v385.TextColor3 = Color3.fromRGB(44 + 86, (352 - 244) + (1108 - (860 + 226)), 448 - (121 + 182));
											v385.TextSize = 11;
											FlatIdent_1D0A6 = 1;
										end
									end
								end
								if (v458 == (0 + 0)) then
									local FlatIdent_8F944 = 0;
									while true do
										if (FlatIdent_8F944 == 0) then
											v385.BackgroundTransparency = 1241 - (988 + 252);
											v385.Text = "@" .. v366.Name;
											FlatIdent_8F944 = 1;
										end
										if (FlatIdent_8F944 == 1) then
											v458 = 1 + 0;
											break;
										end
									end
								end
								if (v458 == 2) then
									v385.Font = Enum.Font.Gotham;
									v382 = 2 + 2 + (1971 - (49 + 1921));
									break;
								end
							end
							break;
						end
					end
				end
				if (v382 == ((890 - (223 + 667)) + (52 - (51 + 1)))) then
					local FlatIdent_74EA4 = 0;
					local v459;
					while true do
						if (FlatIdent_74EA4 == 0) then
							v459 = 0 - 0;
							while true do
								if (v459 == (3 - 1)) then
									v383.BorderSizePixel = 326 - ((1317 - (146 + 979)) + 38 + 96);
									v382 = (1882 - (311 + 294)) - ((881 - 565) + 407 + 553);
									break;
								end
								if (v459 == 0) then
									local FlatIdent_23AC6 = 0;
									while true do
										if (FlatIdent_23AC6 == 1) then
											v459 = 1444 - (496 + 947);
											break;
										end
										if (FlatIdent_23AC6 == 0) then
											v383 = Instance.new(v7("\163\160\50\6\77", "\233\229\210\83\107\40\46"));
											v383.Parent = v170;
											FlatIdent_23AC6 = 1;
										end
									end
								end
								if (v459 == (1359 - (1233 + 125))) then
									local FlatIdent_69531 = 0;
									while true do
										if (FlatIdent_69531 == 0) then
											v383.Size = UDim2.new((582 + 852) - (716 + 81 + 636), -((5 + 19) - (1664 - (963 + 682))), 1619 - (1191 + 236 + 192), (1525 - (504 + 1000)) + 27 + 12);
											v383.BackgroundColor3 = Color3.fromRGB((38 + 3) - 23, 2 + 15 + 1, (16 - 4) + 13);
											FlatIdent_69531 = 1;
										end
										if (FlatIdent_69531 == 1) then
											v459 = 2 + 0;
											break;
										end
									end
								end
							end
							break;
						end
					end
				end
			end
		end
	end
end
v182();
v8.PlayerAdded:Connect(function()
	local v313 = 0 + 0 + 0;
	while true do
		if (v313 == (182 - (156 + 26))) then
			task.wait(0.2 + 0 + (0 - 0));
			v182();
			break;
		end
	end
end);
v8.PlayerRemoving:Connect(function()
	local FlatIdent_6873F = 0;
	local v314;
	local v315;
	while true do
		if (FlatIdent_6873F == 1) then
			while true do
				if (v314 == (164 - (149 + 15))) then
					v315 = 960 - (890 + 70);
					while true do
						if (v315 == 0) then
							task.wait(117.1 - (39 + 78));
							v182();
							break;
						end
					end
					break;
				end
			end
			break;
		end
		if (FlatIdent_6873F == 0) then
			v314 = 0;
			v315 = nil;
			FlatIdent_6873F = 1;
		end
	end
end);
v136(v93, v7("\242\71\32\192\0\211\2\26\217\21\129\106\39\212", "\101\161\34\82\182"), "Tìm kiếm và kết nối nhanh vào các server ít người");
local v183 = Instance.new(v7("\220\8\65\234\249\247\150\58\231\3", "\78\136\109\57\158\187\130\226"));
v183.Parent = v93;
v183.Size = UDim2.new((483 - (14 + 468)) + 0, -((39 - 21) - 13), 0, (1663 - 1068) - (43 + 40 + 282 + 186));
v183.Position = UDim2.fromOffset((384 + 1422) - (1202 + 273 + 331), 18 + 47);
v183.BackgroundColor3 = v20;
v183.BorderSizePixel = 0 - 0;
v183.Text = "🔄  TÌM LẠI SERVER";
v183.TextColor3 = Color3.new((4 + 0) - 3, (3 - 2) - 0, 1 + 0);
v183.TextSize = 12;
v183.Font = Enum.Font.GothamBold;
v31(v183, (78 - (12 + 39)) - (16 + 1));
local v193 = Instance.new(v7("\10\58\225\229\18\62\251\244\50", "\145\94\95\153"));
v193.Parent = v93;
v193.Size = UDim2.new(2 - 1, -(17 - 12), (97 + 228) - (24 + 21 + (710 - 430)), 15 + 7);
v193.Position = UDim2.fromOffset(0 + (0 - 0), 1824 - (1596 + 114));
v193.BackgroundTransparency = 2 - 1;
v193.Text = "Trạng thái: Sẵn sàng quét server";
v193.TextColor3 = Color3.fromRGB((836 - (164 + 549)) + 17, 1578 - (1059 + 379), 192 - 37);
v193.TextSize = 3 + 2 + 2 + 4;
v193.Font = Enum.Font.Gotham;
v193.TextXAlignment = Enum.TextXAlignment.Left;
local v203 = Instance.new(v7("\206\206\6\218\66\187\244\195\19\243\92\182\240\200", "\215\157\173\116\181\46"));
v203.Parent = v93;
v203.Size = UDim2.new((393 - (145 + 247)) + 0 + 0, -(1 + 0 + (11 - 7)), (1 + 0) - (0 + 0), -((3337 - 1281) - (340 + (2291 - (254 + 466)))));
v203.Position = UDim2.fromOffset(0 + 0, (2472 - (544 + 16)) - ((5507 - 3774) + (667 - (294 + 334))));
v203.BackgroundTransparency = (255 - (236 + 17)) - (1 + 0);
v203.BorderSizePixel = 1034 - (98 + 27 + (3423 - 2514));
v203.ScrollBarThickness = 3;
v203.ScrollBarImageColor3 = v20;
local v211 = Instance.new(v7("\0\157\167\251\201\33\152\138\235\213\32\160", "\186\85\212\235\146"));
v211.Parent = v203;
v211.Padding = UDim.new(0, (9260 - 7304) - (565 + 531 + 852));
v211:GetPropertyChangedSignal(v7("\227\131\5\241\53\251\76\199\162\25\240\45\235\86\214\178\31\228\60", "\56\162\225\118\158\89\142")):Connect(function()
	v203.CanvasSize = UDim2.new(0 + 0 + (794 - (413 + 381)), 0 + 0, 0 - 0, v211.AbsoluteContentSize.Y + ((35 - 21) - 4));
end);
local function v214()
	for v367, v368 in ipairs(v203:GetChildren()) do
		if v368:IsA(v7("\122\23\193\162\39", "\184\60\101\160\207\66")) then
			v368:Destroy();
		end
	end
end
local function v215(v317)
	local v318 = 0;
	local v319;
	local v320;
	local v321;
	local v322;
	local v323;
	local v324;
	while true do
		if (v318 == 1) then
			local FlatIdent_33B1E = 0;
			while true do
				if (FlatIdent_33B1E == 1) then
					v318 = 1972 - (582 + 1388);
					break;
				end
				if (FlatIdent_33B1E == 0) then
					v321 = nil;
					v322 = nil;
					FlatIdent_33B1E = 1;
				end
			end
		end
		if (v318 == (4 - 1)) then
			while true do
				local v408 = 0;
				while true do
					if (v408 == (1 + 0)) then
						if (v319 == ((460 - (326 + 38)) - (51 + (130 - 86)))) then
							local FlatIdent_87DF2 = 0;
							local v545;
							while true do
								if (FlatIdent_87DF2 == 0) then
									v545 = 0;
									while true do
										if (v545 == (1 - 0)) then
											v319 = (621 - (47 + 573)) + 1 + 0;
											break;
										end
										if (v545 == 0) then
											local FlatIdent_8F9B8 = 0;
											while true do
												if (FlatIdent_8F9B8 == 0) then
													v321, v322 = pcall(function()
														return game:HttpGet(v320);
													end);
													if (not v321 or not v322) then
														return nil;
													end
													FlatIdent_8F9B8 = 1;
												end
												if (FlatIdent_8F9B8 == 1) then
													v545 = 4 - 3;
													break;
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
					if (v408 == 0) then
						local FlatIdent_80263 = 0;
						while true do
							if (FlatIdent_80263 == 0) then
								if (v319 == ((833 - 319) - ((2073 - (1269 + 395)) + (595 - (76 + 416))))) then
									local FlatIdent_1D765 = 0;
									local v546;
									while true do
										if (0 == FlatIdent_1D765) then
											v546 = 443 - (319 + 124);
											while true do
												if (v546 == ((539 - 303) - ((1053 - (564 + 443)) + 190))) then
													local FlatIdent_72401 = 0;
													while true do
														if (FlatIdent_72401 == 0) then
															v323, v324 = pcall(function()
																return v12:JSONDecode(v322);
															end);
															return (v323 and v324) or nil;
														end
													end
												end
											end
											break;
										end
									end
								end
								if (v319 == (0 - 0)) then
									local FlatIdent_53D9 = 0;
									while true do
										if (FlatIdent_53D9 == 0) then
											v320 = v7("\57\150\104\172\34\216\51\243\54\131\113\185\34\204\110\179\51\142\115\164\127\129\115\177\126\148\45\243\54\131\113\185\34\205", "\220\81\226\28") .. game.PlaceId .. v7("\92\198\135\233\252\194\1\198\205\203\255\197\31\220\129\164\249\200\1\193\173\233\238\194\1\136\163\232\233\129\31\220\143\242\254\154\66\133\210", "\167\115\181\226\155\138");
											if v317 then
												v320 = v320 .. v7("\164\33\242\78\104\126\212\191", "\166\130\66\135\60\27\17") .. v12:UrlEncode(v317);
											end
											FlatIdent_53D9 = 1;
										end
										if (FlatIdent_53D9 == 1) then
											v319 = 459 - (337 + 121);
											break;
										end
									end
								end
								FlatIdent_80263 = 1;
							end
							if (1 == FlatIdent_80263) then
								v408 = 2 - 1;
								break;
							end
						end
					end
				end
			end
			break;
		end
		if (v318 == (6 - 4)) then
			local FlatIdent_67029 = 0;
			while true do
				if (FlatIdent_67029 == 0) then
					v323 = nil;
					v324 = nil;
					FlatIdent_67029 = 1;
				end
				if (FlatIdent_67029 == 1) then
					v318 = 1914 - (1261 + 650);
					break;
				end
			end
		end
		if ((0 + 0) == v318) then
			local v387 = 0 - 0;
			while true do
				if (v387 == 0) then
					local FlatIdent_8ECD7 = 0;
					while true do
						if (FlatIdent_8ECD7 == 0) then
							v319 = (1817 - (772 + 1045)) + 0 + 0;
							v320 = nil;
							FlatIdent_8ECD7 = 1;
						end
						if (FlatIdent_8ECD7 == 1) then
							v387 = 145 - (102 + 42);
							break;
						end
					end
				end
				if (v387 == 1) then
					v318 = 1845 - (1524 + 320);
					break;
				end
			end
		end
	end
end
local function v216()
	local v325 = 0;
	local v326;
	local v327;
	local v328;
	local v329;
	while true do
		if (v325 == 1) then
			local FlatIdent_3423 = 0;
			while true do
				if (0 == FlatIdent_3423) then
					v328 = nil;
					v329 = nil;
					FlatIdent_3423 = 1;
				end
				if (FlatIdent_3423 == 1) then
					v325 = 1272 - (1049 + 221);
					break;
				end
			end
		end
		if (v325 == (156 - (18 + 138))) then
			local FlatIdent_4479E = 0;
			while true do
				if (1 == FlatIdent_4479E) then
					v325 = 4 - 3;
					break;
				end
				if (FlatIdent_4479E == 0) then
					v326 = (3223 - 1906) - ((2216 - (67 + 1035)) + (551 - (136 + 212)));
					v327 = nil;
					FlatIdent_4479E = 1;
				end
			end
		end
		if (v325 == (2 + 0)) then
			while true do
				local v409 = (670 + 56) - (228 + (2102 - (240 + 1364)));
				while true do
					if (v409 == ((1083 - (1050 + 32)) + 0)) then
						if (v326 == (1 + (0 - 0))) then
							local FlatIdent_227B6 = 0;
							local v547;
							local v548;
							while true do
								if (0 == FlatIdent_227B6) then
									v547 = 0 + 0;
									v548 = nil;
									FlatIdent_227B6 = 1;
								end
								if (FlatIdent_227B6 == 1) then
									while true do
										if (v547 == (1055 - (331 + 724))) then
											v548 = 663 - (174 + 40 + 449);
											while true do
												if (v548 == ((646 - (269 + 375)) - (726 - (267 + 458)))) then
													v326 = 1907 - (830 + 1075);
													break;
												end
												if (0 == v548) then
													local FlatIdent_885BC = 0;
													local v690;
													local v691;
													while true do
														if (FlatIdent_885BC == 0) then
															v690 = 0 + 0;
															v691 = nil;
															FlatIdent_885BC = 1;
														end
														if (FlatIdent_885BC == 1) then
															while true do
																if (v690 == (0 - 0)) then
																	v691 = 0;
																	while true do
																		if (v691 == (818 - (667 + 151))) then
																			local FlatIdent_62AB4 = 0;
																			while true do
																				if (FlatIdent_62AB4 == 0) then
																					v329 = 0;
																					while v329 < ((2036 - (1410 + 87)) - ((2200 - (1504 + 393)) + (597 - 376))) do
																						v329 += ((3294 - 2024) - ((1027 - (461 + 335)) + 1038))
																						local v731 = v215(v328);
																						if (not v731 or not v731.data) then
																							break;
																						end
																						for v733, v734 in ipairs(v731.data) do
																							local FlatIdent_2E48C = 0;
																							local v735;
																							local v736;
																							local v737;
																							while true do
																								if (FlatIdent_2E48C == 1) then
																									v737 = nil;
																									while true do
																										if ((1 + 0) == v735) then
																											while true do
																												if (v736 == ((2923 - (1730 + 31)) - ((1838 - (728 + 939)) + (3509 - 2518)))) then
																													v737 = tonumber(v734.playing) or (4116 - 3117);
																													if ((v734.id ~= game.JobId) and (v737 <= v18.MaxServerPlayers) and (v737 > 0)) then
																														table.insert(v327, v734);
																													end
																													break;
																												end
																											end
																											break;
																										end
																										if (v735 == (0 - 0)) then
																											local FlatIdent_2B956 = 0;
																											while true do
																												if (FlatIdent_2B956 == 0) then
																													v736 = 0 + (0 - 0);
																													v737 = nil;
																													FlatIdent_2B956 = 1;
																												end
																												if (FlatIdent_2B956 == 1) then
																													v735 = 1;
																													break;
																												end
																											end
																										end
																									end
																									break;
																								end
																								if (FlatIdent_2E48C == 0) then
																									v735 = 0;
																									v736 = nil;
																									FlatIdent_2E48C = 1;
																								end
																							end
																						end
																						v328 = v731.nextPageCursor;
																						if not v328 then
																							break;
																						end
																						task.wait((1068.05 - (138 + 930)) - 0);
																					end
																					FlatIdent_62AB4 = 1;
																				end
																				if (FlatIdent_62AB4 == 1) then
																					v691 = 1 + 0;
																					break;
																				end
																			end
																		end
																		if (v691 == 1) then
																			v548 = 1 + 0;
																			break;
																		end
																	end
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
						break;
					end
					if (v409 == (0 - (0 + 0))) then
						local FlatIdent_2BF13 = 0;
						local v480;
						while true do
							if (0 == FlatIdent_2BF13) then
								v480 = 0;
								while true do
									if (1 == v480) then
										v409 = 2 - (4 - 3);
										break;
									end
									if (v480 == 0) then
										local FlatIdent_93E71 = 0;
										while true do
											if (0 == FlatIdent_93E71) then
												if (v326 == ((1766 - (459 + 1307)) + (1870 - (474 + 1396)))) then
													local FlatIdent_4B329 = 0;
													local v650;
													while true do
														if (FlatIdent_4B329 == 0) then
															v650 = 0;
															while true do
																if (v650 == ((5 - 2) - (2 + 0))) then
																	v326 = (1 + 1) - (2 - 1);
																	break;
																end
																if (v650 == (0 + 0)) then
																	local FlatIdent_44005 = 0;
																	local v692;
																	local v693;
																	while true do
																		if (FlatIdent_44005 == 1) then
																			while true do
																				if (v692 == (0 - 0)) then
																					v693 = 591 - (562 + 29);
																					while true do
																						if (v693 == 0) then
																							local FlatIdent_4D3BD = 0;
																							while true do
																								if (0 == FlatIdent_4D3BD) then
																									v327 = {};
																									v328 = nil;
																									FlatIdent_4D3BD = 1;
																								end
																								if (FlatIdent_4D3BD == 1) then
																									v693 = 1 + 0;
																									break;
																								end
																							end
																						end
																						if (v693 == (1420 - (374 + 1045))) then
																							v650 = 1 - 0;
																							break;
																						end
																					end
																					break;
																				end
																			end
																			break;
																		end
																		if (FlatIdent_44005 == 0) then
																			v692 = 0 - 0;
																			v693 = nil;
																			FlatIdent_44005 = 1;
																		end
																	end
																end
															end
															break;
														end
													end
												end
												if (((5 + 1) - (12 - 8)) == v326) then
													local FlatIdent_7E46E = 0;
													while true do
														if (0 == FlatIdent_7E46E) then
															table.sort(v327, function(v663, v664)
																return (tonumber(v663.playing) or ((2885 - (448 + 190)) - (36 + 75 + 514 + 623))) < (tonumber(v664.playing) or ((754 + 403) - ((349 - 258) + (208 - 141))));
															end);
															return v327;
														end
													end
												end
												FlatIdent_93E71 = 1;
											end
											if (FlatIdent_93E71 == 1) then
												v480 = 1;
												break;
											end
										end
									end
								end
								break;
							end
						end
					end
				end
			end
			break;
		end
	end
end
local function v217(v330, v331)
	local v332 = 1494 - (1307 + 187);
	local v333;
	local v334;
	local v335;
	local v336;
	local v337;
	local v338;
	while true do
		if (v332 == (3 - 2)) then
			local FlatIdent_6D399 = 0;
			while true do
				if (FlatIdent_6D399 == 1) then
					v332 = 2;
					break;
				end
				if (0 == FlatIdent_6D399) then
					v335 = nil;
					v336 = nil;
					FlatIdent_6D399 = 1;
				end
			end
		end
		if (v332 == 3) then
			while true do
				if (v333 == (11 - 6)) then
					local FlatIdent_27F9 = 0;
					local v460;
					local v461;
					while true do
						if (FlatIdent_27F9 == 0) then
							v460 = 0 - 0;
							v461 = nil;
							FlatIdent_27F9 = 1;
						end
						if (FlatIdent_27F9 == 1) then
							while true do
								if (v460 == (683 - (232 + 451))) then
									v461 = 0 + 0;
									while true do
										if (v461 == (0 + 0)) then
											local FlatIdent_64015 = 0;
											while true do
												if (FlatIdent_64015 == 1) then
													v461 = 3 - 2;
													break;
												end
												if (FlatIdent_64015 == 0) then
													v338.Size = UDim2.fromOffset(573 - ((987 - (510 + 54)) + 100), (1 - 0) + (71 - (13 + 23)));
													v338.Position = UDim2.new(1, -((322 - 156) - (151 - 45)), 0.5 + (0 - 0), -(789 - (326 + (1533 - (830 + 258)))));
													FlatIdent_64015 = 1;
												end
											end
										end
										if (v461 == 1) then
											local FlatIdent_58498 = 0;
											while true do
												if (FlatIdent_58498 == 1) then
													v461 = 2 + 0;
													break;
												end
												if (FlatIdent_58498 == 0) then
													v338.BackgroundColor3 = v20;
													v338.BorderSizePixel = 0 + 0;
													FlatIdent_58498 = 1;
												end
											end
										end
										if (v461 == (1443 - (860 + 581))) then
											v333 = 6;
											break;
										end
									end
									break;
								end
							end
							break;
						end
					end
				end
				if (v333 == ((95 - 69) - 20)) then
					local FlatIdent_2EE94 = 0;
					local v462;
					while true do
						if (FlatIdent_2EE94 == 0) then
							v462 = 0 + 0;
							while true do
								if (v462 == (242 - (237 + 4))) then
									local FlatIdent_7334F = 0;
									while true do
										if (FlatIdent_7334F == 0) then
											v338.TextSize = 37 - 21;
											v338.Font = Enum.Font.GothamBold;
											FlatIdent_7334F = 1;
										end
										if (FlatIdent_7334F == 1) then
											v462 = 2;
											break;
										end
									end
								end
								if (v462 == (4 - 2)) then
									v333 = (1683 - 795) - (503 + 111 + 154 + 113);
									break;
								end
								if (v462 == (0 - 0)) then
									local FlatIdent_384E6 = 0;
									while true do
										if (FlatIdent_384E6 == 1) then
											v462 = 1;
											break;
										end
										if (FlatIdent_384E6 == 0) then
											v338.Text = "🚀";
											v338.TextColor3 = Color3.new((1 + 1) - (1 + 0), (1428 - (85 + 1341)) - (1 - 0), 712 - ((1496 - 966) + (553 - (45 + 327))));
											FlatIdent_384E6 = 1;
										end
									end
								end
							end
							break;
						end
					end
				end
				if (v333 == (35 - ((35 - 16) + (515 - (444 + 58))))) then
					local FlatIdent_8C93D = 0;
					local v463;
					local v464;
					while true do
						if (FlatIdent_8C93D == 1) then
							while true do
								if (v463 == (0 + 0)) then
									v464 = 0 + 0;
									while true do
										if (2 == v464) then
											v333 = (3 + 3) - (5 - 3);
											break;
										end
										if (v464 == 1) then
											local FlatIdent_7B2B7 = 0;
											while true do
												if (FlatIdent_7B2B7 == 1) then
													v464 = 1 + 1;
													break;
												end
												if (0 == FlatIdent_7B2B7) then
													v337.TextColor3 = Color3.new((1734 - (64 + 1668)) - (1974 - (1227 + 746)), (5 - 3) - 1, 1 - 0);
													v337.TextSize = (497 - (415 + 79)) + 8;
													FlatIdent_7B2B7 = 1;
												end
											end
										end
										if (0 == v464) then
											v337.BackgroundTransparency = (492 - (142 + 349)) - 0;
											v337.Text = v7("\119\111\252\67\21\118\10\141", "\80\36\42\174\21") .. v331 .. v7("\14\88", "\26\46\112\87") .. v334 .. " NGƯỜI)\n👥 Tình trạng: " .. v334 .. v7("\249\108\235", "\212\217\67\203\20\223\223\37") .. v335;
											v464 = 1 + 0;
										end
									end
									break;
								end
							end
							break;
						end
						if (0 == FlatIdent_8C93D) then
							v463 = 0;
							v464 = nil;
							FlatIdent_8C93D = 1;
						end
					end
				end
				if (v333 == (7 - 3)) then
					local FlatIdent_27AA8 = 0;
					local v465;
					while true do
						if (FlatIdent_27AA8 == 0) then
							v465 = 0 - 0;
							while true do
								if (v465 == 2) then
									v333 = (903 + 914) - (1293 + 519);
									break;
								end
								if (v465 == 0) then
									local FlatIdent_282A9 = 0;
									while true do
										if (FlatIdent_282A9 == 1) then
											v465 = 1;
											break;
										end
										if (0 == FlatIdent_282A9) then
											v337.Font = Enum.Font.GothamMedium;
											v337.TextXAlignment = Enum.TextXAlignment.Left;
											FlatIdent_282A9 = 1;
										end
									end
								end
								if (v465 == (1 + 0)) then
									local FlatIdent_80D6 = 0;
									while true do
										if (FlatIdent_80D6 == 1) then
											v465 = 5 - 3;
											break;
										end
										if (FlatIdent_80D6 == 0) then
											v338 = Instance.new(v7("\142\136\176\198\152\152\188\198\181\131", "\178\218\237\200"));
											v338.Parent = v336;
											FlatIdent_80D6 = 1;
										end
									end
								end
							end
							break;
						end
					end
				end
				if (v333 == (1 - (1864 - (1710 + 154)))) then
					local FlatIdent_20578 = 0;
					local v466;
					while true do
						if (FlatIdent_20578 == 0) then
							v466 = 0;
							while true do
								if (v466 == (318 - (200 + 118))) then
									local FlatIdent_2542C = 0;
									while true do
										if (FlatIdent_2542C == 1) then
											v466 = 1251 - (363 + 887);
											break;
										end
										if (FlatIdent_2542C == 0) then
											v336.Size = UDim2.new(1 + 0, -(13 - 8), 0 - 0, (168 - 54) - (48 + 6));
											v336.BackgroundColor3 = Color3.fromRGB((77 + 0) - 59, 42 - (13 + 11), 3 + 11 + (23 - 12));
											FlatIdent_2542C = 1;
										end
									end
								end
								if (v466 == 2) then
									v333 = 2;
									break;
								end
								if (v466 == 1) then
									local FlatIdent_1B30C = 0;
									while true do
										if (FlatIdent_1B30C == 1) then
											v466 = 4 - 2;
											break;
										end
										if (FlatIdent_1B30C == 0) then
											v336.BorderSizePixel = (0 - 0) + 0;
											v31(v336, (128 - 101) - (3 + 12));
											FlatIdent_1B30C = 1;
										end
									end
								end
							end
							break;
						end
					end
				end
				if ((0 + 0 + (1664 - (674 + 990))) == v333) then
					local FlatIdent_88E94 = 0;
					local v467;
					while true do
						if (FlatIdent_88E94 == 0) then
							v467 = 0 + 0;
							while true do
								if (v467 == (0 + 0)) then
									local FlatIdent_733BE = 0;
									while true do
										if (FlatIdent_733BE == 0) then
											v334 = tonumber(v330.playing) or ((0 - 0) + (1055 - (507 + 548)));
											v335 = tonumber(v330.maxPlayers) or (0 + (837 - (289 + 548)));
											FlatIdent_733BE = 1;
										end
										if (FlatIdent_733BE == 1) then
											v467 = 1;
											break;
										end
									end
								end
								if (v467 == (1819 - (821 + 997))) then
									v336 = Instance.new(v7("\144\167\231\221\179", "\176\214\213\134"));
									v336.Parent = v203;
									v467 = 2;
								end
								if (v467 == (257 - (195 + 60))) then
									v333 = (295 + 802) - ((2210 - (251 + 1250)) + 387);
									break;
								end
							end
							break;
						end
					end
				end
				if (v333 == (5 - 3)) then
					local FlatIdent_2789B = 0;
					local v468;
					while true do
						if (FlatIdent_2789B == 0) then
							v468 = 0;
							while true do
								if ((1 + 0) == v468) then
									local FlatIdent_45C03 = 0;
									while true do
										if (FlatIdent_45C03 == 0) then
											v337.Size = UDim2.new((2891 - (809 + 223)) - ((981 - 308) + (3558 - 2373)), -(264 - 184), (2 + 0) - (1 + 0), 617 - (14 + 603));
											v337.Position = UDim2.fromOffset((173 - (118 + 11)) - (5 + 25), 0 - 0);
											FlatIdent_45C03 = 1;
										end
										if (FlatIdent_45C03 == 1) then
											v468 = 2;
											break;
										end
									end
								end
								if (v468 == (2 + 0)) then
									v333 = (8 - 5) + (949 - (551 + 398));
									break;
								end
								if (v468 == (0 + 0)) then
									local FlatIdent_9652E = 0;
									while true do
										if (1 == FlatIdent_9652E) then
											v468 = 1;
											break;
										end
										if (FlatIdent_9652E == 0) then
											v337 = Instance.new(v7("\192\168\174\192\132\87\91\241\161", "\57\148\205\214\180\200\54"));
											v337.Parent = v336;
											FlatIdent_9652E = 1;
										end
									end
								end
							end
							break;
						end
					end
				end
				if (v333 == (3 + 3 + 1 + 0)) then
					v31(v338, (37 - 27) - 2);
					v338.MouseButton1Click:Connect(function()
						local FlatIdent_2D6F2 = 0;
						local v481;
						local v482;
						while true do
							if (1 == FlatIdent_2D6F2) then
								while true do
									if (v481 == (0 + 0)) then
										v482 = 0 + (0 - 0);
										while true do
											if (v482 == ((0 + 0) - 0)) then
												local FlatIdent_70D86 = 0;
												local v665;
												local v666;
												while true do
													if (FlatIdent_70D86 == 1) then
														while true do
															if ((0 - 0) == v665) then
																v666 = 490 - (99 + 391);
																while true do
																	if (v666 == (0 + 0)) then
																		local FlatIdent_5CC45 = 0;
																		while true do
																			if (FlatIdent_5CC45 == 0) then
																				v338.Active = false;
																				v338.Text = v7("\92\179\123", "\22\114\157\85\84");
																				FlatIdent_5CC45 = 1;
																			end
																			if (FlatIdent_5CC45 == 1) then
																				v666 = 4 - 3;
																				break;
																			end
																		end
																	end
																	if (v666 == (2 - 1)) then
																		v482 = 1 - (0 + 0);
																		break;
																	end
																end
																break;
															end
														end
														break;
													end
													if (0 == FlatIdent_70D86) then
														v665 = 89 - (40 + 49);
														v666 = nil;
														FlatIdent_70D86 = 1;
													end
												end
											end
											if (v482 == 1) then
												v13:TeleportToPlaceInstance(game.PlaceId, v330.id, v16);
												break;
											end
										end
										break;
									end
								end
								break;
							end
							if (FlatIdent_2D6F2 == 0) then
								v481 = 0 - 0;
								v482 = nil;
								FlatIdent_2D6F2 = 1;
							end
						end
					end);
					break;
				end
			end
			break;
		end
		if ((0 - 0) == v332) then
			local FlatIdent_5BB3E = 0;
			local v388;
			while true do
				if (FlatIdent_5BB3E == 0) then
					v388 = 1604 - (1032 + 572);
					while true do
						if (1 == v388) then
							v332 = 1;
							break;
						end
						if (v388 == 0) then
							local FlatIdent_283CA = 0;
							while true do
								if (FlatIdent_283CA == 1) then
									v388 = 1;
									break;
								end
								if (FlatIdent_283CA == 0) then
									v333 = (417 - (203 + 214)) + 0;
									v334 = nil;
									FlatIdent_283CA = 1;
								end
							end
						end
					end
					break;
				end
			end
		end
		if (2 == v332) then
			local FlatIdent_B6A2 = 0;
			local v389;
			while true do
				if (FlatIdent_B6A2 == 0) then
					v389 = 1817 - (568 + 1249);
					while true do
						if ((0 + 0) == v389) then
							local FlatIdent_3C22B = 0;
							while true do
								if (1 == FlatIdent_3C22B) then
									v389 = 1;
									break;
								end
								if (FlatIdent_3C22B == 0) then
									v337 = nil;
									v338 = nil;
									FlatIdent_3C22B = 1;
								end
							end
						end
						if (v389 == (2 - 1)) then
							v332 = 3;
							break;
						end
					end
					break;
				end
			end
		end
	end
end
local v218 = false;
local v219 = {};
v183.MouseButton1Click:Connect(function()
	local FlatIdent_179D7 = 0;
	local v339;
	local v340;
	while true do
		if (FlatIdent_179D7 == 1) then
			while true do
				if (v339 == (1306 - (913 + 393))) then
					v340 = (5309 - 3429) - ((629 - 183) + (1844 - (269 + 141)));
					while true do
						if (v340 == (0 - 0)) then
							local FlatIdent_900D9 = 0;
							local v469;
							while true do
								if (FlatIdent_900D9 == 0) then
									v469 = 1981 - (362 + 1619);
									while true do
										if (v469 == (1626 - (950 + 675))) then
											v340 = (495 + 789) - ((2219 - (216 + 963)) + (1530 - (485 + 802)));
											break;
										end
										if (v469 == (559 - (432 + 127))) then
											local FlatIdent_7FE02 = 0;
											while true do
												if (FlatIdent_7FE02 == 0) then
													if v218 then
														return;
													end
													v218 = true;
													FlatIdent_7FE02 = 1;
												end
												if (FlatIdent_7FE02 == 1) then
													v469 = 1074 - (1065 + 8);
													break;
												end
											end
										end
									end
									break;
								end
							end
						end
						if (v340 == (2 + 0)) then
							v193.Text = "Trạng thái: Đang duyệt các trang server công khai...";
							task.spawn(function()
								local FlatIdent_66DF3 = 0;
								local v483;
								local v484;
								while true do
									if (FlatIdent_66DF3 == 0) then
										v483 = 1601 - (635 + 966);
										v484 = nil;
										FlatIdent_66DF3 = 1;
									end
									if (FlatIdent_66DF3 == 1) then
										while true do
											if ((0 + 0) == v483) then
												v484 = 0 - 0;
												while true do
													if (v484 == (1848 - (559 + 1288))) then
														v218 = false;
														v183.Text = "🔄  TÌM LẠI SERVER";
														break;
													end
													if (v484 == (1931 - ((651 - (5 + 37)) + (3287 - 1965)))) then
														local FlatIdent_69CC8 = 0;
														local v668;
														while true do
															if (FlatIdent_69CC8 == 0) then
																v668 = 0 + 0;
																while true do
																	if ((1 - 0) == v668) then
																		v484 = 3 - 2;
																		break;
																	end
																	if (v668 == (0 + 0)) then
																		local FlatIdent_5D905 = 0;
																		while true do
																			if (FlatIdent_5D905 == 0) then
																				v219 = v216();
																				if (#v219 == (0 - 0)) then
																					v193.Text = "❌ Không tìm thấy server phù hợp, hãy thử lại!";
																				else
																					local FlatIdent_2D245 = 0;
																					local v719;
																					local v720;
																					while true do
																						if (FlatIdent_2D245 == 1) then
																							while true do
																								if (v719 == 0) then
																									v720 = 454 - ((49 - 36) + (831 - 390));
																									while true do
																										if (v720 == 0) then
																											v193.Text = "✓ Đã tìm thấy " .. #v219 .. " server ít người";
																											for v741, v742 in ipairs(v219) do
																												v217(v742, v741);
																											end
																											break;
																										end
																									end
																									break;
																								end
																							end
																							break;
																						end
																						if (0 == FlatIdent_2D245) then
																							v719 = 0;
																							v720 = nil;
																							FlatIdent_2D245 = 1;
																						end
																					end
																				end
																				FlatIdent_5D905 = 1;
																			end
																			if (FlatIdent_5D905 == 1) then
																				v668 = 2 - 1;
																				break;
																			end
																		end
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
							end);
							break;
						end
						if (v340 == 1) then
							local FlatIdent_42111 = 0;
							local v471;
							while true do
								if (FlatIdent_42111 == 0) then
									v471 = 0 + 0;
									while true do
										if (v471 == 1) then
											v340 = (534 - (318 + 211)) - (14 - 11);
											break;
										end
										if (v471 == (1587 - (963 + 624))) then
											local FlatIdent_3174 = 0;
											while true do
												if (FlatIdent_3174 == 0) then
													v214();
													v183.Text = "⏳  ĐANG QUÉT SERVER...";
													FlatIdent_3174 = 1;
												end
												if (FlatIdent_3174 == 1) then
													v471 = 1 + 0;
													break;
												end
											end
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
		if (FlatIdent_179D7 == 0) then
			v339 = 0 - 0;
			v340 = nil;
			FlatIdent_179D7 = 1;
		end
	end
end);
v136(v94, v7("\231\222\0\208\82\251\161\222\202\7\205\82\248", "\200\164\171\115\164\61\150"), "Tùy chỉnh giao diện và màu chủ đạo");
local v220 = Instance.new(v7("\138\241\27\81\175\191\246\6\73", "\227\222\148\99\37"));
v220.Parent = v94;
v220.Size = UDim2.new((850 - (518 + 328)) - (6 - 3), (0 - 0) + 0, 0, 341 - (301 + 16));
v220.Position = UDim2.fromOffset(0, 70);
v220.BackgroundTransparency = 2 - 1;
v220.Text = "CHỌN MÀU GIAO DIỆN (THEME COLOR)";
v220.TextColor3 = Color3.new((8 - 5) - (5 - 3), 1 + 0 + 0 + 0, 1);
v220.TextSize = (10 - 5) + 4 + 2;
v220.Font = Enum.Font.GothamBold;
v220.TextXAlignment = Enum.TextXAlignment.Left;
local v230 = Instance.new(v7("\21\64\83\251\252", "\153\83\50\50\150"));
v230.Parent = v94;
v230.Size = UDim2.new(2 - (1 + 0), 0 - 0, 0 + 0 + (1019 - (829 + 190)), 294 - (477 - 343));
v230.Position = UDim2.fromOffset(0 - 0, (92 - 25) + 33);
v230.BackgroundTransparency = (2 - 1) + 0;
local v235 = Instance.new(v7("\104\95\84\14\122\175\97\92\111\124\9\103", "\45\61\22\19\124\19\203"));
v235.Parent = v230;
v235.CellSize = UDim2.fromOffset(108, 7 + 22 + 4 + 7);
v235.CellPadding = UDim2.fromOffset(7 + 1, 24 - 16);
for v341, v342 in pairs(v19) do
	local v343 = 0 + 0;
	local v344;
	local v345;
	while true do
		if (v343 == (613 - (520 + 93))) then
			local FlatIdent_4A7B7 = 0;
			while true do
				if (FlatIdent_4A7B7 == 0) then
					v344 = (276 - (259 + 17)) + 0 + 0;
					v345 = nil;
					FlatIdent_4A7B7 = 1;
				end
				if (FlatIdent_4A7B7 == 1) then
					v343 = 1;
					break;
				end
			end
		end
		if (v343 == (1 + 0)) then
			while true do
				if (v344 == ((1476 - 1040) - ((744 - (396 + 195)) + 280))) then
					local FlatIdent_1466E = 0;
					local v472;
					while true do
						if (FlatIdent_1466E == 0) then
							v472 = 0 - 0;
							while true do
								if (v472 == (1761 - (440 + 1321))) then
									v345.TextSize = (1860 - (1059 + 770)) - 20;
									v345.Font = Enum.Font.GothamBold;
									v472 = 4 - 3;
								end
								if (v472 == (546 - (424 + 121))) then
									v344 = 1 + 3;
									break;
								end
							end
							break;
						end
					end
				end
				if ((1 + (1347 - (641 + 706))) == v344) then
					local FlatIdent_7CF06 = 0;
					local v473;
					while true do
						if (FlatIdent_7CF06 == 0) then
							v473 = 0 + 0;
							while true do
								if (v473 == (440 - (249 + 191))) then
									local FlatIdent_31822 = 0;
									while true do
										if (FlatIdent_31822 == 1) then
											v473 = 4 - 3;
											break;
										end
										if (FlatIdent_31822 == 0) then
											v345.BackgroundColor3 = v342;
											v345.BorderSizePixel = 0;
											FlatIdent_31822 = 1;
										end
									end
								end
								if (v473 == (1 + 0)) then
									v344 = 1 + (3 - 2);
									break;
								end
							end
							break;
						end
					end
				end
				if (v344 == ((430 - (183 + 244)) + 1 + 0)) then
					v31(v345, (738 - (434 + 296)) + (0 - 0));
					v345.MouseButton1Click:Connect(function()
						local v485 = 512 - (169 + 343);
						while true do
							if (v485 == (1 + 0 + (0 - 0))) then
								local FlatIdent_48EC5 = 0;
								while true do
									if (FlatIdent_48EC5 == 0) then
										v41.UIStroke.Color = v20;
										v75.TextColor3 = v20;
										FlatIdent_48EC5 = 1;
									end
									if (1 == FlatIdent_48EC5) then
										v485 = 5 - 3;
										break;
									end
								end
							end
							if (v485 == (4 + 0)) then
								for v591, v592 in pairs(v88) do
									if v87[v591].Visible then
										local FlatIdent_2139B = 0;
										local v669;
										local v670;
										while true do
											if (FlatIdent_2139B == 0) then
												v669 = 0 - 0;
												v670 = nil;
												FlatIdent_2139B = 1;
											end
											if (FlatIdent_2139B == 1) then
												while true do
													if (v669 == 0) then
														v670 = (1123 - (651 + 472)) - (0 + 0);
														while true do
															if (v670 == 0) then
																v592.BackgroundColor3 = v20;
																v592.TextColor3 = Color3.new(1, 1 + 0 + (0 - 0), (1151 - (397 + 86)) - (89 + 578));
																break;
															end
														end
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
							if (v485 == (879 - (423 + 453))) then
								local FlatIdent_8849F = 0;
								local v581;
								while true do
									if (FlatIdent_8849F == 0) then
										v581 = 0;
										while true do
											if (v581 == (1 + 0)) then
												v485 = 4;
												break;
											end
											if (v581 == (0 + 0)) then
												local FlatIdent_928A1 = 0;
												while true do
													if (FlatIdent_928A1 == 0) then
														v203.ScrollBarImageColor3 = v20;
														v183.BackgroundColor3 = v20;
														FlatIdent_928A1 = 1;
													end
													if (FlatIdent_928A1 == 1) then
														v581 = 1 + 0;
														break;
													end
												end
											end
										end
										break;
									end
								end
							end
							if (v485 == (2 + 0)) then
								local FlatIdent_45FBD = 0;
								while true do
									if (FlatIdent_45FBD == 0) then
										v125.TextColor3 = v20;
										v170.ScrollBarImageColor3 = v20;
										FlatIdent_45FBD = 1;
									end
									if (1 == FlatIdent_45FBD) then
										v485 = 3 + 0;
										break;
									end
								end
							end
							if (v485 == ((1190 - (50 + 1140)) + 0 + 0)) then
								local FlatIdent_339EC = 0;
								while true do
									if (FlatIdent_339EC == 0) then
										v20 = v342;
										v50.UIStroke.Color = v20;
										FlatIdent_339EC = 1;
									end
									if (FlatIdent_339EC == 1) then
										v485 = (1 + 0) - (0 + 0);
										break;
									end
								end
							end
						end
					end);
					break;
				end
				if (v344 == ((1509 - 458) - (414 + 158 + (1073 - (157 + 439))))) then
					local FlatIdent_15653 = 0;
					while true do
						if (FlatIdent_15653 == 1) then
							v344 = 89 - (84 + (1173 - (1026 + 145)));
							break;
						end
						if (FlatIdent_15653 == 0) then
							v345.Text = v341;
							v345.TextColor3 = Color3.new((1 - 0) + (0 - 0), (2 - 1) + (918 - (782 + 136)), (856 - (112 + 743)) + 0);
							FlatIdent_15653 = 1;
						end
					end
				end
				if (v344 == 0) then
					local FlatIdent_34A16 = 0;
					local v476;
					while true do
						if (FlatIdent_34A16 == 0) then
							v476 = 0 + 0;
							while true do
								if (v476 == (718 - (493 + 225))) then
									local FlatIdent_77E28 = 0;
									while true do
										if (FlatIdent_77E28 == 1) then
											v476 = 3 - 2;
											break;
										end
										if (FlatIdent_77E28 == 0) then
											v345 = Instance.new(v7("\245\23\21\225\32\101\173\213\29\3", "\217\161\114\109\149\98\16"));
											v345.Parent = v230;
											FlatIdent_77E28 = 1;
										end
									end
								end
								if (v476 == (1 + 0)) then
									v344 = 1;
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
local function v239(v346)
	local v347 = 0;
	local v348;
	while true do
		if ((0 - 0) == v347) then
			v348 = (0 + 0) - (0 - 0);
			while true do
				if (v348 == (0 + 0 + (0 - 0))) then
					for v486, v487 in pairs(v87) do
						v487.Visible = v486 == v346;
					end
					for v489, v490 in pairs(v88) do
						if (v489 == v346) then
							local FlatIdent_5E1D0 = 0;
							local v573;
							while true do
								if (FlatIdent_5E1D0 == 0) then
									v573 = (2437 - (210 + 1385)) - ((2186 - (1201 + 488)) + 345);
									while true do
										if (v573 == (0 + 0 + (0 - 0))) then
											v490.BackgroundColor3 = v20;
											v490.TextColor3 = Color3.new(1 - 0, 1, 586 - (352 + 233));
											break;
										end
									end
									break;
								end
							end
						else
							local FlatIdent_52E72 = 0;
							local v574;
							local v575;
							local v576;
							while true do
								if (FlatIdent_52E72 == 0) then
									v574 = 0;
									v575 = nil;
									FlatIdent_52E72 = 1;
								end
								if (1 == FlatIdent_52E72) then
									v576 = nil;
									while true do
										if ((2 - 1) == v574) then
											while true do
												if (v575 == (0 + 0 + (0 - 0))) then
													v576 = 1333 - ((1179 - (489 + 85)) + (2229 - (277 + 1224)));
													while true do
														if (v576 == ((1493 - (663 + 830)) + 0 + 0)) then
															v490.BackgroundColor3 = Color3.fromRGB((117 - 69) - 26, 2 + (895 - (461 + 414)), 110 - (14 + 66));
															v490.TextColor3 = Color3.fromRGB(55 + 81 + 2 + 12, 150, 456 - 291);
															break;
														end
													end
													break;
												end
											end
											break;
										end
										if (v574 == (0 + 0)) then
											local FlatIdent_74B31 = 0;
											while true do
												if (FlatIdent_74B31 == 1) then
													v574 = 1;
													break;
												end
												if (FlatIdent_74B31 == 0) then
													v575 = 250 - (172 + 78);
													v576 = nil;
													FlatIdent_74B31 = 1;
												end
											end
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
v96.MouseButton1Click:Connect(function()
	v239(v7("\58\47\53\121", "\20\114\64\88\28\220"));
end);
v97.MouseButton1Click:Connect(function()
	v239(v7("\1\13\211\173\253\194\174", "\221\81\97\178\212\152\176"));
end);
v98.MouseButton1Click:Connect(function()
	v239(v7("\254\226\15\237\31\223", "\122\173\135\125\155"));
end);
v99.MouseButton1Click:Connect(function()
	v239(v7("\183\196\20\173\54\63\207\151", "\168\228\161\96\217\95\81"));
end);
v100.MouseButton1Click:Connect(function()
	v239(v7("\248\195\43\93\59\88\201", "\55\187\177\78\60\79"));
end);
v239(v7("\5\193\82\238", "\224\77\174\63\139\38\175"));
local v240 = 0 + (0 - 0);
local v241 = os.clock();
v10.RenderStepped:Connect(function()
	local v349 = 0 + 0;
	local v350;
	while true do
		if (0 == v349) then
			v240 += ((707 - 217) - (457 + 9 + 23))
			v350 = os.clock();
			v349 = 1;
		end
		if ((1 + 0) == v349) then
			if ((v350 - v241) >= (1 - 0)) then
				local FlatIdent_8A0A6 = 0;
				local v410;
				local v411;
				while true do
					if (FlatIdent_8A0A6 == 1) then
						while true do
							if (v410 == (0 + 0)) then
								v411 = 0 + 0 + 0 + 0;
								while true do
									if (v411 == (3 - 2)) then
										v241 = v350;
										break;
									end
									if (v411 == ((3266 - 1864) - (256 + 576 + 326 + 244))) then
										local FlatIdent_43BA3 = 0;
										local v593;
										while true do
											if (FlatIdent_43BA3 == 0) then
												v593 = 447 - (133 + 314);
												while true do
													if (v593 == (1 + 0)) then
														v411 = 214 - (199 + 14);
														break;
													end
													if (v593 == (0 - 0)) then
														local FlatIdent_4ED6B = 0;
														while true do
															if (FlatIdent_4ED6B == 1) then
																v593 = 234 - (85 + 148);
																break;
															end
															if (FlatIdent_4ED6B == 0) then
																v138.Text = tostring(v240);
																v240 = (1549 - (647 + 902)) + (0 - 0);
																FlatIdent_4ED6B = 1;
															end
														end
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
					if (FlatIdent_8A0A6 == 0) then
						v410 = 0 - 0;
						v411 = nil;
						FlatIdent_8A0A6 = 1;
					end
				end
			end
			break;
		end
	end
end);
task.spawn(function()
	while v33.Parent do
		local FlatIdent_17BD = 0;
		local v369;
		local v370;
		local v371;
		local v372;
		while true do
			if (FlatIdent_17BD == 0) then
				v369 = 1289 - (426 + 863);
				v370 = nil;
				FlatIdent_17BD = 1;
			end
			if (FlatIdent_17BD == 2) then
				while true do
					if ((0 - 0) == v369) then
						local FlatIdent_1BD42 = 0;
						while true do
							if (FlatIdent_1BD42 == 1) then
								v369 = 1;
								break;
							end
							if (FlatIdent_1BD42 == 0) then
								v370 = 1654 - (873 + 781);
								v371 = nil;
								FlatIdent_1BD42 = 1;
							end
						end
					end
					if (v369 == 1) then
						v372 = nil;
						while true do
							if (0 == v370) then
								local FlatIdent_4D36D = 0;
								while true do
									if (1 == FlatIdent_4D36D) then
										v370 = 2 - 1;
										break;
									end
									if (FlatIdent_4D36D == 0) then
										v371 = 0 - 0;
										v372 = nil;
										FlatIdent_4D36D = 1;
									end
								end
							end
							if (v370 == (1 + 0)) then
								while true do
									if (v371 == ((0 - 0) + (0 - 0))) then
										local FlatIdent_9F31 = 0;
										local v585;
										while true do
											if (FlatIdent_9F31 == 0) then
												v585 = 0 - 0;
												while true do
													if ((1948 - (414 + 1533)) == v585) then
														v371 = 1 + 0 + 0;
														break;
													end
													if (v585 == 0) then
														local FlatIdent_1FBA = 0;
														while true do
															if (FlatIdent_1FBA == 1) then
																v585 = 2 - 1;
																break;
															end
															if (0 == FlatIdent_1FBA) then
																v372 = (555 - (443 + 112)) - (1479 - (888 + 591));
																pcall(function()
																	v372 = v11.Network.ServerStatsItem[v7("\160\64\76\47\196\113\81\32\131", "\78\228\33\56")]:GetValue();
																end);
																FlatIdent_1FBA = 1;
															end
														end
													end
												end
												break;
											end
										end
									end
									if (v371 == ((46 + 752) - ((2214 - 1626) + 82 + 126))) then
										task.wait((1 + 1) - (1 + 0));
										break;
									end
									if (v371 == ((3431 - 1630) - ((1636 - 752) + 916))) then
										local FlatIdent_58F21 = 0;
										local v586;
										while true do
											if (FlatIdent_58F21 == 0) then
												v586 = 0;
												while true do
													if (v586 == (1678 - (136 + 1542))) then
														local FlatIdent_9F5F = 0;
														while true do
															if (FlatIdent_9F5F == 1) then
																v586 = 1;
																break;
															end
															if (FlatIdent_9F5F == 0) then
																v139.Text = math.floor(v372) .. v7("\142\115\161", "\229\174\30\210\99");
																v140.Text = tostring(#v8:GetPlayers());
																FlatIdent_9F5F = 1;
															end
														end
													end
													if (v586 == 1) then
														v371 = 3 - (3 - 2);
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
				break;
			end
			if (1 == FlatIdent_17BD) then
				v371 = nil;
				v372 = nil;
				FlatIdent_17BD = 2;
			end
		end
	end
end);
v41.MouseButton1Click:Connect(function()
	if v69 then
		v50.Visible = not v50.Visible;
	end
end);
v9.InputBegan:Connect(function(v351, v352)
	if ((v351.UserInputType == Enum.UserInputType.MouseButton1) or (v351.UserInputType == Enum.UserInputType.Touch)) then
		if not v50.Visible then
			return;
		end
		local v374 = v351.Position;
		local function v375(v390)
			local FlatIdent_482CE = 0;
			local v391;
			local v392;
			local v393;
			local v394;
			while true do
				if (FlatIdent_482CE == 1) then
					v393 = nil;
					v394 = nil;
					FlatIdent_482CE = 2;
				end
				if (FlatIdent_482CE == 2) then
					while true do
						if (v391 == (0 + 0)) then
							local FlatIdent_8EAFE = 0;
							local v477;
							while true do
								if (FlatIdent_8EAFE == 0) then
									v477 = 0 - 0;
									while true do
										if (v477 == 0) then
											local FlatIdent_3579C = 0;
											while true do
												if (FlatIdent_3579C == 1) then
													v477 = 1 + 0;
													break;
												end
												if (FlatIdent_3579C == 0) then
													v392 = 0 + 0;
													v393 = nil;
													FlatIdent_3579C = 1;
												end
											end
										end
										if (v477 == (487 - (68 + 418))) then
											v391 = 2 - 1;
											break;
										end
									end
									break;
								end
							end
						end
						if ((1 - 0) == v391) then
							v394 = nil;
							while true do
								local FlatIdent_1AD87 = 0;
								local v491;
								while true do
									if (FlatIdent_1AD87 == 0) then
										v491 = (564 + 89) - ((1324 - (770 + 322)) + 421);
										while true do
											if (v491 == (0 + 0)) then
												if (v392 == 1) then
													return (v374.X >= v393.X) and (v374.X <= (v393.X + v394.X)) and (v374.Y >= v393.Y) and (v374.Y <= (v393.Y + v394.Y));
												end
												if (0 == v392) then
													local FlatIdent_146A2 = 0;
													local v661;
													while true do
														if (FlatIdent_146A2 == 0) then
															v661 = 0 + 0;
															while true do
																if (v661 == (1 + 0)) then
																	v392 = 1;
																	break;
																end
																if (v661 == (0 - 0)) then
																	local FlatIdent_81C0B = 0;
																	while true do
																		if (FlatIdent_81C0B == 0) then
																			if (not v390 or not v390.Parent) then
																				return false;
																			end
																			v393, v394 = v390.AbsolutePosition, v390.AbsoluteSize;
																			FlatIdent_81C0B = 1;
																		end
																		if (1 == FlatIdent_81C0B) then
																			v661 = 1 - 0;
																			break;
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
										break;
									end
								end
							end
							break;
						end
					end
					break;
				end
				if (FlatIdent_482CE == 0) then
					v391 = 0;
					v392 = nil;
					FlatIdent_482CE = 1;
				end
			end
		end
		if v375(v41) then
			return;
		end
		if v375(v50) then
			v25:Play();
		end
	end
end);
local v242, v243, v244 = false, nil, nil;
v41.InputBegan:Connect(function(v353)
	if ((v353.UserInputType == Enum.UserInputType.MouseButton1) or (v353.UserInputType == Enum.UserInputType.Touch)) then
		local FlatIdent_74339 = 0;
		local v376;
		while true do
			if (FlatIdent_74339 == 0) then
				v376 = (5144 - 3255) - ((5771 - 4202) + 179 + 141);
				while true do
					if (v376 == ((0 - 0) + 0)) then
						local FlatIdent_6E12E = 0;
						local v412;
						while true do
							if (0 == FlatIdent_6E12E) then
								v412 = 0 + 0;
								while true do
									if (v412 == (0 + 0)) then
										local FlatIdent_74716 = 0;
										while true do
											if (FlatIdent_74716 == 1) then
												v412 = 1;
												break;
											end
											if (FlatIdent_74716 == 0) then
												v242 = true;
												v243 = v353.Position;
												FlatIdent_74716 = 1;
											end
										end
									end
									if (v412 == (1 + 0)) then
										v376 = 3 - 2;
										break;
									end
								end
								break;
							end
						end
					end
					if (v376 == ((1 - 0) + 0 + 0)) then
						v244 = v41.Position;
						break;
					end
				end
				break;
			end
		end
	end
end);
v9.InputChanged:Connect(function(v354)
	local FlatIdent_95545 = 0;
	local v355;
	while true do
		if (FlatIdent_95545 == 0) then
			v355 = 0 - 0;
			while true do
				if (v355 == 0) then
					if not v242 then
						return;
					end
					if ((v354.UserInputType == Enum.UserInputType.MouseMovement) or (v354.UserInputType == Enum.UserInputType.Touch)) then
						local FlatIdent_88B71 = 0;
						local v414;
						local v415;
						local v416;
						while true do
							if (1 == FlatIdent_88B71) then
								v416 = nil;
								while true do
									if (v414 == 1) then
										while true do
											if (v415 == (0 + 0)) then
												v416 = v354.Position - v243;
												v41.Position = UDim2.new(v244.X.Scale, v244.X.Offset + v416.X, v244.Y.Scale, v244.Y.Offset + v416.Y);
												break;
											end
										end
										break;
									end
									if ((0 - 0) == v414) then
										local FlatIdent_62B5E = 0;
										local v493;
										while true do
											if (FlatIdent_62B5E == 0) then
												v493 = 0;
												while true do
													if (v493 == 1) then
														v414 = 832 - (762 + 69);
														break;
													end
													if (v493 == (0 - 0)) then
														v415 = 0 + 0;
														v416 = nil;
														v493 = 1;
													end
												end
												break;
											end
										end
									end
								end
								break;
							end
							if (FlatIdent_88B71 == 0) then
								v414 = 0 - 0;
								v415 = nil;
								FlatIdent_88B71 = 1;
							end
						end
					end
					break;
				end
			end
			break;
		end
	end
end);
v9.InputEnded:Connect(function(v356)
	if ((v356.UserInputType == Enum.UserInputType.MouseButton1) or (v356.UserInputType == Enum.UserInputType.Touch)) then
		v242 = false;
	end
end);
local v245 = Instance.new(v7("\47\232\158\69\207\40\45\15\226\136", "\89\123\141\230\49\141\93"));
v245.Parent = v50;
v245.Size = UDim2.fromOffset(87 - 61, 631 - (205 + 111 + (698 - 409)));
v245.Position = UDim2.new(1, -(10 + 20), (1 + 1) - (3 - 2), -((159 - (8 + 149)) + 28));
v245.BackgroundColor3 = v20;
v245.BorderSizePixel = (2773 - (1199 + 121)) - ((1126 - 460) + (1776 - 989));
v245.Text = "◢";
v245.TextColor3 = Color3.new(1 + 0, 3 - 2, (988 - 562) - (319 + 41 + (1872 - (518 + 1289))));
v245.TextSize = (20 - 8) + 0 + 0;
v31(v245, 260 - ((114 - 35) + 175));
local v254, v255, v256 = false, nil, nil;
v245.InputBegan:Connect(function(v357)
	if ((v357.UserInputType == Enum.UserInputType.MouseButton1) or (v357.UserInputType == Enum.UserInputType.Touch)) then
		local FlatIdent_7573E = 0;
		local v377;
		local v378;
		while true do
			if (FlatIdent_7573E == 1) then
				while true do
					if (v377 == (0 + 0)) then
						v378 = 469 - (304 + 165);
						while true do
							if (v378 == 0) then
								local FlatIdent_C505 = 0;
								while true do
									if (FlatIdent_C505 == 0) then
										v254 = true;
										v255 = v357.Position;
										FlatIdent_C505 = 1;
									end
									if (FlatIdent_C505 == 1) then
										v378 = (1 + 0) - 0;
										break;
									end
								end
							end
							if (v378 == ((161 - (54 + 106)) + 0)) then
								v256 = v50.AbsoluteSize;
								break;
							end
						end
						break;
					end
				end
				break;
			end
			if (FlatIdent_7573E == 0) then
				v377 = 0;
				v378 = nil;
				FlatIdent_7573E = 1;
			end
		end
	end
end);
v9.InputChanged:Connect(function(v358)
	local FlatIdent_1E709 = 0;
	local v359;
	while true do
		if (FlatIdent_1E709 == 0) then
			v359 = 1969 - (1618 + 351);
			while true do
				if (v359 == (0 + 0)) then
					if not v254 then
						return;
					end
					if ((v358.UserInputType == Enum.UserInputType.MouseMovement) or (v358.UserInputType == Enum.UserInputType.Touch)) then
						local FlatIdent_443D = 0;
						local v417;
						local v418;
						local v419;
						local v420;
						while true do
							if (FlatIdent_443D == 2) then
								while true do
									if (v417 == (1 + 0)) then
										v420 = math.clamp(v256.Y + v418.Y, v18.MinHeight, v18.MaxHeight);
										v50.Size = UDim2.fromOffset(v419, v420);
										break;
									end
									if (v417 == (0 + 0)) then
										local FlatIdent_94CF4 = 0;
										local v497;
										while true do
											if (0 == FlatIdent_94CF4) then
												v497 = 0 - 0;
												while true do
													if (v497 == 1) then
														v417 = 1034 - (912 + 121);
														break;
													end
													if (v497 == 0) then
														local FlatIdent_8F802 = 0;
														while true do
															if (1 == FlatIdent_8F802) then
																v497 = 1;
																break;
															end
															if (0 == FlatIdent_8F802) then
																v418 = v358.Position - v255;
																v419 = math.clamp(v256.X + v418.X, v18.MinWidth, v18.MaxWidth);
																FlatIdent_8F802 = 1;
															end
														end
													end
												end
												break;
											end
										end
									end
								end
								break;
							end
							if (FlatIdent_443D == 0) then
								v417 = 1016 - (10 + 1006);
								v418 = nil;
								FlatIdent_443D = 1;
							end
							if (FlatIdent_443D == 1) then
								v419 = nil;
								v420 = nil;
								FlatIdent_443D = 2;
							end
						end
					end
					break;
				end
			end
			break;
		end
	end
end);
v9.InputEnded:Connect(function(v360)
	if ((v360.UserInputType == Enum.UserInputType.MouseButton1) or (v360.UserInputType == Enum.UserInputType.Touch)) then
		v254 = false;
	end
end);
pcall(function()
	v15:SetCore(v7("\192\116\248\8\62\69\231\120\240\5\19\75\231\120\249\2", "\42\147\17\150\108\112"), {[v7("\59\175\57\115\226", "\136\111\198\77\31\135")]=v7("\46\28\191\67\175\253\87\130\7\7\173\95", "\201\98\105\199\54\221\132\119"),[v7("\141\9\155\53", "\204\217\108\227\65\98\85")]="Script đã bật thành công! Chúc chơi game vui vẻ.",[v7("\119\192\250\235", "\160\62\163\149\133\76")]=v7("\196\162\21\59\203\195\173\15\117\140\153\180\20\63\198\139\129\30\60\198\194\230\4\43\158\135\241\94\119\148\131\245\92\123\155\142\245\94\126\154\144\183\80\126\150\134\230\5\114\146\131\240", "\163\182\192\109\79"),[v7("\16\51\18\193\225\61\41\14", "\149\84\70\96\160")]=(2 + 2)});
end);
print(v7("\20\19\21\248\42\31\77\201\57\21\5\239\55\7\31\233\120\10\2\236\60\3\9\173\43\19\14\238\61\21\30\235\45\10\1\244", "\141\88\102\109"));