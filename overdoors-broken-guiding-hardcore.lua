--[[
OVERDOORS HARD MODE - FULL ENTITIES + TRUST/BETRAYAL + BROKEN GUIDING LIGHT + ROOM ATTACK
Hardcore V4 + Custom Entities (ALL)
Delta Safe | One File
by chu be te liet (merged & guarded & fixed)
Changes:
- Removed Sprint loader
- Removed Depth entity from spawn list
- Removed Him entity
- Fixed math.clamp -> clamp
- Added small update GUI showing removed/added items
]]

if getgenv().OVERDOORS_LOADED then return end
getgenv().OVERDOORS_LOADED = true

-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

local P = Players.LocalPlayer

-- SAFE HELPERS
local function safeDo(fn) pcall(fn) end
local function clamp(v,a,b) if v<a then return a end if v>b then return b end return v end

----------------------------------------------------------------
-- INTRO / BOTTOM NOTIFY
----------------------------------------------------------------
task.spawn(function()
    task.wait(0.5)
    if not P or not P:FindFirstChild("PlayerGui") then return end
    local gui = Instance.new("ScreenGui"); gui.ResetOnSpawn=false; gui.Name="OVERDOORS_INTRO"; gui.Parent=P.PlayerGui
    local txt = Instance.new("TextLabel", gui)
    txt.Size = UDim2.fromScale(1,1); txt.BackgroundTransparency=1
    txt.Text="THE OVERDOORS"; txt.Font=Enum.Font.GothamBlack; txt.TextScaled=true
    txt.TextColor3=Color3.fromRGB(255,0,0); txt.TextTransparency=1
    for i=1,12 do txt.TextTransparency = clamp(txt.TextTransparency - 0.08,0,1); task.wait(0.04) end
    task.wait(1.5)
    for i=1,12 do txt.TextTransparency = clamp(txt.TextTransparency + 0.08,0,1); task.wait(0.04) end
    gui:Destroy()
end)

task.spawn(function()
    task.wait(3)
    if not P or not P:FindFirstChild("PlayerGui") then return end
    local gui = Instance.new("ScreenGui", P.PlayerGui); gui.ResetOnSpawn=false; gui.Name="OVERDOORS_NOTIFY"
    local msg = Instance.new("TextLabel", gui)
    msg.Size = UDim2.fromScale(1,0.07); msg.Position = UDim2.fromScale(0,0.92)
    msg.BackgroundTransparency=1; msg.TextScaled=true; msg.Font=Enum.Font.GothamBold
    msg.TextColor3 = Color3.fromRGB(170,255,200); msg.TextTransparency=1; msg.Text="script OVERDOORS by chu be te liet"
    pcall(function() TweenService:Create(msg,TweenInfo.new(0.4),{TextTransparency=0}):Play() end)
    task.wait(3)
    pcall(function() TweenService:Create(msg,TweenInfo.new(0.4),{TextTransparency=1}):Play() end)
    task.wait(0.6)
    gui:Destroy()
end)

-- Remove specific violet music if present
pcall(function()
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Sound") and type(v.SoundId)=="string" and v.SoundId:find("76760458012018") then
            pcall(function() v:Stop(); v:Destroy() end)
        end
    end
end)

----------------------------------------------------------------
-- PLAYER STATS
----------------------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if not P then return end
            local c = P.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then
                h.WalkSpeed = 20
                h.JumpPower = 38
            end
        end)
    end
end)

----------------------------------------------------------------
-- LOAD HARDCORE V4 (guarded)
----------------------------------------------------------------
pcall(function()
    local ok, body = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/localplayerr/Doors-stuff/refs/heads/main/Hardcore%20v4%20recreate/main%20code")
    end)
    if ok and body and #body>10 then pcall(loadstring(body)) end
end)

