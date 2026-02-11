local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ControlAura = ReplicatedStorage:WaitForChild("Remotes").ControlAura

local UIS = game:GetService("UserInputService")

local AuraKey = Enum.KeyCode.F
local Player = game:GetService("Players").LocalPlayer

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == AuraKey then
		ControlAura:FireServer("On")
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == AuraKey then
		ControlAura:FireServer("Off")
	end
end)
