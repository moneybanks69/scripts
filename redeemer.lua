local wuzz85, wuzz86, localPlayer, wuzz87, net, wuzz88, wuzz89, wuzz90, keyboardEnabled, flag18
local wuzzfn29, wuzz91, tbl18, max, flag19, wuzz92, flag20, autoRedeem, autoType, manual
local flag21, thread, wuzzn32, wuzzn33, listenKey, g, str7, tbl19, wuzz93, wuzz94
local flag22, autoListen, wuzz95, wuzz96, wuzzfn30, wuzzfn31, wuzzfn32, wuzzfn33, wuzzfn34, wuzzfn35
local wuzzfn36, wuzzfn37, wuzzfn38, wuzzfn39, wuzzfn40, wuzzfn41, tbl20, tbl21, gothamMedium, gothamBold
local gothamBlack, wuzzfn42, wuzzfn43, wuzzfn44, wuzzfn45, wuzzfn46, wuzzfn47, wuzzfn48, wuzzfn49, ScreenGui
local Main, Frame, Rag, wuzz97, wuzz98, wuzzn34, wuzz99, wuzzfn50, TextBox, wuzz100
local clear, redeem, wuzzfn51, listen, Frame2, Frame3, TextButton, wuzz101, wuzz102, wuzz103
local wuzz104, wuzz105, wuzz106, start, wuzz107, wuzz108
do  
	local visible, showKeybinds, wuzzfn52, Settings, Frame4, Frame5, words
	do
		local tbl22, Frame6
		do
			do
				local wuzz109
				do
					do
						local getupvalues_, getconnections_, setupvalue_  
						do
							do
								local writeClipboard
								do
									do
										local wuzzfn53 = cloneref or function(arg)
											return arg
										end
										local wuzz110 = wuzzfn53(game:GetService("Players"))
										wuzz85 = wuzzfn53(game:GetService("ReplicatedStorage"))  
										wuzz86 = wuzzfn53(game:GetService("UserInputService"))
										wuzz109 = wuzzfn53(game:GetService("TweenService"))
										localPlayer = wuzz110.LocalPlayer
										wuzz87 = localPlayer:WaitForChild("PlayerGui")
										net = wuzz85:WaitForChild("Packages"):WaitForChild("Net")
										wuzz88 = wuzzfn53(game:GetService("RunService"))
									end
									do
										wuzz89 = localPlayer
										wuzz90 = wuzz87  
										getupvalues_ = debug and debug.getupvalues or getupvalues
										do
											local wuzz110 = getconnections
											if wuzz110 then
												getconnections_ = wuzz110
											else
												getconnections_ = debug and debug.getconnections
											end
										end  
									end
									setupvalue_ = debug and debug.setupvalue or setupvalue
									do
										local wuzz110 = setclipboard or toclipboard
										if wuzz110 then
											writeClipboard = wuzz110
										else
											writeClipboard = syn and syn.write_clipboard
										end
									end  
								end
								do
									keyboardEnabled = wuzz86.KeyboardEnabled
									flag18 = wuzz86.TouchEnabled and not keyboardEnabled
									wuzzfn29 = function()
										if not flag18 then
											return 1
										end
										local currentCamera = workspace.CurrentCamera  
										currentCamera = currentCamera and currentCamera.ViewportSize.Y or 600
										local uiSize = _G.__RdmCfgStr and _G.__RdmCfgStr("uiSize", "MEDIUM") or "MEDIUM"
										local wuzzn35 = uiSize == "BIG" and 1.15 or uiSize == "SMALL" and 0.8 or 1
										return math.clamp(currentCamera * 0.88 / 548, 0.5, 1.3) * wuzzn35
									end
									wuzz91 = wuzzfn29()
									do
										local tbl23 = {}
										if readfile and isfile then
											local ok, result = pcall(function()  
												if isfile("redeemer_settings.txt") then
													return readfile("redeemer_settings.txt")
												end
											end)
											if ok and type(result) == "string" then
												for match in result:gmatch("[^\n]+") do
													local match2, wuzz110 = match:match("^(%w+)=(.*)$")
													if match2 then
														tbl23[match2] = wuzz110  
													end
												end
											end
										end
										_G.__RdmCfgBool = function(arg, arg2)
											local wuzz110 = tbl23[arg]
											if wuzz110 == "1" then
												return true
											end
											if wuzz110 == "0" then  
												return false
											end
											return arg2
										end
										_G.__RdmCfgStr = function(arg, arg2)
											local wuzz110 = tbl23[arg]
											local wuzz111 = "string"
											return type(wuzz110) == wuzz111 and wuzz110 ~= "" and wuzz110 or arg2
										end
										_G.__RdmCfgSet = function(arg, arg2)  
											tbl23[arg] = type(arg2) == "boolean" and (arg2 and "1" or "0") or tostring(arg2)
											if not writefile then
												return
											end
											local tbl24 = {}
											for k, wuzz110 in pairs(tbl23) do
												tbl24[#tbl24 + 1] = k .. "=" .. tostring(wuzz110)
											end
											table.sort(tbl24)  
											pcall(writefile, "redeemer_settings.txt", table.concat(tbl24, "\n"))
										end
									end
								end
								do
									tbl18 = {
										listenKey = Enum.KeyCode.F,
																			}
									tbl22 = { MAX = 0.06 }  
									max = tbl22[_G.__RdmCfgStr("speed", "MAX")] or tbl22.MAX
									flag19 = _G.__RdmCfgBool("wordMode", false)
									wuzz92 = 0.2
									flag20 = false
									autoRedeem = _G.__RdmCfgBool("autoRedeem", true)
									autoType = _G.__RdmCfgBool("autoType", true)
									manual = _G.__RdmCfgBool("manual", false)
									flag21 = false
									thread = nil  
									wuzzn32 = 0
									wuzzn33 = 1
									listenKey = tbl18.listenKey
									g = Enum.KeyCode.G
									str7 = nil
									tbl19 = {}
									wuzz93 = nil
									wuzz94 = nil
									flag22 = false
									autoListen = _G.__RdmCfgBool("autoListen", true)  
									wuzz95 = _G.__RdmCfgBool("spamOnListen", true)
									showKeybinds = _G.__RdmCfgBool("showKeybinds", keyboardEnabled)
									wuzz96 = _G.__RdmCfgBool("ignoreSystem", true)
									_G.__RdmDuo = _G.__RdmCfgBool("duo", false)
									_G.__SabClassifyDrop = function(arg)
										local str8 = tostring(arg or "")
										local str9 = str8:lower()
										local tbl23 = {}
										for match in str8:gmatch("[%w']+") do  
											tbl23[#tbl23 + 1] = match
										end
										local wuzzn35 = #tbl23
										if wuzzn35 == 0 then
											return nil
										end
										local str10 = " " .. str9:gsub("[^%w]", " ") .. " "
										if str9:find("?", 1, true) then
											return "riddle"
										end  
										for _, wuzz110 in ipairs({
											" what ",
											" how ",
											" which ",
											" whose ",
											" when ",
											" who ",
											" whats ",
											" where ",  
											" why ",
											" guess ",
											" riddle ",
											" answer ",
										}) do
											if str10:find(wuzz110, 1, true) then
												return "riddle"
											end
										end
										if str10:find(" my ", 1, true) then  
											return "riddle"
										end
										local flag23 = wuzzn35 >= 2
										local pos
										if flag23 then
											pos = str10:find(" plus ", 1, true) or str9:find("+", 1, true)
										else
											pos = flag23
										end
										if pos then  
											return "riddle"
										end
										if wuzzn35 >= 4 and str10:find(" and ", 1, true) then
											return "riddle"
										end
										if str9:find("code", 1, true) then
											return "code"
										end
										for _, wuzz110 in ipairs({ " redeem ", " type ", " enter ", " claim " }) do  
											if str10:find(wuzz110, 1, true) then
												return "code"
											end
										end
										if wuzzn35 >= 7 then
											return "riddle"
										end
										if wuzzn35 == 1 then
											return "code"  
										end
										if wuzzn35 <= 3 then
											local wuzz110 = 0
											for _, wuzz111 in ipairs(tbl23) do
												if #wuzz111 >= 3 and (wuzz111 == wuzz111:upper() and wuzz111:match("%a") or wuzz111:match("%d")) then
													wuzz110 += 1
												end
											end
											if wuzz110 == wuzzn35 then
												return "code"  
											end
										end
										return nil
									end
									wuzzfn30 = nil
									wuzzfn52 = nil
									wuzzfn31 = nil
									wuzzfn32 = nil
									wuzzfn33 = function(arg)  
										if type(arg) ~= "string" then
											return tostring(arg)
										end
										return (arg:gsub("<[^>]->", ""))
									end
									wuzzfn34 = function(arg)
										return (arg or ""):gsub("^%s+", ""):gsub("%s+$", "")
									end
									wuzzfn35 = function(arg)  
										if not writeClipboard then
											return false
										end
										return (pcall(writeClipboard, arg))
									end
									wuzzfn36 = function(arg)
										local tbl23 = {}
										for match in arg:gmatch("[%w_]+") do
											tbl23[#tbl23 + 1] = match
										end  
										return tbl23
									end
									wuzzfn37 = function(arg)
										local wuzz110 = nil
										for match in arg:gmatch("[%w_]+") do
											if #match >= 4 and match:match("%a") and (match:match("%u") or match:match("%d")) then
												wuzz110 = match
											end
										end  
										if wuzz110 then
											return wuzz110
										end
										for match in arg:gmatch("[%w_]+") do
											if #match >= 4 then
												return match
											end
										end
									end
									do
										local tbl23 = {
											leads = {
												"use",
												"using",
												"redeem",
												"type",
												"enter",
												"claim",
												"with",  
												"grab",
												"got",
												"here is",
												"heres",
												"here's",
												"there is",
												"theres",
												"there's",
											},
											articles = {  
												"",
												"the%s+",
												"a%s+",
												"an%s+",
												"this%s+",
												"your%s+",
												"new%s+",
											},
											patterns = {
												"code%s+is",  
												"codes?%s+are",
												"code%s+for",
												"code%s+to%s+use",
												"code%s*[:%-]",
												"new%s+code",
												"free%s+code",
												"secret%s+code",
												"working%s+code",
												"another%s+code",
											},  
										}
										for _, lead in ipairs(tbl23.leads) do
											local str8 = lead:gsub("%s+", "%%s+")
											for _, article in ipairs(tbl23.articles) do
												tbl23.patterns[#tbl23.patterns + 1] = str8 .. "%s+" .. article .. "code"
											end
										end
										tbl23.names = { "sammy" }
										local function wuzzfn53(arg)  
											for match, match2 in arg:gmatch("()([%w_]+)") do
												if #match2 >= 4 and match2:match("%a") and (match2:match("%u") or match2:match("%d")) then
													return arg:sub(match)
												end
											end
										end
										wuzzfn38 = function(arg)
											local str8 = arg:lower()
											local wuzz110 = nil  
											local wuzz111 = nil
											local function wuzzfn54(arg2, arg3, arg4)
												local wuzzn35 = 1
												while true do
													local ok, result, result2 = pcall(string.find, str8, arg2, wuzzn35, arg3)
													if not (not ok or not result) then
														if not wuzz110 or result2 > wuzz110 then
															wuzz110 = result2
															wuzz111 = arg4
														end  
														wuzzn35 = result2 + 1
														continue
													end
													break
												end
											end
											for _, pattern in ipairs(tbl23.patterns) do
												wuzzfn54(pattern, false, false)
											end  
											if str8:find("code") then
												for _, name in ipairs(tbl23.names) do
													local wuzz112 = true
													wuzzfn54(name:lower(), wuzz112, true)
												end
											end
											if not wuzz110 then
												return nil
											end
											local str9 = arg:sub(wuzz110 + 1)  
											local wuzz112 = wuzzfn53(str9)
											if wuzz111 then
												return wuzz112
											end
											return wuzz112 or ""
										end
									end
								end
							end  
							do
								local function wuzzfn53(arg)
									if not getupvalues_ then
										return {}
									end
									local ok, result = pcall(getupvalues_, arg)
									local tbl23 = {}
									if ok and result then
										for _, wuzz110 in pairs(result) do
											if typeof(wuzz110) == "Instance" and (wuzz110:IsA("RemoteEvent") or wuzz110:IsA("RemoteFunction") or wuzz110:IsA("UnreliableRemoteEvent")) and wuzz110.Parent == net then  
												table.insert(tbl23, wuzz110)
											end
										end
									end
									return tbl23
								end
								wuzzfn39 = function()
									local ok, result = pcall(function()
										return require(wuzz85.Controllers:FindFirstChild("NotificationController", true))  
									end)
									if ok then
										local wuzz110 = "table"
										ok = type(result) == wuzz110
									end
									if ok then
										local wuzz110 = "function"
										ok = type(result.Start) == wuzz110
									end
									if ok then
										return wuzzfn53(result.Start)[1]
									end
								end
							end
						end
						do
							local wuzzfn53, wuzzfn54
							do
								wuzzfn53 = function()  
									local codes = wuzz87:FindFirstChild("Codes")
									if not codes then
										return nil
									end
									local wuzz110 = (codes:FindFirstChild("Codes") or codes):FindFirstChild("Main")
									wuzz110 = wuzz110 and wuzz110:FindFirstChild("TextBox")
									if wuzz110 and wuzz110:IsA("TextBox") then
										return wuzz110
									end  
									for _, descendant in ipairs(codes:GetDescendants()) do
										if descendant:IsA("TextBox") then
											return descendant
										end
									end
								end
								do
									local function wuzzfn55()
										local codes = wuzz87:FindFirstChild("Codes")
										if not codes then  
											return nil
										end
										local codes2 = codes:FindFirstChild("Codes") or codes
										local confirm = (codes2:FindFirstChild("Main") or codes2):FindFirstChild("Confirm")
										if confirm and (confirm:IsA("ImageButton") or confirm:IsA("TextButton")) then
											return confirm
										end
										local wuzz110 = nil
										for _, descendant in ipairs(codes:GetDescendants()) do  
											if descendant:IsA("ImageButton") or descendant:IsA("TextButton") then
												local str8 = descendant.Name:lower()
												if str8:find("confirm") or str8:find("submit") or str8:find("redeem") or str8:find("enter") then
													return descendant
												end
												wuzz110 = wuzz110 or descendant
											end
										end
										return wuzz110
									end  
									local wuzzfn56 = nil
									wuzzfn56 = function(arg, arg2)
										if not (arg and setupvalue_ and getupvalues_) then
											return
										end
										arg2 = arg2 or 1
										local ok, result = pcall(getupvalues_, arg)
										if ok and type(result) == "table" then
											for k, wuzz110 in pairs(result) do  
												local wuzz111 = "boolean"
												if type(wuzz110) == wuzz111 then
													pcall(setupvalue_, arg, k, false)
												else
													local wuzz112 = "function"
													if type(wuzz110) == wuzz112 and arg2 > 0 then
														wuzzfn56(wuzz110, arg2 - 1)
													end
												end
											end  
										end
									end
									local function wuzzfn57(arg, ...)
										if not getconnections_ then
											return false
										end
										local ok, result = pcall(getconnections_, arg)
										local flag23 = not ok
										if not flag23 then  
											local wuzz110 = "table"
											flag23 = type(result) ~= wuzz110
										end
										if flag23 or #result == 0 then
											return false
										end
										local wuzz110 = table.pack(...)
										local wuzz111, wuzz112, wuzz113 = ipairs(result)
										local flag24 = false  
										for _, wuzz114 in wuzz111, wuzz112, wuzz113 do
											if wuzz114.Enabled ~= false then
												local function_ = nil
												pcall(function()
													function_ = wuzz114.Function
												end)
												wuzzfn56(function_)
												local ok2
												if function_ then
													ok2 = pcall(task.spawn, function_, table.unpack(wuzz110, 1, wuzz110.n))  
												else
													ok2 = pcall(function()
														wuzz114:Fire(table.unpack(wuzz110, 1, wuzz110.n))
													end)
												end
												flag24 = flag24 or ok2
											end
										end
										return flag24  
									end
									wuzzfn40 = function(text)
										if type(text) ~= "string" or text == "" then
											return
										end
										local wuzz110 = wuzzfn53()
										if not wuzz110 then
											return
										end  
										pcall(function()
											if wuzz110.Text ~= text then
												wuzz110.Text = text
											end
										end)
									end
									wuzzfn54 = function(text)
										if not getconnections_ then
											return false, "no getconnections"
										end  
										local wuzz110 = wuzzfn53()
										if not wuzz110 then
											return false, "code box not found"
										end
										pcall(function()
											wuzz110.Text = text
											wuzz110.Active = true
											wuzz110.Selectable = true
										end)
										local wuzz111 = wuzzfn55()  
										local flag23 = false
										if wuzz111 then
											local flag24 = wuzzfn57(wuzz111.MouseButton1Click)
											flag24 = flag24 or false
											flag23 = wuzzfn57(wuzz111.Activated) or flag24
										end
										if not flag23 then
											flag23 = wuzzfn57(wuzz110.FocusLost, true) or flag23
										end  
										return flag23, flag23 and "submitted" or "no submit control"
									end
								end
							end
							do
								local function wuzzfn55(text)
									local wuzz110 = wuzzfn53()
									if not wuzz110 then
										return false, "code box not found"
									end  
									if not pcall(function()
										wuzz110.Text = text
										wuzz110:CaptureFocus()
									end) then
										return false, "focus failed"
									end
									task.wait(0.1)
									local ok = pcall(function()
										wuzz110:ReleaseFocus(true)
									end)  
									return ok, ok and "submitted" or "release failed"
								end
								wuzzfn41 = function(arg)
									local wuzz110, wuzz111 = wuzzfn54(arg)
									if wuzz110 then
										return true, wuzz111
									end
									if getconnections_ then
										return false, wuzz111
									end  
									return wuzzfn55(arg)
								end
							end
						end
					end
					tbl20 = {
						ready = false,
						why = "EventController unavailable",
						IsBlocked = function()  
							return false
						end,
					}
					do
						local function wuzzfn53(arg)
							local wuzz110 = wuzz85:FindFirstChild("Controllers")
							wuzz110 = wuzz110 and wuzz110:FindFirstChild(arg, true)
							if not (wuzz110 and wuzz110:IsA("ModuleScript")) then
								return nil
							end  
							local ok, result = pcall(require, wuzz110)
							if ok and type(result) == "table" then
								return result
							end
						end
						local EventController = wuzzfn53("EventController")
						local EffectController = wuzzfn53("EffectController")
						local flag23 = EventController and type(EventController.Events) == "table"
						if flag23 then  
							local wuzz110 = "function"
							flag23 = type(EventController.Execute) == wuzz110
						end
						if not flag23 then
							tbl20.why = "EventController missing Events/Execute"
						else
							local brainrotEventTool, wuzz110, wuzzfn54, wuzzfn55, wuzzfn56, wuzzfn57, wuzzfn58
							do
								do  
									brainrotEventTool = _G.__BrainrotEventTool
									if not brainrotEventTool then
										brainrotEventTool = {}
										_G.__BrainrotEventTool = brainrotEventTool
									end
									brainrotEventTool.origExecute = brainrotEventTool.origExecute or EventController.Execute
									brainrotEventTool.origGetActive = brainrotEventTool.origGetActive or EventController.GetActiveEvents
									if EffectController then
										brainrotEventTool.origRun = brainrotEventTool.origRun or EffectController.Run
									end  
									brainrotEventTool.fakes = brainrotEventTool.fakes or {}
									brainrotEventTool.capture = brainrotEventTool.capture or {}
									brainrotEventTool.spawned = brainrotEventTool.spawned or {}
									brainrotEventTool.clearedAttrs = brainrotEventTool.clearedAttrs or {}
									brainrotEventTool.stashed = brainrotEventTool.stashed or {}
									if brainrotEventTool.blocked == nil then
										brainrotEventTool.blocked = false
									end
									tbl20.S = brainrotEventTool  
									tbl20.IsBlocked = function()
										return brainrotEventTool.blocked and true or false
									end
									wuzz110 = nil
									do
										local getupvalue_ = debug and debug.getupvalue
										if getupvalue_ then
											local ok, result = pcall(getupvalue_, brainrotEventTool.origExecute, 5)
											if ok and type(result) == "table" then  
												wuzz110 = result
											end
										end
									end
								end
								if not brainrotEventTool.shimmed then
									EventController.GetActiveEvents = function(arg)
										local tbl23 = {}
										if not brainrotEventTool.blocked then
											local ok, result = pcall(brainrotEventTool.origGetActive, arg)  
											if ok and type(result) == "table" then
												for _, wuzz112 in pairs(result) do
													tbl23[#tbl23 + 1] = wuzz112
												end
											end
										end
										for _, fake in pairs(brainrotEventTool.fakes) do
											tbl23[#tbl23 + 1] = fake
										end  
										return tbl23
									end
									brainrotEventTool.shimmed = true
								end
								wuzzfn54 = function()
									local wuzz111 = wuzzfn53("LightingController")
									if wuzz111 and type(wuzz111.Update) == "function" then
										pcall(function()
											wuzz111:Update()  
										end)
									end
									local SoundController = wuzzfn53("SoundController")
									local flag24
									if SoundController then
										local wuzz112 = "function"
										flag24 = type(SoundController.UpdateOST) == wuzz112
									else
										flag24 = SoundController
									end  
									if flag24 then
										pcall(function()
											SoundController:UpdateOST()
										end)
									end
								end
								wuzzfn55 = function(arg)
									return arg:IsA("Sky") or arg:IsA("Atmosphere") or arg:IsA("Clouds") or arg:IsA("PostEffect")
								end
								wuzzfn56 = function()  
									local flag24 = EffectController
									if EffectController then
										local wuzz111 = "table"
										flag24 = type(EffectController.ActiveEffects) == wuzz111
									end
									if not flag24 then
										return 0
									end
									local tbl23 = {}
									for k in pairs(EffectController.ActiveEffects) do  
										tbl23[#tbl23 + 1] = k
									end
									for _, wuzz111 in ipairs(tbl23) do
										local wuzz112 = "table"
										local flag25 = type(EffectController.Effects) == wuzz112 and EffectController.Effects[wuzz111] or nil
										EffectController.ActiveEffects[wuzz111] = nil
										if type(flag25) == "table" then
											local wuzz113 = "function"
											if type(flag25.OnUpdate) == wuzz113 then  
												pcall(function()
													flag25:OnUpdate()
												end)
											end
											if type(flag25.OnStop) == "function" then
												pcall(function()
													flag25:OnStop()
												end)
											end
										end
									end
									return #tbl23
								end
								do
									local tbl23 = {
										EventsLoaded = true,
										NextCrystalEvent = true,
										CrystalEventLastTime = true,
										SantaMerchantStockId = true,  
										SantaMerchantNextStockId = true,
										FuseMachineLuck = true,
										FuseMachineLuckTimer = true,
									}
									local tbl24 = {
										"AyMiGatitoEvent",
										"ChicleteiraBicicleteiraEvent",
										"EasterEvent",
										"ExtinctEvent",
										"IndonesiaEvent",  
										"MeowlEvent",
										"MexicoEvent",
										"RipMyGrannyEvent",
										"SkibidiEvent",
										"StPatricksEvent",
										"StrawberryEvent",
										"TrickOrTreatEvent",
										"ValentinesEvent",
										"YinYangEvent",
										"WitchingHourEvent",  
									}
									local tbl25 = {
										"Lighting",
										"WallRecolor",
										"Atmosphere",
									}
									wuzzfn57 = function()
										if not (EffectController and type(EffectController.Effects) == "table") then
											return
										end  
										for _, wuzz111 in ipairs(tbl25) do
											local wuzz112 = EffectController.Effects[wuzz111]
											local flag24
											if wuzz112 then
												local wuzz113 = "function"
												flag24 = type(wuzz112.OnUpdate) == wuzz113
											else
												flag24 = wuzz112
											end
											if flag24 then
												pcall(function()
													wuzz112:OnUpdate()
												end)
											end
										end
									end
									wuzzfn58 = function()
										local tbl26 = {}
										for _, wuzz111 in ipairs(tbl24) do  
											tbl26[wuzz111] = true
										end
										local wuzz111 = 0
										for k, wuzz112 in pairs(wuzz85:GetAttributes()) do
											local wuzz113 = "string"
											local flag24 = type(k) == wuzz113 and wuzz112 == true and not tbl23[k]
											local pos
											if flag24 then
												pos = tbl26[k] or k:find("Event") or k:find("Phase") or k:find("Hour")  
											else
												pos = flag24
											end
											if pos then
												pcall(function()
													wuzz85:SetAttribute(k, nil)
												end)
												brainrotEventTool.clearedAttrs[k] = true
												wuzz111 += 1
											end  
										end
										wuzzfn57()
										return wuzz111
									end
								end
							end
							do
								local function wuzzfn59()
									local wuzzn35 = 0
									for k in pairs(brainrotEventTool.clearedAttrs) do  
										pcall(function()
											wuzz85:SetAttribute(k, true)
										end)
										wuzzn35 += 1
									end
									table.clear(brainrotEventTool.clearedAttrs)
									wuzzfn57()
									return wuzzn35
								end  
								local function wuzzfn60()
									local wuzzn35 = 0
									for _, descendant in ipairs(workspace:GetDescendants()) do
										if descendant:IsA("Sound") and descendant.Playing and descendant.Looped then
											pcall(function()
												descendant:Stop()
											end)
											wuzzn35 += 1
										end
									end  
									return wuzzn35
								end
								local function wuzzfn61()
									local wuzzn35 = 0
									for k, wuzz111 in pairs(brainrotEventTool.stashed) do
										if typeof(k) == "Instance" then
											pcall(function()
												k.Parent = wuzz111
											end)  
											wuzzn35 += 1
										end
										brainrotEventTool.stashed[k] = nil
									end
									return wuzzn35
								end
								local function wuzzfn62()
									local effects = _G.Effects
									if type(effects) == "table" and type(effects.Block) == "function" and type(effects.Unblock) == "function" then
										return effects  
									end
								end
								tbl20.Block = function()
									local wuzz111 = wuzzfn62()
									if wuzz111 then
										wuzz111.Block()
										brainrotEventTool.blocked = true
										return true, "blocked (effects panel)"
									end  
									local wuzzn35 = 0
									for k, event in pairs(EventController.Events) do
										if type(event) == "table" and rawget(event, "Active") then
											if not (type(EventController.Cancel) == "function" and pcall(function()
												return EventController:Cancel(k)
											end)) then
												rawset(event, "Active", false)
												rawset(event, "__started", false)
											end  
											wuzzn35 += 1
										end
									end
									local wuzz112 = wuzzfn56()
									for k, wuzz113 in pairs(brainrotEventTool.capture) do
										local flag24 = type(wuzz113) == "table"
										if flag24 then
											local wuzz114 = "table"
											flag24 = type(wuzz113.caught) == wuzz114
										end  
										if flag24 then
											for k2 in pairs(wuzz113.caught) do
												local wuzz114 = "Instance"
												if typeof(k2) == wuzz114 and k2.Parent and not wuzzfn55(k2) then
													pcall(function()
														k2:Destroy()
													end)
												end
											end  
										end
										brainrotEventTool.capture[k] = nil
									end
									table.clear(brainrotEventTool.spawned)
									table.clear(brainrotEventTool.fakes)
									if wuzz110 then
										for k, wuzz113 in pairs(wuzz110) do
											local wuzz114 = "table"
											if type(wuzz113) == wuzz114 then
												for _, wuzz115 in ipairs(wuzz113) do  
													if typeof(wuzz115) == "Instance" and not wuzzfn55(wuzz115) then
														pcall(function()
															wuzz115:Destroy()
														end)
													end
												end
											end
											wuzz110[k] = nil
										end  
									end
									EventController.Execute = function()
										return false
									end
									if EffectController then
										EffectController.Run = function()
											return false, false
										end
									end
									brainrotEventTool.blocked = true  
									wuzzfn54()
									wuzzfn58()
									local wuzz113 = wuzzfn60()
									return true, ("blocked %d event(s), %d fx, %d sound(s)"):format(wuzzn35, wuzz112, wuzz113)
								end
								tbl20.Unblock = function()
									local wuzz111 = wuzzfn62()
									if wuzz111 then
										wuzz111.Unblock()  
										brainrotEventTool.blocked = false
										return true, "unblocked (effects panel)"
									end
									EventController.Execute = brainrotEventTool.origExecute
									if EffectController and brainrotEventTool.origRun then
										EffectController.Run = brainrotEventTool.origRun
									end
									brainrotEventTool.blocked = false
									local wuzz112 = wuzzfn59()  
									local wuzz113 = wuzzfn61()
									wuzzfn54()
									return true, ("unblocked - %d flag(s), %d model(s) restored"):format(wuzz112, wuzz113)
								end
							end
							tbl20.ready = true
							tbl20.why = nil
						end
					end
				end  
				local wuzz110
				do
					do
						tbl21 = {
							bg = Color3.fromRGB(11, 6, 23),
							panel = Color3.fromRGB(23, 12, 45),
							panel2 = Color3.fromRGB(40, 21, 72),
							line = Color3.fromRGB(91, 48, 142),
							acc = Color3.fromRGB(156, 76, 255),
							acc2 = Color3.fromRGB(95, 40, 185),  
							accHi = Color3.fromRGB(207, 146, 255),
							txt = Color3.fromRGB(248, 240, 255),
							sub = Color3.fromRGB(181, 158, 218),
							ok = Color3.fromRGB(55, 195, 105),
							err = Color3.fromRGB(205, 50, 50),
							warn = Color3.fromRGB(255, 215, 0),
							input = Color3.fromRGB(17, 9, 33),
							dark = Color3.fromRGB(8, 4, 20),
						}
						gothamMedium = Enum.Font.GothamMedium
						gothamBold = Enum.Font.GothamBold
						gothamBlack = Enum.Font.GothamBlack
						wuzzfn42 = function(arg, arg2, parent)
							local instance = Instance.new(arg)
							local wuzz111 = pairs
							local tbl23 = arg2 or {}
							for k, wuzz112 in wuzz111(tbl23) do
								instance[k] = wuzz112
							end  
							if parent then
								instance.Parent = parent
							end
							return instance
						end
						wuzzfn43 = function(arg, arg2)
							wuzzfn42("UICorner", { CornerRadius = UDim.new(0, arg2 or 8) }, arg)
						end
						wuzzfn44 = function(arg, arg2, arg3, arg4)  
							return wuzzfn42("UIStroke", { Color = arg2 or tbl21.line, Thickness = arg3 or 1, Transparency = arg4 or 0 }, arg)
						end
						wuzzfn45 = function(arg, arg2, arg3, arg4)
							wuzz109:Create(arg, TweenInfo.new(arg2, arg4 or Enum.EasingStyle.Quad), arg3):Play()
						end
						do
							local function wuzzfn53(arg, arg2, arg3, arg4)
								return wuzzfn42("UIGradient", { Color = ColorSequence.new(arg2, arg3), Rotation = arg4 or 90 }, arg)
							end
							wuzzfn46 = function(arg, arg2, arg3, arg4, arg5, arg6)  
								return wuzzfn42("TextLabel", {
									BackgroundTransparency = 1,
									Text = arg,
									Font = arg4 or gothamMedium,
									TextSize = arg2 or 12,
									TextColor3 = arg3 or tbl21.txt,
									TextXAlignment = arg5 or Enum.TextXAlignment.Left,
									}, arg6)
							end  
							local function wuzzfn54(arg, arg2)
								local flag23 = nil
								local wuzz111 = nil
								local wuzz112 = nil
								arg.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										local position = input.Position
										local position2 = arg2.Position
										flag23 = true
										wuzz111 = position  
										wuzz112 = position2
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												flag23 = false
											end
										end)
									end
								end)
								wuzz86.InputChanged:Connect(function(input)  
									if flag23 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
										local wuzzn35 = input.Position - wuzz111
										arg2.Position = UDim2.new(wuzz112.X.Scale, wuzz112.X.Offset + wuzzn35.X, wuzz112.Y.Scale, wuzz112.Y.Offset + wuzzn35.Y)
									end
								end)
							end
							wuzzfn47 = function(arg, arg2, arg3, arg4)
								local wuzz111 = wuzzfn42("Frame", {
									Name = arg,
									Size = UDim2.fromOffset(arg2, arg3),  
									BackgroundColor3 = tbl21.bg,
									BorderSizePixel = 0,
									Active = true,
									ClipsDescendants = true,
								})
								wuzzfn43(wuzz111, 14)
								wuzzfn53(wuzz111, Color3.fromRGB(49, 19, 86), Color3.fromRGB(9, 5, 25), 90)
								wuzzfn44(wuzz111, tbl21.acc, 1.5, 0.45)
								if flag18 then
									wuzzfn42("UIScale", { Name = "WinScale", Scale = wuzz91 }, wuzz111)  
								end
								local Frame7 = wuzzfn42("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = tbl21.panel, BorderSizePixel = 0 }, wuzz111)
								wuzzfn43(Frame7, 14)
								wuzzfn42("Frame", {
									Size = UDim2.new(1, 0, 0, 14),
									Position = UDim2.new(0, 0, 1, -14),
									BackgroundColor3 = tbl21.panel,
									BorderSizePixel = 0,
									}, Frame7)  
								local ImageLabel = wuzzfn42("Frame", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(0, 12, 0.5, -12),
    BackgroundColor3 = Color3.fromRGB(31, 12, 57),
    BorderSizePixel = 0,
}, Frame7)
local logoLetter = wuzzfn46("W", 18, Color3.fromRGB(220, 142, 255), gothamBlack, Enum.TextXAlignment.Center, ImageLabel)
logoLetter.Size = UDim2.fromScale(1, 1)
wuzzfn43(ImageLabel, 12)
								wuzzfn44(ImageLabel, tbl21.acc, 1.5, 0.2)
								local wuzz112 = wuzzfn46(arg4, 14, tbl21.txt, gothamBlack, Enum.TextXAlignment.Left, Frame7)  
								wuzz112.Size = UDim2.new(1, -80, 1, 0)
								wuzz112.Position = UDim2.fromOffset(44, 0)
								wuzzfn54(Frame7, wuzz111)
								return wuzz111, Frame7, ImageLabel, wuzz112
							end
							wuzzfn48 = function(arg, arg2)
								local TextButton2 = wuzzfn42("TextButton", {
									BackgroundColor3 = tbl21.panel2,
									Text = arg,  
									Font = gothamBold,
									TextSize = 12,
									TextColor3 = tbl21.txt,
									AutoButtonColor = false,
									BorderSizePixel = 0,
									}, arg2)
								wuzzfn43(TextButton2, 8)
								local wuzz111 = wuzzfn44(TextButton2, tbl21.line, 1, 0.2)
								TextButton2.MouseEnter:Connect(function()  
									wuzzfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.panel })
									wuzzfn45(wuzz111, 0.12, { Color = tbl21.acc, Transparency = 0 })
								end)
								TextButton2.MouseLeave:Connect(function()
									wuzzfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.panel2 })
									wuzzfn45(wuzz111, 0.12, { Color = tbl21.line, Transparency = 0.2 })
								end)
								return TextButton2
							end
							wuzzfn49 = function(arg, arg2)  
								local TextButton2 = wuzzfn42("TextButton", {
									BackgroundColor3 = tbl21.acc,
									Text = arg,
									Font = gothamBlack,
									TextSize = 13,
									TextColor3 = Color3.fromRGB(255, 255, 255),
									AutoButtonColor = false,
									BorderSizePixel = 0,
									}, arg2)
								wuzzfn43(TextButton2, 8)
								wuzzfn53(TextButton2, tbl21.acc, tbl21.acc2, 90)
								TextButton2.MouseEnter:Connect(function()
									wuzzfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.accHi })
								end)
								TextButton2.MouseLeave:Connect(function()
									wuzzfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.acc })
								end)
								return TextButton2
							end  
						end
					end
					do
						local hui = gethui and gethui() or wuzz87
						local wuzz = hui:FindFirstChild("Wuzz")
						if wuzz then
							wuzz:Destroy()
						end
						ScreenGui = wuzzfn42("ScreenGui", {  
							Name = "Wuzz",
							ResetOnSpawn = false,
							ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
							DisplayOrder = 250,
							}, hui)
					end
					do
						local wuzz111, wuzz112
						Main, wuzz110, wuzz111, wuzz112 = wuzzfn47("Main", 316, 548, "WUZZ")
						Main.Position = UDim2.new(1, -340, 0.5, -274)  
						if flag18 then
							Main.Position = UDim2.new(1, -math.floor(316 * wuzz91) - 8, 0.5, -math.floor(548 * wuzz91 / 2))
						end
						Main.Parent = ScreenGui
					local purpleOutline = Main:FindFirstChildOfClass("UIStroke")
					if purpleOutline then
						purpleOutline.Color = Color3.fromRGB(178, 95, 255)
						purpleOutline.Thickness = 2
						wuzz109:Create(purpleOutline, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Color = Color3.fromRGB(225, 169, 255), Thickness = 3.5, Transparency = 0.05 }):Play()
						local outlineGradient = Instance.new("UIGradient")
						outlineGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(94, 33, 215)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 168, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(113, 50, 246))})
						outlineGradient.Parent = purpleOutline
						wuzz109:Create(outlineGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 }):Play()
					end
					local glowGradient = Main:FindFirstChildOfClass("UIGradient")
					if glowGradient then
						wuzz109:Create(glowGradient, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), { Rotation = 270 }):Play()
					end
						wuzz112.Size = UDim2.new(1, -262, 1, 0)
					end
				end
				do
					wuzzfn43(wuzzfn42("ImageLabel", {  
						Name = "CityBg",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ZIndex = 0,
						Image = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(154, 105, 255),
						ScaleType = Enum.ScaleType.Crop,
						}, Main), 14)  
					do
						local Frame7 = wuzzfn42("Frame", {
							Name = "LeavesLayer",
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = 0,
							ClipsDescendants = true,
							}, Main)
						wuzzfn43(Frame7, 14)  
						local tbl23 = {}
						local color = Color3.fromRGB(199, 151, 255)
						local color2 = Color3.fromRGB(167, 104, 255)
						local color3 = Color3.fromRGB(126, 64, 236)
						local color4 = Color3.fromRGB(231, 190, 255)
						local color5 = Color3.fromRGB
						local wuzz111 = 210
						tbl23[1] = color
						tbl23[2] = color2  
						tbl23[3] = color3
						tbl23[4] = color4
						do
							local values = table.pack(color5(230, 110, wuzz111))
							table.move(values, 1, values.n, 5, tbl23)
						end
						for i = 1, 24 do
							task.spawn(function()
								task.wait(math.random() * 2.5)
								while Frame7.Parent do  
									local wuzzn35 = math.random(5, 8)
									local wuzzn36 = wuzzn35
									local wuzzn37 = math.random()
									local wuzz112 = 0.3
									local Frame8 = wuzzfn42("Frame", {
										Size = UDim2.new(0, wuzzn35, 0, wuzzn36),
										AnchorPoint = Vector2.new(0.5, 0.5),
										Position = UDim2.new(wuzzn37, 0, 0, -wuzzn36),
										BackgroundColor3 = tbl23[math.random(#tbl23)],  
										BackgroundTransparency = 0.15 + math.random() * wuzz112,
										BorderSizePixel = 0,
										ZIndex = 0,
										Rotation = math.random(0, 359),
										}, Frame7)
									wuzzfn42("UICorner", { CornerRadius = UDim.new(1, 0) }, Frame8)
									local new = NumberSequenceKeypoint.new
									wuzzfn42("UIGradient", {
										Rotation = math.random(0, 359),
										Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), new(1, 0.55) }),  
										}, Frame8)
									local wuzzn38 = 4 + math.random() * 2.6
									local wuzz113 = 0.3
									local wuzzn39 = (math.random() - 0.5) * wuzz113
									local wuzzn40 = math.random(180, 540)
									local wuzzn41 = math.random() < 0.5 and -1 or 1
									wuzz109:Create(Frame8, TweenInfo.new(wuzzn38, Enum.EasingStyle.Linear), { Position = UDim2.new(wuzzn37 + wuzzn39, 0, 1, wuzzn36 * 2), Rotation = Frame8.Rotation + wuzzn40 * wuzzn41 }):Play()
									task.wait(wuzzn38)
									if Frame8 and Frame8.Parent then  
										Frame8:Destroy()
									end
									task.wait(math.random() * 0.5)
								end
							end)
						end
					end
				end
				do
					Frame = wuzzfn42("Frame", {  
						Size = UDim2.fromOffset(8, 8),
						Position = UDim2.new(1, -212, 0.5, -4),
						BackgroundColor3 = tbl21.sub,
						BorderSizePixel = 0,
						Visible = false,
						}, wuzz110)
					wuzzfn43(Frame, 4)
					Settings = wuzzfn48("Settings", wuzz110)  
					Settings.Size = UDim2.fromOffset(38, 22)
					Settings.Position = UDim2.new(1, -71, 0.5, -11)
					Settings.TextSize = 8
					do
						local wuzz111 = wuzzfn48("", wuzz110)
						wuzz111.Size = UDim2.fromOffset(22, 22)
						wuzz111.Position = UDim2.new(1, -28, 0.5, -11)
						wuzzfn43(wuzzfn42("Frame", {
							Size = UDim2.fromOffset(10, 2),
							Position = UDim2.new(0.5, -5, 0.5, -1),  
							BackgroundColor3 = tbl21.txt,
							BorderSizePixel = 0,
							}, wuzz111), 1)
						local wuzz112 = wuzzfn42("Frame", {
							Size = UDim2.fromOffset(2, 10),
							Position = UDim2.new(0.5, -1, 0.5, -5),
							BackgroundColor3 = tbl21.txt,
							BorderSizePixel = 0,
							Visible = false,
							}, wuzz111)  
						wuzzfn43(wuzz112, 1)
						wuzzn34 = 548
						visible = false
						wuzz111.MouseButton1Click:Connect(function()
							visible = not visible
							wuzz112.Visible = visible
							wuzzfn45(Main, 0.25, { Size = UDim2.fromOffset(316, visible and 179 or wuzzn34) })
						end)
					end  
				end
			end
			Frame6 = wuzzfn42("Frame", {
				Size = UDim2.new(1, -20, 1, -54),
				Position = UDim2.fromOffset(10, 48),
				BackgroundTransparency = 1,
				}, Main)
			wuzzfn42("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,  
				}, Frame6)
			do
				local Frame7 = wuzzfn42("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = tbl21.panel,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					}, Frame6)
				wuzzfn43(Frame7, 9)  
				wuzzfn44(Frame7, tbl21.line, 1, 0.3)
				local Frame8 = wuzzfn42("Frame", {
					Size = UDim2.fromOffset(8, 8),
					Position = UDim2.new(0, 12, 0.5, -4),
					BackgroundColor3 = tbl21.sub,
					BorderSizePixel = 0,
					}, Frame7)
				wuzzfn43(Frame8, 4)
				wuzz99 = wuzzfn46("starting...", 12, tbl21.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
				wuzz99.Size = UDim2.new(1, -32, 1, 0)  
				wuzz99.Position = UDim2.fromOffset(28, 0)
				wuzz99.TextTruncate = Enum.TextTruncate.AtEnd
				wuzzfn50 = function(text, arg)
					wuzz99.Text = text
					local ok = arg == "ok" and tbl21.ok or arg == "err" and tbl21.err or arg == "busy" and tbl21.acc or arg == "wait" and tbl21.warn or tbl21.txt
					wuzz99.TextColor3 = ok
					Frame8.BackgroundColor3 = ok
				end
			end
		end  
		do
			do
				do
					do
						local wuzz109 = wuzzfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 50),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 2,
							}, Frame6)  
						wuzzfn43(wuzz109, 9)
						wuzzfn44(wuzz109, tbl21.line, 1, 0.3)
						local wuzz110 = wuzzfn46("CODE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, wuzz109)
						wuzz110.Size = UDim2.new(1, -16, 0, 11)
						wuzz110.Position = UDim2.fromOffset(11, 5)
						TextBox = wuzzfn42("TextBox", {
							Size = UDim2.new(1, -18, 0, 26),
							Position = UDim2.fromOffset(9, 18),
							BackgroundColor3 = tbl21.input,  
							Text = "",
							PlaceholderText = "type or snipe a code...",
							PlaceholderColor3 = tbl21.sub,
							Font = gothamBlack,
							TextSize = 14,
							TextColor3 = tbl21.txt,
							ClearTextOnFocus = false,
							BorderSizePixel = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							}, wuzz109)  
					end
					do
						wuzzfn43(TextBox, 7)
						do
							local wuzz109 = wuzzfn44(TextBox, tbl21.line, 1.2, 0.25)
							wuzzfn42("UIPadding", {
								PaddingLeft = UDim.new(0, 9),
								PaddingRight = UDim.new(0, 9),
								}, TextBox)  
							TextBox.Focused:Connect(function()
								wuzzfn45(wuzz109, 0.12, { Color = tbl21.acc, Transparency = 0 })
							end)
							TextBox.FocusLost:Connect(function()
								wuzzfn45(wuzz109, 0.12, { Color = tbl21.line, Transparency = 0.25 })
							end)
						end
					end
					do  
						local wuzz109 = wuzzfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 33),
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							}, Frame6)
						wuzzfn42("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, 6),
							SortOrder = Enum.SortOrder.LayoutOrder,
							}, wuzz109)  
						wuzz100 = wuzzfn48("COPY", wuzz109)
						wuzz100.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						wuzz100.LayoutOrder = 1
						clear = wuzzfn48("CLEAR", wuzz109)
						clear.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						clear.LayoutOrder = 2
						redeem = wuzzfn49("REDEEM", wuzz109)
					end
				end
				do  
					local wuzzfn53
					do
						redeem.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						redeem.LayoutOrder = 3
						redeem.TextColor3 = Color3.fromRGB(0, 0, 0)
						wuzzfn51 = function(arg, arg2, arg3, arg4, arg5)
							local Frame7 = wuzzfn42("Frame", {
								Size = UDim2.new(1, 0, 0, 31),
								BackgroundColor3 = tbl21.panel,
								BorderSizePixel = 0,  
								LayoutOrder = arg2,
								}, arg)
							wuzzfn43(Frame7, 8)
							wuzzfn44(Frame7, tbl21.line, 1, 0.3)
							local wuzz109 = wuzzfn46(arg3, 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
							wuzz109.Size = UDim2.new(1, -56, 1, 0)
							wuzz109.Position = UDim2.fromOffset(12, 0)
							wuzz109.TextTruncate = Enum.TextTruncate.AtEnd
							local Frame8 = wuzzfn42("Frame", {  
								Size = UDim2.fromOffset(36, 18),
								Position = UDim2.new(1, -44, 0.5, -9),
								BackgroundColor3 = tbl21.line,
								BorderSizePixel = 0,
								}, Frame7)
							wuzzfn43(Frame8, 9)
							local Frame9 = wuzzfn42("Frame", {
								Size = UDim2.fromOffset(14, 14),
								Position = UDim2.new(0, 2, 0.5, -7),
								BackgroundColor3 = tbl21.txt,  
								BorderSizePixel = 0,
								}, Frame8)
							wuzzfn43(Frame9, 7)
							local wuzz110 = wuzzfn42("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, Frame7)
							local flag23 = arg4
							local function wuzzfn54()
								wuzzfn45(Frame8, 0.16, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.line })
								wuzzfn45(Frame9, 0.16, { Position = UDim2.new(0, flag23 and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
								wuzzfn45(wuzz109, 0.16, { TextColor3 = flag23 and tbl21.txt or tbl21.sub })  
							end
							wuzzfn54()
							wuzz110.MouseButton1Click:Connect(function()
								flag23 = not flag23
								wuzzfn54()
								if arg5 then
									arg5(flag23)
								end
							end)  
							return Frame7
						end
						wuzzfn53 = function(arg, arg2, arg3, arg4)
							return wuzzfn51(Frame6, arg, arg2, arg3, arg4)
						end
						do
							local Frame7 = wuzzfn42("Frame", {
								Size = UDim2.new(1, 0, 0, 31),
								BackgroundColor3 = tbl21.panel,
								BorderSizePixel = 0,  
								LayoutOrder = 4,
								}, Frame6)
							wuzzfn43(Frame7, 8)
							wuzzfn44(Frame7, tbl21.line, 1, 0.3)
							listen = wuzzfn46("LISTEN", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
							listen.Size = UDim2.new(1, -56, 1, 0)
							listen.Position = UDim2.fromOffset(12, 0)
							Frame2 = wuzzfn42("Frame", {
								Size = UDim2.fromOffset(36, 18),  
								Position = UDim2.new(1, -44, 0.5, -9),
								BackgroundColor3 = tbl21.line,
								BorderSizePixel = 0,
								}, Frame7)
							wuzzfn43(Frame2, 9)
							Frame3 = wuzzfn42("Frame", {
								Size = UDim2.fromOffset(14, 14),
								Position = UDim2.new(0, 2, 0.5, -7),
								BackgroundColor3 = tbl21.txt,
								BorderSizePixel = 0,  
								}, Frame2)
							wuzzfn43(Frame3, 7)
							TextButton = wuzzfn42("TextButton", {
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								Text = "",
								}, Frame7)
						end
					end  
					do
						Frame5 = wuzzfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 5,
							}, Frame6)
						wuzzfn43(Frame5, 8)
						wuzzfn44(Frame5, tbl21.line, 1, 0.3)  
						do
							local wuzz109 = wuzzfn46("LISTEN KEY", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
							wuzz109.Size = UDim2.new(1, -100, 1, 0)
							wuzz109.Position = UDim2.fromOffset(12, 0)
						end
					end
					wuzz101 = wuzzfn48(listenKey and listenKey.Name or "-", Frame5)
					wuzz101.Size = UDim2.fromOffset(46, 24)
					wuzz101.Position = UDim2.new(1, -84, 0.5, -12)
					wuzz101.TextSize = 11  
					wuzz102 = wuzzfn48("X", Frame5)
					wuzz102.Size = UDim2.fromOffset(24, 24)
					wuzz102.Position = UDim2.new(1, -32, 0.5, -12)
					wuzz102.TextSize = 12
					Frame4 = wuzzfn42("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = tbl21.panel,
						BorderSizePixel = 0,
						LayoutOrder = 6,
						}, Frame6)  
					wuzzfn43(Frame4, 8)
					wuzzfn44(Frame4, tbl21.line, 1, 0.3)
					do
						local wuzz109 = wuzzfn46("REDEEM KEY", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame4)
						wuzz109.Size = UDim2.new(1, -100, 1, 0)
						wuzz109.Position = UDim2.fromOffset(12, 0)
					end
					wuzz103 = wuzzfn48(g and g.Name or "-", Frame4)
					wuzz103.Size = UDim2.fromOffset(46, 24)  
					wuzz103.Position = UDim2.new(1, -84, 0.5, -12)
					wuzz103.TextSize = 11
					wuzz104 = wuzzfn48("X", Frame4)
					wuzz104.Size = UDim2.fromOffset(24, 24)
					wuzz104.Position = UDim2.new(1, -32, 0.5, -12)
					wuzz104.TextSize = 12
					wuzzfn53(7, "AUTO REDEEM", autoRedeem, function(arg)
						autoRedeem = arg
						_G.__RdmCfgSet("autoRedeem", arg)
					end)  
					wuzzfn53(8, "AUTO TYPE", autoType, function(arg)
						autoType = arg
						_G.__RdmCfgSet("autoType", arg)
					end)
					wuzzfn53(9, "MANUAL", manual, function(arg)
						manual = arg
						tbl19 = {}
						wuzzfn52()
					end)  
				end
				do
					local function wuzzfn53(arg, arg2, arg3, arg4, arg5)
						local Frame7 = wuzzfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = arg,
							}, Frame6)
						wuzzfn43(Frame7, 8)
						wuzzfn44(Frame7, tbl21.line, 1, 0.3)
						local wuzz109 = wuzzfn46(arg2, 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
						wuzz109.Size = UDim2.fromOffset(56, 31)
						wuzz109.Position = UDim2.fromOffset(11, 0)
						local wuzz110 = wuzzfn42("Frame", {
							Size = UDim2.fromOffset(168, 23),
							Position = UDim2.new(1, -177, 0.5, -11.5),
							BackgroundColor3 = tbl21.input,
							BorderSizePixel = 0,  
							}, Frame7)
						wuzzfn43(wuzz110, 7)
						local tbl23 = {}
						local function wuzzfn54(arg6)
							for k, wuzz111 in pairs(tbl23) do
								local flag23 = k == arg6
								wuzzfn45(wuzz111, 0.12, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.input })
								wuzz111.TextColor3 = flag23 and Color3.fromRGB(255, 255, 255) or tbl21.sub
							end
							if arg5 then
								arg5(arg6)
							end
						end
						for i, wuzz111 in ipairs(arg3) do
							local flag23 = type(wuzz111) == "table" and wuzz111[1] or wuzz111
							local flag24 = type(wuzz111) == "table" and wuzz111[2] or wuzz111
							local TextButton2 = wuzzfn42("TextButton", {
								Size = UDim2.new(1 / #arg3, -2, 1, -2),
								Position = UDim2.new((i - 1) / #arg3, 1, 0, 1),  
								BackgroundColor3 = tbl21.input,
								Text = flag24,
								Font = gothamBold,
								TextSize = flag24:find("\n") and 8 or 10,
								TextColor3 = tbl21.sub,
								AutoButtonColor = false,
								BorderSizePixel = 0,
								}, wuzz110)
							wuzzfn43(TextButton2, 6)
							tbl23[flag23] = TextButton2  
							TextButton2.MouseButton1Click:Connect(function()
								wuzzfn54(flag23)
							end)
						end
						wuzzfn54(arg4)
						return Frame7, wuzzfn54
					end
					words = wuzzfn53(11, "WORDS", { "1", "2", "3", "4" }, tostring(wuzzn33), function(arg)
						wuzzn33 = tonumber(arg) or 1
						tbl19 = {}  
						if flag20 and not manual then
							wuzzfn50(("listening... 0/%d"):format(wuzzn33), "wait")
						end
					end)
					local Frame7 = wuzzfn42("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = tbl21.panel,
						BorderSizePixel = 0,
						LayoutOrder = 12,  
						}, Frame6)
					wuzzfn43(Frame7, 8)
					wuzz105 = wuzzfn44(Frame7, tbl21.line, 1, 0.3)
					wuzz106 = wuzzfn46("SPAM", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
					wuzz106.Size = UDim2.new(1, -94, 1, 0)
					wuzz106.Position = UDim2.fromOffset(11, 0)
					start = wuzzfn48("START", Frame7)
					start.Size = UDim2.fromOffset(70, 24)
					start.Position = UDim2.new(1, -78, 0.5, -12)
					start.TextSize = 11
					wuzz107 = wuzzfn42("Frame", {
						Size = UDim2.fromOffset(7, 7),
						Position = UDim2.new(0, 9, 0.5, -3.5),
						BackgroundColor3 = tbl21.line,
						BorderSizePixel = 0,
						}, start)
					wuzzfn43(wuzz107, 4)
					wuzzfn53(13, "SPEED", { "MAX", { "WORD", "EVERY\nWORD" } }, _G.__RdmCfgBool("wordMode", false) and "WORD" or "MAX", function(arg)
						flag19 = arg == "WORD"  
						if not flag19 then
							max = tbl22[arg] or tbl22.MAX
						end
						_G.__RdmCfgSet("speed", arg)
						_G.__RdmCfgSet("wordMode", flag19)
					end)
				end
			end
			do
				local Frame7  
				do
					do
						do
							local wuzz109 = nil
							for _, descendant in ipairs(Frame6:GetDescendants()) do
								if descendant:IsA("TextButton") and descendant.Text == "EVERY\nWORD" then
									wuzz109 = descendant
									break
								else
									wuzz109 = nil  
								end
							end
							if wuzz109 then
								wuzzfn42("TextLabel", {
									Size = UDim2.fromOffset(64, 8),
									AnchorPoint = Vector2.new(0.5, 1),
									Position = UDim2.new(0.5, 0, 0, -1),
									BackgroundTransparency = 1,
									TextColor3 = tbl21.warn,  
									TextTransparency = 0.35,
									Font = gothamBlack,
									TextSize = 8,
									Text = "RISKY",
									ZIndex = 3,
									}, wuzz109)
							end
						end
					end
					Frame7 = wuzzfn42("Frame", {  
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = tbl21.panel,
						BorderSizePixel = 0,
						LayoutOrder = 14,
						}, Frame6)
					wuzzfn43(Frame7, 8)
					wuzzfn44(Frame7, tbl21.line, 1, 0.3)
					do
						local events = wuzzfn46("EVENTS", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)  
						events.Size = UDim2.new(1, -104, 1, 0)
						events.Position = UDim2.fromOffset(11, 0)
					end
				end
				local blockAll = wuzzfn48("BLOCK ALL", Frame7)
				blockAll.Size = UDim2.fromOffset(88, 24)
				blockAll.Position = UDim2.new(1, -97, 0.5, -12)
				blockAll.TextSize = 10
				local flag23 = false
				local wuzz109 = nil  
				local str8 = nil
				local str9 = nil
				local wuzzn35 = 0
				local function wuzzfn53()
					local flag24 = os.clock() < wuzzn35
					local str10 = tostring(tbl20.ready) .. tostring(flag24)
					if str10 == wuzz109 then
						return
					end  
					wuzz109 = str10
					blockAll.Text = flag24 and "BLOCKED" or "BLOCK ALL"
					blockAll.TextColor3 = not tbl20.ready and tbl21.sub or flag24 and tbl21.ok or tbl21.txt
				end
				blockAll.MouseButton1Click:Connect(function()
					if flag23 then
						return
					end
					if not tbl20.ready then
						local wuzz110 = "err"  
						wuzzfn50("events: " .. tostring(tbl20.why), wuzz110)
						return
					end
					flag23 = true
					wuzzfn50("blocking events...", "busy")
					task.spawn(function()
						local ok, result, result2 = pcall(tbl20.Block)
						if ok and result then
							result2 = result2 or "blocked"  
							str8 = result2
							str9 = "ok"
						else
							str8 = "events: " .. tostring(result2 or result)
							str9 = "err"
						end
						flag23 = false
					end)
				end)
				task.spawn(function()  
					while Frame7.Parent do
						if str8 then
							local wuzz110 = str8
							local wuzz111 = str9
							str8 = nil
							str9 = nil
							if wuzz111 == "ok" then
								wuzzn35 = os.clock() + 1
							end
							pcall(wuzzfn50, wuzz110, wuzz111)  
						end
						pcall(wuzzfn53)
						task.wait(0.2)
					end
				end)
				wuzzfn53()
			end
		end
	end  
	do
		local wuzzfn53, Settings2
		do
			do
				do
					local wuzzn35 = 548
					local wuzzn36 = 36
					local tbl22 = {}
					local tbl23 = {}
					local wuzzn37 = 0  
					local function wuzzfn54(arg, arg2, arg3)
						local flag23 = tbl22[arg]
						if flag23 == nil then
							flag23 = true
						end
						if flag23 == arg2 then
							return
						end
						tbl22[arg] = arg2
						local wuzzn38 = (tbl23[arg] or 0) + 1  
						tbl23[arg] = wuzzn38
						wuzzn37 = math.max(0, wuzzn37 + (arg2 and -1 or 1))
						wuzzn34 = wuzzn35 - wuzzn37 * wuzzn36
						if not visible then
							if arg3 then
								Main.Size = UDim2.fromOffset(316, wuzzn34)
							else
								wuzzfn45(Main, 0.2, { Size = UDim2.fromOffset(316, wuzzn34) }, Enum.EasingStyle.Quart)
							end  
						end
						arg.ClipsDescendants = true
						if arg2 then
							arg.Visible = true
							if arg3 then
								arg.Size = UDim2.new(1, 0, 0, 31)
								arg.ClipsDescendants = false
								return
							end
							arg.Size = UDim2.new(1, 0, 0, 0)  
							wuzzfn45(arg, 0.2, { Size = UDim2.new(1, 0, 0, 31) }, Enum.EasingStyle.Quart)
							task.delay(0.22, function()
								if tbl23[arg] == wuzzn38 then
									arg.ClipsDescendants = false
								end
							end)
						elseif arg3 then
							arg.Size = UDim2.new(1, 0, 0, 0)
							arg.Visible = false
							return  
						else
							wuzzfn45(arg, 0.2, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quart)
							task.delay(0.22, function()
								if tbl23[arg] == wuzzn38 then
									arg.Visible = false
								end
							end)
						end
					end
					wuzzfn52 = function(arg)  
						wuzzfn54(words, not manual, arg)
					end
					wuzzfn53 = function(arg)
						wuzzfn54(Frame5, showKeybinds, arg)
						wuzzfn54(Frame4, showKeybinds, arg)
					end
				end
			end
			do  
				local wuzz109
				Settings2, wuzz109 = wuzzfn47("Settings", 300, flag18 and 316 or 280, "SETTINGS")
				Settings2.Visible = false
				Settings2.Parent = ScreenGui
				local wuzz110 = wuzzfn48("X", wuzz109)
				wuzz110.Size = UDim2.fromOffset(22, 22)
				wuzz110.Position = UDim2.new(1, -28, 0.5, -11)
				wuzz110.TextSize = 12
				wuzz110.MouseButton1Click:Connect(function()  
					Settings2.Visible = false
				end)
			end
		end
		local Frame6
		do
			Frame6 = wuzzfn42("Frame", {
				Size = UDim2.new(1, -20, 1, -60),
				Position = UDim2.fromOffset(10, 50),
				BackgroundTransparency = 1,  
				BorderSizePixel = 0,
				}, Settings2)
			wuzzfn42("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, Frame6)
			wuzzfn51(Frame6, 1, "AUTO LISTEN", autoListen, function(arg)
				autoListen = arg
				_G.__RdmCfgSet("autoListen", arg)  
			end)
			wuzzfn51(Frame6, 2, "SPAM ON LISTEN", wuzz95, function(arg)
				wuzz95 = arg
				_G.__RdmCfgSet("spamOnListen", arg)
			end)
			wuzzfn51(Frame6, 3, "SHOW KEYBINDS", showKeybinds, function(arg)
				showKeybinds = arg
				wuzzfn53()
				_G.__RdmCfgSet("showKeybinds", arg)
			end)  
			wuzzfn51(Frame6, 4, "IGNORE SYSTEM PHRASES", wuzz96, function(arg)
				wuzz96 = arg
				_G.__RdmCfgSet("ignoreSystem", arg)
			end)
			do
				local wuzz109 = wuzzfn51(Frame6, 6, "DUO MODE (WITH RIDDLER)", _G.__RdmDuo, function(rdmDuo)
					_G.__RdmDuo = rdmDuo
					_G.__RdmCfgSet("duo", rdmDuo)
					if _G.__SabDuoSync then  
						_G.__SabDuoSync()
					end
					return
				end)
				local wuzz110 = wuzzfn46("0/2", 10, tbl21.sub, gothamBold, Enum.TextXAlignment.Right, wuzz109)
				wuzz110.Size = UDim2.fromOffset(50, 31)
				wuzz110.Position = UDim2.new(1, -84, 0, 0)
				for _, child in ipairs(wuzz109:GetChildren()) do
					if child:IsA("TextLabel") and child ~= wuzz110 then
						child.Size = UDim2.new(1, -100, 1, 0)  
					end
				end
				local function redeemer()
					local wuzzn35 = (_G.__RiddlerDuo and 1 or 0) + (_G.__RdmDuo and 1 or 0)
					wuzz110.Text = wuzzn35 .. "/2"
					wuzz110.TextColor3 = wuzzn35 == 2 and tbl21.acc or wuzzn35 == 1 and (tbl21.warn or tbl21.sub) or tbl21.sub
				end
				redeemer()
				_G.__SabDuoRefresh = _G.__SabDuoRefresh or {}
				_G.__SabDuoRefresh.redeemer = redeemer  
				_G.__SabDuoSync = function()
					local wuzz111 = pairs
					local sabDuoRefresh = _G.__SabDuoRefresh or {}
					for _, wuzz112 in wuzz111(sabDuoRefresh) do
						pcall(wuzz112)
					end
				end
				_G.__SabDuoSync()
				task.spawn(function()  
					while wuzz109.Parent do
						redeemer()
						task.wait(1)
					end
				end)
			end
		end
		do
			local Frame7
			do  
				if flag18 then
					local Frame8
					do
						local Frame9 = wuzzfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 5,
							}, Frame6)
						wuzzfn43(Frame9, 8)  
						wuzzfn44(Frame9, tbl21.line, 1, 0.3)
						local uiSize = wuzzfn46("UI SIZE", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame9)
						uiSize.Size = UDim2.fromOffset(70, 31)
						uiSize.Position = UDim2.fromOffset(11, 0)
						Frame8 = wuzzfn42("Frame", {
							Size = UDim2.fromOffset(168, 23),
							Position = UDim2.new(1, -177, 0.5, -11.5),
							BackgroundColor3 = tbl21.input,
							BorderSizePixel = 0,
							}, Frame9)  
					end
					wuzzfn43(Frame8, 7)
					do
						local tbl22 = {}
						local function wuzzfn54(arg, arg2)
							for k, wuzz109 in pairs(tbl22) do
								local flag23 = k == arg
								wuzzfn45(wuzz109, 0.12, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.input })
								wuzz109.TextColor3 = flag23 and Color3.fromRGB(255, 255, 255) or tbl21.sub  
							end
							if arg2 then
								return
							end
							_G.__RdmCfgSet("uiSize", arg)
							if tbl18.refit then
								tbl18.refit()
							end
						end
						local tbl23 = { "BIG", "MEDIUM", "SMALL" }  
						for i, wuzz109 in ipairs(tbl23) do
							local TextButton2 = wuzzfn42("TextButton", {
								Size = UDim2.new(1 / #tbl23, -2, 1, -2),
								Position = UDim2.new((i - 1) / #tbl23, 1, 0, 1),
								BackgroundColor3 = tbl21.input,
								Text = wuzz109,
								Font = gothamBold,
								TextSize = 9,
								TextColor3 = tbl21.sub,  
								AutoButtonColor = false,
								BorderSizePixel = 0,
								}, Frame8)
							wuzzfn43(TextButton2, 6)
							tbl22[wuzz109] = TextButton2
							TextButton2.MouseButton1Click:Connect(function()
								wuzzfn54(wuzz109)
							end)
						end  
						wuzzfn54(_G.__RdmCfgStr("uiSize", "MEDIUM"), true)
					end
				end
			end
		end
		do
			local function wuzzfn54()
				if flag18 then
					Settings2.Position = UDim2.new(0.5, -math.floor(Settings2.AbsoluteSize.X / 2), 0.5, -math.floor(Settings2.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					Settings2.Position = UDim2.new(position.X.Scale, position.X.Offset - Settings2.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end
				Settings2.Visible = true
			end  
			wuzz108 = wuzzfn54
			Settings.MouseButton1Click:Connect(function()
				if not Settings2.Visible then
					wuzzfn54()
					return
				end
				Settings2.Visible = false
			end)
		end  
		wuzzfn53(true)
	end
	wuzzfn52(true)
end
local Frame4, wuzzfn52, wuzzfn53, tbl22
Frame4 = Frame
wuzzfn53 = function() end
local wuzzfn54
do
	do
		local str8, wuzzn35
		do
			str8 = ""
			wuzzn35 = 0
			do
				local function wuzzfn55(descendant)
					task.defer(function()  
						if not descendant.Parent then
							return
						end
						local descendants = descendant:IsA("TextLabel") and { descendant } or descendant:GetDescendants()
						for _, descendant2 in ipairs(descendants) do
							if descendant2:IsA("TextLabel") and descendant2.Text ~= "" then
								local str9 = wuzzfn33(descendant2.Text):lower()
								local now2 = os.clock()
								str8 = str9
								wuzzn35 = now2  
								return
							end
						end
					end)
				end
				local function wuzzfn56(arg)
					if not arg then
						return
					end  
					arg.DescendantAdded:Connect(wuzzfn55)
					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							descendant:GetPropertyChangedSignal("Text"):Connect(function()
								if descendant.Text ~= "" then
									local str9 = wuzzfn33(descendant.Text):lower()
									local now2 = os.clock()
									str8 = str9
									wuzzn35 = now2
								end  
							end)
						end
					end
				end
				wuzzfn56(wuzz87:FindFirstChild("Notification"))
				wuzzfn56(wuzz87:FindFirstChild("Notifications"))
				wuzzfn56(wuzz87:FindFirstChild("Announcement"))
			end
		end  
		do
			local tbl23 = {
				"base is full",
				"sold out",
				"out of stock",
				"already redeemed",
				"already used",
				"code redeemed",
				"you have already",
			}  
			wuzzfn54 = function(arg)
				if wuzzn35 <= (arg or 0) then
					return nil
				end
				if os.clock() - wuzzn35 > 3 then
					return nil
				end
				for _, wuzz109 in ipairs(tbl23) do
					if str8:find(wuzz109, 1, true) then  
						return wuzz109
					end
				end
			end
		end
	end
end
local wuzzfn55, wuzzfn56, wuzzfn57, wuzzfn58, wuzzfn59, wuzzfn60, wuzzfn61, wuzzfn62, wuzzfn63, wuzzfn64
do  
	do
		wuzzfn55 = function(arg, arg2)
			local wuzz109 = wuzzfn34(arg)
			if wuzz109 == "" then
				wuzzfn50("nothing to redeem", "err")
				return false, false
			end
			arg2 = arg2 and arg2 .. " " or ""
			wuzzfn50(("%sredeeming: %s"):format(arg2, wuzz109), "busy")
			local wuzz110, wuzz111 = wuzzfn41(wuzz109)  
			local flag23 = wuzz110 and type(wuzz111) == "table"
			if flag23 and (wuzz111.success or wuzz111.Success) and true then
				wuzzfn50(("%sredeemed: %s"):format(arg2, wuzz109), "ok")
			elseif flag23 then
				wuzzfn50(("%srejected: %s"):format(arg2, wuzz109), "err")
			elseif wuzz110 then
				wuzzfn50(("%ssent: %s"):format(arg2, wuzz109), "busy")
			else
				wuzzfn50(("%sfailed to send: %s"):format(arg2, wuzz109), "err")  
			end
			return wuzz110, flag23 and (wuzz111.success == true or wuzz111.Success == true)
		end
		wuzzfn52 = function(text)
			TextBox.Text = text
			wuzzfn55(text)
		end
		do
			local wuzzfn65 = nil
			local function wuzzfn66(arg)  
				local wuzz109 = wuzzfn34(arg or "")
				if wuzz109 == "" then
					return false
				end
				wuzzn32 += 1
				local wuzz110, wuzz111 = wuzzfn55(wuzz109)
				if wuzz110 and wuzz111 then
					local wuzz112 = "ok"
					wuzzfn50(("spam %d - redeemed: %s"):format(wuzzn32, wuzz109), wuzz112)  
				elseif wuzz110 then
					wuzzfn50(("spam %d - sent: %s"):format(wuzzn32, wuzz109), "busy")
				else
					wuzzfn50(("spam %d - failed: %s"):format(wuzzn32, wuzz109), "err")
				end
				return wuzz110
			end
			wuzzfn56 = function(arg)
				if flag21 and flag20 and flag19 then
					wuzzfn66(arg)  
				end
			end
			local function wuzzfn67()
				while flag21 and flag20 do
					if flag19 then
						if wuzzn32 == 0 then
							wuzzfn50("spam - redeem on every word", "wait")
						end
						task.wait(0.1)  
					else
						if wuzzfn34(TextBox.Text) == "" then
							wuzzfn50("spam - waiting for a code...", "wait")
						else
							wuzzfn66(TextBox.Text)
						end
						task.wait(max)
					end
				end  
				if flag21 then
					wuzzfn65(false)
				end
			end
			wuzzfn65 = function(arg)
				if arg and not flag20 then
					wuzzfn50("turn LISTEN on first", "err")
					return
				end
				if arg == flag21 then  
					return
				end
				flag21 = arg
				start.Text = arg and "STOP" or "START"
				start.TextColor3 = arg and tbl21.acc or tbl21.txt
				wuzzfn45(wuzz107, 0.16, { BackgroundColor3 = arg and tbl21.acc or tbl21.line })
				wuzzfn45(wuzz106, 0.16, { TextColor3 = arg and tbl21.txt or tbl21.sub })
				wuzzfn45(wuzz105, 0.16, { Color = arg and tbl21.acc or tbl21.line, Transparency = arg and 0.15 or 0.3 })
				if arg then  
					wuzzn32 = 0
					thread = task.spawn(wuzzfn67)
				else
					thread = nil
					if flag20 then
						wuzzfn50("spam stopped", "wait")
					end
				end
			end
			start.MouseButton1Click:Connect(function()  
				wuzzfn65(not flag21)
			end)
			redeem.MouseButton1Click:Connect(function()
				redeem.Text = "..."
				wuzzfn55(TextBox.Text)
				redeem.Text = "REDEEM"
			end)
			TextBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then  
					wuzzfn55(TextBox.Text)
				end
			end)
			wuzz100.MouseButton1Click:Connect(function()
				local copied = wuzzfn34(TextBox.Text)
				if copied == "" then
					wuzzfn50("nothing to copy", "err")
					return
				end
				local wuzz109 = wuzzfn35(copied)  
				wuzzfn50(wuzz109 and "copied: " .. copied or "copy failed", wuzz109 and "ok" or "err")
			end)
			clear.MouseButton1Click:Connect(function()
				TextBox.Text = ""
				wuzz93 = nil
				tbl19 = {}
				wuzzfn50(flag20 and "listening... (cleared)" or "cleared", flag20 and "wait" or "idle")
			end)
			wuzzfn57 = function(text)
				wuzz93 = text  
				TextBox.Text = text
			end
			wuzzfn58 = function()
				if not (not keyboardEnabled or not listenKey) then
					return "press " .. listenKey.Name .. " to fire"
				end
				return "tap LISTEN to fire"
			end
			wuzzfn59 = function()  
				if not keyboardEnabled then
					return "idle - tap LISTEN to start"
				end
				return listenKey and "idle - press " .. listenKey.Name .. " to listen" or "idle - no listen key bound"
			end
			wuzzfn60 = function(arg)
				flag20 = arg
				if not arg and flag21 then
					wuzzfn65(false)
				end  
				wuzzfn45(Frame2, 0.16, { BackgroundColor3 = arg and tbl21.acc or tbl21.line })
				wuzzfn45(Frame3, 0.16, { Position = UDim2.new(0, arg and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
				wuzzfn45(listen, 0.16, { TextColor3 = arg and tbl21.txt or tbl21.sub })
				if arg then
					tbl19 = {}
					if wuzz95 and not flag21 then
						if wuzz93 and TextBox.Text == wuzz93 then
							wuzzfn57("")
						end
						wuzzfn65(true)  
					end
					if manual then
						wuzzfn50("listening... " .. wuzzfn58(), "wait")
					else
						local wuzz109 = "wait"
						wuzzfn50(("listening... 0/%d"):format(wuzzn33), wuzz109)
					end
				else
					wuzzfn50(wuzzfn59(), "idle")  
				end
			end
		end
	end
	do
		wuzzfn61 = function(arg)
			if autoType then
				wuzzfn57(arg)
			end
			if autoRedeem then  
				wuzzfn55(arg, "[FULL]")
			else
				wuzzfn50("captured: " .. arg .. " (auto-redeem off)", "ok")
			end
		end
		wuzzfn62 = function(arg)
			local wuzz109 = wuzzfn34(arg or "")
			if wuzz109 == "" then
				return  
			end
			local now2 = os.clock()
			task.spawn(function()
				for i = 1, 3 do
					task.wait(wuzz92)
					local wuzz110 = wuzzfn54(now2)
					if wuzz110 then
						local wuzz111 = "wait"
						wuzzfn50(("%s - stopped retrying"):format(wuzz110), wuzz111)
						break  
					else
						wuzzn32 += 1
						local wuzz111, wuzz112 = wuzzfn55(wuzz109, "[FULL]")
						wuzzfn50(("confirm %d/%d - %s%s"):format(i, 3, wuzz111 and "sent: " or "retry: ", wuzz109), wuzz111 and "ok" or "busy")
						if not (wuzz111 and wuzz112) then
							continue
						end
					end
					break  
				end
			end)
		end
		do
			local function wuzzfn65()
				local str8 = table.concat(tbl19)
				local wuzz109 = flag21
				wuzzfn60(false)
				if str8 ~= "" then
					wuzzfn61(str8)  
					if wuzz109 then
						wuzzfn62(str8)
					end
				end
			end
			wuzzfn63 = function()
				if flag20 then
					if manual then
						wuzzfn65()  
					else
						wuzzfn60(false)
					end
				else
					wuzzfn60(true)
				end
			end
		end
	end
	TextButton.MouseButton1Click:Connect(wuzzfn63)  
	wuzz101.MouseButton1Click:Connect(function()
		str7 = "listen"
		wuzz101.Text = "..."
		wuzz101.TextColor3 = tbl21.warn
	end)
	wuzz102.MouseButton1Click:Connect(function()
		listenKey = nil
		str7 = nil
		wuzz101.Text = "-"  
		wuzz101.TextColor3 = tbl21.txt
		if not flag20 then
			wuzzfn50(wuzzfn59(), "idle")
		end
	end)
	wuzz103.MouseButton1Click:Connect(function()
		str7 = "redeem"
		wuzz103.Text = "..."
		wuzz103.TextColor3 = tbl21.warn
	end)  
	wuzz104.MouseButton1Click:Connect(function()
		g = nil
		str7 = nil
		wuzz103.Text = "-"
		wuzz103.TextColor3 = tbl21.txt
	end)
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if flag20 and TextBox.Text ~= wuzz93 then
			tbl19 = {}
		end  
	end)
	tbl18.positions = {
		Top = true,
		Bottom = true,
		Center = true,
		Middle = true,
		Left = true,
		Right = true,
		TopRight = true,
		TopLeft = true,  
		BottomRight = true,
		BottomLeft = true,
	}
	do
		local function wuzzfn65(arg)
			return wuzzfn33(tostring(arg or "")):lower():gsub("[^%w]", "")
		end
		local tbl23 = {
			phrases = {
				"code is",  
				"use code",
				"font color",
				"fontcolour",
				"fontcolor",
				"font colour",
				"sammy has activated bubblegum machine",
				"sammy activated 2x luck",
				"sammy activated 6x luck",
				"sammy activated 8x luck",
				"sammy activated 10x luck",  
				"sammy activated 12x luck",
				"sammy activated 15x luck",
				"sammy activated 20x luck",
				"sammy activated 25x luck",
				"sammy activated 30x luck",
				"sammy activated 35x luck",
				"sammy activated",
				"coins shop",
				"brainrot trader",
				"robux shop",  
				"robuxshop",
				"spin wheel",
				"spinwheel",
				"trade plaza",
				"tradeplaza",
				"event has started",
				"eventhasstarted",
				"allowfriends",
				"setcreatorid",
				"to buy this",  
				"tobuythis",
				"your base is already locked",
				"your base is full",
				"request failed",
				"you locked your base for",
				"you got a free spin",
				"broke into your base",
				"someone is stealing",
				"trade has been completed",
				"tradehasbeencompleted",  
				"event has been activated",
				"has been activated",
				"has activated",
				"base is already locked",
				"you locked your base",
				"you have locked your base",
				"locked your base",
				"brainrot express has arrived",
				"brainrot express has arrv",
				"brainrot express leaving in",  
			},
			prefixes = { "sammy:", "spydersammy:" },
			compact = {},
		}
		local tbl24 = {}
		for _, phrase in ipairs(tbl23.phrases) do
			local wuzz109 = wuzzfn65(phrase)
			if wuzz109 ~= "" and not tbl24[wuzz109] then
				tbl24[wuzz109] = true  
				tbl23.compact[#tbl23.compact + 1] = { phrase = phrase, compact = wuzz109 }
			end
		end
		wuzzfn64 = function(arg)
			if not wuzz96 or not flag20 then
				return false
			end
			local str8 = wuzzfn33(tostring(arg or "")):lower()
			local str9 = str8:gsub("%s+", "")
			for _, prefixe in ipairs(tbl23.prefixes) do
				if str9:find(prefixe, 1, true) then
					return true, prefixe
				end
			end
			local wuzz109 = wuzzfn65(str8)
			for _, wuzz110 in ipairs(tbl23.compact) do
				if wuzz109:find(wuzz110.compact, 1, true) then
					return true, wuzz110.phrase
				end  
			end
			return false
		end
	end
end
do
	do
		local function wuzzfn65(...)
			local wuzz109 = table.pack(...)  
			if wuzz109.n == 0 or typeof(wuzz109[1]) ~= "string" then
				return false
			end
			if wuzz96 then
				return wuzz109[4] == "Top"
			end
			for i = 2, wuzz109.n do
				local wuzz110 = wuzz109[i]
				if typeof(wuzz110) == "string" and (wuzz110:find("Sounds%.") or wuzz110:find("rbxassetid") or tbl18.positions[wuzz110]) then
					return true  
				end
			end
			return false
		end
		wuzzfn30 = function(...)
			local wuzz109 = table.pack(...)
			if not wuzzfn65(...) then
				return
			end  
			local wuzz110 = wuzzfn33(tostring(wuzz109[1] or ""))
			if wuzz110 ~= "" then
				if wuzzfn64(wuzz110) then
					return
				end
				if _G.__RdmDuo and _G.__RiddlerDuo then
					local wuzz111 = _G.__SabClassifyDrop(wuzz110)
					if wuzz111 == "riddle" then
						_G.__SabDropClaim = { text = wuzz110, kind = "riddle", at = os.clock() }
						wuzzfn50("riddle - left to the AI riddler", "wait")  
						wuzzfn53(wuzz110, nil)
						return
					end
					if wuzz111 == "code" then
						_G.__SabDropClaim = { text = wuzz110, kind = "code", at = os.clock() }
					end
				end
				local wuzz111 = wuzzfn37(wuzz110)
				local wuzz112  
				if autoListen and not flag20 then
					wuzz112 = wuzzfn38(wuzz110)
					if wuzz112 then
						wuzzfn60(true)
						if wuzz112 == "" then
							wuzzfn50("trigger heard - waiting for the code...", "busy")
							wuzzfn53(wuzz110, wuzz111)
							return
						end  
					else
						wuzz112 = wuzz110
					end
				else
					wuzz112 = wuzz110
				end
				if flag20 then
					for _, wuzz113 in ipairs(wuzzfn36(wuzz112)) do
						tbl19[#tbl19 + 1] = wuzz113
						if flag19 and flag21 then  
							if manual then
								wuzzfn56(table.concat(tbl19))
							else
								local tbl23 = {}
								for i = 1, math.min(#tbl19, wuzzn33) do
									tbl23[i] = tbl19[i]
								end
								wuzzfn56(table.concat(tbl23))
							end  
						end
					end
					if manual then
						local str8 = table.concat(tbl19)
						wuzzfn57(str8)
						wuzzfn40(str8)
						local wuzz113 = "wait"
						wuzzfn50(("listening... %d words - %s"):format(#tbl19, wuzzfn58()), wuzz113)
					else
						local wuzz113 = wuzzn33  
						local tbl23 = {}
						for i = 1, math.min(#tbl19, wuzz113) do
							tbl23[i] = tbl19[i]
						end
						local str8 = table.concat(tbl23)
						wuzzfn57(str8)
						wuzzfn40(str8)
						if wuzz113 <= #tbl19 then
							local wuzz114 = flag21  
							tbl19 = {}
							wuzzfn60(false)
							wuzzfn61(str8)
							if wuzz114 then
								wuzzfn62(str8)
								wuzz111 = str8
							else
								wuzz111 = str8
							end
						else  
							wuzzfn50(("listening... %d/%d"):format(#tbl19, wuzz113), "wait")
						end
					end
				end
				wuzzfn53(wuzz110, wuzz111)
				return
			end
		end
	end  
end
if getgenv and getgenv().StopWuzz then
	pcall(getgenv().StopWuzz)
end
do
	local tbl23 = {}
	local wuzz109 = nil
	local wuzzn35 = 0
	local function wuzzfn65(...)  
		local wuzz110 = table.pack(...)
		local str8 = tostring(...)
		local now2 = os.clock()
		if str8 == wuzz109 and now2 - wuzzn35 < 0.25 then
			return
		end
		wuzz109 = str8
		wuzzn35 = now2
		pcall(wuzzfn30, table.unpack(wuzz110, 1, wuzz110.n))
	end  
	wuzz94 = wuzzfn39()
	if wuzz94 then
		Frame.BackgroundColor3 = tbl21.ok
		Frame4.BackgroundColor3 = tbl21.ok
		tbl23[#tbl23 + 1] = wuzz94.OnClientEvent:Connect(wuzzfn65)
	else
		do
			local wuzzn36 = 0
			for _, child in ipairs(net:GetChildren()) do  
				if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
					wuzzn36 += 1
					tbl23[#tbl23 + 1] = child.OnClientEvent:Connect(wuzzfn65)
					if not (wuzzn36 >= 400) then
						continue
					end
				else
					continue
				end
				break  
			end
			tbl23[#tbl23 + 1] = net.ChildAdded:Connect(function(child)
				if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
					tbl23[#tbl23 + 1] = child.OnClientEvent:Connect(wuzzfn65)
				end
			end)
			flag22 = wuzzn36 > 0
		end
		local warn_ = flag22 and tbl21.warn or tbl21.err  
		Frame.BackgroundColor3 = warn_
		Frame4.BackgroundColor3 = warn_
	end
	if flag18 then
		local currentCamera = workspace.CurrentCamera
		local function refit()
			wuzz91 = wuzzfn29()
			for _, descendant in ipairs(ScreenGui:GetDescendants()) do
				if descendant:IsA("UIScale") and descendant.Name == "WinScale" then
					descendant.Scale = wuzz91  
				end
			end
			Main.Position = UDim2.new(1, -math.floor(316 * wuzz91) - 8, 0.5, -math.floor(wuzzn34 * wuzz91 / 2))
		end
		if currentCamera then
			currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)
		end
		tbl18.refit = refit
		refit()
	end  
	wuzz86.InputBegan:Connect(function(input, gameProcessed)
		local userInputType = input.UserInputType
		if not (userInputType == Enum.UserInputType.Keyboard or userInputType == Enum.UserInputType.Gamepad1) then
			if str7 and userInputType == Enum.UserInputType.Touch then
				local rebinding = str7
				str7 = nil
				if rebinding == "listen" then
					wuzz101.Text = listenKey and listenKey.Name or "-"
					wuzz101.TextColor3 = tbl21.txt  
				else
					wuzz103.Text = g and g.Name or "-"
					wuzz103.TextColor3 = tbl21.txt
				end
			end
			return
		end
		if str7 == "listen" then
			str7 = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then  
				listenKey = input.KeyCode
			end
			wuzz101.Text = listenKey and listenKey.Name or "-"
			wuzz101.TextColor3 = tbl21.txt
			if not flag20 then
				wuzzfn50(wuzzfn59(), "idle")
			end
			return
		end
		if str7 == "redeem" then  
			str7 = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then
				g = input.KeyCode
			end
			wuzz103.Text = g and g.Name or "-"
			wuzz103.TextColor3 = tbl21.txt
			return
		end
		if gameProcessed then
			return  
		end
		if listenKey and input.KeyCode == listenKey then
			wuzzfn63()
		end
		if g and input.KeyCode == g then
			wuzzfn55(TextBox.Text)
		end
	end)
	if getgenv then  
		getgenv().WuzzAnnounce = function(...)
			wuzzfn30(...)
		end
		getgenv().WuzzStatus = function()
			return wuzz99.Text
		end
		getgenv().StopWuzz = function()
			flag21 = false
			flag20 = false
			if wuzzfn32 then
				pcall(wuzzfn32)
			end
			for _, wuzz110 in ipairs(tbl23) do
				pcall(function()
					wuzz110:Disconnect()
				end)  
			end
			tbl23 = {}
			if ScreenGui then
				ScreenGui:Destroy()
			end
		end
		getgenv().WuzzUnblockEvents = function()
			if not tbl20.ready then
				return false, tbl20.why  
			end
			return tbl20.Unblock()
		end
	end
end
wuzzfn60(false)
if wuzz94 or flag22 then
	wuzzfn50(keyboardEnabled and (listenKey and "ready - press " .. listenKey.Name .. " to listen" or "ready - no listen key bound") or "ready - tap LISTEN to start", "idle")
else
	wuzzfn50("notify remote not found", "err")  
end