----------------------------------------------------------------
-- SCREECH / HIDE / SPIDER tweaks (safe)
----------------------------------------------------------------
pcall(function()
    if RS and RS:FindFirstChild("Entities") and RS.Entities:FindFirstChild("Screech") and RS.Entities.Screech:FindFirstChild("Top") then
        RS.Entities.Screech.Top.Eyes.Color = Color3.fromRGB(255,255,0)
    end
    local G
    pcall(function()
        G = (P and P:FindFirstChild("PlayerGui") and P.PlayerGui:FindFirstChild("MainUI") and P.PlayerGui.MainUI:FindFirstChild("Initiator") and P.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game")) and P.PlayerGui.MainUI.Initiator.Main_Game or nil
    end)
    if G and G.RemoteListener and G.RemoteListener.Modules then
        local M = G.RemoteListener.Modules
        pcall(function()
            if M.Screech and M.Screech.Caught then M.Screech.Caught.SoundId="rbxassetid://7492033495"; M.Screech.Caught.PlaybackSpeed=1.6 end
            if M.Screech and M.Screech.Attack then M.Screech.Attack.SoundId="rbxassetid://8080941676" end
            if M.HideMonster and M.HideMonster.Scare then M.HideMonster.Scare.SoundId="rbxassetid://9126213741" end
            if M.SpiderJumpscare and M.SpiderJumpscare.Scare then M.SpiderJumpscare.Scare.SoundId="rbxassetid://8080941676" end
        end)
    end
end)

----------------------------------------------------------------
-- ENTITY SPAWNER HELPER (no Him, Depth removed)
----------------------------------------------------------------
local function spawnLoop(delayTime, url, waitRoom)
    task.spawn(function()
        while true do
            task.wait(delayTime)
            if waitRoom then pcall(function() if RS and RS.GameData and RS.GameData.LatestRoom then RS.GameData.LatestRoom.Changed:Wait() end end) end
            pcall(function()
                local ok, body = pcall(function() return game:HttpGet(url) end)
                if ok and body and #body>10 then pcall(loadstring(body)) end
            end)
        end
    end)
end

-- ENTITIES (Depth and Him removed)
local entities = {
    {150, "https://raw.githubusercontent.com/Junbbinopro/Guardian-entity/refs/heads/main/Guardian", true},
    {190, "https://raw.githubusercontent.com/Junbbinopro/Wh1t3/refs/heads/main/Entity", true},
    {215, "https://raw.githubusercontent.com/trungdepth-dot/Entity-greance/refs/heads/main/Greance-20", true},
    {250, "https://raw.githubusercontent.com/trungdepth-dot/Entity-surge/refs/heads/main/Surge-20", true},
    -- Him removed by user request
    {325, "https://pastefy.app/ofutwkjb/raw", true}, -- Cease
    {35,  "https://raw.githubusercontent.com/vct0721/Doors-Stuff/refs/heads/main/Entities/Shocker", false},
    {350, "https://github.com/PABMAXICHAC/doors-monsters-scripts/raw/main/blinkcrux", true},
    {550, "https://raw.githubusercontent.com/trungdepth-dot/Entity-greed/refs/heads/main/Greed-update", true},
    {320, "https://raw.githubusercontent.com/Junbbinopro/Black-smile/refs/heads/main/Black", true},
    {600, "https://raw.githubusercontent.com/Junbbinopro/Munci-entity/refs/heads/main/Munci-20", true},
    {440, "https://raw.githubusercontent.com/Junbbinopro/Blue-face/refs/heads/main/Entity", true},
    {620, "https://raw.githubusercontent.com/Junbbinopro/Hungerd/refs/heads/main/Entity", true},
    {210, "https://raw.githubusercontent.com/Junbbinopro/200-entity/refs/heads/main/Entity", true},
    {290, "https://raw.githubusercontent.com/trungdepth-dot/Entity-bluyer/refs/heads/main/Entity-20", true},
    {230, "https://raw.githubusercontent.com/Junbbinopro/Trauma-entity/refs/heads/main/Trauma", true},
    {420, "https://raw.githubusercontent.com/Junbbinopro/Screamer/refs/heads/main/Entity", false},
}

for _,v in ipairs(entities) do spawnLoop(v[1], v[2], v[3]) end

-- Show update notice (Depth/Him removed + Broken Guiding added)
task.spawn(function()
    pcall(function()
        if not P or not P:FindFirstChild("PlayerGui") then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "OVERDOORS_UPDATE"
        gui.ResetOnSpawn = false
        gui.Parent = P.PlayerGui

        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0,420,0,120)
        frame.Position = UDim2.new(0.5,0,0.06,0)
        frame.AnchorPoint = Vector2.new(0.5,0)
        frame.BackgroundTransparency = 0.2
        frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
        frame.BorderSizePixel = 0

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1,0,0,36)
        title.Position = UDim2.new(0,0,0,0)
        title.BackgroundTransparency = 1
        title.Text = "Broken Guiding Update"
        title.Font = Enum.Font.GothamBold
        title.TextScaled = true
        title.TextColor3 = Color3.fromRGB(255,200,80)

        local list = Instance.new("TextLabel", frame)
        list.Size = UDim2.new(1, -12, 1, -46)
        list.Position = UDim2.new(0,6,0,40)
        list.BackgroundTransparency = 1
        list.TextWrapped = true
        list.TextXAlignment = Enum.TextXAlignment.Left
        list.TextYAlignment = Enum.TextYAlignment.Top
        list.Font = Enum.Font.Gotham
        list.TextScaled = false
        list.TextSize = 18
        list.TextColor3 = Color3.fromRGB(170,255,200)
        list.Text = "Added:  - Broken Guiding Light\nRemoved: - Him entity\nRemoved: - Depth entity"

        task.delay(5, function() pcall(function() gui:Destroy() end) end)
    end)
