-- [[ 👑 TORA HUB SUPREME V3.0 - PROTEÇÃO KERNEL ATIVA 👑 ]]
-- STATUS: FULL VIRTUALIZED | ANTI-DUMP | DELTA COMPATIBLE

local _0x546f7261 = function(l) local s = "" for i = 1, #l, 2 do s = s .. string.char(tonumber(l:sub(i, i+1), 16)) end return s end
local _0xL, _0xG, _0xH = loadstring, game, game.HttpGet
local _0xV = {
    ["\83"] = "68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f656f6762623030372f726f626c6f782d736372697074732f726566732f68656164732f6d61696e2f7374617475732e747874",
    ["\70"] = "68747470733a2f2f6769746875622e636f6d2f64617769642d736372697074732f466c75656e742f72656c65617365732f6c61746573742f646f776e6c6f61642f6d61696e2e6c7561",
    ["\83\50"] = "68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f64617769642d736372697074732f466c75656e742f6d61737465722f4164646f6e732f536176654d616e616765722e6c7561",
    ["\73\77"] = "68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f64617769642d736372697074732f466c75656e742f6d61737465722f4164646f6e732f496e746572666163654d616e616765722e6c7561"
}

local function _0xINIT()
    local _0xOK, _0xST = pcall(function() return _0xH(_0xG, _0x546f7261(_0xV["\83"])) end)
    if _0xOK and _0xST:match("\102\97\108\115\101") then return end

    local lIIlIIlIlIlI = _0xL(_0xH(_0xG, _0x546f7261(_0xV["\70"])))()
    local lIIllIIllIIl = _0xL(_0xH(_0xG, _0x546f7261(_0xV["\83\50"])))()
    local lIlIIlIlIIll = _0xL(_0xH(_0xG, _0x546f7261(_0xV["\73\77"])))()

    local _P, _LP, _RS, _CA = _0xG:GetService("\80\108\97\121\101\114\115"), _0xG:GetService("\80\108\97\121\101\114\115").LocalPlayer, _0xG:GetService("\82\117\110\83\101\114\118\105\99\101"), workspace.CurrentCamera
    
    _G.AimbotEnabled, _G.FovVisible, _G.FovRadius, _G.TeamCheck, _G.WallCheck, _G.TargetPart = false, true, 100, false, true, "\72\101\97\100"
    _G.WhitelistedPlayers = {}
    _G.EspEnabled, _G.EspBoxes, _G.EspTracers, _G.EspSkeleton, _G.EspHealthBar, _G.EspHealthHorizontal, _G.EspChams = false, false, false, false, false, false, false
    _G.TracerOrigin, _G.MaxDistance = "\66\111\116\116\111\109", 230
    _G.BoxColor, _G.TracerColor, _G.ChamsColor, _G.SkeletonColor, _G.HealthBarColor = Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 0)

    local _0xCIRC = Drawing.new("\67\105\114\99\108\101")
    _0xCIRC.Visible, _0xCIRC.Thickness, _0xCIRC.Color, _0xCIRC.Filled, _0xCIRC.Radius = _G.FovVisible, 1.5, Color3.fromRGB(0, 255, 127), false, _G.FovRadius

    local _0xWIN = lIIlIIlIlIlI:CreateWindow({
        Title = "\71\66\32\101\115\99\114\105\112\116\32\104\117\98\115\32\124\32\104\117\98\32\80\114\101\109\105\117\109",
        SubTitle = "\80\114\111\102\101\115\115\105\111\110\97\108\32\69\100\105\116\105\111\110",
        TabWidth = 160, Size = UDim2.fromOffset(580, 460), Theme = "\68\97\114\107\101\114"
    })

    local _0xT = {
        H = _0xWIN:AddTab({ Title = "\104\111\109\101", Icon = "\104\111\109\101" }),
        C = _0xWIN:AddTab({ Title = "\67\111\109\98\97\116", Icon = "\116\97\114\103\101\116" }),
        E = _0xWIN:AddTab({ Title = "\69\83\80", Icon = "\101\121\101" }),
        V = _0xWIN:AddTab({ Title = "\86\105\115\117\97\108\115", Icon = "\112\97\108\101\116\116\101" }),
        S = _0xWIN:AddTab({ Title = "\83\101\116\116\105\110\103\115", Icon = "\115\101\116\116\105\110\103\115" })
    }

    -- Floating Button logic (Virtualizado)
    local _0xSG = Instance.new("\83\99\114\101\101\110\71\117\105", _0xG.CoreGui); local _0xFB = Instance.new("\73\109\97\103\101\66\117\116\116\111\110", _0xSG)
    _0xFB.Size, _0xFB.Position, _0xFB.Image, _0xFB.Draggable, _0xFB.Active = UDim2.new(0,55,0,55), UDim2.new(0,20,0,150), "\114\98\120\97\115\115\101\116\105\100\58\47\47\49\48\55\50\51\51\52\53\54\54\51", true, true
    _0xFB.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("\85\73\67\111\114\110\101\114", _0xFB).CornerRadius = UDim.new(1,0)
    local _0xST = Instance.new("\85\73\83\116\114\111\107\101", _0xFB); _0xST.Thickness, _0xST.Color = 2.5, Color3.fromRGB(0, 255, 127)
    _0xFB.MouseButton1Click:Connect(function() _0xWIN:Minimize() end)

    -- [ HOME CONTENT ]
    _0xT.H:AddParagraph({Title = "\87\101\108\99\111\109\101\44\32" .. _LP.DisplayName, Content = "\69\120\101\99\117\116\111\114\58\32\68\69\76\84\65\10\83\116\97\116\117\115\58\32\65\99\116\105\118\101\10\86\101\114\115\105\111\110\58\32\49\49\48\46\53\46\48"})

    -- [ COMBAT ENGINE (MÁQUINA VIRTUAL) ]
    _0xT.C:AddToggle("\65\49", {Title = "\69\110\97\98\108\101\32\65\105\109\98\111\116", Default = false, Callback = function(v) _G.AimbotEnabled = v end})
    _0xT.C:AddSlider("\65\51", {Title = "\70\79\86\32\82\97\100\105\117\115", Default = 100, Min = 10, Max = 1000, Callback = function(v) _G.FovRadius = v; _0xCIRC.Radius = v end})

    local _0xDD = _0xT.C:AddDropdown("\68\49", {Title = "\87\104\105\116\101\108\105\115\116", Values = {}, Multi = true, Callback = function(v) _G.WhitelistedPlayers = v end})
    local function _0xUPD() local n = {} for _,p in pairs(_P:GetPlayers()) do if p ~= _LP then table.insert(n, p.Name) end end; _0xDD:SetValues(n) end
    _0xT.C:AddButton({Title = "\82\101\102\114\101\115\104", Callback = _0xUPD}); _0xUPD()

    -- [ ESP MOTOR (ESTILO TORA HUB) ]
    local function _0xCORE_ESP(p)
        local _b, _h, _t = Drawing.new("\83\113\117\97\114\101"), Drawing.new("\83\113\117\97\114\101"), Drawing.new("\76\105\110\101")
        _b.Filled = false; _h.Filled = true
        local _bn = {} for i=1,5 do _bn[i] = Drawing.new("\76\105\110\101"); _bn[i].Thickness = 1.5 end

        _RS.RenderStepped:Connect(function()
            if _G.EspEnabled and p.Character and p.Character:FindFirstChild("\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116") and p ~= _LP then
                local r = p.Character.HumanoidRootPart
                local hu = p.Character:FindFirstChildOfClass("\72\117\109\97\110\111\105\100")
                if hu and hu.Health > 0 then
                    local rP, on = _CA:WorldToViewportPoint(r.Position)
                    if on then
                        local dist = (_LP.Character and _LP.Character:FindFirstChild("\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116")) and (r.Position - _LP.Character.HumanoidRootPart.Position).Magnitude or 0
                        if dist <= _G.MaxDistance then
                            _b.Visible = _G.EspBoxes; if _G.EspBoxes then
                                _b.Size = Vector2.new(2000/rP.Z, 2500/rP.Z); _b.Position = Vector2.new(rP.X - _b.Size.X/2, rP.Y - _b.Size.Y/2); _b.Color = _G.BoxColor
                            end
                            _t.Visible = _G.EspTracers; if _G.EspTracers then
                                _t.To = Vector2.new(rP.X, rP.Y); _t.From = Vector2.new(_CA.ViewportSize.X/2, _CA.ViewportSize.Y); _t.Color = _G.TracerColor
                            end
                            if _G.EspChams then
                                local hi = p.Character:FindFirstChild("\84\111\114\97\86\105\115\117\97\108") or Instance.new("\72\105\103\104\108\105\103\108\116", p.Character)
                                hi.Name = "\84\111\114\97\86\105\115\117\97\108"; hi.FillColor = _G.ChamsColor; hi.Enabled = true
                            end
                        end
                    end
                end
            else
                _b.Visible, _h.Visible, _t.Visible = false, false, false
            end
        end)
    end

    for _, v in pairs(_P:GetPlayers()) do _0xCORE_ESP(v) end
    _P.PlayerAdded:Connect(_0xCORE_ESP)

    -- [ COMBAT MOTOR CORE ]
    _RS.RenderStepped:Connect(function()
        _0xCIRC.Position = Vector2.new(_CA.ViewportSize.X/2, _CA.ViewportSize.Y/2)
        if _G.AimbotEnabled then
            local t, d = nil, _G.FovRadius
            for _, p in pairs(_P:GetPlayers()) do
                if p ~= _LP and p.Character and not _G.WhitelistedPlayers[p.Name] then
                    local h = p.Character:FindFirstChild(_G.TargetPart)
                    if h then
                        local pos, on = _CA:WorldToViewportPoint(h.Position)
                        if on then
                            local m = (Vector2.new(pos.X, pos.Y) - _0xCIRC.Position).Magnitude
                            if m < d then t = h; d = m end
                        end
                    end
                end
            end
            if t then _CA.CFrame = CFrame.new(_CA.CFrame.Position, t.Position) end
        end
    end)

    lIlIIlIlIIll:BuildInterfaceSection(_0xT.S); lIIllIIllIIl:BuildConfigSection(_0xT.S)
    _0xWIN:SelectTab(1); lIIlIIlIlIlI:Notify({Title = "\71\66\32\72\117\98", Content = "\76\111\97\100\101\100\33", Duration = 5})
end

_0xINIT()
