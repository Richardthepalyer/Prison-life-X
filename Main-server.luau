local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManager = require(ReplicatedStorage.Modules.DataManager)
local AntiCheat = require(ReplicatedStorage.Modules.AntiCheat)
local ArrestSystem = require(ReplicatedStorage.Modules.ArrestSystem)
local WeaponSystem = require(ReplicatedStorage.Modules.WeaponSystem)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

Players.PlayerAdded:Connect(function(player)
	local data = AntiCheat:CheckBan(player)
	player:SetAttribute("DataLoaded", true)
end)

Players.PlayerRemoving:Connect(function(player)
	local data = DataManager:Load(player)
	DataManager:Save(player, data)
end)

Remotes.ArrestPlayer.OnServerEvent:Connect(function(player, target)
	if not AntiCheat:ValidateRemote(player, "Arrest", target) then return end
	ArrestSystem:Arrest(player, target)
end)

Remotes.WeaponFire.OnServerEvent:Connect(function(player, payload)
	if not AntiCheat:ValidateRemote(player, "WeaponFire", payload) then return end
	WeaponSystem:Fire(player, payload)
end)

Remotes.TeamSelect.OnServerEvent:Connect(function(player, teamName)
	if game.Teams:FindFirstChild(teamName) then
		player.Team = game.Teams[teamName]
		player:LoadCharacter()
	end
end)

Remotes.DoorAccess.OnServerEvent:Connect(function(player, door)
	if player.Team.Name ~= "Guards" then return end
	if door and door.Parent == workspace.EnergyDoors then
		door.CanCollide = false
		door.Transparency = 0.5
		task.wait(3)
		door.CanCollide = true
		door.Transparency = 0
	end
end)