end)

print("UPDATE: Removed 'Him' and 'Depth' entities. Added 'Broken Guiding Light' features.")

----------------------------------------------------------------
-- GUIDING LIGHT (load remote candle only)
-- (Sprint loader REMOVED on purpose)
----------------------------------------------------------------
pcall(function()
    local ok,body = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Junbbinopro/Guiding-light-candle/refs/heads/main/Candle")
    end)
    if ok and body and #body>10 then pcall(loadstring(body)) end
end)

----------------------------------------------------------------
-- CRUCIFIX: loader + try give crucifix; spawn at door 1
----------------------------------------------------------------
pcall(function()
    local ok, body = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/PenguinManiack/Crucifix/main/Crucifix.lua")
    end)
    if ok and body and #body>10 then pcall(loadstring(body)) end
end)

local function tryGiveCrucifix()
    local candidates = {}
    local function scan(parent)
        for _,v in ipairs(parent:GetDescendants()) do
            if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("crucifix") then
                table.insert(candidates, v)
            end
        end
    end
    pcall(function() scan(workspace) end)
    pcall(function() scan(game:GetService("ReplicatedStorage")) end)
    if #candidates > 0 and P and P:FindFirstChild("Backpack") then
        pcall(function()
            local item = candidates[1]:Clone()
            item.Parent = P.Backpack
        end)
        return true
    end
    if P and P:FindFirstChild("Backpack") then
        local ok2, exist = pcall(function() return P.Backpack:FindFirstChild("Crucifix") end)
        if not ok2 or not exist then
            local tool = Instance.new("Tool"); tool.Name="Crucifix"; tool.RequiresHandle=true
            local handle = Instance.new("Part"); handle.Name="Handle"; handle.Size=Vector3.new(1,1,1); handle.CanCollide=false; handle.Transparency=0.7; handle.Parent=tool
            tool.Parent = P.Backpack
            pcall(function() tool.ToolTip = "Crucifix (placeholder)" end)
            return true
        end
    end
    return false
end

task.spawn(function()
    for i=1,5 do
        if tryGiveCrucifix() then break end
        task.wait(1)
    end
end)

pcall(function()
    if RS and RS:FindFirstChild("GameData") and RS.GameData:FindFirstChild("LatestRoom") then
        RS.GameData.LatestRoom.Changed:Connect(function()
            pcall(function()
                local val = RS.GameData.LatestRoom.Value or RS.GameData.LatestRoom
                local roomNum = tonumber(tostring(val)) or (type(val)=="Instance" and tonumber(val.Name) or nil)
                if roomNum == 1 then tryGiveCrucifix() end
            end)
        end)
    end
end)

