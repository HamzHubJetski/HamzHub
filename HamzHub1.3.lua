--// HamzHub v1.3 - Lynx Edition (Added Auto Sell, Multiplier, Inf Jump, Anti AFK, WalkSpeed)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = 'HamzHub - Lynx Features',
   LoadingTitle = 'HamzHub Lynx',
   LoadingSubtitle = 'Fish It Ultimate',
   ConfigurationSaving = {
      Enabled = true,
      FolderName = 'HamzHubLynx',
      FileName = 'Config'
   },
   KeySystem = false
})

local MainTab = Window:CreateTab('Main', 4483362458)
local TeleTab = Window:CreateTab('Teleports', 4483362458)
local MiscTab = Window:CreateTab('Misc', 4483362458)

--// Services
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local VirtualUser = game:GetService('VirtualUser')
local RunService = game:GetService('RunService')

local player = Players.LocalPlayer
local character, humanoidRootPart, humanoid

--// Character handler
local function setupCharacter(char)
   character = char
   humanoidRootPart = char:WaitForChild('HumanoidRootPart', 5)
   humanoid = char:WaitForChild('Humanoid', 5)
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

--// Remotes
local Remotes = ReplicatedStorage:WaitForChild('Remotes')
local CastLine = Remotes:WaitForChild('CastLine')
local ReelIn = Remotes:WaitForChild('ReelIn')
local ShakeRemote = Remotes:WaitForChild('Shake')

local SellRemote
pcall(function()
   SellRemote = Remotes:WaitForChild('SellAllFishes', 10)
end)

--// States
local autoFish = false
local instantFishing = false
local blatantMode = false
local autoSell = false
local multiplier = 1
local infJump = false
local antiAFK = false
local walkSpeed = 16
local fishingThread = false
local sellThread = false
local afkThread = false
local jumpConn = nil

--// Teleports (Added more Lynx-like spots)
local TPs = {
   Spawn = Vector3.new(0, 12, 0),
   Merchant = Vector3.new(-50, 8, 100),
   ['Ghostfin Spot'] = Vector3.new(200, 8, -300),
   ['Best Spot 2'] = Vector3.new(-150, 8, 250),
   Island1 = Vector3.new(500, 55, 0),
   Kohana = Vector3.new(0, 8, 500), -- Example
   Event = Vector3.new(100, 8, 100) -- Example event spot
}

local function teleport(pos)
   if humanoidRootPart then
      humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
   end
end

--// Auto Fishing
local function startFishing()
   if fishingThread then return end
   fishingThread = true
   task.spawn(function()
      while autoFish do
         pcall(function()
            CastLine:FireServer()
            task.wait(0.15)
            ReelIn:FireServer()
            if blatantMode or instantFishing then
               for i = 1, multiplier do
                  ShakeRemote:FireServer('Perfect')
                  task.wait(blatantMode and 0.05 or 0.1)
               end
               task.wait(blatantMode and 0.1 or 0.45)
            else
               task.wait(math.random(1, 3))
            end
         end)
         task.wait(0.1)
      end
      fishingThread = false
   end)
end

--// Auto Sell
local function startSelling()
   if sellThread or not SellRemote then return end
   sellThread = true
   task.spawn(function()
      while autoSell do
         pcall(function()
            SellRemote:FireServer()
         end)
         task.wait(3)
      end
      sellThread = false
   end)
end

--// Inf Jump
local function toggleInfJump(v)
   infJump = v
   if jumpConn then jumpConn:Disconnect() end
   if v then
      jumpConn = UserInputService.JumpRequest:Connect(function()
         if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end)
   end
end

--// Anti AFK
local function toggleAntiAFK(v)
   antiAFK = v
   if afkThread then task.cancel(afkThread) end
   if v then
      VirtualUser:CaptureController()
      afkThread = task.spawn(function()
         while antiAFK do
            VirtualUser:ClickButton2(Vector2.new(math.random(-400,400), math.random(-400,400)))
            task.wait(math.random(50,70))
         end
      end)
   end
end

--// Main Tab
MainTab:CreateToggle({
   Name = 'Auto Fishing',
   CurrentValue = false,
   Flag = 'AutoFish',
   Callback = function(v)
      autoFish = v
      if v then startFishing() end
   end
})

MainTab:CreateToggle({
   Name = 'Instant Fishing (Perfect)',
   CurrentValue = false,
   Flag = 'InstantFish',
   Callback = function(v)
      instantFishing = v
      if v then blatantMode = false end
      if autoFish then startFishing() end
   end
})

MainTab:CreateToggle({
   Name = 'Blatant Mode (Super Fast)',
   CurrentValue = false,
   Flag = 'Blatant',
   Callback = function(v)
      blatantMode = v
      if v then instantFishing = false end
      if autoFish then startFishing() end
   end
})

MainTab:CreateSlider({
   Name = 'Multiplier (Shakes)',
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 1,
   Flag = 'Multiplier',
   Callback = function(v)
      multiplier = v
   end
})

MainTab:CreateToggle({
   Name = 'Auto Sell',
   CurrentValue = false,
   Flag = 'AutoSell',
   Callback = function(v)
      autoSell = v
      if v then startSelling() end
   end
})

MainTab:CreateButton({
   Name = 'Sell All Now',
   Callback = function()
      if SellRemote then
         pcall(function() SellRemote:FireServer() end)
         Rayfield:Notify({Title = 'Sell', Content = 'Sold all fishes!', Duration = 2})
      end
   end
})

--// Teleports
for name, pos in pairs(TPs) do
   TeleTab:CreateButton({
      Name = 'TP to ' .. name,
      Callback = function() teleport(pos) end
   })
end

--// Misc Tab
MiscTab:CreateToggle({
   Name = 'Infinite Jump',
   CurrentValue = false,
   Flag = 'InfJump',
   Callback = toggleInfJump
})

MiscTab:CreateToggle({
   Name = 'Anti AFK',
   CurrentValue = false,
   Flag = 'AntiAFK',
   Callback = toggleAntiAFK
})

MiscTab:CreateSlider({
   Name = 'Walk Speed',
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Flag = 'WalkSpeed',
   Callback = function(v)
      walkSpeed = v
      if humanoid then humanoid.WalkSpeed = v end
   end
})

--// Notify
Rayfield:Notify({
   Title = 'HamzHub Lynx Loaded!',
   Content = 'Fitur Lynx: Auto Sell, x10 Multi, Inf Jump, Anti AFK, Speed. Stabil & Blatant!',
   Duration = 5,
   Image = 4483362458
})
