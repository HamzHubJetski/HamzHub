--// HamzHub Fish It - Red Black Edition
--// by HamzHub

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Window
local Window = Rayfield:CreateWindow({
   Name = "HamzHub | Fish It",
   LoadingTitle = "HamzHub Loader",
   LoadingSubtitle = "Red • Black Edition",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HamzHub",
      FileName = "FishIt"
   },
   KeySystem = false
})

--// Theme (Merah Hitam)
Rayfield:SetTheme({
   Background = Color3.fromRGB(15,15,15),
   Topbar = Color3.fromRGB(20,20,20),
   Shadow = Color3.fromRGB(0,0,0),
   Text = Color3.fromRGB(255,80,80),
   ElementBackground = Color3.fromRGB(25,25,25),
   ElementBackgroundHover = Color3.fromRGB(35,35,35),
   SecondaryText = Color3.fromRGB(200,50,50),
   Accent = Color3.fromRGB(255,0,0)
})

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local TeleTab = Window:CreateTab("Teleports", 4483362458)

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local CastLine = Remotes:WaitForChild("CastLine")
local ReelIn = Remotes:WaitForChild("ReelIn")
local ShakeRemote = Remotes:WaitForChild("Shake")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--// States
local AutoFish = false
local Instant = false
local Blatant = false

--// Teleport Locations (Fish It)
local Locations = {
   ["Fisherman Island (Spawn)"] = Vector3.new(0, 12, 0),
   ["Ocean"] = Vector3.new(900, 10, -200),
   ["Kohana Island"] = Vector3.new(800, 12, 500),
   ["Kohana Volcano"] = Vector3.new(850, 25, 550),
   ["Coral Reef"] = Vector3.new(1500, 10, -500),
   ["Esoteric Depths"] = Vector3.new(1700, 10, -800),
   ["Tropical Grove"] = Vector3.new(1300, 10, 300),
   ["Crater Island"] = Vector3.new(500, 10, -1000),
   ["Lost Isle"] = Vector3.new(-400, 20, -1200),
   ["Ancient Jungle"] = Vector3.new(-150, 15, 900),
   ["Pirate Cove"] = Vector3.new(-800, 25, 400)
}

--// Teleport Func
local function TP(pos)
   hrp.CFrame = CFrame.new(pos)
end

--// Auto Fishing
task.spawn(function()
   while task.wait() do
      if AutoFish then
         CastLine:FireServer()
         task.wait(0.05)

         if Blatant then
            ReelIn:FireServer()
            ShakeRemote:FireServer("Perfect")
         elseif Instant then
            task.wait(0.4)
            ReelIn:FireServer()
            ShakeRemote:FireServer("Perfect")
         else
            task.wait(math.random(1,3))
            ReelIn:FireServer()
         end
      end
   end
end)

--// UI Toggles
MainTab:CreateToggle({
   Name = "Auto Fishing",
   CurrentValue = false,
   Callback = function(v)
      AutoFish = v
   end
})

MainTab:CreateToggle({
   Name = "Instant Fishing",
   CurrentValue = false,
   Callback = function(v)
      Instant = v
   end
})

MainTab:CreateToggle({
   Name = "Blatant Mode (Fast)",
   CurrentValue = false,
   Callback = function(v)
      Blatant = v
   end
})

--// Teleport Dropdown
local TPList = {}
for name,_ in pairs(Locations) do
   table.insert(TPList, name)
end

TeleTab:CreateDropdown({
   Name = "Teleport Location",
   Options = TPList,
   CurrentOption = TPList[1],
   Callback = function(choice)
      TP(Locations[choice])
   end
})

--// Notify
Rayfield:Notify({
   Title = "HamzHub Loaded",
   Content = "Fish It script siap dipakai 🔥",
   Duration = 5
})