----------------------------------------------------------------
-- RANDOM SCREAMS (configurable chance)
----------------------------------------------------------------
task.spawn(function()
    local screamAssets = {
        "rbxassetid://9043345732",
        "rbxassetid://9043346124",
        "rbxassetid://4714389545",
    }
    local screamChance = 0.85 -- 85% spawn chance when tick hits
    while true do
        task.wait(math.random(25,70))
        if math.random() <= screamChance then
            pcall(function()
                if not P then return end
                local char = P.Character
                local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                if not hrp then return end
                local sound = Instance.new("Sound")
                sound.SoundId = screamAssets[math.random(#screamAssets)]
                sound.Volume = math.random(30,50)/20
                sound.PlaybackSpeed = math.random(95,115)/100
                sound.RollOffMode = Enum.RollOffMode.Inverse
                sound.RollOffMinDistance = 8
                sound.RollOffMaxDistance = 80
                sound.Parent = hrp
                sound:Play()
                Debris:AddItem(sound, 8)
            end)
        end
    end
end)

----------------------------------------------------------------
-- TRUST / BETRAYAL + BROKEN GUIDING LIGHT
----------------------------------------------------------------
getgenv().OVERDOORS_TRUST = getgenv().OVERDOORS_TRUST or { trust = 0, betrayal = 0 }
local TR = getgenv().OVERDOORS_TRUST

local TRUST_INC = 5
local BETRAYAL_INC = 10
local TRUST_PENALTY_ON_BETRAY = 15
local BROKEN_BASE_CHANCE = 0.15
local BROKEN_EXTRA_PER_BETRAY = 0.01
local BROKEN_DURATION = 120
local INTERACT_DISTANCE = 6

local function findGuidingCandles()
    local list = {}
    local function scan(parent)
        for _,v in ipairs(parent:GetDescendants()) do
            if v:IsA("Model") or v:IsA("BasePart") then
                local n = v.Name:lower()
                if n:find("candle") or n:find("guiding") or n:find("guidelight") then
                    table.insert(list, v)
                end
            end
        end
    end
    pcall(function() scan(workspace) end)
    pcall(function() scan(game:GetService("ReplicatedStorage")) end)
    return list
end

local brokenMap = setmetatable({}, {__mode="k"})

-- Trust UI
local function createTrustUI()
    if not P or not P:FindFirstChild("PlayerGui") then return end
    if P.PlayerGui:FindFirstChild("OVERDOORS_TRUST_UI") then return end
    local gui = Instance.new("ScreenGui"); gui.Name = "OVERDOORS_TRUST_UI"; gui.ResetOnSpawn=false; gui.Parent = P.PlayerGui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,240,0,36)
    frame.BackgroundTransparency = 0.4
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.new(0.5,0.85,0,0)

    local barBg = Instance.new("Frame", frame)
    barBg.Size = UDim2.new(0.9,0,0.45,0); barBg.Position = UDim2.fromScale(0.05,0.12)
    barBg.BackgroundColor3 = Color3.fromRGB(40,40,40); barBg.BorderSizePixel=0

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0,0,1,0); bar.Position = UDim2.new(0,0,0,0)
    bar.BackgroundColor3 = Color3.fromRGB(40,200,120); bar.BorderSizePixel=0

    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(0.9,0,0.45,0); txt.Position = UDim2.new(0.05,0,0.6,0)
    txt.BackgroundTransparency = 1; txt.TextScaled=true; txt.Font=Enum.Font.GothamBold
    txt.TextColor3 = Color3.fromRGB(220,220,220); txt.Text = "Trust: 0%   Betrayal: 0%"

    local function updateUI()
        local trust = TR.trust or 0
        local betray = TR.betrayal or 0
        local w = clamp(trust/100,0,1)
        pcall(function() bar:TweenSize(UDim2.new(w,0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true) end)
        txt.Text = string.format("Trust: %d%%   Betrayal: %d%%", math.floor(trust), math.floor(betray))
        local g = clamp(trust/100,0,1)
        bar.BackgroundColor3 = Color3.fromHSV(g*0.3, 0.8, 0.9)
    end

    updateUI()
    return {gui=gui, update=updateUI}
end

local trustUI = createTrustUI()

local function setTrust(val) TR.trust = clamp(math.floor(val+0.5),0,100); if trustUI and trustUI.update then pcall(trustUI.update) end end
local function setBetrayal(val) TR.betrayal = clamp(math.floor(val+0.5),0,100); if trustUI and trustUI.update then pcall(trustUI.update) end end
local function changeTrust(d) setTrust((TR.trust or 0) + d) end
local function changeBetrayal(d) setBetrayal((TR.betrayal or 0) + d) end

TR.trust = TR.trust or 0
TR.betrayal = TR.betrayal or 0
if trustUI and trustUI.update then pcall(trustUI.update) end

local function isNearAnyCandle(pos, maxDist)
    local candles = findGuidingCandles()
    for _,c in ipairs(candles) do
        local primary
        if c:IsA("BasePart") then primary = c
        elseif c:IsA("Model") then primary = c:FindFirstChildWhichIsA("BasePart") or c:FindFirstChild("HumanoidRootPart") end
        if primary and primary.Position and pos then
            if (primary.Position - pos).Magnitude <= (maxDist or INTERACT_DISTANCE) then
                return c, primary
            end
        end
    end
    return nil, nil
end

local function breakCandleInstance(inst)
    if not inst then return end
    if brokenMap[inst] then return end
    brokenMap[inst] = true
    pcall(function()
        for _,v in ipairs(inst:GetDescendants()) do
            if v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
                v.Enabled = false
            elseif v:IsA("BasePart") then
                pcall(function() v.Transparency = 0.5 end)
            end
        end
        local s = Instance.new("Sound", workspace)
        s.SoundId = "rbxassetid://12222225"
        s.Volume = 1
        s:Play()
        Debris:AddItem(s,6)
    end)
    task.spawn(function()
        task.wait(BROKEN_DURATION)
        pcall(function()
            for _,v in ipairs(inst:GetDescendants()) do
                if v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
                    v.Enabled = true
                end
                if v:IsA("BasePart") then
                    pcall(function() v.Transparency = 0 end)
                end
            end
        end)
        brokenMap[inst] = nil
    end)
end

local function onInteractNearCandle(inst)
    if not inst then return end
    if brokenMap[inst] then
        changeTrust(2)
        return
    end
    changeTrust(TRUST_INC)
    local extra = (TR.betrayal or 0) * BROKEN_EXTRA_PER_BETRAY
    local chance = BROKEN_BASE_CHANCE + extra
    if math.random() < chance then
        breakCandleInstance(inst)
        changeTrust(-10)
    end
end

-- hook E to interact near candle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
        pcall(function()
            if not P then return end
            local char = P.Character
            local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            if not hrp then return end
            local inst, prim = isNearAnyCandle(hrp.Position, INTERACT_DISTANCE)
            if inst and prim then onInteractNearCandle(inst) end
        end)
    end
end)

local function watchCrucifixTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    local function activated()
        pcall(function()
            if not P then return end
            local char = P.Character
            local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            if not hrp then return end
            local inst = isNearAnyCandle(hrp.Position, INTERACT_DISTANCE)
            if inst then
                changeBetrayal(BETRAYAL_INC)
                changeTrust(-TRUST_PENALTY_ON_BETRAY)
                if math.random() < 0.5 then breakCandleInstance(inst) end
            end
        end)
    end
    pcall(function() tool.Activated:Connect(activated) end)
end

local function scanForCrucifixAndWatch()
    pcall(function()
        if P and P:FindFirstChild("Backpack") then
            for _,t in ipairs(P.Backpack:GetChildren()) do
                if t:IsA("Tool") and t.Name:lower():find("crucifix") then watchCrucifixTool(t) end
            end
            P.Backpack.ChildAdded:Connect(function(c) if c:IsA("Tool") and c.Name:lower():find("crucifix") then watchCrucifixTool(c) end end)
        end
        if P and P:FindFirstChild("Character") then
            for _,t in ipairs(P.Character:GetChildren()) do
                if t:IsA("Tool") and t.Name:lower():find("crucifix") then watchCrucifixTool(t) end
            end
            P.Character.ChildAdded:Connect(function(c) if c:IsA("Tool") and c.Name:lower():find("crucifix") then watchCrucifixTool(c) end end)
        end
    end)
end

task.spawn(function()
    scanForCrucifixAndWatch()
    if P then P.CharacterAdded:Connect(function() task.wait(1); scanForCrucifixAndWatch() end) end
end)

-- try hook remote/bindable 'UseCandle' events (best-effort)
task.spawn(function()
    local candidates = {}
    local function scanRec(parent)
        for _,v in ipairs(parent:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("BindableEvent") then
                local n = (v.Name or ""):lower()
                if n:find("candle") or n:find("guid") or n:find("use") then table.insert(candidates, v) end
            end
        end
    end
    pcall(function() scanRec(workspace) end)
    pcall(function() scanRec(RS) end)
    for _,ev in ipairs(candidates) do
        pcall(function()
            if ev:IsA("BindableEvent") then ev.Event:Connect(function(...) changeTrust(TRUST_INC) end)
            elseif ev:IsA("RemoteEvent") then ev.OnClientEvent:Connect(function(...) changeTrust(TRUST_INC) end) end
        end)
    end
end)

----------------------------------------------------------------
-- GUIDING LIGHT ROOM EVENT (70% chance per room => show text => attack 25 HP)
----------------------------------------------------------------
do
    local ROOM_CHANCE = 0.7 -- 70%
    local ATTACK_DAMAGE = 25
    local DISPLAY_TIME = 4
    local GUIDING_IMAGE = "rbxassetid://113872823623472"
    local DIALOGUES = {
        "Why are you standing here?",
        "I wanna... um... BETRAYTAL TOU MUHEHEHE",
        "Do you really trust me?",
        "Stay still...",
        "Wrong choice."
    }

    local function showGuidingDialogue(text)
        if not P or not P:FindFirstChild("PlayerGui") then return end
        pcall(function() if P.PlayerGui:FindFirstChild("GUIDING_ROOM_EVENT") then P.PlayerGui.GUIDING_ROOM_EVENT:Destroy() end end)
        local gui = Instance.new("ScreenGui"); gui.Name = "GUIDING_ROOM_EVENT"; gui.ResetOnSpawn=false; gui.Parent = P.PlayerGui
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0.6,0,0.35,0); frame.Position = UDim2.fromScale(0.5,0.45); frame.AnchorPoint = Vector2.new(0.5,0.5)
        frame.BackgroundTransparency = 1
        local img = Instance.new("ImageLabel", frame)
        img.Image = GUIDING_IMAGE; img.Size = UDim2.new(0.35,0,1,0); img.BackgroundTransparency = 1; img.ImageTransparency = 1
        local txt = Instance.new("TextLabel", frame)
        txt.Size = UDim2.new(0.6,0,1,0); txt.Position = UDim2.new(0.38,0,0,0)
        txt.BackgroundTransparency = 1; txt.TextWrapped = true; txt.TextScaled = true
        txt.Font = Enum.Font.GothamBold; txt.TextColor3 = Color3.fromRGB(0,210,255); txt.TextStrokeTransparency = 0.6
        txt.TextTransparency = 1; txt.Text = text
        pcall(function() TweenService:Create(img, TweenInfo.new(0.4), {ImageTransparency = 0}):Play() end)
        pcall(function() TweenService:Create(txt, TweenInfo.new(0.4), {TextTransparency = 0}):Play() end)
        task.delay(DISPLAY_TIME, function()
            pcall(function() TweenService:Create(img, TweenInfo.new(0.3), {ImageTransparency = 1}):Play() end)
            pcall(function() TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 1}):Play() end)
            task.wait(0.4)
            pcall(function() gui:Destroy() end)
        end)
    end

    local function guidingAttack()
        local char = P and P.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        pcall(function() hum:TakeDamage(ATTACK_DAMAGE) end)
        local flash = Instance.new("ScreenGui", P.PlayerGui)
        local f = Instance.new("Frame", flash)
        f.Size = UDim2.fromScale(1,1); f.BackgroundColor3 = Color3.new(1,1,1); f.BackgroundTransparency = 1
        pcall(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play() end)
        task.wait(0.1)
        pcall(function() TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() end)
        Debris:AddItem(flash, 0.6)
    end

    pcall(function()
        if RS and RS:FindFirstChild("GameData") and RS.GameData:FindFirstChild("LatestRoom") then
            RS.GameData.LatestRoom.Changed:Connect(function()
                task.wait(1)
                if math.random() <= ROOM_CHANCE then
                    local msg = DIALOGUES[math.random(#DIALOGUES)]
                    showGuidingDialogue(msg)
                    task.delay(DISPLAY_TIME + 0.2, function() guidingAttack() end)
                end
            end)
        end
    end)
end

----------------------------------------------------------------
-- READY
----------------------------------------------------------------
print("OVERDOORS FULL ENTITIES (no Him, no Depth) + Trust/Betrayal + Broken Guiding Light + Guiding Room Attack loaded")
